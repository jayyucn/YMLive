//
//  ReportAlert.h
//  live
//
//  Created by AlexiChen on 15/11/5.
//  Copyright © 2015年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReportAlertAction)(NSString *reportcontent);

@interface ReportAlert : UIView
{
    __weak IBOutlet UIButton *_commit;
    
    __weak UIButton *_selectButton;
}

@property (nonatomic, copy) ReportAlertAction action;

- (void)show;

@end
