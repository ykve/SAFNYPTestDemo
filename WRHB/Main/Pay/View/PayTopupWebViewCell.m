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
    
    
//    self.webView = [[CellWebViewController alloc] init];
    self.webView.frame = CGRectMake(25, 5, kSCREEN_WIDTH - 25*2, 300);
    
//    self.webView.view.backgroundColor = [UIColor redColor];
//    self.webView.UIDelegate = self;
//    self.webView.navigationDelegate = self;
    
//    [self addSubview:self.webView.view];
//    [self.webView.view mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.insets(UIEdgeInsetsMake(5, 25, 20, -25));
//    }];
//    self.webView.frame = CGRectMake(25, 5, kSCREEN_WIDTH - 25*2, 300);
}

- (WKWebView *)webView
{
    if (!_webView)
    {
        //        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:self.webConfig];
        _webView = [WKWebView new];
        _webView.ba_web_isAutoHeight = YES;
        //  添加 WKWebView 的代理，注意：用此方法添加代理
        BAKit_WeakSelf
        [_webView ba_web_initWithDelegate:weak_self.webView uIDelegate:weak_self.webView];

        _webView.backgroundColor = BAKit_Color_Clear_pod;
        _webView.userInteractionEnabled = false;

        self.webView.ba_web_getCurrentHeightBlock = ^(CGFloat currentHeight) {

            BAKit_StrongSelf
//            self.cell_height = currentHeight;
            [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.insets(UIEdgeInsetsMake(5, 25, 20, 25));
                make.height.mas_equalTo(currentHeight);
            }];
            NSLog(@"html 高度2：%f", currentHeight);

//            if (self.WebLoadFinish)
//            {
//                self.WebLoadFinish(self.cell_height);
//            };
        };

        [self.contentView addSubview:_webView];
    }
    return _webView;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
