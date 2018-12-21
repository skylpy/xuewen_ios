//
//  XWChoiceLabelCell.h
//  XueWen
//
//  Created by Karron Su on 2018/12/14.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWLabelModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ChoiceBlock)(XWLabelModel *labelModel);
@interface XWChoiceLabelCell : UITableViewCell

@property (nonatomic, strong) XWLabelModel *model;
@property (nonatomic, copy) ChoiceBlock block;

@end

NS_ASSUME_NONNULL_END
