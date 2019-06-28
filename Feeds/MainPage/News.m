#import "News.h"

@interface News()

@end

@implementation News

-(id)initWithGroupId:(NSString*)_group_id Title:(NSString *)_title ImgNum:(int)_imgNum Imgs:(NSMutableArray<NSString*>*)_imgs{
    if (self = [super init]) {
        self.group_id = _group_id;
        self.title = _title;
        self.imgNum = _imgNum;
        self.imgs = _imgs;
    }
    return self;
}

@end
