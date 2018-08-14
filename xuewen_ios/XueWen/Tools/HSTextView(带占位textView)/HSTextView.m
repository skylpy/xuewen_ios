//
//  HSTextView.m
//  happyselling
//
//  Created by Pingzi on 2017/6/15.
//  Copyright © 2017年 iOS李鹏. All rights reserved.
//

#import "HSTextView.h"

@implementation HSTextView



- (void)drawRect:(CGRect)rect
{
    if ([self hasText])
    {
        return;
    }
    else
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[NSFontAttributeName] = self.font;
        dic[NSForegroundColorAttributeName] = self.placeHolderColor;
        CGRect drawRect = CGRectMake(5, 8, rect.size.width - 5, rect.size.height + 20);
        [self.placeHolder drawInRect:drawRect withAttributes:dic];
    }
}

- (void)textDidChange
{
    [self setNeedsDisplay];
}

- (void)setText:(NSString *)text
{
    [super setText:text];
//    _text = text;
    [self textDidChange];
}

- (void)layoutSubviews
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:self];
    [super layoutSubviews];
    [self setNeedsDisplay];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//-(void)setPlaceHolder:(NSString *)placeHolder
//{
//    self.placeHolder = placeHolder;
//    [self setNeedsDisplay];
//}
//
//-(void)setPlaceHolderColor:(UIColor *)placeHolderColor
//{
//    self.placeHolderColor  = placeHolderColor;
//    [self setNeedsDisplay];
//}

@end
