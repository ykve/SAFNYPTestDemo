//
//  ClubHomeCell.m
//  WRHB
//
//  Created by AFan on 2019/10/31.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "ClubHomeCell.h"

@interface ClubHomeCell ()

@end

@implementation ClubHomeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    ClubHomeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ClubHomeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setupSubViews];
    }
    return self;
}


#pragma mark ----- subView
- (void)setupSubViews {
    
    
}






- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
