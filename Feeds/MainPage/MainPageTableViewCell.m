#import "MainPageTableViewCell.h"

@implementation MainPageTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.layoutMargins = UIEdgeInsetsZero;
        
        CGRect screenRect = [UIScreen mainScreen].bounds;
        self.title = [[UILabel alloc]  initWithFrame:CGRectMake(20, 5, screenRect.size.width - 40, 40)];
        self.title.numberOfLines = 2;
        self.title.textAlignment = NSTextAlignmentLeft;
        self.title.font = [UIFont boldSystemFontOfSize:16];
        self.title.textColor = [UIColor blackColor];
        self.title.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.title];
        
        self.img1 = [[UIImageView alloc] init];
        self.img1.frame = CGRectMake(20, 55, 120, 120);
        self.img1.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:self.img1];
        
        self.img2 = [[UIImageView alloc] init];
        self.img2.frame = CGRectMake(145, 55, 120, 120);
        self.img2.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:self.img2];
        
        self.img3 = [[UIImageView alloc] init];
        self.img3.frame = CGRectMake(280, 55, 120, 120);
        self.img3.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:self.img3];
    }
    return self;
}

@end
