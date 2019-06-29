//
//  RegisterViewController.m
//  test1
//
//  Created by student on 2019/6/22.
//  Copyright © 2019 demo. All rights reserved.
//

#import "RegisterViewController.h"
#import "AppDelegate.h"
#import "ViewController.h"
#define API_WEBSITE "http://hw.mikualpha.cn";

@interface RegisterViewController ()
@property (strong, nonatomic) UIImageView *appIcon;
@property (strong, nonatomic) UIImageView *userImage;
@property (strong, nonatomic) UIImageView *passwordImage;
@property (strong, nonatomic) UIImageView *confirmImage;
@property (strong, nonatomic) UITextField *userText;
@property (strong, nonatomic) UITextField *passwordText;
@property (strong, nonatomic) UITextField *confirmText;
@property (strong, nonatomic) UIButton *registerButton;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self loadUI];
    [self.registerButton addTarget:self action:@selector(registerButtonOnClick) forControlEvents:UIControlEventTouchDown];
}

- (void)loadUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(onClickBack:)];
    
    self.registerButton = [[UIButton alloc] init];
    self.registerButton.frame = CGRectMake(157, 668, 100, 30);
    [self.registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.registerButton setBackgroundColor:[UIColor redColor]];
    self.registerButton.layer.borderWidth = 1.0f;
    self.registerButton.layer.cornerRadius = 4.0f;
    [self.view addSubview:self.registerButton];
    
    UIImage *appIconImages = [UIImage imageNamed:@"user.jpg"];
    self.appIcon = [[UIImageView alloc] initWithImage:appIconImages];
    self.appIcon.frame = CGRectMake(132, 152, 150, 150);
    [self.view addSubview:self.appIcon];
    
    UIImage *userImages = [UIImage imageNamed:@"user.jpg"];
    self.userImage = [[UIImageView alloc] initWithImage:userImages];
    self.userImage.frame = CGRectMake(91, 380, 30, 30);
    [self.view addSubview:self.userImage];
    
    UIImage *passwordImages = [UIImage imageNamed:@"password.jpeg"];
    self.passwordImage = [[UIImageView alloc] initWithImage:passwordImages];
    self.passwordImage.frame = CGRectMake(91, 440, 30, 30);
    [self.view addSubview:self.passwordImage];
    
    UIImage *confirmImages = [UIImage imageNamed:@"confirm.jpg"];
    self.confirmImage = [[UIImageView alloc] initWithImage:confirmImages];
    self.confirmImage.frame = CGRectMake(91, 500, 30, 30);
    [self.view addSubview:self.confirmImage];
    
    self.userText = [[UITextField alloc] init];
    self.userText.frame = CGRectMake(136, 380, 187, 30);
    self.userText.placeholder = @"请输入用户名";
    [self.view addSubview:self.userText];
    
    self.passwordText = [[UITextField alloc] init];
    self.passwordText.frame = CGRectMake(136, 440, 187, 30);
    self.passwordText.placeholder = @"请设置密码";
    self.passwordText.secureTextEntry = YES;
    [self.view addSubview:self.passwordText];
    
    self.confirmText = [[UITextField alloc] init];
    self.confirmText.frame = CGRectMake(136, 500, 187, 30);
    self.confirmText.placeholder = @"请确认密码";
    self.confirmText.secureTextEntry = YES;
    [self.view addSubview:self.confirmText];
    
}

- (void)onClickBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)registerButtonOnClick {
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:nil delegateQueue: [NSOperationQueue mainQueue]];
    
    NSURL *url = [NSURL URLWithString:@"http://hw.mikualpha.cn/register.php"];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    NSString *params = [NSString stringWithFormat:@"username=%@&password=%@", self.userText.text, self.passwordText.text];
    [urlRequest setHTTPMethod:@"POST"];
    urlRequest.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask *dataTask = [delegateFreeSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        NSNumber* status = [dic objectForKey:@"status"];
        int myStatus = [status intValue];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"消息提示" message:@"请求方式或传参错误" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"点击取消");
        }]];
        
        if (myStatus == 200){
            NSDictionary* dataDic = [dic objectForKey:@"data"];
            AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            myDelegate.token = [dataDic objectForKey:@"token"];
            NSLog(@"%@", myDelegate.token);
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"消息提示" message:@"成功注册用户" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                //跳转到登录页面
                [self dismissViewControllerAnimated:YES completion:nil];
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
            
            
            /*UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainPage" bundle:nil];
            id detailVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"Main"];
            [self.navigationController pushViewController:detailVC animated:YES];
            NSLog(@"%@",self.navigationController);*/
            
        }else if (myStatus == 400){
            [self presentViewController:alertController animated:YES completion:nil];
        }else if (myStatus == 403){
            alertController.message = @"用户名已存在";
            [self presentViewController:alertController animated:YES completion:nil];
        }else if (myStatus == 404){
            alertController.message = @"服务器连接错误，请稍后重试";
            [self presentViewController:alertController animated:YES completion:nil];
        }else if (myStatus == 1001){
            alertController.message = @"用户名长度过短";
            [self presentViewController:alertController animated:YES completion:nil];
        }else if (myStatus == 1002){
            alertController.message = @"密码长度过短";
            [self presentViewController:alertController animated:YES completion:nil];
        }else if (myStatus == 1003){
            alertController.message = @"用户名长度过长";
            [self presentViewController:alertController animated:YES completion:nil];
        }else if (myStatus == 1004){
            alertController.message = @"密码长度过长";
            [self presentViewController:alertController animated:YES completion:nil];
        }else if (myStatus == 1005){
            alertController.message = @"用户名格式非法";
            [self presentViewController:alertController animated:YES completion:nil];
        }else if (myStatus == 1006){
            alertController.message = @"密码格式非法";
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
    
    [dataTask resume];
}

@end
