//
//  XWNotesTableCell.h
//  XueWen
//
//  Created by Karron Su on 2018/5/15.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XWCommentModel.h"
#import "XWNotesModel.h"


@interface XWNotesTableCell : UITableViewCell

@property (nonatomic, strong) XWCommentModel *commentModel;

@property (nonatomic, strong) XWNotesModel *noteModel;

@end
