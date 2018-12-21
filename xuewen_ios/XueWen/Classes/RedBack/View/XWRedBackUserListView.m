//
//  XWRedBackUserListView.m
//  XueWen
//
//  Created by aaron on 2018/9/8.
//  Copyright © 2018年 KarronSu. All rights reserved.
//

#import "XWRedBackUserListView.h"
#import "XWRedBackCell.h"

static NSString * const XWRedBackCellID = @"XWRedBackCellID";

@interface XWRedBackUserListView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) NSMutableArray * dataArray;
@end

@implementation XWRedBackUserListView

- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = 0;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView registerClass:[XWRedBackCell class] forCellReuseIdentifier:XWRedBackCellID];
    }
    return _tableView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
        [self requestData];
    }
    return self;
}

- (void)requestData {
    
     NSArray * array = @[@"1.任何用户都有3次摇红包机会，用户以余额购买课 程后，即可再获得一次摇红包机会； ",
      @"2.用户邀请好友参与活动，好友获得多少金额的红包， 用户也可获得同等金额的红包；",
      @"3.红包满10元即可提现，提现申请需在App内提交， 提现需绑定支付宝；",
      @"4.每位用户只能绑定一个支付宝，同一个支付宝不能 同时绑定多个用户；",
      @"5.每天提现次数最多3次，每月最多10次，到账时间 T+3；",
      @"6.本次活动最终解释权归广州学问信息科技有限公司 所有。",
                        ];
    for (NSString * title in array) {
        XWRedBackModel * model = [XWRedBackModel new];
        model .height = [title heightWithWidth:kWidth-92 size:14];
        model.title = title;
        [self.dataArray addObject:model];
    }
    [self.tableView reloadData];
}

- (void)setupUI {
    
    [self addSubview:self.tableView ];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    XWRedBackModel * model = self.dataArray[indexPath.row];
    return model.height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    XWRedBackCell * cell = [tableView dequeueReusableCellWithIdentifier:XWRedBackCellID forIndexPath:indexPath];
    
    cell.model = self.dataArray[indexPath.row];
    return cell;
}

@end

@implementation XWRedBackModel

@end


