//
//  LCConfirmViewController.m
//  XCLive
//
//  Created by ztkztk on 14-4-28.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCConfirmViewController.h"


@interface LCConfirmViewController ()

@end

@implementation LCConfirmViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    
    
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.view addSubview:_iconImageView];
    
    _iconImageView.centerX = ScreenWidth / 2;
    _iconImageView.top = 50;
    _iconImageView.image=[UIImage imageNamed:@"AppIcon60x60@2x"];
    
    _iconImageView.layer.cornerRadius = 6;
    _iconImageView.layer.masksToBounds = YES;
    
    _introLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,295,90)];
    _introLabel.textAlignment = NSTextAlignmentCenter;
    _introLabel.textColor=[UIColor grayColor];
    _introLabel.font=[UIFont systemFontOfSize:17];
    _introLabel.backgroundColor =[UIColor clearColor];
    [self.view addSubview:_introLabel];
    _introLabel.centerX=ScreenWidth / 2;
    _introLabel.top=_iconImageView.bottom+10;
    _introLabel.numberOfLines=4;
    

    
    self.confirmBtn=[ESButton buttonWithTitle:nil buttonColor:ESButtonColorBlue];
    _confirmBtn.frame=CGRectMake(10, 280,ScreenWidth - 20,40);
    [_confirmBtn setTitleColor:[UIColor whiteColor]
                      forState:UIControlStateNormal];
    
    
    
    [self.view addSubview:_confirmBtn];
    
    // Custom initialization
    self.changeBtn=[ESButton buttonWithTitle:nil buttonColor:ESButtonColorCoffee];
    
    _changeBtn.frame=CGRectMake(10, 350,ScreenWidth - 20,40);
    [_changeBtn setTitleColor:[UIColor whiteColor]
                     forState:UIControlStateNormal];
    
    
    
   
    [self.view addSubview:_changeBtn];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
