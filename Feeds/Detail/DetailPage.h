//
//  DetailViewController.h
//  Homework
//
//  Created by student9 on 2019/6/22.
//  Copyright © 2019 ksy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DetailPage: UIViewController

//@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) WKWebView *  webView;
@property (nonatomic, strong) UIView* bgView;
@property (nonatomic, strong) UIImageView* imgView;
@property (nonatomic, strong) NSString* groupId;

@property (strong, nonatomic) UIButton *likeIcon;
@property (strong, nonatomic) UITextView *likeNum;
@property (retain, nonatomic) UIImage *beforelike;
@property (retain, nonatomic) UIImage *afterlike;
@property Boolean giveLike;

-(instancetype)initWithGroupId:(NSString*)group_id;
@end

NS_ASSUME_NONNULL_END
