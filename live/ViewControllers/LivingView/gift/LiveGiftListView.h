//
//  LiveGiftListView.h
//  qianchuo
//
//  Created by jacklong on 16/3/5.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "LiveGiftItemView.h"
#import "LiveGiftCell.h"

typedef void(^SelectGiftBlock)(int currentGiftId);

@interface LiveGiftListView : UITableView<UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic,strong)NSArray *keysArray;
@property (nonatomic,strong)NSMutableArray *giftArray; 
@property (nonatomic)BOOL autoSelect;
@property (nonatomic,copy)SelectGiftBlock seleckGiftBlock;
-(void)reflashMe;
@end
