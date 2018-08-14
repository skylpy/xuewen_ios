//
//  UIView+FrameView.m
//  happyselling
//
//  Created by ShaJin on 2017/10/28.
//  Copyright © 2017年 iOS李鹏. All rights reserved.
//

#import "UIView+FrameView.h"

@implementation UIView (FrameView)
- (void)setFrameX:(CGFloat)frameX{
    self.frame = CGRectMake(frameX, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (void)setFrameY:(CGFloat)frameY{
    self.frame = CGRectMake(self.frame.origin.x, frameY, self.frame.size.width, self.frame.size.height);
}

- (void)setFrameW:(CGFloat)frameW{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, frameW, self.frame.size.height);
}

- (void)setFrameH:(CGFloat)frameH{
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, frameH);
}

- (CGFloat)frameX{
    return self.frame.origin.x;
}

- (CGFloat)frameY{
    return self.frame.origin.y;
}

- (CGFloat)frameW{
    return self.frame.size.width;
}

- (CGFloat)frameH{
    return self.frame.size.height;
}
@end
