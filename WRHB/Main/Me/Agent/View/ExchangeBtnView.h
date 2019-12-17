//
//  ExchangeBtnView.h
//  Project
//
//  Created AFan on 2019/9/28.
//  Copyright © 2019 AFan. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ExchangeBtnView : UIView{
    NSInteger _selectIndex;
}
@property (nonatomic, strong) UIView *barView;
@property (nonatomic, strong)NSArray *btnTitleArray;
@property (nonatomic, copy)CallbackBlock callbackBlock;
-(void)setSelectIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END
