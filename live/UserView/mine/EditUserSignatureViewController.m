//
//  EditUserSignatureViewController.m
//  qianchuo
//
//  Created by jacklong on 16/4/1.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "EditUserSignatureViewController.h"

#define  NAME_LENGHT 32

@interface  EditUserSignatureViewController()
{
    BOOL _isLoading;
}
@end

@implementation EditUserSignatureViewController

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    self.title = ESLocalizedString(@"个性签名");
    
    UIButton *leftItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    leftItemBtn.frame = CGRectMake(0, 0, 65.0, 30.0);
    
    [leftItemBtn setTitle:ESLocalizedString(@"取消")
                 forState:UIControlStateNormal];
    leftItemBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    leftItemBtn.backgroundColor = [UIColor clearColor];
    
    [leftItemBtn addTarget:self
                    action:@selector(leftAction)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftItem=[[UIBarButtonItem alloc] initWithCustomView:leftItemBtn];
    self.navigationItem.leftBarButtonItem=leftItem;
    
    
    UIButton *rightItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightItemBtn.frame=CGRectMake(0, 0, 65.0, 30.0);
    
    rightItemBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [rightItemBtn setTitle:ESLocalizedString(@"保存")
                  forState:UIControlStateNormal];
    rightItemBtn.backgroundColor=[UIColor clearColor];
    
    [rightItemBtn addTarget:self
                     action:@selector(rightAction)
           forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightItem=[[UIBarButtonItem alloc] initWithCustomView:rightItemBtn];
    self.navigationItem.rightBarButtonItem=rightItem;
    
    UIView  *headLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 15, SCREEN_WIDTH, 1)];
    headLineView.backgroundColor = RGBA16(0x20000000);
    [self.view  addSubview:headLineView];
    
    
    UIView * contentContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, headLineView.bottom, SCREEN_WIDTH, 80)];
    //发送框容器
    contentContainerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:contentContainerView];
    
    _signatureTextView = [[UITextView alloc] initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-40, contentContainerView.height)];
    _signatureTextView.text = [LCMyUser mine].signature;
    _signatureTextView.backgroundColor = [UIColor clearColor];
    _signatureTextView.textColor = ColorPink;
    _signatureTextView.delegate = self;
    _signatureTextView.font = [UIFont systemFontOfSize:15.f];
    [_signatureTextView setReturnKeyType:UIReturnKeyDefault];
    [contentContainerView addSubview:_signatureTextView];
    [_signatureTextView becomeFirstResponder];
    
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-30, contentContainerView.bottom-30, 30, 15)];
    _numLabel.textAlignment = NSTextAlignmentLeft;
    _numLabel.textColor = [UIColor grayColor];
    _numLabel.font  = [UIFont systemFontOfSize:11.f];
    
    [self.view addSubview:_numLabel];

    
    UIView  *endLineView = [[UIView alloc] initWithFrame:CGRectMake(0, contentContainerView.bottom, SCREEN_WIDTH, 1)];
    endLineView.backgroundColor = RGBA16(0x20000000);
    [self.view addSubview:endLineView];
    
    _promptLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, endLineView.bottom+30, SCREEN_WIDTH, 20)];
    _promptLabel.textAlignment = NSTextAlignmentCenter;
    _promptLabel.textColor = [UIColor grayColor];
    _promptLabel.font  = [UIFont systemFontOfSize:16.f];
    
    [self.view addSubview:_promptLabel];
    _promptLabel.text = [NSString stringWithFormat:ESLocalizedString(@"您最多还能输入%d个文字"),(int)(NAME_LENGHT - _signatureTextView.text.length)];
    _numLabel.text = [NSString stringWithFormat:@"%d",(int)(NAME_LENGHT - _signatureTextView.text.length)];
}


- (void)textViewDidChange:(UITextView *)textView
{
    if (textView == _signatureTextView) {
        if (textView.text.length > NAME_LENGHT) {
            textView.text = [textView.text substringToIndex:NAME_LENGHT];
            _promptLabel.text = [NSString stringWithFormat:ESLocalizedString(@"您最多还能输入0个文字")];
            _numLabel.text = [NSString stringWithFormat:@"%d",0];
        } else {
            _promptLabel.text = [NSString stringWithFormat:ESLocalizedString(@"您最多还能输入%d个文字"),(int)(NAME_LENGHT - _signatureTextView.text.length)];
            _numLabel.text = [NSString stringWithFormat:@"%d",(int)(NAME_LENGHT - _signatureTextView.text.length)];
        }
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)string
{
    if (textView == _signatureTextView) {
        if (textView.text.length == 0) return YES;
        
        NSInteger existedLength = textView.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > NAME_LENGHT) {
            return NO;
        }
    }
    
    return YES;
}

- (void) rightAction
{
    if (_signatureTextView.text.length == 0) {
        return;
    }
    
    if ([_signatureTextView.text isEqualToString:[LCMyUser mine].signature]) {
        [_signatureTextView resignFirstResponder];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    
    if(_isLoading)
        return;
    
    _isLoading=YES;
    ESWeakSelf;
    LCRequestSuccessResponseBlock successBlock=^(NSDictionary *responseDic){
        
        ESStrongSelf;
        NSLog(@"edit detail = %@",responseDic);
        int stat=[responseDic[@"stat"] intValue];
        if(stat == URL_REQUEST_SUCCESS)
        {
            [LCMyUser mine].signature = _self.signatureTextView.text;
            [[LCMyUser mine] save];
            [_self.signatureTextView resignFirstResponder];
            
            
            [[NSNotificationCenter defaultCenter] postNotificationName:NotificationMsg_EditInfo_Success
                                                                object:@"signature" ];
            
            [_self.navigationController popViewControllerAnimated:YES];
        }
        else
        {
            [LCNoticeAlertView showMsg:responseDic[@"msg"]];
        }
        
        _isLoading = NO;
        
    };
    
    LCRequestFailResponseBlock failBlock=^(NSError *error){
        NSLog(@"edit fial :%@",error);
        ESStrongSelf;
        _isLoading = NO;
        [LCNoticeAlertView showMsg:ESLocalizedString(@"保存失败")];
    };
    
    
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"signature":_signatureTextView.text}
                                                  withPath:URL_EDIT_USER_INFO
                                               withRESTful:POST_REQUEST
                                          withSuccessBlock:successBlock
                                             withFailBlock:failBlock];
}

- (void) leftAction
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
