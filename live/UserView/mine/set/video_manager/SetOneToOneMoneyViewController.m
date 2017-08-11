//
//  SetOneToOneMoneyViewController.m
//  qianchuo 设置1v1视频的钱
//
//  Created by jacklong on 16/10/25.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "SetOneToOneMoneyViewController.h"

@interface SetOneToOneMoneyViewController()<UITextViewDelegate,UIGestureRecognizerDelegate>
{
    BOOL isRequest;
    UITextView *_inputTextView;
    UIButton   *_confirmBtn;
}

@end

@implementation SetOneToOneMoneyViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    self.title = @"1v1视频聊天条件";
    self.view.backgroundColor = [UIColor whiteColor]; 
    
    UIImage *bgImg = [UIImage imageNamed:@"image/setotomoney/set_money_bg"];
    UIImageView *bgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, bgImg.size.width/4, bgImg.size.height/4)];
    bgImgView.image = bgImg;
    bgImgView.centerX = SCREEN_WIDTH/2;
    [self.view  addSubview:bgImgView];
    
    UILabel *promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(35,90, bgImgView.width-70, 80)];
    promptLabel.text = @"为了防止过多的视频聊天邀请对您造成骚扰，请您为视频聊天设置一些条件，同时也能为您带来有美币收益";
    promptLabel.numberOfLines = 4;
    promptLabel.textColor = [UIColor blackColor];
    promptLabel.font = [UIFont systemFontOfSize:15.f];
    [bgImgView addSubview:promptLabel];
    
    UILabel *adviseLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, promptLabel.bottom+5, bgImgView.width, 20)];
    adviseLabel.textColor = ColorPink;
    adviseLabel.font = [UIFont systemFontOfSize:12.f];
    adviseLabel.textAlignment = NSTextAlignmentCenter;
    adviseLabel.text = @"建议条件：20~80 钻/分钟";
    [bgImgView addSubview:adviseLabel];
    
    UIImage *areaImg = [UIImage imageNamed:@"image/setotomoney/set_money_area_bg"];
    UIImageView *areaImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, adviseLabel.top+15, areaImg.size.width/4, areaImg.size.height/4)];
    areaImgView.centerX = bgImgView.width/2;
    areaImgView.image = areaImg;
    [bgImgView addSubview:areaImgView];
    

    UIImage *editBgImg = [UIImage imageNamed:@"image/setotomoney/edit_money_bg"];
    
    UIImageView *editBgImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 30,editBgImg.size.width/3, editBgImg.size.height/3)];
    editBgImgView.image = editBgImg;
    editBgImgView.centerX = areaImgView.width/2;
    [areaImgView addSubview:editBgImgView];
    
    UILabel *promptDiamondLabel = [[UILabel alloc] initWithFrame:CGRectMake(editBgImgView.left+editBgImgView.width/2+3, 30,editBgImg.size.width/6, editBgImg.size.height/3)];
    promptDiamondLabel.text = @"钻/分钟";
    promptDiamondLabel.textColor = [UIColor whiteColor];
    promptDiamondLabel.font = [UIFont systemFontOfSize:14.f];
    [areaImgView addSubview:promptDiamondLabel];
    
    _inputTextView=[[UITextView alloc] initWithFrame:editBgImgView.frame];
    _inputTextView.left = editBgImgView.left+10;
    _inputTextView.delegate=self;
    _inputTextView.textColor=[UIColor whiteColor];
    if ([LCCore globalCore].setDiamond > 0) {
        _inputTextView.text = [NSString stringWithFormat:@"%d",[LCCore globalCore].setDiamond];
    } else {
       _inputTextView.text = @"20";
    }
    
    _inputTextView.backgroundColor = [UIColor clearColor];
    _inputTextView.font = [UIFont boldSystemFontOfSize:14];
    _inputTextView.keyboardType = UIKeyboardTypeNumberPad;
    _inputTextView.returnKeyType = UIReturnKeyDone;
    [areaImgView addSubview:_inputTextView];
    [_inputTextView becomeFirstResponder];
    
    _confirmBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, _inputTextView.bottom, 60, 40)];
    [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    _confirmBtn.titleLabel.text = @"确认";
    _confirmBtn.titleLabel.textColor = [UIColor whiteColor];
    _confirmBtn.centerX = areaImgView.width/2;
    [areaImgView addSubview:_confirmBtn];
    [_confirmBtn addTarget:self action:@selector(setMoneyAction) forControlEvents:UIControlEventTouchUpInside];
    
    UITapGestureRecognizer* singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                       action:@selector(singleTap)];
    singleRecognizer.numberOfTapsRequired = 1; // 单击
    singleRecognizer.delegate = self;
    [self.view addGestureRecognizer:singleRecognizer];
}

#pragma mark - 事件
- (void) setMoneyAction
{
    NSString *diamond = _inputTextView.text;
    if (diamond.length ==0) {
        [LCNoticeAlertView showMsg:@"请您设置每分钟扣费钻石，不能低于20钻石"];
        return;
    }
    
    int diamondInt = [diamond intValue];
    if (diamondInt < 20) {
        [LCNoticeAlertView showMsg:@"请您设置每分钟合理扣费钻石，不能低于20钻石"];
        return;
    }
    
    if (isRequest) {
        return;
    }
    
    isRequest = YES;
    ESWeakSelf;
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"diamond":@(diamondInt)}  withPath:URL_OVO_SET_DEDUCTION withRESTful:GET_REQUEST withSuccessBlock:^(NSDictionary *responseDic) {
        ESStrongSelf;
        _self->isRequest = NO;
        
        NSLog(@"URL_OVO_SET_DEDUCTION res %@", responseDic);
        
        if ([responseDic[@"stat"] intValue] == 200) {
            [_self setDiamondSucc:responseDic[@"msg"]];
            [LCCore globalCore].setDiamond = diamondInt;
        } else {
           [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
        
    } withFailBlock:^(NSError *error) {
        ESStrongSelf;
        _self->isRequest = NO;
        [LCNoticeAlertView showMsg:@"设置失败"];
    }];
    
}

- (void)setDiamondSucc:(NSString *)msg
{
    ESWeakSelf;
    UIAlertView *alertView = [UIAlertView alertViewWithTitle:@"提示" message:msg cancelButtonTitle:@"确认" didDismissBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
        ESStrongSelf;
        [_self.navigationController popViewControllerAnimated:YES];
    } otherButtonTitles:nil, nil];
    [alertView show];
}

#pragma mark textfield delegate
- (BOOL)textView:(UITextView *)atextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    NSString *new = [_inputTextView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger res = 4-[new length];
    if(res >= 0){
        return YES;
    }
    else{
        NSRange rg = {0,[text length]+res};
        if (rg.length>0) {
            NSString *s = [text substringWithRange:rg];
            [_inputTextView setText:[_inputTextView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSLog(@"textFieldShouldReturn");
    return YES;
}


#pragma mark 屏幕点击
- (void) singleTap
{
    
}

#pragma mark - 点击范围
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:_inputTextView];
    CGPoint confirmPoint = [touch locationInView:_confirmBtn];
    if (point.x > 0 && point.x < _inputTextView.frame.size.width &&
        point.y > 0 && point.y < _inputTextView.frame.size.height)
    {
        [_inputTextView becomeFirstResponder];
    }
    else if (confirmPoint.x > 0 && confirmPoint.x < _confirmBtn.frame.size.width &&
               confirmPoint.y > 0 && confirmPoint.y < _confirmBtn.frame.size.height)
    {
        [self setMoneyAction];
    }
    else
    {
        [_inputTextView resignFirstResponder];
    }
    
    return NO;
}



@end
