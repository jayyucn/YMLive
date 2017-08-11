//
//  CameraPopView.m
//  qianchuo
//
//  Created by jacklong on 16/5/1.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "CameraPopView.h"
#import "CameraChangeCell.h"

@interface CameraPopView()<UITableViewDataSource, UITableViewDelegate>
{
    CGFloat _popoverWidth;
}

@property (nonatomic, strong) NSArray *configs;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) DXPopover *popover;
@end

@implementation CameraPopView

ES_SINGLETON_IMP(cameraPopView);

- (void) initPopViewData
{
    if (!self.configs) {
        self.configs = @[@{@"title":@"开闪光",@"icon":@"image/liveroom/room_pop_up_lamp",@"state":@"0"},
                         @{@"title":@"翻转",@"icon":@"image/liveroom/room_pop_up_camera_p",@"state":@"0"},];
    }
   
}

- (void) setPopViewData:(NSArray *)configs
{
    if (configs) {
        self.configs = configs;
        
        if (self.tableView) {
            [self.tableView reloadData];
        }
    }
}

- (BOOL) popViewIsHidden
{
    if (self.popover) {
        return  self.popover.isHidden;
    }
    
    return YES;
}

- (void)showPopoverWithView:(UIView *)view withTargetView:(UIView *)targetView
{
    [self initView];
    
    [self updateTableViewFrame];
    
    CGRect frame  = CGRectMake(targetView.origin.x-targetView.width*2-targetView.width/4, targetView.origin.y, targetView.width, targetView.height);
    
    CGPoint startPoint =
    CGPointMake(CGRectGetMidX(frame) + 30, CGRectGetMinY(frame) - 5);
    [self.popover showAtPoint:startPoint
               popoverPostion:DXPopoverPositionUp
              withContentView:self.tableView
                       inView:view];
    
    ESWeakSelf;
    self.popover.didDismissHandler = ^{
        ESStrongSelf;
        [_self bounceTargetView:targetView];
    };

    [self.tableView reloadData];
}

- (void) initView
{
    _popoverWidth = 100;
    
    self.tableView = [[UITableView alloc] init];
    self.tableView.frame = CGRectMake(0, 0,_popoverWidth, 70);
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self resetPopover];
}

- (void)resetPopover
{
    self.popover = [DXPopover new];
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"count:%ld",self.configs.count);
    return self.configs.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell_pop_Identifier";
    CameraChangeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[CameraChangeCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    
    cell.infoDict = self.configs[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        int cameraState = [self.configs[1][@"state"] intValue];
        if (cameraState == 1) {// 后置摄像头状态
            if (self.delegate) {
                [self.delegate onShanLightController:[self.configs[indexPath.row][@"state"] intValue]];
            }
        }
    } else if(indexPath.row == 1) {
        if (self.delegate) {
            [self.delegate onCameraController:[self.configs[indexPath.row][@"state"] intValue]];
        }
    } else if (indexPath.row == 2) {
        if (self.delegate) {
          [self.delegate onBeautyController:[self.configs[indexPath.row][@"state"] intValue]];
        }
    }
    
    [self.popover dismiss];
}

- (void)updateTableViewFrame {
    CGRect tableViewFrame = self.tableView.frame;
    tableViewFrame.size.width = _popoverWidth;
    self.tableView.frame = tableViewFrame;
    self.popover.contentInset = UIEdgeInsetsZero;
    self.popover.backgroundColor = RGBA16(0x7f000000);
}

- (void)bounceTargetView:(UIView *)targetView
{
    targetView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.5
                          delay:0.0
         usingSpringWithDamping:0.3
          initialSpringVelocity:5
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         targetView.transform = CGAffineTransformIdentity;
                     }
                     completion:nil];
}


@end
