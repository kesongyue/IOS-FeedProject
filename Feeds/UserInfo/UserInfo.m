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
#import <AFNetworking/AFNetworking.h>

@interface UserInfo () <UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray<NSString*> *datalist;
@property(nonatomic, strong) NSMutableArray<NSString*> *items;
@property (strong, nonatomic) UIImageView *headImage;
@property (nonatomic, strong)SelectPhotoManager *photoManager;

@property(nonatomic, strong) NSString *url1;
@property(nonatomic, assign) int like_count;
@property(nonatomic, assign) int comment_count;
@property(nonatomic, assign) int whichnum;
@property(nonatomic, strong) NSString *nickname;
@property(nonatomic, strong) NSString *signment;

@property(nonatomic, strong) UILabel *name;
@property(nonatomic, strong) UILabel *sign;
@property(nonatomic, strong) UIButton *btn1;
@property(nonatomic, strong) UIButton *btn2;
@property(nonatomic, strong) UIButton *btn3;
@property(nonatomic, strong) UIButton *btn4;

@end

@implementation UserInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeNameNotification:) name:@"ChangeNameNotification" object:nil];
    
    [self loaddata];
}

-(void)ChangeNameNotification:(NSNotification*)notification{
    NSDictionary *nameDictionary = [notification userInfo];
    int flag = 0;
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (_whichnum == 0){
        _name.text = [nameDictionary objectForKey:@"name"];
        flag = 1;
    }
    else if (_whichnum == 1){
        _sign.text = [nameDictionary objectForKey:@"name"];
        flag = 1;
    }
    else if (_whichnum == 2){
        _datalist[2] = [nameDictionary objectForKey:@"name"];
        [_tableView reloadData];
    }
    else if (_whichnum == 3){
        _datalist[3] = [nameDictionary objectForKey:@"name"];
        [_tableView reloadData];
    }
    else if (_whichnum == 4){
        _datalist[4] = [nameDictionary objectForKey:@"name"];
        [_tableView reloadData];
    }
    if (flag == 1){
        NSURLSessionConfiguration *defaultConfigObj = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration:defaultConfigObj
                                                                          delegate:self
                                                                     delegateQueue:[NSOperationQueue mainQueue]];
        NSURL * url = [NSURL URLWithString:@"http://hw.mikualpha.cn/user.php"];
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
        [request setValue:myDelegate.token forHTTPHeaderField:@"Authorization"];
        [request setHTTPMethod:@"POST"];
        NSString * str  = [NSString stringWithFormat:@"%@%@%@%@", @"nickname=", _name.text, @"&signment=", _sign.text];
        NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:data];
        
        NSURLSessionDataTask *dataTask = [delegateFreeSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
            NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
            NSNumber* status = [dic objectForKey:@"status"];
            NSLog(@"jsonString%@", jsonString);
            NSLog(@"error%@", error);
            int myStatus = [status intValue];
            if (myStatus == 200){
                NSLog(@"upload succeed");
            }else if (myStatus == 400){
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"参数错误" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"点击取消");
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
            }else if (myStatus == 401){
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登录信息已过期" message:@"" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    NSLog(@"点击取消");
                }]];
                [self presentViewController:alertController animated:YES completion:nil];
            }
        }];
        
        [dataTask resume];
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//生成控件
- (void)setup
{
    self.view.backgroundColor = UIColor.whiteColor;
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    self.headImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 100, 100, 100)];
    NSURL *imageUrl = [NSURL URLWithString: self.url1];
    UIImage *myImages = [UIImage imageWithData:[NSData dataWithContentsOfURL:imageUrl]];
    _headImage.image = myImages;
    _headImage.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [_headImage addGestureRecognizer:tap];
    [self.view addSubview:_headImage];
    
    _name = [[UILabel alloc] initWithFrame:CGRectMake(130, 120, 200, 40)];
    _name.backgroundColor = [UIColor whiteColor];
    _name.text = _nickname;
    _name.textAlignment =  NSTextAlignmentLeft;
    _name.font = [UIFont systemFontOfSize:20.f];
    _name.font = [UIFont boldSystemFontOfSize:20.f];
    _name.textColor = [UIColor blackColor];
    [self.view addSubview:_name];
    
    _sign = [[UILabel alloc] initWithFrame:CGRectMake(130, 160, 250, 20)];
    _sign.backgroundColor = [UIColor whiteColor];
    //sign.text = @"这家伙很懒，什么都没有留下...";
    _sign.text = _signment;
    _sign.textAlignment =  NSTextAlignmentLeft;
    _sign.font = [UIFont systemFontOfSize:8.f];
    _sign.font = [UIFont boldSystemFontOfSize:15.f];
    _sign.textColor = [UIColor blackColor];
    [self.view addSubview:_sign];
    
    _btn1 = [[UIButton alloc] initWithFrame:CGRectMake(5, 200, 100, 70)];
    //[btn1 setBackgroundColor: [UIColor grayColor]];
    [_btn1 setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    //int num1 = 4;
    NSString *str1 = [NSString stringWithFormat:@"%d", _comment_count];
    NSString *str2 = @"\n评论";
    NSString *str3 = [NSString stringWithFormat:@"%@%@", str1, str2];
    [_btn1 setTitle:str3 forState:UIControlStateNormal];
    _btn1.titleLabel.textAlignment = NSTextAlignmentCenter;
    _btn1.titleLabel.font = [UIFont systemFontOfSize:19.f];
    _btn1.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:_btn1];
    
    _btn2 = [[UIButton alloc] initWithFrame:CGRectMake(105, 200, 100, 70)];
    //[btn2 setBackgroundColor: [UIColor grayColor]];
    [_btn2 setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    int num2 = 3;
    str1 = [NSString stringWithFormat:@"%d", num2];
    str2 = @"\n关注";
    str3 = [NSString stringWithFormat:@"%@%@", str1, str2];
    [_btn2 setTitle:str3 forState:UIControlStateNormal];
    _btn2.titleLabel.textAlignment = NSTextAlignmentCenter;
    _btn2.titleLabel.font = [UIFont systemFontOfSize:19.f];
    _btn2.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:_btn2];
    
    _btn3 = [[UIButton alloc] initWithFrame:CGRectMake(205, 200, 100, 70)];
    //[btn3 setBackgroundColor: [UIColor grayColor]];
    [_btn3 setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    int num3 = screenRect.size.width;
    str1 = [NSString stringWithFormat:@"%d", num3];
    str2 = @"\n粉丝";
    str3 = [NSString stringWithFormat:@"%@%@", str1, str2];
    [_btn3 setTitle:str3 forState:UIControlStateNormal];
    _btn3.titleLabel.textAlignment = NSTextAlignmentCenter;
    _btn3.titleLabel.font = [UIFont systemFontOfSize:19.f];
    _btn3.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:_btn3];
    
    _btn4 = [[UIButton alloc] initWithFrame:CGRectMake(305, 200, 100, 70)];
    //[btn4 setBackgroundColor: [UIColor grayColor]];
    [_btn4 setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    //int num4 = screenRect.size.height;
    str1 = [NSString stringWithFormat:@"%d", _like_count];
    str2 = @"\n点赞";
    str3 = [NSString stringWithFormat:@"%@%@", str1, str2];
    [_btn4 setTitle:str3 forState:UIControlStateNormal];
    _btn4.titleLabel.textAlignment = NSTextAlignmentCenter;
    _btn4.titleLabel.font = [UIFont systemFontOfSize:19.f];
    _btn4.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:_btn4];
    
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
    
    NSURLSessionConfiguration *defaultConfigObj = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *delegateFreeSession = [NSURLSession sessionWithConfiguration:defaultConfigObj
                                                                      delegate:self
                                                                 delegateQueue:[NSOperationQueue mainQueue]];
    
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSURL *url = [NSURL URLWithString:@"http://hw.mikualpha.cn/user.php"];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setValue:myDelegate.token forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"GET"];
    NSURLSessionDataTask *dataTask = [delegateFreeSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        NSNumber* status = [dic objectForKey:@"status"];
        int myStatus = [status intValue];
        if (myStatus == 200){
            NSDictionary* dataDic = [dic objectForKey:@"data"];
            self.nickname = [dataDic objectForKey:@"nickname"];
            self.signment = [dataDic objectForKey:@"signment"];
            self.url1 = [dataDic objectForKey:@"avatar"];
            //跳转到新闻首页
            NSLog(@"成功获取信息");
            [self setup];
        }else if (myStatus == 400){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"参数错误" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"点击取消");
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }else if (myStatus == 401){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登录信息已过期" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"点击取消");
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
    }];
    
    [dataTask resume];
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
        
        NSData *imagedata = UIImagePNGRepresentation(image);
        image = [UIImage imageWithData:imagedata];
        mySelf.headImage.image = image;
        [self upLoadImage:image];
        //保存到本地
        NSData *data = UIImagePNGRepresentation(image);
        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"headerImage"];
    };
}

-(void)upLoadImage:(UIImage *)image{
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer.timeoutInterval = 20;
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager.requestSerializer setValue:myDelegate.token forHTTPHeaderField:@"Authorization"];
    NSString *URLSTR = @"http://hw.mikualpha.cn/avatar_upload.php";
    
    [manager POST:URLSTR parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *imagedata = UIImagePNGRepresentation(image);
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        // 设置时间格式
        [formatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *dateString = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString  stringWithFormat:@"%@.png", dateString];
        //按照表单格式把二进制文件写入formData表单
        [formData appendPartWithFileData:imagedata name:@"file" fileName:fileName mimeType:@"image/png"];
        
    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        //NSLog(@"成功%@", responseObject);
        NSString* jsonString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSData* jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        NSNumber* status = [dic objectForKey:@"status"];
        int myStatus = [status intValue];
        if(myStatus == 200){
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"更换头像成功" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                NSLog(@"点击取消");
            }]];
            [self presentViewController:alertController animated:YES completion:nil];
        }
        //NSLog(@"成功");
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"上传失败%@", error);
    }];
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
    _whichnum = (int)(indexPath.section * 2 + indexPath.row);
    ModifyInfo *controller = [[ModifyInfo alloc] initWithInfo:info];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:navController animated:YES completion:nil];
    });
    //NSLog(@"succeed");
}

@end
