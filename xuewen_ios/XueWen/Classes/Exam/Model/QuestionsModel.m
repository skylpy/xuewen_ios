//
//  QuestionsModel.m
//  XueWen
//
//  Created by ShaJin on 2017/12/12.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import "QuestionsModel.h"
@implementation QuestionsOptionModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"optionID"        : @"id",
             @"questionsID"     : @"test_node_id",
             @"content"         : @"option_content"
             };
}

- (BOOL)right{
    return [_correct boolValue];
}

- (NSString *)select{
    return _isSelected ? @"1" : @"0";
}

- (void)setSelect:(NSString *)select{
    _isSelected = [select boolValue];
}

+ (NSArray *)mj_ignoredPropertyNames{
    return @[@"isSelected",@"right"];
}

@end

@implementation QuestionsModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{
             @"testID"      : @"test_id",
             @"questionsID" : @"id",
             @"content"       : @"node_title",
             @"creatTime"   : @"create_time",
             @"options"     : @"option"
             };
}

+ (NSDictionary *)objectClassInArray{
    return @{@"options" : @"QuestionsOptionModel"};
}

- (BOOL)multiSelect{
    return [_type boolValue];
}

- (NSString *)hasCommit{
    return _commited ? @"1" : @"0";
}

- (void)setHasCommit:(NSString *)hasCommit{
    _commited = [hasCommit boolValue];
}

+ (NSArray *)mj_ignoredPropertyNames{
    return @[@"multiSelect",@"commited"];
}
@end
