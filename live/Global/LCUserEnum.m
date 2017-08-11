//
//  testObj.m
//  XCLive
//
//  Created by ztkztk on 14-4-24.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCUserEnum.h"

//@implementation LCUserEnum


//NSArray* iThinkList(void)//我想
//{
//    return @[@"找个对象",
//             @"征婚",
//             @"谈恋爱",
//             @"去约会",
//             @"去旅游",
//             @"去看电影",
//             @"见面",
//             @"找个聊友",
//             @"找个共度晚餐",
//             @"去逛街",
//             @"去唱歌",
//             @"去健身",
//             @"温柔拥抱",
//             @"开车兜风",
//             @"自己填写"];
//}

//int selectIThink(void)
//{
//    int flag=0;
//    for(NSString *aString in iThinkList())
//    {
//        if([aString isEqualToString:[LCMyUser mine].ithink])
//        {
//            break;
//        }
//        flag++;
//    }
//    if(flag==[iThinkList() count])
//        flag=0;
//    return flag;
//}
//
//
//
//NSArray* goodList(void)
//{
//    return @[@"不抽烟",
//             @"不喝酒",
//             @"爱情专一",
//             @"帅",
//             @"漂亮",
//             @"温柔",
//             @"才华横溢",
//             @"有房",
//             @"有车",
//             @"潜力股",
//             @"富二代",
//             @"土豪"];
//}
//
//NSArray *hobbiesList(void)
//{
//    return @[@"抽烟",
//             @"喝酒",
//             @"泡妞",
//             @"赌博",
//             @"旅游",
//             @"健身",
//             @"足球",
//             @"篮球",
//             @"羽毛球",
//             @"乒乓球",
//             @"台球",
//             @"高尔夫",
//             @"钓鱼",
//             @"游泳",
//             @"瑜伽",
//             @"做菜",
//             @"酒吧",
//             @"玩电脑",
//             @"唱歌",
//             @"看书",
//             @"看电影",
//             @"宅",
//             @"逛商场",
//             @"开车",
//             @"吃遍大街小巷",
//             @"摄影",
//             @"打牌麻将"];
//
//}


NSDictionary *getMultiList(NSString *originString, NSArray *listArray)
{
    
    
    NSMutableDictionary *listDic=[NSMutableDictionary dictionary];
    for(NSString *title in listArray)
    {
        //{@"select":@(YES),@"content":@"土豪"}
        NSRange range=[originString rangeOfString:title];
        if(range.location!=NSNotFound){
            [listDic setObject:@(YES) forKey:title];
        }else{
            [listDic setObject:@(NO) forKey:title];
        }
    }
    
    
    
    //获取自定义字符串
    NSArray *array = [originString componentsSeparatedByString:@"/"];
    NSLog(@"array:%@",array);
    
    NSString *custom=@"";
    
    for(NSString *title in array)
    {
        int i=0;
        for(;i<[listArray count];i++)
        {
            NSString *titleA=listArray[i];
            if([title isEqualToString:titleA])
                break;
            
        }
        if(i==[listArray count])
        {
            custom=title;
            break;
        }
        
    }
    
    return @{@"list":listDic,@"custom":custom};
    
}


//@end


/*
 *
 *
 */
//
//NSArray* jobList(void)//我想
//{
//    return @[@"无",
//             @"计算机/互联网/IT/通讯/手机",
//             @"金融/银行/证券/投资",
//             @"娱乐/艺术/表演",
//             @"生产/加工/制造",
//             @"医疗/护理/制药",
//             @"酒店/餐饮/旅游/其他服务",
//             @"文体/影视/写作/媒体",
//             @"建筑/房地产/装修/物管",
//             @"学术/设计/创意",
//             @"市场/公关",
//             @"交通/仓储/物流",
//             @"财务/ 审计/统计",
//             @"能源/矿产/地质勘察",
//             @"商务/采购/贸易",
//             @"客服/技术支持",
//             @"电子/半导体/仪器仪表",
//             @"电气/能源/动力",
//             @"工程/机械",
//             @"保险",
//             @"法律/法务",
//             @"教育/培训",
//             @"人力资源",
//             @"军人/警察",
//             @"学生",
//             @"公务员/事业单位",
//             @"农村劳动者",
//             @"其他"];
//}
//
//int selectJob(void)
//{
//    int flag=0;
//    for(NSString *aString in jobList())
//    {
//        if([aString isEqualToString:[LCMyUser mine].job])
//        {
//            break;
//        }
//        flag++;
//    }
//    return flag;
//}
//
//
//NSArray* statureList(void)//体型
//{
//    return @[@"骨感",
//             @"苗条",
//             @"匀称",
//             @"微胖",
//             @"健壮",
//             @"丰满"];
//
//}
//
//int selectStature(void)
//{
//    int flag=0;
//    for(NSString *aString in statureList())
//    {
//        if([aString isEqualToString:[LCMyUser mine].stature])
//        {
//            break;
//        }
//        flag++;
//    }
//    return flag;
//
//}
//
