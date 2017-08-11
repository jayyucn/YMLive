//
//  LCAuthEmailViewController+Email.h
//  XCLive
//
//  Created by ztkztk on 14-7-6.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "LCAuthEmailViewController.h"

#import <MessageUI/MessageUI.h>

@import AddressBookUI;


@interface LCAuthEmailViewController (Email)<MFMailComposeViewControllerDelegate>



-(void)openEmailWithAddress:(NSString *)emailAddress;

@end
