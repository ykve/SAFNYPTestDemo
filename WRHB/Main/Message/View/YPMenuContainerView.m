

#import "YPMenuContainerView.h"
#import "YPMenuView.h"

@implementation YPMenuContainerView

- (void) dealloc { NSLog(@"dealloc %@", self); }

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = ApHexColor(@"#000000", 0.2);
        
        UITapGestureRecognizer *gestureRecognizer;
        gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                    action:@selector(singleTap:)];
        [self addGestureRecognizer:gestureRecognizer];
    }
    return self;
}

- (void)singleTap:(UITapGestureRecognizer *)recognizer
{
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:[YPMenuView class]] && [subview respondsToSelector:@selector(dismiss:)]) {
            [subview performSelector:@selector(dismiss:) withObject:@(YES)];
        }
    }
}

@end

