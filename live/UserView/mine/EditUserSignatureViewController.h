//
//  EditUserSignatureViewController.h
//  qianchuo
//
//  Created by jacklong on 16/4/1.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "LCViewController.h"

@interface EditUserSignatureViewController : LCViewController<UITextViewDelegate>
 
@property (nonatomic, strong)UITextView     *signatureTextView;
@property (nonatomic, strong)UILabel        *promptLabel;

@property (nonatomic, strong)UILabel        *numLabel;
@end
