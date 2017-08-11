//
//  LCLevelManager.m
//  XCLive
//
//  Created by jacklong on 15/10/31.
//  Copyright © 2015年 www.0x123.com. All rights reserved.
//

#import "LCLevelManager.h"

@implementation LCLevelManager
static double g_consume[37];
static double g_income[50];



static LCLevelManager *_sharedDegreeManage = nil;

+ (LCLevelManager *)sharedDegreeManage
{
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        _sharedDegreeManage = [[self alloc] init];
    });
    return _sharedDegreeManage;
}



-(id)init
{
    if(self=[super init])
    {
        
        g_consume[0]=800;
        g_consume[1]=1600;
        g_consume[2]=3200;
        g_consume[3]=6400;
        g_consume[4]=12800;
        g_consume[5]=25600;
        g_consume[6]=51200;
        g_consume[7]=102400;
        g_consume[8]=204800;
        g_consume[9]=409600;
        g_consume[10]=819200;
        g_consume[11]=1228800;
        g_consume[12]=1857600;
        g_consume[13]=2515200;
        g_consume[14]=3330400;
        g_consume[15]=4260800;
        g_consume[16]=5221600;
        g_consume[17]=6443200;
        g_consume[18]=7686400;
        g_consume[19]=8972800;
        g_consume[20]=10245600;
        g_consume[21]=11691200;
        g_consume[22]=13121600;
        g_consume[23]=15743200;
        g_consume[24]=19486400;
        g_consume[25]=24772800;
        g_consume[26]=31772800;
        g_consume[27]=38772800;
        g_consume[28]=51772800;
        g_consume[29]=79772800;
        g_consume[30]=110772800;
        g_consume[31]=156772800;
        g_consume[32]=223772800;
        g_consume[33]=321772800;
        g_consume[34]=470772800;
        g_consume[35]=670772800;
        g_consume[36]=1000000000;
        
        g_income[0]=800;
        g_income[1]=1600;
        g_income[2]=3200;
        g_income[3]=6400;
        g_income[4]=12800;
        g_income[5]=25600;
        g_income[6]=51200;
        g_income[7]=102400;
        g_income[8]=204800;
        g_income[9]=409600;
        g_income[10]=819200;
        g_income[11]=1638400;
        g_income[12]=2576800;
        g_income[13]=3515200;
        g_income[14]=4530400;
        g_income[15]=5660800;
        g_income[16]=6821600;
        g_income[17]=8043200;
        g_income[18]=9286400;
        g_income[19]=10572800;
        g_income[20]=11945600;
        g_income[21]=13491200;
        g_income[22]=15421600;
        g_income[23]=17243200;
        g_income[24]=19886400;
        g_income[25]=24772800;
        g_income[26]=31772800;
        g_income[27]=38772800;
        g_income[28]=46772800;
        g_income[29]=55772800;
        g_income[30]=65772800;
        g_income[31]=71772800;
        g_income[32]=83772800;
        g_income[33]=99772800;
        g_income[34]=118772800;
        g_income[35]=139772800;
        g_income[36]=169772800;
        g_income[37]=209772800;
        g_income[38]=267772800;
        g_income[39]=345772800;
        g_income[40]=425772800;
        g_income[41]=515772800;
        g_income[42]=615772800;
        g_income[43]=725772800;
        g_income[44]=845772800;
        g_income[45]=975772800;
        g_income[45]=1115772800;
        g_income[47]=1255772800;
        g_income[48]=1405772800;
        g_income[49]=1605772800;
        
        
    }
    return self;
}

// 主播等级
-(int)getCharmDegreeByIncome:(double)income
{
    int i=0;
    for(;i<50;i++)
    {
        if(income <= g_income[i]) {
            break;
        }
    }
    return i;
}

//获取主播升级进度
-(float)getCharmDegreeProgress:(double)income
{
    int currentDegree=[self getCharmDegreeByIncome:income];
    
    
    double currentDegreeIncome= (currentDegree==0)? 0:g_income[currentDegree-1];
    return (income-currentDegreeIncome)/(g_income[currentDegree]-currentDegreeIncome);
}
// 消费等级

-(int)getConsumeDegreeByConsume:(double)consume
{
    int i=0;
    for(;i<37;i++)
    {
        if(consume <= g_consume[i]) {
            break;
        }
    }
    return i;
}


//获取玩家升级进度

-(float)getConsumeDegreeProgress:(double)consume
{
    int currentDegree=[self getConsumeDegreeByConsume:consume];
    
    double currentDegreeConsume= (currentDegree==0) ? 0:g_consume[currentDegree-1];
    
    return (consume-currentDegreeConsume)/(g_consume[currentDegree]-currentDegreeConsume);
}

@end
