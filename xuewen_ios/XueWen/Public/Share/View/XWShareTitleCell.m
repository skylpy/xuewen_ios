//
//  XWShareTitleCell.m
//  XueWen
//
//  Created by Karron Su on 2018/6/14.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWShareTitleCell.h"


@interface XWShareTitleCell () <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *coursNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *tchHeadImg;
@property (weak, nonatomic) IBOutlet UILabel *tchNameLabel;
@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation XWShareTitleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.scrollEnabled = NO;
    [self.tchHeadImg rounded:20];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setModel:(XWCoursModel *)model{
    _model = model;
    [self.tchHeadImg sd_setImageWithURL:[NSURL URLWithString:_model.tchOrgPhotoAll]];
    self.tchNameLabel.text = _model.tchOrg;
    self.coursNameLabel.text = _model.courseName;
    [self.webView loadHTMLString:_model.tchOrgIntroduction baseURL:nil];
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
    
    js=[NSString stringWithFormat:js, kWidth, kWidth - 61];
    [webView stringByEvaluatingJavaScriptFromString:js];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
    
    CGFloat height = [[webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight"] floatValue];
    self.height = height;
    [self postNotificationWithName:@"ShareIntroductionTitle" object:self];
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
