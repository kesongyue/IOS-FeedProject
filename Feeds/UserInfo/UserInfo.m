//
//  UserInfo.m
//  Feeds
//
//  Created by student7 on 2019/6/28.
//  Copyright © 2019 student9. All rights reserved.
//

#import "UserInfo.h"
#import "SelectPhotoManager.h"
#import "ModifyInfo.h"
#import "AppDelegate.h"

@interface UserInfo () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray<NSString*> *datalist;
@property(nonatomic, strong) NSMutableArray<NSString*> *items;
@property (strong, nonatomic) UIImageView *headImage;
@property (nonatomic, strong)SelectPhotoManager *photoManager;

@end

@implementation UserInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self loaddata];
    [self setup];
    [self loginButtonOnClick];
}

- (void)loginButtonOnClick {
    NSURL *url = [NSURL URLWithString:@"http://hw.mikualpha.cn/login.php"];
    
    //创建request
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *params = @"username=maple&password=123456789";
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
            NSLog(@"登陆成功");
            //跳转到新闻首页
            
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

//生成控件
- (void)setup
{
    self.view.backgroundColor = UIColor.whiteColor;
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    self.headImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 100, 100, 100)];
    [_headImage setImage:[UIImage imageNamed:@"icon_directory.jpg"]];
    _headImage.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [_headImage addGestureRecognizer:tap];
    [self.view addSubview:_headImage];
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(130, 120, 200, 40)];
    name.backgroundColor = [UIColor whiteColor];
    name.text = @"超级用户";
    name.textAlignment =  NSTextAlignmentLeft;
    name.font = [UIFont systemFontOfSize:20.f];
    name.font = [UIFont boldSystemFontOfSize:20.f];
    name.textColor = [UIColor blackColor];
    [self.view addSubview:name];
    
    UILabel *sign = [[UILabel alloc] initWithFrame:CGRectMake(130, 160, 250, 20)];
    sign.backgroundColor = [UIColor whiteColor];
    sign.text = @"这家伙很懒，什么都没有留下...";
    sign.textAlignment =  NSTextAlignmentLeft;
    sign.font = [UIFont systemFontOfSize:8.f];
    sign.font = [UIFont boldSystemFontOfSize:15.f];
    sign.textColor = [UIColor blackColor];
    [self.view addSubview:sign];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(5, 200, 100, 70)];
    //[btn1 setBackgroundColor: [UIColor grayColor]];
    [btn1 setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    int num1 = 4;
    NSString *str1 = [NSString stringWithFormat:@"%d", num1];
    NSString *str2 = @"\n评论";
    NSString *str3 = [NSString stringWithFormat:@"%@%@", str1, str2];
    [btn1 setTitle:str3 forState:UIControlStateNormal];
    btn1.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn1.titleLabel.font = [UIFont systemFontOfSize:19.f];
    btn1.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [btn1 addTarget:self action:@selector(payClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(105, 200, 100, 70)];
    //[btn2 setBackgroundColor: [UIColor grayColor]];
    [btn2 setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    int num2 = 3;
    str1 = [NSString stringWithFormat:@"%d", num2];
    str2 = @"\n关注";
    str3 = [NSString stringWithFormat:@"%@%@", str1, str2];
    [btn2 setTitle:str3 forState:UIControlStateNormal];
    btn2.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn2.titleLabel.font = [UIFont systemFontOfSize:19.f];
    btn2.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:btn2];
    
    UIButton *btn3 = [[UIButton alloc] initWithFrame:CGRectMake(205, 200, 100, 70)];
    //[btn3 setBackgroundColor: [UIColor grayColor]];
    [btn3 setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    int num3 = screenRect.size.width;
    str1 = [NSString stringWithFormat:@"%d", num3];
    str2 = @"\n粉丝";
    str3 = [NSString stringWithFormat:@"%@%@", str1, str2];
    [btn3 setTitle:str3 forState:UIControlStateNormal];
    btn3.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn3.titleLabel.font = [UIFont systemFontOfSize:19.f];
    btn3.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:btn3];
    
    UIButton *btn4 = [[UIButton alloc] initWithFrame:CGRectMake(305, 200, 100, 70)];
    //[btn4 setBackgroundColor: [UIColor grayColor]];
    [btn4 setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    int num4 = screenRect.size.height;
    str1 = [NSString stringWithFormat:@"%d", num4];
    str2 = @"\n点赞";
    str3 = [NSString stringWithFormat:@"%@%@", str1, str2];
    [btn4 setTitle:str3 forState:UIControlStateNormal];
    btn4.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn4.titleLabel.font = [UIFont systemFontOfSize:19.f];
    btn4.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:btn4];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 300, screenRect.size.width, 300) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //[tableView1 setBackgroundColor: [UIColor grayColor]];
    /*tableView1.sectionFooterHeight = 0;
     tableView1.sectionHeaderHeight = 6;*/
    _tableView.bounces = NO;
    _tableView.alwaysBounceVertical = NO;
    [self.view addSubview:_tableView];
}

- (void)loaddata{
    self.items = [[NSMutableArray alloc]initWithObjects:@"昵称",@"个性签名",@"性别",@"生日",@"地区",nil];
    self.datalist = [[NSMutableArray alloc]initWithObjects:@"",@"",@"男",@"2019-9-1",@"中国",nil];
    
    /*NSURLSessionConfiguration *defaultConfigObj = [NSURLSessionConfiguration defaultSessionConfiguration];
     NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration:defaultConfigObj
     delegate:self
     delegateQueue:[NSOperationQueue mainQueue]];
     
     NSURL *url = [NSURL URLWithString:@"http://hw.mikualpha.cn/user.php"];*/
}

- (void)payClick{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"请输入个人信息" preferredStyle:UIAlertControllerStyleAlert];
    //增加确定按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //获取第1个输入框；
        UITextField *userNameTextField = alertController.textFields.firstObject;
        
        //获取第2个输入框；
        UITextField *passwordTextField = alertController.textFields.lastObject;
        
        NSLog(@"用户名 = %@，密码 = %@",userNameTextField.text,passwordTextField.text);
        
    }]];
    
    //增加取消按钮；
    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    
    //定义第一个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入用户名";
    }];
    //定义第二个输入框；
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入密码";
    }];
    
    [self presentViewController:alertController animated:true completion:nil];
}

//头像点击事件
-(void)tapClick:(UITapGestureRecognizer *)recognizer{
    
    if (!_photoManager) {
        _photoManager =[[SelectPhotoManager alloc]init];
    }
    [_photoManager startSelectPhotoWithImageName:@"选择头像"];
    __weak typeof(self)mySelf=self;
    //选取照片成功
    _photoManager.successHandle=^(SelectPhotoManager *manager,UIImage *image){
        
        mySelf.headImage.image = image;
        //保存到本地
        NSData *data = UIImagePNGRepresentation(image);
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"headerImage"];
    };
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 2;
    }
    return 3;
}

/*-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
 {
 return 6;
 }*/

- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return @"个人资料";
    }
    return @"完善资料";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellID = [NSString stringWithFormat:@"cellID:%zd", indexPath.section];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (nil == cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if(indexPath.section == 0){
        cell.textLabel.text = _items[indexPath.row];
        cell.detailTextLabel.text = _datalist[indexPath.row];
    }
    else{
        cell.textLabel.text = _items[2 + indexPath.row];
        cell.detailTextLabel.text = _datalist[2 + indexPath.row];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    /*NSString *str1 = @"修改";
     NSString *str2 = _items[indexPath.section * 2 + indexPath.row];
     NSString *str3 = [NSString stringWithFormat:@"%@%@", str1, str2];*/
    NSString *info = _items[indexPath.section * 2 + indexPath.row];
    ModifyInfo *controller = [[ModifyInfo alloc] initWithInfo:info];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:navController animated:YES completion:nil];
    });
    //NSLog(@"succeed");
}

@end
