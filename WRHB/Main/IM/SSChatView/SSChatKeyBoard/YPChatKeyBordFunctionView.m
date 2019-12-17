//
//  YPChatKeyBordFunctionView.m
//  YPChatView
//
//  Created by soldoros on 2019/11/25.
//  Copyright © 2018年 soldoros. All rights reserved.
//

#import "YPChatKeyBordFunctionView.h"




@interface YPChatKeyBordFunctionView()

@property (nonatomic, strong) UIPageControl *pageControll;
@property (nonatomic, assign) NSInteger numberPage;

@end


@implementation YPChatKeyBordFunctionView{
    NSArray *titles,*images,*viewTags;
    NSInteger count;
    NSInteger number;
}





-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = YPChatCellColor;
        count = 8;
        
        //添加功能只需要在标题和图片数组里面直接添加就行
//        titles = @[@"照片",@"视频",@"位置"];
//        images = @[@"zhaopian",@"shipin",@"weizhi"];
        
        if ([AppModel sharedInstance].chatSessionType == ChatSessionType_SystemRoom || [AppModel sharedInstance].chatSessionType == ChatSessionType_ManyPeople_Game) {
            viewTags = @[@(ChatExtensionBar_Rule),@(ChatExtensionBar_WanFa),@(ChatExtensionBar_RedEnevpole),@(ChatExtensionBar_CustomerService),@(ChatExtensionBar_MakeMoney),@(ChatExtensionBar_Join),@(ChatExtensionBar_Fu),@(ChatExtensionBar_Recharge),@(ChatExtensionBar_Album),@(ChatExtensionBar_Camera),@(ChatExtensionBar_Help),@(0),@(0),@(0),@(0),@(0)];
            
        } else if ([AppModel sharedInstance].chatSessionType == ChatSessionType_ManyPeople_NormalChat) {
             viewTags = @[@(ChatExtensionBar_Album),@(ChatExtensionBar_Camera),@(ChatExtensionBar_RedEnevpole),@(ChatExtensionBar_Recharge),@(ChatExtensionBar_Fu),@(ChatExtensionBar_MakeMoney),@(ChatExtensionBar_Join),@(ChatExtensionBar_Help)];
            
        } else if ([AppModel sharedInstance].chatSessionType == ChatSessionType_CustomerService) {
            viewTags = @[@(ChatExtensionBar_Album),@(ChatExtensionBar_Camera),@(ChatExtensionBar_Recharge),@(ChatExtensionBar_Fu),@(ChatExtensionBar_MakeMoney),@(ChatExtensionBar_Join),@(ChatExtensionBar_Help)];
            
        } else {
            viewTags = @[@(ChatExtensionBar_Album),@(ChatExtensionBar_Camera),@(ChatExtensionBar_RedEnevpole),@(ChatExtensionBar_Recharge),@(ChatExtensionBar_Fu),@(ChatExtensionBar_MakeMoney),@(ChatExtensionBar_Join),@(ChatExtensionBar_Help)];
            
        }
        [self imgOrTitleTagArray:viewTags];
        
        
        NSInteger number = titles.count%count == 0 ? titles.count/count :titles.count/count +1;
        
        
        _mScrollView = [UIScrollView new];
        _mScrollView.frame = self.bounds;
        _mScrollView.centerY = self.height * 0.5;
        _mScrollView.backgroundColor = YPChatCellColor;
        _mScrollView.pagingEnabled = YES;
        _mScrollView.delegate = self;
        [self addSubview:_mScrollView];
        _mScrollView.maximumZoomScale = 2.0;
        _mScrollView.minimumZoomScale = 0.5;
        _mScrollView.canCancelContentTouches = NO;
        _mScrollView.delaysContentTouches = YES;
        _mScrollView.showsVerticalScrollIndicator = FALSE;
        _mScrollView.showsHorizontalScrollIndicator = FALSE;
        _mScrollView.backgroundColor = [UIColor clearColor];
        _mScrollView.contentSize = CGSizeMake(YPSCREEN_Width *number, self.height);
        
//        _pageControll = [[UIPageControl alloc] init];
        _pageControll = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 0, 10)];
//        _pageControll.bounds = CGRectMake(0, 0, 160, 10);
        _pageControll.centerX  = YPSCREEN_Width*0.5;
        _pageControll.top = self.height - kiPhoneX_Bottom_Height;
        _pageControll.numberOfPages = number;
        _pageControll.currentPage = 0;

        [_pageControll setCurrentPageIndicatorTintColor:[UIColor grayColor]];
        [_pageControll setPageIndicatorTintColor:makeColorRgb(200, 200, 200)];
        
        [self addSubview:_pageControll];
        
//        _pageControll.backgroundColor = [UIColor redColor];
        
        
        for(NSInteger i=0;i<number;++i){
            
            UIView *backView = [UIView new];
            backView.bounds = CGRectMake(0, 0, self.width-40, self.height-55);
            backView.centerX = self.width*0.5 + i*self.width;
            backView.top = 20;
            [_mScrollView addSubview:backView];
            
            for(NSInteger j= (i * count);j<(i+1)*count && j<titles.count;++j){
                
                UIView *btnView = [UIView new];
                btnView.bounds = CGRectMake(0, 0, backView.width/4, backView.height*0.5);
                btnView.tag = [viewTags[j] integerValue];
                btnView.left = j%4 * btnView.width;
                btnView.top = (j/4)%2*btnView.height;
                [backView addSubview:btnView];
                btnView.backgroundColor = YPChatCellColor;
//                if(btnView.top>btnView.height) {
//                    btnView.top = 0;
//                }
                
                
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                btn.bounds = CGRectMake(0, 0, 50, 50);
                btn.top = 15;
                btn.titleLabel.font = [UIFont systemFontOfSize:14];
                btn.centerX = btnView.width*0.5;
                [btnView addSubview:btn];
                NSString *icoName = images[j];
                if (icoName.length > 0) {
                    [btn setImage:[UIImage imageNamed:icoName] forState:UIControlStateNormal];
                }
                btn.userInteractionEnabled = YES;
                
                
                UILabel *lab = [UILabel new];
                lab.bounds = CGRectMake(0, 0, 80, 20);
                lab.text = titles[j];
                lab.font = [UIFont systemFontOfSize:12];
                lab.textColor = [UIColor grayColor];
                lab.textAlignment = NSTextAlignmentCenter;
                [lab sizeToFit];
                lab.centerX = btnView.width*0.5;
                lab.top = btn.bottom + 15;
                [btnView addSubview:lab];
                lab.userInteractionEnabled = YES;
                
                
                UITapGestureRecognizer *gesture=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(footerGestureClick:)];
                [btnView addGestureRecognizer:gesture];
                
            }
        }
        
    }
    return self;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    if (scrollView == self.mScrollView) {
        if (scrollView.contentOffset.x >= YPSCREEN_Width * self.numberPage){
            self.numberPage = 1;
        } else {
            self.numberPage = 0;
        }
        self.pageControll.currentPage = (self.mScrollView.contentOffset.x / YPSCREEN_Width);
    }
}

//多功能点击10+
-(void)footerGestureClick:(UITapGestureRecognizer *)sender{
    
    if(_delegate && [_delegate respondsToSelector:@selector(YPChatKeyBordFunctionViewBtnClick:)]){
        [_delegate YPChatKeyBordFunctionViewBtnClick:sender.view.tag];
    }
}




- (void)imgOrTitleTagArray:(NSArray *)tagArray {
    
    NSMutableArray *titleArray = [NSMutableArray array];
    NSMutableArray *imageArray = [NSMutableArray array];
    
    for (NSNumber *tag in tagArray) {
        NSString *title;
        NSString *image;
        switch (tag.integerValue) {
            case ChatExtensionBar_Fu:
                title = @"福利";
                image = @"csb_fu";
                
                break;
            case ChatExtensionBar_Rule:
                title = @"群规";
                image = @"csb_rule";
                break;
            case ChatExtensionBar_RedEnevpole:
                title = @"红包";
                image = @"csb_redenevpole";
                break;
            case ChatExtensionBar_Recharge:
                title = @"充值";
                image = @"csb_recharge";
                break;
            case ChatExtensionBar_MakeMoney:
                title = @"赚钱";
                image = @"csb_make_money";
                break;
            case ChatExtensionBar_Join:
                title = @"加盟";
                image = @"csb_join";
                break;
            case ChatExtensionBar_Help:
                title = @"帮助";
                image = @"csb_help";
                break;
            case ChatExtensionBar_CustomerService:
                title = @"客服";
                image = @"csb_customer_service";
                break;
            case ChatExtensionBar_Camera:
                title = @"拍摄";
                image = @"csb_camera";
                break;
            case ChatExtensionBar_Album:
                title = @"照片";
                image = @"csb_photo_album";
                break;
            case ChatExtensionBar_WanFa:
                title = @"玩法";
                image = @"csb_wanfa";
                break;
            default:
                title = @"";
                image = @"";
                break;
        }
        [titleArray addObject:title];
        [imageArray addObject:image];
    }
    
    titles = [titleArray copy];
    images = [imageArray copy];
    
}


@end
