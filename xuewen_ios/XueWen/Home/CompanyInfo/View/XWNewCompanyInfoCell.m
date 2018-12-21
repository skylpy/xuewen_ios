//
//  XWNewCompanyInfoCell.m
//  XueWen
//
//  Created by Karron Su on 2018/11/1.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWNewCompanyInfoCell.h"

@interface XWNewCompanyInfoCell () <UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation XWNewCompanyInfoCell

#pragma mark - Getter
- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        _webView.scrollView.scrollEnabled = NO;
    }
    return _webView;
}

#pragma mark - Setter
- (void)setHtml:(NSString *)html{
    _html = html;
    [self.webView loadHTMLString:_html baseURL:nil];
}

#pragma mark - lifecycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self drawUI];
    }
    return self;
}

- (void)drawUI{
    [self.contentView addSubview:self.webView];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [self.webView.scrollView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:@"0"];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.contentView).offset(-10);
        make.left.mas_equalTo(self.contentView).offset(15);
        make.right.mas_equalTo(self.contentView).offset(-15);
        make.top.mas_equalTo(self.contentView);
    }];
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
//    [MBProgressHUD hideHUD];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{

    return YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSString *text = [NSString stringWithFormat:@"%@", context];
    if ([text isEqualToString:@"0"]) {
        if ([keyPath isEqualToString:@"contentSize"]) {
            CGSize contentSize = [self.webView sizeThatFits:CGSizeZero];
            self.cellHeight = contentSize.height;
//            [MBProgressHUD hideHUD];
            [self postNotificationWithName:@"WEBVIEWHEIGHT" object:self];
            
        }
    }
    
}

@end
