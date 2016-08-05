//
//  BigFileViewController.m
//  DownloadTest
//
//  Created by zhekexinxi on 16/8/5.
//  Copyright © 2016年 刘士伟. All rights reserved.
//

#import "BigFileViewController.h"

@interface BigFileViewController () <NSURLSessionDownloadDelegate>
@property (nonatomic, strong) NSURLSessionDownloadTask* downloadTask;

@property (nonatomic, strong) NSData* resumeData;

@property(nonatomic, strong)NSURLSession *session;

@property(nonatomic, assign)BOOL isDownloading;

@property(nonatomic, assign)double downloadProgress;

@property (strong, nonatomic) IBOutlet UILabel *progressLabel;
@property (strong, nonatomic) IBOutlet UIButton *startOrPause;

@end

@implementation BigFileViewController
- (NSURLSession *)session
{
    if (!_session) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)startOrPauseDownload:(id)sender {
    
    if (self.downloadTask == nil) {//如果是第一次点击就开始任务
        
        NSString *urlString = @"http://183.129.200.98:9900/ydbs/test/localFile.mp4";
        NSURL *url = [NSURL URLWithString:urlString];
        
        // 创建任务
        self.downloadTask = [self.session downloadTaskWithURL:url];
        // 开始任务
        [self.downloadTask resume];
        
        _isDownloading = YES;
        
        [self.startOrPause setTitle:@"pause" forState:UIControlStateNormal];
    }else{
        if (_isDownloading) {//如果正在下载
            __weak typeof(self) weakSelf = self;
            [self.downloadTask cancelByProducingResumeData:^(NSData *resumeData) {
                //  resumeData : 包含了继续下载的开始位置下载的url
                weakSelf.resumeData = resumeData;
                weakSelf.downloadTask = nil;
            }];
            _isDownloading = NO;
             [self.startOrPause setTitle:@"start" forState:UIControlStateNormal];
        }else{//如果已经暂停
            self.downloadTask = [self.session downloadTaskWithResumeData:self.resumeData];
            [self.downloadTask resume]; // 开始任务
            self.resumeData = nil;
            _isDownloading = YES;
             [self.startOrPause setTitle:@"pause" forState:UIControlStateNormal];
        }
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//下载完毕
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location{
    
    NSString *caches = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    // response.suggestedFilename建议使用的文件名,一般跟服务器端的文件名一致
    NSString *file = [caches stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
   
    // 将临时文件剪切或者复制Caches文件夹
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    [mgr moveItemAtPath:location.path toPath:file error:nil];
    
    // 提示下载完成
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"下载完成" message:downloadTask.response.suggestedFilename preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:nil];
   
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    [self.startOrPause setTitle:@"finish" forState:UIControlStateNormal];
    self.startOrPause.userInteractionEnabled = NO;
}

//下载中
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    
//    NSLog(@"%lld", totalBytesWritten);
//    NSLog(@"%lld", totalBytesExpectedToWrite);
    
    self.downloadProgress = (double)totalBytesWritten/totalBytesExpectedToWrite;
    self.progressLabel.text = [NSString stringWithFormat:@"进度:%.2f%%",(double)(totalBytesWritten/totalBytesExpectedToWrite * 100)];
    
}


//恢复下载
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
