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
@property (nonatomic, strong) NSArray* array;
@property (nonatomic, strong) UIView* bgView;
@property (nonatomic, strong) UIImageView* imgView;

@end

NS_ASSUME_NONNULL_END
