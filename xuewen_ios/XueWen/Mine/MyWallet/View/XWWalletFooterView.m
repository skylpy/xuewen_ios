//
//  XWWalletFooterView.m
//  XueWen
//
//  Created by aaron on 2018/11/15.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWWalletFooterView.h"

@interface XWWalletFooterView ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webViews;

@end

@implementation XWWalletFooterView

+ (instancetype)shareWalletFooterView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"XWWalletFooterView" owner:self options:nil].firstObject;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"explain" ofType:@"html"];
    //创建URL
    NSURL* url = [NSURL fileURLWithPath:path];
    //创建NSURLRequest
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    //加载
    [self.webViews loadRequest:request];
    self.webViews.delegate = self;
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
}

@end
