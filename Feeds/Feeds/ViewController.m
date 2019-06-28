//
//  LoginViewController.m
//  test1
//
//  Created by student on 2019/6/22.
//  Copyright © 2019 demo. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "RegisterViewController.h"
#define API_WEBSITE "http://hw.mikualpha.cn";

@interface ViewController ()
@property (strong, nonatomic) UIImageView *appIcon;
@property (strong, nonatomic) UIImageView *usernameIcon;
@property (strong, nonatomic) UIImageView *passwordIcon;
@property (strong, nonatomic) UITextField *username;
@property (strong, nonatomic) UITextField *password;
@property (strong, nonatomic) UIButton *loginButton;
@property (strong, nonatomic) UIButton *registerButton;

@end

@implementation ViewController
//ffff
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self loadUI];
    
    [self.loginButton addTarget:self action:@selector(loginButtonOnClick) forControlEvents:UIControlEventTouchDown];
    [self.registerButton addTarget:self action:@selector(registerButtonOnClick) forControlEvents:UIControlEventTouchDown];
    
}

- (void)loadUI {
    self.loginButton = [[UIButton alloc] init];
    self.loginButton.frame = CGRectMake(157, 602, 100, 30);
    [self.loginButton setTitle:@"登陆" forState:UIControlStateNormal];
    [self.loginButton setBackgroundColor:[UIColor redColor]];
    self.loginButton.layer.borderWidth = 1.0f;
    self.loginButton.layer.cornerRadius = 4.0f;
    [self.view addSubview:self.loginButton];
    
    self.registerButton = [[UIButton alloc] init];
    self.registerButton.frame = CGRectMake(157, 668, 100, 30);
    [self.registerButton setTitle:@"注册" forState:UIControlStateNormal];
    [self.registerButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    self.registerButton.layer.borderColor = [[UIColor redColor] CGColor];
    self.registerButton.layer.borderWidth = 1.0f;
    self.registerButton.layer.cornerRadius = 4.0f;
    [self.view addSubview:self.registerButton];
    
    UIImage *appIconImages = [UIImage imageNamed:@"user.jpg"];
    self.appIcon = [[UIImageView alloc] initWithImage:appIconImages];
    self.appIcon.frame = CGRectMake(132, 152, 150, 150);
    [self.view addSubview:self.appIcon];
    
    UIImage *userImages = [UIImage imageNamed:@"user.jpg"];
    self.usernameIcon = [[UIImageView alloc] initWithImage:userImages];
    self.usernameIcon.frame = CGRectMake(91, 402, 30, 30);
    [self.view addSubview:self.usernameIcon];
    
    
    UIImage *passwordImages = [UIImage imageNamed:@"password.jpeg"];
    self.passwordIcon = [[UIImageView alloc] initWithImage:passwordImages];
    self.passwordIcon.frame = CGRectMake(91, 451, 30, 30);
    [self.view addSubview:self.passwordIcon];
    
    self.username = [[UITextField alloc] init];
    self.username.frame = CGRectMake(136, 402, 187, 30);
    self.username.placeholder = @"请输入用户名";
    [self.view addSubview:self.username];
    
    self.password = [[UITextField alloc] init];
    self.password.frame = CGRectMake(136, 451, 187, 30);
    self.password.placeholder = @"请输入密码";
    self.password.secureTextEntry = YES;
    [self.view addSubview:self.password];
}

- (void)loginButtonOnClick {
    NSURL *url = [NSURL URLWithString:@"http://hw.mikualpha.cn/login.php"];
    
    //创建request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *params = [NSString stringWithFormat:@"username=%@&password=%@", self.username.text, self.password.text];
    request.HTTPBody = [params dataUsingEncoding:NSUTF8StringEncoding];
    
    //创建NSURLSession
    NSURLSessionConfiguration *defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:nil delegateQueue: [NSOperationQueue mainQueue]];
    
    //创建任务
    NSURLSessionDataTask *task = [delegateFreeSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        NSNumber* status = [dic objectForKey:@"status"];
        int myStatus = [status intValue];
        if (myStatus == 200){
            NSDictionary* dataDic = [dic objectForKey:@"data"];
            AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            myDelegate.token = [dataDic objectForKey:@"token"];
            NSLog(@"%@", myDelegate.token);
            //跳转到新闻首页
            UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainPage" bundle:nil];
            id detailVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"Main"];
            [self.navigationController pushViewController:detailVC animated:YES];
            NSLog(@"%@",self.navigationController);
            
        }else if (myStatus == 400){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"消息提示" message:@"请求方式或传参错误" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"点击取消");
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }else if (myStatus == 403){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"消息提示" message:@"用户名或密码错误" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"点击取消");
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        
        
    }];
    
    [task resume];
}

- (void)registerButtonOnClick {
    RegisterViewController *controller = [[RegisterViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:navController animated:YES completion:nil];
    
}

@end
