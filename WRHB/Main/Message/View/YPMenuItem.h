

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YPMenuItem : NSObject
@property (nullable, nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *title;

@property (nonatomic, copy) void (^__nullable action)(YPMenuItem *item);

- (void)clickMenuItem;
+ (instancetype)itemWithImage:(nullable UIImage *)image
                        title:(NSString *)title
                       action:(void (^__nullable)(YPMenuItem *item))action;

@end

NS_ASSUME_NONNULL_END
