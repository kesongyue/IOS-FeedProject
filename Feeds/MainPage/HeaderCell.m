#import "HeaderCell.h"

@implementation HeaderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.layoutMargins = UIEdgeInsetsZero;
        
        self.title = [[UILabel alloc]  initWithFrame:CGRectMake(0, 00, self.frame.size.width, 50)];
        self.title.numberOfLines = 1;
        self.title.textAlignment = NSTextAlignmentLeft;
        self.title.font = [UIFont boldSystemFontOfSize:16];
        self.title.textColor = [UIColor blackColor];
        self.title.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:self.title];
    }
    return self;
}

@end
