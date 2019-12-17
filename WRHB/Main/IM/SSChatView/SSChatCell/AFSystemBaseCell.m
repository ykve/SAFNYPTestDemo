//
//  AFSystemBaseCell.m
//  Project
//
//  Created by AFan on 2019/4/15.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "AFSystemBaseCell.h"

@implementation AFSystemBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        // Remove touch delay for iOS 7
        for (UIView *view in self.subviews) {
            if([view isKindOfClass:[UIScrollView class]]) {
                ((UIScrollView *)view).delaysContentTouches = NO;
                break;
            }
        }
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = YPChatCellColor;
        self.contentView.backgroundColor = YPChatCellColor;
        [self initChatCellUI];
    }
    return self;
}


-(void)initChatCellUI {
    
}

-(void)setModel:(ChatMessagelLayout *)model{
    _model = model;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
