//
//  LCRegDoneController.h
//  XCLive
//
//  Created by jacklong on 16/1/12.
//  Copyright © 2016年 www.yuanphone.com. All rights reserved.
//

#import "LCTableViewController.h"
#import "MMBabyPhoto.h"
#import "LCMyUser.h"

@interface LCRegDoneController : LCTableViewController
@property (nonatomic,strong)MMBabyPhoto *babyPhoto;
@property (nonatomic,strong)NSMutableDictionary *infoDic;
@property (nonatomic,strong)UITableViewCell *nicknameCell;
@property (nonatomic,strong)UITableViewCell *brithdayCell;
@property (nonatomic,strong)UITableViewCell *sexCell;
@property (nonatomic)BOOL Loading;
@end
