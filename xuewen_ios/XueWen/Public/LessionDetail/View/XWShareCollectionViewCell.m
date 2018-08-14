//
//  XWShareCollectionViewCell.m
//  XueWen
//
//  Created by Karron Su on 2018/6/12.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWShareCollectionViewCell.h"

@interface XWShareCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;


@end

@implementation XWShareCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.imgView rounded:23.5];
}

- (void)setIcon:(NSString *)icon title:(NSString *)title{
    self.imgView.image = LoadImage(icon);
    self.titleLabel.text = title;
}

@end
