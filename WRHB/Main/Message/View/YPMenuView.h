

#import <UIKit/UIKit.h>
#import "YPMenu.h"

NS_ASSUME_NONNULL_BEGIN

@interface YPMenuView : UIView

- (void)dismissMenu:(BOOL)animated;
- (void)showMenuInView:(UIView *)view
              fromRect:(CGRect)rect
                  menu:(YPMenu *)menu
             menuItems:(NSArray *)menuItems;

@end

NS_ASSUME_NONNULL_END
