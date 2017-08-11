//
//  LCCustomBackItemController.m
//  XCLive
//
//  Created by ztkztk on 14-7-7.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "LCCustomBackItemController.h"


#import "LCConfirmViewController.h"


@interface LCCustomBackItemController ()

@end

@implementation LCCustomBackItemController

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
    
    UIButton *backItemBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backItemBtn.frame=CGRectMake(0, 0, 60.0, 25.0);
    backItemBtn.backgroundColor=[UIColor clearColor];
    [backItemBtn setTitle:@"返回" forState:UIControlStateNormal];
    [backItemBtn addTarget:self
                    action:@selector(backAction)
          forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *backItem=[[UIBarButtonItem alloc] initWithCustomView:backItemBtn];
    
    self.navigationItem.leftBarButtonItem=backItem;

}

-(void)backAction
{
    for (UIViewController *temp in self.navigationController.viewControllers) {
        if ([temp isKindOfClass:[LCConfirmViewController class]]) {
            [self.navigationController popToViewController:temp animated:YES];
            return;
        }
    }
     
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
