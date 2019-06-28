#import <Foundation/Foundation.h>

@interface News : NSObject

@property(strong, nonatomic) NSString * group_id;
@property(strong, nonatomic) NSString * title;
@property(assign, nonatomic) int imgNum;
@property(strong, nonatomic) NSMutableArray<NSString*> * imgs;

-(id)initWithGroupId:(NSString*)_group_id Title:(NSString *)title ImgNum:(int)_imgNum Imgs:(NSMutableArray<NSString*>*)_imgs;

@end
