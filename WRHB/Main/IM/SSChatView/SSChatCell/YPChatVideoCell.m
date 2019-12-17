//
//  YPChatVideoCell.m
//  YPChatView
//
//  Created by soldoros on 2019/10/15.
//  Copyright © 2018年 soldoros. All rights reserved.
//

#import "YPChatVideoCell.h"
#import "VideoModel.h"
#import "NSDate+DaboExtension.h"
#import "ZJCirclePieProgressView.h"

@implementation YPChatVideoCell


-(void)initChatCellUI{
    
    [super initChatCellUI];
   
    
    self.mImgView = [UIImageView new];
    self.mImgView.layer.cornerRadius = 5;
    self.mImgView.layer.masksToBounds  = YES;
    self.mImgView.contentMode = UIViewContentModeScaleAspectFit;
    self.mImgView.backgroundColor = [UIColor whiteColor];
    [self.bubbleBackView addSubview:self.mImgView];
    self.mImgView.userInteractionEnabled = YES;
    
    
    self.mVideoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.mImgView addSubview:self.mVideoBtn];
    [self.mVideoBtn addTarget:self action:@selector(videoButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    self.mVideoBtn.backgroundColor = [UIColor blackColor];
    self.mVideoBtn.alpha = 0.5;
    
    
    self.mVideoImg = [UIImageView new];
    self.mVideoImg.tag = 3000;
    self.mVideoImg.bounds = CGRectMake(0, 0, 40, 40);
    [self.mImgView addSubview:self.mVideoImg];
    self.mVideoImg.image = [UIImage imageNamed:@"icon_bofang"];
    self.mVideoImg.userInteractionEnabled = NO;
    
    // 饼状
    self.videoProgressView = [[ZJCirclePieProgressView alloc] initWithFrame: CGRectMake(0, 0, 40, 40)];
    self.videoProgressView.tag = 3100;
    self.videoProgressView.hidden = YES;
    self.videoProgressView.progressColor = [UIColor whiteColor];
    [self.mImgView addSubview:self.videoProgressView];

}


-(void)setModel:(ChatMessagelLayout *)model{
    
    [super setModel:model];
    
    UIImage *image = [UIImage imageNamed:model.message.backImgString];
    image = [image resizableImageWithCapInsets:model.imageInsets resizingMode:UIImageResizingModeStretch];
    
    self.bubbleBackView.frame = model.bubbleBackViewRect;
    self.bubbleBackView.image = image;
//    [self.bubbleBackView setBackgroundImage:image forState:UIControlStateNormal];
    
    UIImage *vimage = [UIImage imageWithData:model.message.videoModel.thumbnail];
    self.mImgView.image = vimage;
//    self.mImgView.image = [UIImage imageNamed:@"cm_default_avatar"];
    self.mImgView.frame = self.bubbleBackView.bounds;
    //给地图设置一个描边 描边跟背景按钮的气泡图片一样
//    UIImageView *btnImgView = [[UIImageView alloc]initWithImage:image];
//    btnImgView.frame = CGRectInset(self.mImgView.frame, 0.0f, 0.0f);
//    self.mImgView.layer.mask = btnImgView.layer;
    

    self.mVideoBtn.frame = self.mImgView.bounds;
    self.mVideoImg.centerY = self.mImgView.height*0.5;
    self.mVideoImg.centerX = self.mImgView.width*0.5;
    
    self.videoProgressView.centerY = self.mImgView.height*0.5;
    self.videoProgressView.centerX = self.mImgView.width*0.5;

    [self setSendMessageStats];
}


-(void)videoButtonPressed:(UIButton *)sender{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(didChatImageVideoCellIndexPatch:layout:)]){
        [self.delegate didChatImageVideoCellIndexPatch:self.indexPath layout:self.model];
    }
}




@end
