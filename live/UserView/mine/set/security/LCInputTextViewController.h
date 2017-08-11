//
//  LCInputTextViewController.h
//  XCLive
//
//  Created by ztkztk on 14-4-28.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCCustomBackItemController.h"

@interface LCInputTextViewController : LCCustomBackItemController<UITextFieldDelegate>
@property (nonatomic,strong)UITextField *inputText;
@end
