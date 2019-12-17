

#import "YPMenu.h"
#import "YPMenuView.h"

@interface YPMenu()
@property (nonatomic, strong) NSMutableArray<YPMenuItem *> *menuItems;
@property (nonatomic, weak) YPMenuView *menuView;
@property (nonatomic, assign) BOOL observing;
@end

@implementation YPMenu

- (instancetype) init
{
    self = [super init];
    if (self) {
        self.menuItems = [NSMutableArray array];
        self.titleFont = [UIFont systemFontOfSize2:15];
        self.arrowHight = 8.f;
        self.menuCornerRadiu = 5.f;
        self.edgeInsets = UIEdgeInsetsMake(1, 10, 1, 10);
        self.minMenuItemHeight = 35.f;
        self.minMenuItemWidth = 32.f; 
        self.gapBetweenImageTitle = 5.f;
        self.menuSegmenteLineStyle = IFMMenuSegmenteLineStylefollowContent;
        self.menuBackgroundStyle = IFMMenuBackgroundStyleDark;
        self.showShadow = YES;
    }
    return self;
}

- (instancetype)initWithItems:(NSArray<YPMenuItem *> *)items{
    self = [self init];
    if (self) {
        [self.menuItems addObjectsFromArray:items];
    }
    return self;
}
- (instancetype)initWithItems:(NSArray<YPMenuItem *> *)items BackgroundStyle:(IFMMenuBackgroundStyle)backgroundStyle{
    self = [self init];
    if (self) {
        [self.menuItems addObjectsFromArray:items];
        self.menuBackgroundStyle = backgroundStyle;
    }
    return self;
}

- (void) dealloc
{
    if (_observing) {        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (void)addMenuItem:(YPMenuItem *)menuItem{
    [self.menuItems addObject:menuItem];
}

- (void) orientationWillChange: (NSNotification *)note
{
    [self dismissMenu];
}

- (void)showFromRect:(CGRect)rect inView:(UIView *)view{
    NSParameterAssert(view);
    NSParameterAssert(self.menuItems.count);
    
    if (_menuView) {
        
        [_menuView dismissMenu:NO];
        _menuView = nil;
    }
    
    if (!_observing) {
        _observing = YES;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationWillChange:) name:UIApplicationWillChangeStatusBarOrientationNotification object:nil];
    }
    
    YPMenuView *menuView = [[YPMenuView alloc] init];
    [view addSubview:menuView];
    _menuView = menuView;
    [menuView showMenuInView:view fromRect:rect menu:self menuItems:self.menuItems];
}

- (void)showFromNavigationController:(UINavigationController *)navigationController WithX:(CGFloat)x{
    CGRect rect = CGRectMake(x, 64, 1, 1);
    [self showFromRect:rect inView:navigationController.view];
}
- (void)showFromTabBarController:(UITabBarController *)tabBarController WithX:(CGFloat)x{
    CGRect rect = CGRectMake(x, [UIScreen mainScreen].bounds.size.height-49, 1, 1);
    [self showFromRect:rect inView:tabBarController.view];
}

- (void) dismissMenu
{
    if (_menuView) {
        [_menuView dismissMenu:NO];
        _menuView = nil;
    }
    if (_observing) {
        _observing = NO;
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}
@end
