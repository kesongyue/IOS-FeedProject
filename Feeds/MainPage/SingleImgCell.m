#import "SingleImgCell.h"

@implementation SingleImgCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.layoutMargins = UIEdgeInsetsZero;
        
        CGRect screenRect = [UIScreen mainScreen].bounds;
        self.title = [[UILabel alloc]  initWithFrame:CGRectMake(20, 10, screenRect.size.width - 130, 50)];
        self.title.numberOfLines = 2;
        self.title.textAlignment = NSTextAlignmentLeft;
        self.title.font = [UIFont boldSystemFontOfSize:16];
        self.title.textColor = [UIColor blackColor];
        self.title.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.title];
        
        self.img1 = [[UIImageView alloc] init];
        self.img1.frame = CGRectMake(320, 20, 80, 80);
        self.img1.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:self.img1];
    }
    return self;
}

@end
