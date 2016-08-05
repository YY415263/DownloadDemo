//
//  ViewController.m
//  DownloadTest
//
//  Created by zhekexinxi on 16/8/5.
//  Copyright © 2016年 刘士伟. All rights reserved.
//

#import "SmallFileViewController.h"

@interface SmallFileViewController ()

//iOS9弃用
@property(nonatomic, strong)NSURLConnection *connection;



@property(nonatomic, strong)NSURLSession *session;
@end

@implementation SmallFileViewController

- (NSURLSession *)session
{
    if (!_session) {
        _session = [NSURLSession sharedSession];
    }
    return _session;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    
    //(一)
    //百度上随便找的一张图片
    NSString *urlString = @"http://183.129.200.98:9900/ydbs/testimage1.png";
    NSURL *url = [NSURL URLWithString:urlString];
    
    //直接用data的dataWithContentsOfURL方法就相当于发送了一个GET请求,就相当于一个小文件下载
    NSData *data = [NSData dataWithContentsOfURL:url];
    
    NSLog(@"%lu", data.length);
    

    //(二)connection请求下载
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    
    
    
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        NSLog(@"%lu", data.length);
        
    }];
  
    
    
    
    //(三)
       // 通过URL初始化task,在block内部可以直接对返回的数据进行处理
    NSURLSessionTask *task = [self.session dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
         NSLog(@"%lu", data.length);
    }];
    
    // 启动任务
    [task resume];
    
  
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
 
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    
}
@end
