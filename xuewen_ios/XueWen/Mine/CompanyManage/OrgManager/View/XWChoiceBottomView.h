//
//  XWChoiceBottomView.h
//  XueWen
//
//  Created by Karron Su on 2018/12/15.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^ChoiceAllBlock)(BOOL selected);
typedef void(^NextPageBlock)(void);

@interface XWChoiceBottomView : UIView

@property (nonatomic, copy) ChoiceAllBlock choiceBlock;
@property (nonatomic, copy) NextPageBlock nextBlock;

@end


NS_ASSUME_NONNULL_END
