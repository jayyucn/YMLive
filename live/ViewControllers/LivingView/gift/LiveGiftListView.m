//
//  LiveGiftListView.m
//  qianchuo
//
//  Created by jacklong on 16/3/5.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "LiveGiftListView.h"

@implementation LiveGiftListView

- (void)dealloc
{
    NSLog(@"%@ dealloc", NSStringFromClass(self.class));
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        self.delegate=self;
        self.dataSource = self;
        self.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return self;
}


-(void)reflashMe
{
    _autoSelect=NO;
    [self reloadData];
}

-(void)setGiftArray:(NSMutableArray *)giftArray
{
    _giftArray=giftArray;
    //_keysArray=[_giftArray allKeys];
    
//    NSComparator cmptr = ^(NSDictionary *gift1,NSDictionary *gift2){
//        
//        int num1=0;
//        ESIntVal(&num1, gift1[@"num"]);
//        
//        int num2=0;
//        ESIntVal(&num2, gift2[@"num"]);
//        
//        if(num1>num2)
//            return NSOrderedDescending;
//        else if(num1<num2)
//            return NSOrderedAscending;
//        else
//            return NSOrderedSame;
//        
//    };
//    
//    [_giftArray sortUsingComparator:cmptr];
    [self reloadData];
    
}


#define kItemNum 4

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if([_giftArray count]>0)
    {
        NSLog(@"_giftArray==%lu",([_giftArray count]+1)/kItemNum);
        int rowNum=((int)[_giftArray count])/kItemNum;
        if(([_giftArray count])%kItemNum!=0)
            rowNum++;
        
        return rowNum;
        
    }else
        return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    LiveGiftCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[LiveGiftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        // 取消选择模式
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    NSInteger flag = indexPath.row * kItemNum;
    for (int i = 0; i<kItemNum; ++i)
    {
        LiveGiftItemView *giftItemView=(LiveGiftItemView *)[cell viewWithTag:1111+i];
        
        if(flag>=[_giftArray count])
        {
            break;
        }
        
        
        if (!giftItemView) {
//            NSLog(@"giftitemview is null flag:%ld",flag);
            return cell;
        }
        
        giftItemView.hidden=NO;
        giftItemView.giftDic=_giftArray[flag];
//        NSLog(@"flag :%ld giftDict:%@",flag,giftItemView.giftDic);
//        [giftItemView updateOfView];
        ESWeakSelf;
        giftItemView.selectBlock=^(int selectTag)
        {
            ESStrongSelf;
            if (_self->_seleckGiftBlock) {
                _self->_seleckGiftBlock(selectTag);
            }
            [_self reloadData];
        };
        
        if(!_autoSelect&&flag==0)
        {
            [giftItemView autoSelectGift];
            _autoSelect=YES;
        }
        
        ++flag;
    }
    
    return cell;
}

#pragma mark - Table view delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ItemHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end

