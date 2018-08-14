//
//  XWAudioSmallView.h
//  XueWen
//
//  Created by Karron Su on 2018/5/19.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol XWAudioSmallViewDelegate <NSObject>

/** 播放/暂停*/
- (void)playAction;
/** 关闭*/
- (void)closeAction;

@end

@interface XWAudioSmallView : UIView

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UIImageView *headImgView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIButton *closeBtn;

/** 老师头像*/
@property (nonatomic, strong) NSString *coverImageUrl;

@property (nonatomic, weak) id<XWAudioSmallViewDelegate> delegate;



- (void)appearWithAnimation:(BOOL)animation;
- (void)disappear;

@end
