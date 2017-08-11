//
//  LCPhotoScrollViewController.m
//  XCLive
//
//  Created by ztkztk on 14-4-23.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCPhotoScrollViewController.h"
#import "FlickrDataSource.h"

@interface LCPhotoScrollViewController ()

@end

@implementation LCPhotoScrollViewController

- (id)initWithImages:(NSArray *)images andStartWithPhotoAtIndex:(NSUInteger)index
{
    
    FlickrDataSource *flickrDataSource=[[FlickrDataSource alloc] init];
    flickrDataSource.images=images;
    if(self=[super initWithDataSource:flickrDataSource
             andStartWithPhotoAtIndex:index])
    {
        
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
