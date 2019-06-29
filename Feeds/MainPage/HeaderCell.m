#import "HeaderCell.h"

@implementation HeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.layoutMargins = UIEdgeInsetsZero;
        
        self.title = [[UILabel alloc]  initWithFrame:CGRectMake(-8, 8, 40, 40)];
        self.title.numberOfLines = 1;
        self.title.textAlignment = NSTextAlignmentLeft;
        self.title.font = [UIFont boldSystemFontOfSize:18];
        self.title.textColor = [UIColor blackColor];
        self.title.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.title];
    }
    return self;
}

@end
