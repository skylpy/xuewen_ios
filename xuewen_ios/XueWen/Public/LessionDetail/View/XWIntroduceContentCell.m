//
//  XWIntroduceContentCell.m
//  XueWen
//
//  Created by Karron Su on 2018/5/15.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWIntroduceContentCell.h"

@interface XWIntroduceContentCell () <UIWebViewDelegate>

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation XWIntroduceContentCell


#pragma mark - Getter / Lazy
- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [UILabel labelWithTextColor:DefaultTitleAColor size:15];
        _titleLabel.text = @"课程简介";
    }
    return _titleLabel;
}

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.scrollView.scrollEnabled = NO;
        _webView.delegate = self;
    }
    return _webView;
}

#pragma mark - InitUI
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self drawUI];
    }
    return self;
}

- (void)drawUI{
    [self addSubview:self.titleLabel];
    [self addSubview:self.webView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(30);
        make.left.mas_equalTo(self).offset(15.5);
    }];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(4.5);
        make.left.mas_equalTo(self).offset(15);
        make.right.mas_equalTo(self).offset(-15);
        make.bottom.mas_equalTo(self).offset(-15);
    }];
    [MBProgressHUD showActivityMessageInWindow:@""];
}

#pragma mark - Setter
- (void)setModel:(XWCoursModel *)model{
    _model = model;
    
    [self.webView loadHTMLString:_model.introduction baseURL:nil];
}

#pragma mark - UIWebViewDelegate

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    NSString *js=@"var script = document.createElement('script');"
    "script.type = 'text/javascript';"
    "script.text = \"function ResizeImages() { "
    "var myimg,oldwidth;"
    "var maxwidth = %f;"
    "for(i=0;i <document.images.length;i++){"
    "myimg = document.images[i];"
    "if(myimg.width > maxwidth){"
    "oldwidth = myimg.width;"
    "myimg.width = %f;"
    "}"
    "}"
    "}\";"
    "document.getElementsByTagName('head')[0].appendChild(script);";
    
    js=[NSString stringWithFormat:js, kWidth, kWidth - 30];
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
   
    self.height = height;
    [self postNotificationWithName:@"IntroductionContent" object:self];
    [MBProgressHUD hideHUD];
}

@end
