//
//  ClassesSelectViewDelegate.h
//  XueWen
//
//  Created by ShaJin on 2017/11/15.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CourseLabelModel;
@protocol ClassesSelectViewDelegate <NSObject>
@optional
- (void)sortLessionDidSelect:(NSString *)text dismiss:(BOOL)dismiss;
- (void)allLessionDidSelectLabel:(CourseLabelModel *)model dismiss:(BOOL)dismiss;
- (void)selectLessionDidSelect:(NSString *)text dismiss:(BOOL)dismiss;
@end
