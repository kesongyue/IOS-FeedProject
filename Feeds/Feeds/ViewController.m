//
//  ViewController.m
//  Feeds
//
//  Created by student9 on 2019/6/22.
//  Copyright © 2019 student9. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)GoOtherStoryboard:(id)sender {
    UIStoryboard *secondStoryBoard = [UIStoryboard storyboardWithName:@"MainPage" bundle:nil];
    id detailVC = [secondStoryBoard instantiateViewControllerWithIdentifier:@"Main"];
    [self.navigationController pushViewController:detailVC animated:YES];
    NSLog(@"%@",self.navigationController);
}

@end
