//
//  LCMyFootprintsViewController+NetWork.h
//  XCLive
//
//  Created by ztkztk on 14-5-14.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCMyFootprintsViewController.h"

@interface LCMyFootprintsViewController (NetWork)
-(void)getFootprintsList:(int)page;
-(void)deleteFootsWithIndexPath:(NSIndexPath *)indexPath;
-(void)removeAllFoots;
@end
