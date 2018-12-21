//
//  XWOrgInputCell.h
//  XueWen
//
//  Created by Karron Su on 2018/12/12.
//  Copyright © 2018 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^InputBlock)(NSDictionary *dict);
@interface XWOrgInputCell : UITableViewCell

@property (nonatomic, strong) NSString *title;
@property (nonatomic, copy) InputBlock block;

@end

NS_ASSUME_NONNULL_END
