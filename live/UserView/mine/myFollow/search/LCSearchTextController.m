//
//  LCSearchTextController.m
//  XCLive
//
//  Created by ztkztk on 14-6-19.
//  Copyright (c) 2014年 www.0x123.com. All rights reserved.
//

#import "LCSearchTextController.h"
#import "LCSearchResultViewController.h"

@interface LCSearchTextController ()

@end

@implementation LCSearchTextController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    self.title=@"搜索";
    //self.navigationItem.rightBarButtonItem.customView.hidden=NO;
    //[self setRightItemTitle:@"搜索"];
    self.inputText.placeholder = @"请输入ID或昵称";
    
    
    // Custom initialization
    self.searchBtn=[ESButton buttonWithTitle:nil buttonColor:ESButtonColorBlue];
    
    _searchBtn.frame=CGRectMake(10, self.inputText.bottom+20,300,40);
    [_searchBtn setTitleColor:[UIColor whiteColor]
                    forState:UIControlStateNormal];
    [_searchBtn setTitle:@"搜索"
                     forState:UIControlStateNormal];

    [_searchBtn addTarget:self
                  action:@selector(searchAction)
        forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_searchBtn];

}


-(void)searchAction
{
    [self rightAction];
}


-(void)rightAction
{
    
    
    if(self.inputText.text&&![self.inputText.text isEqualToString:@""])
    {
        [self.inputText resignFirstResponder];
        LCSearchResultViewController *searchController=[LCSearchResultViewController searchController:self.inputText.text];
        [self.navigationController pushViewController:searchController animated:YES];
    }else{
        [LCNoticeAlertView showMsg:@"请输入您要搜索的ID或昵称"];
    }
    
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
