#import "MainPageViewController.h"
#import "MainPageTableViewCell.h"
#import "SingleImgCell.h"
#import "News.h"
#import "AppDelegate.h"
#import "DetailPage.h"

@interface MainPageViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray<News*> * arrayDS;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UITableView *selectView;
@property (nonatomic, assign) int offset;

@end

@implementation MainPageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    CGRect screenRect = [UIScreen mainScreen].bounds;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 50, screenRect.size.width, screenRect.size.height - 50) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.arrayDS = [NSMutableArray array];
    self.offset = 0;
    [self setupRefresh];
}

-(void)setupRefresh {
    //1.添加刷新控件
    UIRefreshControl *control=[[UIRefreshControl alloc]init];
    [control addTarget:self action:@selector(refreshStateChange:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:control];
    
    //2.马上进入刷新状态，并不会触发UIControlEventValueChanged事件
    [control beginRefreshing];
    
    // 3.加载数据
    [self refreshStateChange:control];
}

-(void)refreshStateChange:(UIRefreshControl *)control {
    NSURLSessionConfiguration * defaultConfigObject = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession * delegateFreeSession = [NSURLSession sessionWithConfiguration:defaultConfigObject delegate:nil delegateQueue:[NSOperationQueue mainQueue]];
    
    NSURL * url = [NSURL URLWithString:@"http://hw.mikualpha.cn/article_feed.php"];
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [request setValue:myDelegate.token forHTTPHeaderField:@"Authorization"];
    [request setHTTPMethod:@"POST"];
    NSString * str  = [NSString stringWithFormat:@"%@%@%@", @"offset=", [NSString stringWithFormat:@"%d", self.offset], @"&count=4"];
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    
    NSURLSessionDataTask * dataTask = [delegateFreeSession dataTaskWithRequest:request completionHandler:^(NSData *  data, NSURLResponse *  response, NSError *  error) {
        if (error == nil) {
            NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
            for (int i = 0; i < [dict[@"data"][@"article_feed"] count]; i++) {
                NSDictionary * temp = dict[@"data"][@"article_feed"][i];
                NSMutableArray<NSString*>* imgs = [NSMutableArray array];
                for (int j = 0; j < [temp[@"image_infos"] count]; j++){
                    NSString * str = [temp[@"image_infos"][j][@"url_prefix"] stringByAppendingString:temp[@"image_infos"][j][@"web_uri"]];
                    [imgs addObject:str];
                }
                News * news = [[News alloc] initWithGroupId:temp[@"group_id"] Title:(NSString *)temp[@"title"] ImgNum:(int)[imgs count] Imgs:(NSMutableArray<NSString*>*)imgs];
                [self.arrayDS insertObject:news atIndex:0];
            }
            self.offset += 4;
            [self.tableView reloadData];
        }
    }];
    [dataTask resume];
    [self.tableView reloadData];
    [control endRefreshing];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return self.arrayDS.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        if ([[self.arrayDS objectAtIndex:indexPath.row] imgNum] == 1){
            MainPageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MPTVC"];
            if (cell == nil) {
                cell = [[MainPageTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MPTVC"];
            }
            cell.title.text = [NSString stringWithFormat:@"%@", [[self.arrayDS objectAtIndex:indexPath.row] title]];
            cell.img1.image = nil;
            cell.img2.image = nil;
            cell.img3.image = nil;
            if ([[self.arrayDS objectAtIndex:indexPath.row] imgNum] >= 1) {
                NSString * urlString = [[self.arrayDS objectAtIndex:indexPath.row] imgs][0];
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
                cell.img1.image = [UIImage imageWithData:data];
            }
            if ([[self.arrayDS objectAtIndex:indexPath.row] imgNum] >= 2) {
                NSString * urlString = [[self.arrayDS objectAtIndex:indexPath.row] imgs][1];
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
                cell.img2.image = [UIImage imageWithData:data];
            }
            if ([[self.arrayDS objectAtIndex:indexPath.row] imgNum] >= 3) {
                NSString * urlString = [[self.arrayDS objectAtIndex:indexPath.row] imgs][2];
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
                cell.img3.image = [UIImage imageWithData:data];
            }
            return cell;
        } else {
            MainPageTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MPTVC"];
            if (cell == nil) {
                cell = [[MainPageTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MPTVC"];
            }
            cell.title.text = [NSString stringWithFormat:@"%@", [[self.arrayDS objectAtIndex:indexPath.row] title]];
            cell.img1.image = nil;
            cell.img2.image = nil;
            cell.img3.image = nil;
            if ([[self.arrayDS objectAtIndex:indexPath.row] imgNum] >= 1) {
                NSString * urlString = [[self.arrayDS objectAtIndex:indexPath.row] imgs][0];
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
                cell.img1.image = [UIImage imageWithData:data];
            }
            if ([[self.arrayDS objectAtIndex:indexPath.row] imgNum] >= 2) {
                NSString * urlString = [[self.arrayDS objectAtIndex:indexPath.row] imgs][1];
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
                cell.img2.image = [UIImage imageWithData:data];
            }
            if ([[self.arrayDS objectAtIndex:indexPath.row] imgNum] >= 3) {
                NSString * urlString = [[self.arrayDS objectAtIndex:indexPath.row] imgs][2];
                NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
                cell.img3.image = [UIImage imageWithData:data];
            }
            return cell;
        }
    
    
}


/**
 *  设置单元格的高度
 */
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
        if ([[self.arrayDS objectAtIndex:indexPath.row] imgNum] == 0) {
            return 60.0f;
        } else if ([[self.arrayDS objectAtIndex:indexPath.row] imgNum] == 1) {
            return 110.0f;
        } else {
            return 185.0f;
        }
    
}


/**
 *  点击单元格触发该方法
 */
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
     DetailPage* detailPage = [[DetailPage alloc]initWithGroupId:[[self.arrayDS objectAtIndex:indexPath.row] group_id]];
    NSLog(@"%@",[[self.arrayDS objectAtIndex:indexPath.row] group_id]);
     UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:detailPage];
     dispatch_async(dispatch_get_main_queue(), ^{
     [self presentViewController:navController animated:YES completion:nil];
     });
     }
}

@end


