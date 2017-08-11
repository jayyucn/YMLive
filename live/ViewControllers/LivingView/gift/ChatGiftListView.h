//
//  ChatGiftListView.h
//  qianchuo
//
//  Created by jacklong on 16/7/14.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "LiveGiftItemView.h"
#import "ChatGiftCell.h"

typedef void(^SelectGiftBlock)(int currentGiftId);

@interface ChatGiftListView : UITableView<UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic,strong)NSArray *keysArray;
@property (nonatomic,strong)NSMutableArray *giftArray;
@property (nonatomic)BOOL autoSelect;
@property (nonatomic,copy)SelectGiftBlock seleckGiftBlock;
-(void)reflashMe;
@end