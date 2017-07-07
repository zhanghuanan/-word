//
//  ViewController.m
//  下载文件
//
//  Created by 钧泰科技 on 16/1/11.
//  Copyright © 2016年 钧泰科技. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "SDProgressView.h"


@interface ViewController ()<UIDocumentInteractionControllerDelegate>
{
    SDBallProgressView *loop;
    UIButton *openBtn;
    UIApplication *app;
    
}
@property (nonatomic, strong) UIDocumentInteractionController *documentInteractionController;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSLog(@"-=-=-%@",_url);
    
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsPath error:nil];
    NSLog(@"-=-=-file have -=-=-=-%@",files);
    
//    UIButton *downBtn = [[UIButton alloc] init];
//    [self.view addSubview:downBtn];
//    [downBtn setBackgroundColor:[UIColor orangeColor]];
//    downBtn.frame = CGRectMake(50, 50, 50, 50);
//    downBtn.backgroundColor = [UIColor redColor];
//    [downBtn addTarget:self action:@selector(downloadnewFlie) forControlEvents:UIControlEventTouchUpInside];
    

    openBtn = [[UIButton alloc] init];
    [self.view addSubview:openBtn];
    openBtn.frame = CGRectMake(50, 200, 50, 50);
    openBtn.backgroundColor = [UIColor orangeColor];
    if (_url == nil) {
        [openBtn addTarget:self action:@selector(openFile) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [openBtn addTarget:self action:@selector(creatDir) forControlEvents:UIControlEventTouchUpInside];
        
        NSString *fileNameStr = [_url lastPathComponent];
        NSLog(@"-=-=-%@",fileNameStr);
    }
    
    
}


- (void)saveFile {
    
    //documents文件夹目录 itunes 会同步这个文件夹的文件，适合存储重要文件
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    //libary/caches 文件夹目录，适合存储大文件，不需要备份的非重要的数据
    NSString *libaryPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    
    //tmp 文件夹，不回同步，系统可能在不运行的时候就删除该目录下的文件，适合保存临时文件
    NSString *tmpPath = NSTemporaryDirectory();
    
    //Library/Preferences: 会同步此文件夹中的内容，通常保存应用的设置信息
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    NSLog(@"\n%@\n%@\n%@\n%@",documentsPath,libaryPath,tmpPath,userDefaults);
}
- (void)creatDir
{
    NSString *documentsPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    NSLog(@"documentsPath is ---  %@",documentsPath);
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:@"test"];
    //创建目录
    NSFileManager *fileManger = [NSFileManager defaultManager];
    BOOL res = [fileManger createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
    if (res) {
        NSLog(@"success");
        NSString *testDoc = [testDirectory stringByAppendingPathComponent:@"演示1.doc"];
        NSData *data = [NSData dataWithContentsOfURL:_url];
        [data writeToFile:testDoc atomically:YES];
        if (_url) {
            NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:documentsPath error:nil];
            NSLog(@"-=-=-file have -=-=-=-%@",files);
            // Initialize Document Interaction Controller
            self.documentInteractionController = [UIDocumentInteractionController
                                                  interactionControllerWithURL:_url];
            // Configure Document Interaction Controller
            [self.documentInteractionController setDelegate:self];
            
            //        [self.documentInteractionController presentPreviewAnimated:YES];
            [self.documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
        }
    }else{
        NSLog(@"faild");
    }
}
- (void)openFile
{
    //把自身沙盒内的文件转成URL地址
     NSURL *URL = [[NSBundle mainBundle] URLForResource:@"演示" withExtension:@"doc"];
    if (URL) {
        // Initialize Document Interaction Controller
        self.documentInteractionController = [UIDocumentInteractionController
                                                        interactionControllerWithURL:URL];
        // Configure Document Interaction Controller
        [self.documentInteractionController setDelegate:self];

//        [self.documentInteractionController presentPreviewAnimated:YES];
          [self.documentInteractionController presentOpenInMenuFromRect:CGRectZero inView:self.view animated:YES];
        
  }
}
- (UIViewController *)documentInteractionControllerViewControllerForPreview:(UIDocumentInteractionController *)controller
{
    return self;
}

//- (void)downloadnewFlie
//{
//    loop = [SDBallProgressView progressView];
//    loop.frame = CGRectMake(150, 150, 150, 150);
//    loop.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:loop];
//    NSString *savePath = [NSHomeDirectory() stringByAppendingString:@"/Documents/"];
//    
//    NSError *saveError;
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    //判断是否存在旧的目标文件，如果存在就先移除；避免无法复制问题
//    if ([fileManager fileExistsAtPath:savePath]) {
//        [fileManager removeItemAtPath:savePath error:&saveError];
//        if (saveError) {
//            NSLog(@"移除旧的目标文件失败，错误信息：%@", saveError.localizedDescription);
//        }else
//        {
//            NSLog(@"delet success");
//        }
//    }
//    [self downloadFileWithInferface:@"http://192.168.1.110:8888/uc/sso/school/fileManager.do?download"
//                       savedPath:savePath
//                 downloadSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
////                     NSLog(@"下载成功");
//                     NSLog(@"\n下载地址是       %@",savePath);
//                 } downloadFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                     NSLog(@"下载失败");
//                 } progress:^(float progress) {
//                     
//                 }];
//}
//- (void)downloadFileWithInferface:(NSString*)requestURL
//                     savedPath:(NSString*)savedPath
//               downloadSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
//               downloadFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
//                      progress:(void (^)(float progress))progress
//
//{
//    
//    
//    requestURL = [requestURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    NSURL *fileURL = [NSURL URLWithString:requestURL];
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:fileURL];
//
//    
//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
//    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:savedPath append:NO]];
//    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
//        float p = (float)totalBytesRead / totalBytesExpectedToRead;
//        progress(p);
//        NSLog(@"download：%f", (float)totalBytesRead / totalBytesExpectedToRead);
//        loop.progress = (float)totalBytesRead / totalBytesExpectedToRead;
//    }];
//    
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//        success(operation,responseObject);
//        NSLog(@"下载成功");
//        
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        success(operation,error);
//        
//        NSLog(@"下载失败");
//        
//    }];
//    
//    [operation start];
//    
//}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
