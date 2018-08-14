//
//  XWArticleContentCell.m
//  XueWen
//
//  Created by Karron Su on 2018/4/27.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWArticleContentCell.h"

@interface XWArticleContentCell () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation XWArticleContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.webView.delegate = self;
    self.webView.scrollView.scrollEnabled = NO;
}

#pragma mark - Setter
- (void)setModel:(XWArticleContentModel *)model{
    _model = model;
    [self.webView loadHTMLString:_model.contentHtml baseURL:nil];
    
}

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
    
    js=[NSString stringWithFormat:js,[UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.width-15];
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    self.cellHeight = height;
    [self postNotificationWithName:@"ARTICLE_WEBVIEW_LOADFINISH" object:self];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
