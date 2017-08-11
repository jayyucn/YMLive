//
//  WatchLiveTableViewCell.h
//  live
//
//  Created by kenneth on 15-7-10.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol WatchLiveCellDelegate <NSObject>
- (void)watchLogoTap:(UITableViewCell*)watchCell;
@end
@interface WatchLiveTableViewCell : UITableViewCell
@property (weak, nonatomic) id<WatchLiveCellDelegate> delegate;
//直播图片
@property (weak, nonatomic) IBOutlet UIImageView *liveImageView;
//用户头像
@property (weak, nonatomic) IBOutlet UIImageView *userLogoImageView;
//用户性别
@property (weak, nonatomic) IBOutlet UIImageView *userGenderImageView;
//直播标题
@property (weak, nonatomic) IBOutlet UILabel *liveTitleLabel;
//
@property (weak, nonatomic) IBOutlet UIImageView *audienceImageView;
//观众人数
@property (weak, nonatomic) IBOutlet UILabel *audienceNumLabel;
//
@property (weak, nonatomic) IBOutlet UIImageView *praiseImageView;
//点赞数量
@property (weak, nonatomic) IBOutlet UILabel *praiseNumLabel;
//直播状态
@property (weak, nonatomic) IBOutlet UILabel *liveStatusLabel;
@property (weak, nonatomic) IBOutlet UIView *liveStatusView;
//名字
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIView *viewContainer;

@property (nonatomic, strong) NSDictionary *liveInfo;

- (instancetype)initVideoWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
