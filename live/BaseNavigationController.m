//
//  BaseNavigationController.m
//  live
//
//  Created by hysd on 15/7/13.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()
{
    BOOL noPushRoot;
}
@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIColor *barTintColor = ColorPink;
    //UIColor *barTintColor = [UIColor colorWithRed:0.0/255 green:102.0/255 blue:204.0/255 alpha:1.0];
    if (ESOSVersionIsAbove7()) {
        UIColor *barItemColor = [UIColor whiteColor];
        [[UINavigationBar appearance] setBarTintColor:barTintColor];
        [[UINavigationBar appearance] setTintColor:barItemColor];
        [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTintColor:barItemColor];
        NSShadow *shadow = [NSShadow new];
        shadow.shadowColor = [UIColor colorWithWhite:0.f alpha:0.7f];
        shadow.shadowOffset = CGSizeMake(0.f, 1.f);
        [[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : barItemColor}];
    }
    else
    {
        [[UINavigationBar appearance] setTintColor:barTintColor];
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //    if(noPushRoot){
    //        viewController.hidesBottomBarWhenPushed = YES;
    //    }
    //    noPushRoot = YES;
    [super pushViewController:viewController animated:animated];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
