//
//  NSArray+CP.m
//  cloudspaceSupport
//
//  Created by muzihuowei on 13-5-14.
//  Copyright (c) 2013年 muzihuowei. All rights reserved.
//

#import "NSArray+CP.h"

@implementation NSArray (CP)

/**
 *  该数组是否为空：nil或count == 0
 *
 *  @param array 待判定数组
 *
 *  @return 是否为空
 */
+ (BOOL)isEmpty:(NSArray *)array
{
    return (array == nil || [array count] == 0);
}

- (id)objAtIndex:(NSUInteger)index
{
    if (self.count == 0)
    {
        assert(FALSE);
        return nil;
    }

    if (index < self.count)
    {
        return [self objectAtIndex:index];
    }else{
    
        assert(FALSE);
        return nil;
    }
}

- (BOOL)containValue:(id)object
{
    BOOL contain = NO;
    for (NSObject *obj in self) {
        if ([obj isEqual:object]) {
            contain = YES;
            break;
        }
    }
    return contain;
}



- (NSUInteger)indexOfObject:(id)obj usingComparator:(NSComparator)cmptr
{
    int index = 0;
    for (id iObj in self) {
        if(cmptr(obj, iObj) == NSOrderedSame)
        {
            return index;
        }
        index++;
    }
    return NSNotFound;
}

@end


@implementation NSMutableArray (CP)

/**
 *  保证去重下  把一个array中的元素拷贝到另一个array中
 *
 *  @param otheArray 被拷贝的array
 *  @param cmptr     比较元素相同的比较器
 */
- (void)addObjectsFromArray:(NSArray*)otheArray withComparator:(NSComparator)cmptr
{
    for (id item in otheArray)
    {
        if ([self indexOfObject:item usingComparator:cmptr] == NSNotFound)
        {
            [self addObject:item];
        }
    }
}


/**
 按首字母排序
 
 @param arr 数据源
 */
+ (NSMutableArray *)sortObjectsAccordingToInitialWithArray:(NSArray *)arr{
    // 初始化UILocalizedIndexedCollation
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    //得出collation索引的数量，这里是27个（26个字母和1个#）
    NSInteger sectionTitlesCount = [[collation sectionTitles] count];
    //初始化一个数组newSectionsArray用来存放最终的数据，我们最终要得到的数据模型应该形如@[@[以A开头的数据数组], @[以B开头的数据数组], @[以C开头的数据数组], ... @[以#(其它)开头的数据数组]]
    NSMutableArray *newSectionsArray = [[NSMutableArray alloc] initWithCapacity:sectionTitlesCount];
    
    //初始化27个空数组加入newSectionsArray
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [newSectionsArray addObject:array];
    }
    
    //将每个名字分到某个section下
    for (id personModel in arr) {
        //获取First属性的值所在的位置，
        NSInteger sectionNumber = [collation sectionForObject:personModel collationStringSelector:@selector(first)];
        //把name为“林丹”的p加入newSectionsArray中的第11个数组中去
        NSMutableArray *sectionNames = newSectionsArray[sectionNumber];
        [sectionNames addObject:personModel];
    }
    
    //对每个section中的数组按照name属性排序
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        NSMutableArray *personArrayForSection = newSectionsArray[index];
        NSArray *sortedPersonArrayForSection = [collation sortedArrayFromArray:personArrayForSection collationStringSelector:@selector(name)];
        newSectionsArray[index] = sortedPersonArrayForSection;
    }
    
    //删除空的数组
    NSMutableArray *finalArr = [NSMutableArray new];
    for (NSInteger index = 0; index < sectionTitlesCount; index++) {
        if (((NSMutableArray *)(newSectionsArray[index])).count != 0) {
            [finalArr addObject:newSectionsArray[index]];
        }
    }
    return finalArr;
}

/**
 *  将数组拆分成固定长度的子数组
 *
 *  @param array 需要拆分的数组
 *
 *  @param subSize 指定长度
 *
 */
+ (NSArray *)splitArray: (NSArray *)array withSubSize : (int)subSize{
    //  数组将被拆分成指定长度数组的个数
    unsigned long count = array.count % subSize == 0 ? (array.count / subSize) : (array.count / subSize + 1);
    //  用来保存指定长度数组的可变数组对象
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    
    //利用总个数进行循环，将指定长度的元素加入数组
    for (int i = 0; i < count; i ++) {
        //数组下标
        int index = i * subSize;
        //保存拆分的固定长度的数组元素的可变数组
        NSMutableArray *arr1 = [[NSMutableArray alloc] init];
        //移除子数组的所有元素
        [arr1 removeAllObjects];
        
        int j = index;
        //将数组下标乘以1、2、3，得到拆分时数组的最大下标值，但最大不能超过数组的总大小
        while (j < subSize*(i + 1) && j < array.count) {
            [arr1 addObject:[array objectAtIndex:j]];
            j += 1;
        }
        //将子数组添加到保存子数组的数组中
        [arr addObject:[arr1 copy]];
    }
    
    return [arr copy];
}


@end

