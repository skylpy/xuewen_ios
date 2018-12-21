//
//  XWOrderFooterView.m
//  XueWen
//
//  Created by aaron on 2018/12/15.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWOrderFooterView.h"

@implementation XWOrderFooterView

+ (instancetype)shareOrderFooterView {
    
    return [[NSBundle mainBundle] loadNibNamed:@"XWOrderFooterView" owner:self options:nil].firstObject;
}

@end
