//
//  PayTopupWebViewCell.m
//  WRHB
//
//  Created by AFan on 2019/12/10.
//  Copyright © 2019 AFan. All rights reserved.
//

#import "PayTopupWebViewCell.h"


@interface PayTopupWebViewCell ()<WKUIDelegate,WKNavigationDelegate>

@end


@implementation PayTopupWebViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID
{
    PayTopupWebViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[PayTopupWebViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI {
    
    
    self.webView = [[CellWebViewController alloc] init];
//    self.webView.view.frame = CGRectMake(25, 5, kSCREEN_WIDTH - 25*2, 300);
//    self.webView.view.backgroundColor = [UIColor redColor];
    
    
//    self.webView.UIDelegate = self;
//    self.webView.navigationDelegate = self;
    [self addSubview:self.webView.view];
    
//    [self.webView.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.insets(UIEdgeInsetsMake(5, 25, 20, -25));
//    }];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
