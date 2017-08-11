//
//  LCTableAlertView.m
//  XCLive
//
//  Created by ztkztk on 14-5-13.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCTableAlertView.h"


@implementation LCTableAlertView


+(void)showTableAlertView:(NSString *)title array:(NSArray *)array withBlock:(LCTableAlertBlock)alertBlock
{
    LCTableAlertView *alertView=[[LCTableAlertView alloc] init];
    alertView.titleLabel.text=title;
    alertView.list=array;
    alertView.tableAlertBlock=alertBlock;
    [alertView showWithAnimated];
    
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.shouldDismissWhenTouchsAnywhere=YES;
        self.autoDismissTimeInterval=0;
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,200,30)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor=[UIColor blackColor];
        _titleLabel.font=[UIFont boldSystemFontOfSize:20];
        _titleLabel.backgroundColor =[UIColor clearColor];
        [self.backgroundView addSubview:_titleLabel];
        _titleLabel.centerX=LCAlertViewWidth/2;
        
        
        // Initialization code
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.titleLabel.bottom+5.0f, self.backgroundView.width, 0) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = 40;
        _tableView.contentInset = UIEdgeInsetsZero;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollsToTop = NO;
        _tableView.scrollEnabled = YES;
        [self.backgroundView addSubview:_tableView];
        


    }
    return self;
}


-(void)setList:(NSArray *)list
{
    _list=list;
    [_tableView reloadData];
}

- (void)layoutSubviews
{
    _tableView.height=_tableView.rowHeight*[self.list count];
    
    self.height=_tableView.bottom+5;
    self.backgroundView.height=self.height;
    
    const CGFloat padding = 5.0;
    CGRect backgroundFrame = self.backgroundView.frame;
    CGRect frame = backgroundFrame;
    frame.size.width = 2 * padding + backgroundFrame.size.width;
    frame.size.height = 2 * padding + backgroundFrame.size.height;
    frame.origin.x = floorf((self.screenSize.width - frame.size.width) / 2.0);
    frame.origin.y = floorf((self.screenSize.height - frame.size.height) / 2.0) - 30.0;
    self.frame = frame;
    backgroundFrame.origin.x = backgroundFrame.origin.y = padding;
    self.backgroundView.frame = backgroundFrame;
    
    
}



#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier=@"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (!cell) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:identifier];
        
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        cell.backgroundColor=[UIColor clearColor];
        // 取消选择模式
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textColor=[UIColor blackColor];
    }
    
    cell.textLabel.text=self.list[indexPath.row];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _tableAlertBlock(indexPath.row+1);
    [self dismissWithAnimated];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
