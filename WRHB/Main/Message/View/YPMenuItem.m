

#import "YPMenuItem.h"

@implementation YPMenuItem

+ (instancetype)itemWithImage:(UIImage *)image
                        title:(NSString *)title
                       action:(void (^)(YPMenuItem *item))action;
{
    return [[YPMenuItem alloc] init:title
                              image:image
                             action:(void (^)(YPMenuItem *item))action];
}
- (instancetype) init:(NSString *) title
      image:(UIImage *) image
     action:(void (^)(YPMenuItem *item))action
{
    NSParameterAssert(title.length || image);
    
    self = [super init];
    if (self) {
        _title = title;
        _image = image;
        _action = action;
    }
    return self;
}

- (void)clickMenuItem
{
    if (self.action) {
        self.action(self);
    }
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"<%@ #%p %@>", [self class], self, _title];
}

@end

