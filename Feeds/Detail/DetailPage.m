//
//  DetailViewController.m
//  Homework
//
//  Created by student9 on 2019/6/22.
//  Copyright © 2019 ksy. All rights reserved.
//

#import "DetailPage.h"
#import "AppDelegate.h"
#ifndef PrefixHeader_pch
#define PrefixHeader_pch


//竖屏幕宽高
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

//设备型号
#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6Plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhone6PlusScale ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) : NO)
#define iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)

//导航栏
#define StatusBarHeight (iPhoneX ? 44.f : 20.f)
#define StatusBarAndNavigationBarHeight (iPhoneX ? 88.f : 64.f)
#define TabbarHeight (iPhoneX ? (49.f + 34.f) : (49.f))
#define BottomSafeAreaHeight (iPhoneX ? (34.f) : (0.f))
#endif /* PrefixHeader_pch */

// WKWebView 内存不释放的问题解决
@interface WeakWebViewScriptMessageDelegate : NSObject<WKScriptMessageHandler>

//WKScriptMessageHandler 这个协议类专门用来处理JavaScript调用原生OC的方法
@property (nonatomic, weak) id<WKScriptMessageHandler> scriptDelegate;

- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate;

@end

@implementation WeakWebViewScriptMessageDelegate
- (instancetype)initWithDelegate:(id<WKScriptMessageHandler>)scriptDelegate {
    self = [super init];
    if (self) {
        _scriptDelegate = scriptDelegate;
    }
    return self;
}
/*- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
 
 }*/

@end


@implementation DetailPage
-(instancetype)initWithGroupId:(NSString*)group_id{
    if(self = [super init]){
        self.groupId = group_id;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"< Back" style:UIBarButtonItemStylePlain target:self action:@selector(onClickBack:)];
    //使图片居中
    NSString* jScript = @"var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta); var imgs = document.getElementsByTagName('img');for (var i in imgs){imgs[i].style.maxWidth='100%';imgs[i].style.height='auto';}";
    WKUserScript* wkUScript = [[WKUserScript alloc]initWithSource:jScript injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:YES];
    WKUserContentController* wkUc = [[WKUserContentController alloc]init];
    [wkUc addUserScript:wkUScript];
    
    WKWebViewConfiguration * config = [[WKWebViewConfiguration alloc]init];
    config.userContentController = wkUc;
    self.webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40) configuration:config];
    //[self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]]];
    self.webView.navigationDelegate = self;
    [self.view addSubview:_webView];
    
    NSURL* url = [NSURL URLWithString:@"https://i.snssdk.com/course/article_content"];
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [request setValue:myDelegate.token forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    //NSLog(@"%@",[@"groupId=q260BmEU5cED%2bKCdYKa0RQ==" stringByAddingPercentEscapesUsingEncoding:kCFStringEncodingASCII]);
    NSMutableString* str = [[NSMutableString alloc] initWithString:@"groupId="];
    [str appendString:self.groupId];
    //[str appendString:@"%3d%3d"];
    NSLog(@"%@",str);
    NSData* data;
    if(self.groupId != nil){
        data = [str dataUsingEncoding:NSUTF8StringEncoding];
    }else{
        data= [@"groupId=q260BmEU5cED%2bKCdYKa0RQ%3d%3d" dataUsingEncoding:NSUTF8StringEncoding];
    }
    [request setValue: @"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    
    NSData* received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary* dict = [NSJSONSerialization JSONObjectWithData:received options:kNilOptions error:nil];
    NSMutableString* html = [dict[@"data"][@"article_content"] mutableCopy];
    NSMutableString* img_url = [dict[@"data"][@"image_url_prefix"] mutableCopy];
    
    //NSData* htmlData = [html dataUsingEncoding:NSUTF8StringEncoding];
    //NSString* result = [[NSString alloc]initWithData:received encoding: NSUTF8StringEncoding];
    //修改原来的html里面的<img使得图片正常显示
    
    html = [self processImageOfHtml:html andImgUrl:img_url];
    [self.webView loadHTMLString:html baseURL:nil];
}

- (void)onClickBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(NSMutableString*)processImageOfHtml:(NSMutableString*) html andImgUrl:(NSMutableString*) imgUrl{
    while (true) {
        NSMutableString* img_url = [[NSMutableString alloc] initWithString:imgUrl];
        NSString *regex = @"<img src=\"\\{\\{[^>]+>";
        NSRange range = [html rangeOfString:regex options:NSRegularExpressionSearch];
        if(range.location == NSNotFound){
            break;
        }
        NSString* newStr = [html substringWithRange:range];
        regex = @"\\{\"[^\\}]+\\}";
        
        newStr = [newStr substringWithRange:[newStr rangeOfString:regex options:NSRegularExpressionSearch]];
        NSDictionary* imgDict = [NSJSONSerialization JSONObjectWithData:[newStr dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
        [img_url appendString: imgDict[@"web_uri"]];
        [img_url insertString:@"<img src=\"" atIndex:0];
        [img_url appendString:@"\">"];
        [html replaceCharactersInRange:range withString:img_url];
    }
    return html;
}

-(void)showBigImage:(NSString *)imageUrl{
    //创建灰色透明背景，使其背后内容不可操作
    self.bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.bgView setBackgroundColor:[UIColor colorWithRed:0.3
                                                    green:0.3
                                                     blue:0.3
                                                    alpha:0.7]];
    [self.view addSubview:self.bgView];
    
    //创建边框视图
    UIView *borderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-10, 380)];
    //将图层的边框设置为圆脚
    borderView.layer.cornerRadius = 8;
    borderView.layer.masksToBounds = YES;
    //给图层添加一个有色边框
    borderView.layer.borderWidth = 2;
    borderView.layer.borderColor = [[UIColor colorWithRed:0.9
                                                    green:0.9
                                                     blue:0.9
                                                    alpha:0.7] CGColor];
    [borderView setCenter:self.bgView.center];
    [self.bgView addSubview:borderView];
    
    //创建关闭按钮
    UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    [closeBtn setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    //scloseBtn.backgroundColor = [UIColor grayColor];
    closeBtn.titleLabel.textAlignment = UITextAlignmentCenter;
    [closeBtn addTarget:self action:@selector(removeBigImage) forControlEvents:UIControlEventTouchUpInside];
    //[closeBtn setFrame:CGRectMake(borderView.frame.origin.x+borderView.frame.size.width-50, borderView.frame.origin.y-6, 50, 27)];
    [closeBtn setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [self.bgView addSubview:closeBtn];
    
    //创建显示图像视图
    self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, CGRectGetWidth(borderView.frame)-20, CGRectGetHeight(borderView.frame)-20)];
    self.imgView.userInteractionEnabled = YES;
    [self.imgView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]]];
    [borderView addSubview:self.imgView];
    
}
//关闭按钮
-(void)removeBigImage
{
    self.bgView.hidden = YES;
}

#pragma mark - WKNavigationDelegate
// 页面开始加载时调用
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 当内容开始返回时调用
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    
}
// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    NSLog(@"didFinishNavigation");
    
    static  NSString * const jsGetImages =
    @"function getImages(){\
    var objs = document.getElementsByTagName(\"img\");\
    for(var i=0;i<objs.length;i++){\
    objs[i].onclick=function(){\
    document.location=\"myweb:imageClick:\"+this.src;\
    };\
    };\
    return objs.length;\
    };getImages();";
    
    //调用自定义js
    //用js获取全部图片
    [self.webView evaluateJavaScript:jsGetImages completionHandler:^(id Result, NSError * error) {
        NSLog(@"js___Result==%@",Result);
        NSLog(@"js___Error -> %@", error);
    }];
    
}
// 页面加载失败时调用
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 接收到服务器跳转请求之后调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation{
    
}
// 在收到响应后，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(WKNavigationResponse *)navigationResponse decisionHandler:(void (^)(WKNavigationResponsePolicy))decisionHandler{
    
    NSLog(@"%@",navigationResponse.response.URL.absoluteString);
    //允许跳转
    decisionHandler(WKNavigationResponsePolicyAllow);
    //不允许跳转
    //decisionHandler(WKNavigationResponsePolicyCancel);
}
// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
    
    //捕获跳转链接
    NSString* requestString = [[navigationAction.request URL] absoluteString];
    NSLog(@"%@",requestString);
    if([requestString hasPrefix:@"myweb:imageClick:"]){
        NSString *imageUrl = [requestString substringFromIndex:@"myweb:imageClick:".length];
        NSLog(@"image url------%@", imageUrl);
        if(self.bgView){
            //设置不隐藏，还原放大缩小，显示图片
            self.bgView.hidden = NO;
            self.imgView.frame = CGRectMake(10, 10, SCREEN_WIDTH-40, 220);
            [self.imgView setImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]]]];
        }else{
            [self showBigImage:imageUrl];
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}
#pragma mark - WKUIDelegate
// 创建一个新的WebView
- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures{
    return [[WKWebView alloc]init];
}
// 输入框
- (void)webView:(WKWebView *)webView runJavaScriptTextInputPanelWithPrompt:(NSString *)prompt defaultText:(nullable NSString *)defaultText initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSString * __nullable result))completionHandler{
    completionHandler(@"http");
}
// 确认框
- (void)webView:(WKWebView *)webView runJavaScriptConfirmPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(BOOL result))completionHandler{
    completionHandler(YES);
}
// 警告框
- (void)webView:(WKWebView *)webView runJavaScriptAlertPanelWithMessage:(NSString *)message initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(void))completionHandler{
    NSLog(@"%@",message);
    completionHandler();
}
@end

