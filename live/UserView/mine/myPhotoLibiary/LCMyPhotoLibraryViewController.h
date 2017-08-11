//
//  LCMyPhotoLibraryViewController.h
//  XCLive
//
//  Created by ztkztk on 14-4-21.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCTableViewController.h"
#import "LCSelectPhoto.h"

@interface LCMyPhotoLibraryViewController : LCTableViewController

@end

#pragma mark - network
@interface LCMyPhotoLibraryViewController (NetWork)
-(void)getPhotoListWithPage:(int)page;
-(void)deletePhoto:(NSDictionary *)photoDic;
@end

