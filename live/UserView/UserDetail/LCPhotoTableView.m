//
//  LCPhotoTableView.m
//  XCLive
//
//  Created by ztkztk on 14-5-12.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCPhotoTableView.h"

@implementation LCPhotoTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor clearColor];
        self.delegate=self;
        self.dataSource = self;
        self.separatorStyle=UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)setPhotos:(NSMutableArray *)photos
{
    _photos = photos;
    
    NSArray *cells=[self visibleCells];
    
 
    
    for(LCPhotoCell *cell in cells)
    {
        
        for (int i = 0; i < PhotoNumEachRow; ++i)
        {
            LCPhoto *photoView=(LCPhoto *)[cell viewWithTag:1000+i];
            
            [photoView cleanView];
        }
    }
    [self reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if([_photos count] > 0)
        return ([_photos count] - 1) / PhotoNumEachRow + 1;
    else
        return 1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
	LCPhotoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
		
        cell = [[LCPhotoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        // 取消选择模式
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    [self loadCellData:cell withIndexPath:indexPath];
       
	return cell;
    
}

-(void)loadCellData:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    
    NSInteger flag = indexPath.row * PhotoNumEachRow;
    for (int i = 0; i < PhotoNumEachRow; ++i)
    {
        LCPhoto *photoView=(LCPhoto *)[cell viewWithTag:1000+i];
        if(flag >= [_photos count])
        {
            
        }
        else
        {
            /*
            photoView.userDic=self.list[flag];
            quareItem.singleTapBlock=^(NSDictionary *dic){
                [self showUser:dic];
            };
             */
            NSDictionary *dic = _photos[flag];
            photoView.photoDic = dic;
            //[photoView setViewImage:dic];
            if(flag==7)
                photoView.moreLabel.hidden=NO;
            else
                photoView.moreLabel.hidden=YES;
        }
        
        ++flag;
        
    }
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return PhotoWidth + 8;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

/*
-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    //设置矩形填充颜色：红色
    CGContextSetRGBFillColor(context, 30.0/255, 30.0/255, 30.0/255, 1.0);
    //填充矩形
    
    CGRect myRect=CGRectMake(0,rect.size.height-1,rect.size.width,1);
    CGContextFillRect(context, myRect);
    //执行绘画
    CGContextStrokePath(context);
}
*/

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
