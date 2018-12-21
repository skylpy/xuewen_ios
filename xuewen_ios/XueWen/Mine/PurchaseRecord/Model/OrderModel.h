//
//  OrderModel.h
//  XueWen
//
//  Created by ShaJin on 2017/12/19.
//  Copyright © 2017年 ShaJin. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface OrderModel : NSObject
/** 订单编号 */
@property (nonatomic, strong) NSString *orderID;
/** 订单课程编号 */
@property (nonatomic, strong) NSString *courseID;
/** 订单课程名称 */
@property (nonatomic, strong) NSString *courseName;
/** 订单课程封面 */
@property (nonatomic, strong) NSString *coverPhoto;
/** 下单时间 */
@property (nonatomic, strong) NSString *creatTime;
/** 订单金额 */
@property (nonatomic, strong) NSString *orderPrice;
/** 实付金额 */
@property (nonatomic, strong) NSString *price;
/** 订单状态 */
@property (nonatomic, strong) NSString *status;
/** 下单人昵称 */
@property (nonatomic, strong) NSString *nickName;
/** 下单人ID */
@property (nonatomic, strong) NSString *userID;
/** 订单类型 0课程1专题3超能组织*/
@property (nonatomic, strong) NSString *type;
/** 订单内容（课程信息||专题信息） */
@property (nonatomic, strong) id purchaseInfo;
/** 专题ID*/
@property (nonatomic, strong) NSString *collegeID;
@end
/**
 "id": 1886,
 "order_id": "18030710660267",
 "account": "xuewen_000084",
 "user_id": 84,
 "nick_name": "13360595494",
 "price": "0.01",
 "coupon_id": 0,
 "status": 0,
 "create_time": 1520388735,
 "payment_time": null,
 "update_time": 1520388735,
 "purchase_type": 0,
 "thematic_id": 0,
 "purchase_info": {
 "id": 395,
 "cover_photo": "uploads\/201832\/1519962854829.png",
 "cover_photo_all": "http:\/\/xuewen-oss.oss-cn-shenzhen.aliyuncs.com\/uploads\/201832\/1519962854829.png",
 "course_name": "企业如何面对未来的发展",
 "tch_org": "马仕举\/金蓝盟",
 "time_length": "00:12:10",
 "introduction": "<p style=\"text-indent: 28px\"><span style=\";font-family:宋体;font-size:14px\"><span style=\"font-family:宋体\">中国的制造业要有前途，就要像习主席所讲的那样，重视产品的创新，淘汰落后的产品和企业。改革开放三四十年来，很多企业在产品上都是低价竞争，大多数企业谈不上创新。<\/span><\/span><\/p><p style=\"text-indent: 28px\"><span style=\";font-family:宋体;font-size:14px\"><span style=\"font-family:宋体\">现在中国有创新的企业，都活得好好的，有预见性的。产品也是有生命周期的，一定要跟得上时代的节奏。经营企业一定要与时代同步，一定要有新思想、新格局、新观念。<\/span><\/span><\/p><p style=\"text-indent: 28px;\"><span style=\";font-family:宋体;font-size:14px\"><span style=\"font-family:宋体\">欢迎走进课程《企业如何面对未来的发展》<\/span><\/span><span style=\";font-family:宋体;font-size:14px\"><span style=\"font-family:宋体\">，企业运营管理实战咨询师马仕举老师为您带来<\/span><\/span><span style=\";font-family:宋体;font-size:14px\"><span style=\"font-family:宋体\">独到的见解<\/span><\/span><span style=\";font-family:宋体;font-size:14px\"><span style=\"font-family:宋体\">。<\/span><\/span><\/p><p style=\"text-indent: 28px;\"><span style=\"font-family: 宋体; font-size: 14px;\">适用人群：<\/span><span style=\"font-family: 宋体; font-size: 14px;\">总经理<\/span><\/p>",
 "tch_org_introduction": "<p style=\"text-indent: 28px\"><span style=\";font-family:宋体;font-size:14px\"><span style=\"font-family:宋体\">企业运营管理实战咨询师<\/span> <\/span><span style=\";font-family:Calibri;font-size:14px\">&nbsp;&nbsp;<\/span><span style=\";font-family:宋体;font-size:14px\"><span style=\"font-family:宋体\">物料管理专家<\/span><\/span><\/p><p style=\"text-indent: 28px\"><span style=\";font-family:宋体;font-size:14px\"><span style=\"font-family:宋体\">丰富的企业工作实战背景<\/span><\/span><span style=\";font-family:宋体;font-size:14px\"><span style=\"font-family:宋体\">：<\/span><\/span><span style=\";font-family:宋体;font-size:14px\"><span style=\"font-family:宋体\">先后在国内大型某民营集团企业、世界<\/span><\/span><span style=\";font-family:Calibri;font-size:14px\">500<span style=\"font-family:宋体\">强某台资企业担任过技术工程师、品保课长、技术部经理、生产部经理、制造总监、<\/span><span style=\"font-family:Calibri\">PMC<\/span><span style=\"font-family:宋体\">总监、供应链总监、常务副总经理兼管理者代表、总经理等职务。<\/span><\/span><\/p><p style=\"text-indent: 28px;\"><span style=\";font-family:宋体;font-size:14px\"><span style=\"font-family:宋体\">具备丰富的企业咨询实战辅导，擅长制造型企业管控模式及战略规划、企业运营管理、企业文化建设、企业组织与流程再造、精益化生产管理、技术工艺、质量管理、营销管理、企业内外部激励机制构建、企业人力资源模块优化等。注重为企业解决实际问题，在将先进管理理念和企业实际相结合方面积累了丰富的实战操盘经验，获得了服务和指导过的企业的较高评价。<\/span><\/span><\/p><p style=\"text-indent: 28px;\"><span style=\"font-family: 宋体; font-size: 14px;\">深度辅导与服务的客户有<\/span><span style=\"font-family: 宋体; font-size: 14px;\">：<\/span><span style=\"font-family: 宋体; font-size: 14px;\">彩虹电器集团有限公司、新东方汽车仪表有限公司、南通医疗器械有限公司、行星工程机械有限公司、金山机械有限公司、容川机电科技有限公司、喜之林家具有限公司、泽润木业有限公司、瑞昶实业有限公司、新丰集团、汇龙泵业有限公司、华泰模塑电器有限公司、环宇工具有限公司、舒奇蒙能源股份有限公司、伟立机器人股份有限公司、金科印务有限公司、龙欣印染有限公司、曹达化工有限公司、麦特电器股份有限公司、都市风韵家具有限公司、玉升铸造有限公司、海得威机械有限公司、艾泰克环保科技有限公司等多家企业运营管理提升项目诊断、咨询和辅导<\/span><span style=\"font-family: 宋体; font-size: 14px;\">。<\/span><\/p>",
 "create_time": 1519972266,
 "total": 3,
 "favorable_price": "0.01",
 "price": "0.01",
 "number": 1,
 "p_people_num": 1,
 "people_count": 1,
 "amount": "0.01"
 }
 */
