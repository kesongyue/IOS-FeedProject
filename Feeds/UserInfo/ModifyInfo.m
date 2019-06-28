//
//  ModifyInfo.m
//  Feeds
//
//  Created by student7 on 2019/6/28.
//  Copyright © 2019 student9. All rights reserved.
//

#import "ModifyInfo.h"

@interface ModifyInfo ()
@property(nonatomic, strong) NSString *Info;
@property(nonatomic, strong) NSArray<NSString*> *allAttributeKeys;

@end

@implementation ModifyInfo

- (instancetype)initWithInfo:(NSString *)info {
    if (self = [super init]) {
        self.Info = info;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(onClickBack:)];
    
    [self setup];
    [self loadData];
}

- (void)onClickBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//生成控件
- (void)setup {
    self.view.backgroundColor = UIColor.whiteColor;
    
    UITextField * textField = [[UITextField alloc]initWithFrame:CGRectMake(20, 100, 280, 40)];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    NSString *str1 = @"请输入你的";
    NSString *str2 = [NSString stringWithFormat:@"%@%@", str1, _Info];
    textField.placeholder = str2;
    [self.view addSubview:textField];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(320, 100, 80, 40)];
    [btn setBackgroundColor: [UIColor greenColor]];
    [btn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.font = [UIFont systemFontOfSize:19.f];
    btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [self.view addSubview:btn];
    
}

- (void)loadData {
    NSString *str1 = @"修改";
    NSString *str2 = [NSString stringWithFormat:@"%@%@", str1, _Info];
    self.title = str2;
    NSLog(@"%@",_Info);
}

@end
