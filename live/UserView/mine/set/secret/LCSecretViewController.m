//
//  LCSecretViewController.m
//  XCLive
//
//  Created by ztkztk on 14-4-26.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCSecretViewController.h"
#import "LCSecretViewController+NetWork.h"
#import "LCSwitchCell.h"

@interface LCSecretViewController ()
@property (nonatomic,strong)NSArray *titleArray;
@end

@implementation LCSecretViewController
@synthesize titleArray;


-(void)dealloc
{
//    [[LCHTTPClient sharedHTTPClient] cancelAllHTTPOperationsWithMethod:nil path:modifySecretURL()];
    
}


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
    self.title=@"隐私";
    
    
    titleArray=@[@[@"允许别人与我匹配夫妻相",@"允许别人搜寻到我"],
                 @[@"踏雪无痕"]];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleSingleLine;
    self.tableView.scrollEnabled=NO;

}

#pragma mark - Table view data source

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 40.0f;
    
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    LCInsetsLabel *sectionFooterLabel=[[LCInsetsLabel alloc] initWithFrame:CGRectMake(0,0,320,35) andInsets:UIEdgeInsetsMake(3,12,0,12)];
    sectionFooterLabel.textAlignment = NSTextAlignmentLeft;
    sectionFooterLabel.textColor=[UIColor grayColor];
    sectionFooterLabel.font=[UIFont systemFontOfSize:16];
    sectionFooterLabel.backgroundColor =[UIColor clearColor];
    if(section==0)
        sectionFooterLabel.text=@"开启后你将获得更多异性关注";
    else
        sectionFooterLabel.text=@"开启后你的访客就不会被对方记录";
    
    return sectionFooterLabel;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [titleArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    return [(NSArray *)titleArray[section] count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier=@"cell";
    LCSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        
        cell=[[LCSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:identifier];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        cell.accessoryView.backgroundColor=[UIColor redColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        
    }
    
    cell.titleLabel.text=titleArray[indexPath.section][indexPath.row];
   
    
    NSString *parameter;
    if(indexPath.section==0)
    {
        if(indexPath.row==0)
        {
//            cell.switchView.on=[LCSet mineSet].allow_match;
            parameter=@"allow_match";
        }else
        {
//            cell.switchView.on=[LCSet mineSet].allow_search;
            parameter=@"allow_search";
        }
        
        
    }else{
//        cell.switchView.on=[LCSet mineSet].is_trace;
        parameter=@"is_trace";
    }
    
    ESWeakSelf;
    cell.switchCellBlock=^(BOOL on){
        ESStrongSelf;
        NSDictionary *dic=@{parameter:@(on)};
        [_self modifySecret:dic];
    };

    
	return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
