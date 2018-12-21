//
//  XWHomeNTopCell.h
//  XueWen
//
//  Created by Karron Su on 2018/10/17.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, HomeNTopIndex) {
    ZCJYTYPE = 0,
    HYGSTYPE = 1,
    CJZJTYPE = 2
};

@protocol XWHomeNTopCellDelegate <NSObject>

@optional
- (void)homeNTopSelectIndex:(HomeNTopIndex)type;

@end

@interface XWHomeNTopCell : UITableViewCell

@property (nonatomic,weak) id <XWHomeNTopCellDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
