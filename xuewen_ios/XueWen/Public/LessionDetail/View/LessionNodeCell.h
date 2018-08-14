//
//  LessionNodeCell.h
//  XueWen
//
//  Created by ShaJin on 2018/1/11.
//  Copyright © 2018年 ShaJin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LessionNodeModel;
@class CourseAudioModel;
@interface LessionNodeCell : UITableViewCell

@property (nonatomic, assign) NSInteger currentTime;

- (void)setModel:(LessionNodeModel *)model free:(BOOL)free isPlay:(BOOL)isPlay;
- (void)setAudio:(CourseAudioModel *)audio free:(BOOL)free isPlay:(BOOL)isPlay;

@end
