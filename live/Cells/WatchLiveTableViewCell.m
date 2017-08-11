//
//  WatchLiveTableViewCell.m
//  live
//
//  Created by kenneth on 15-7-10.
//  Copyright (c) 2015年 kenneth. All rights reserved.
//

#import "WatchLiveTableViewCell.h"
#import "Macro.h"
#import "ReportAlert.h"
#import "Business.h" 

@implementation WatchLiveTableViewCell

- (void)awakeFromNib {
    // Initialization code
    //选中背景不发生改变
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    //self.layer.cornerRadius = 5;
    //self.clipsToBounds = YES;
    //圆形头像
    self.userLogoImageView.layer.cornerRadius = self.userLogoImageView.frame.size.width/2;
    self.userLogoImageView.clipsToBounds = YES;
    self.userLogoImageView.layer.borderWidth = 1;
    self.userLogoImageView.layer.borderColor = RGB16(COLOR_BG_WHITE).CGColor;
    UITapGestureRecognizer* logoTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(watchLogoTap:)];
    self.userLogoImageView.userInteractionEnabled = YES;
    [self.userLogoImageView addGestureRecognizer:logoTap];
    //直播状态
    self.liveStatusView.layer.cornerRadius = 2;
    self.liveStatusView.clipsToBounds = YES;
    self.liveStatusView.backgroundColor = RGB16(COLOR_BG_RED);
    //观众
    self.audienceNumLabel.textColor = RGB16(COLOR_FONT_WHITE);
    //点赞
    self.praiseNumLabel.textColor = RGB16(COLOR_FONT_WHITE);
    //标题
    self.liveTitleLabel.textColor = RGB16(COLOR_FONT_WHITE);
    //主播
    self.userNameLabel.textColor = RGB16(COLOR_FONT_WHITE);
    //容器
    self.viewContainer.backgroundColor = RGBA16(COLOR_BG_ALPHABLACK);
    
}

- (IBAction)report:(id)sender
{
    ReportAlert *alert = [[[NSBundle mainBundle] loadNibNamed:@"ReportAlert" owner:self options:nil] lastObject];
    alert.action = ^(NSString *reportContent) {
//        [[Business sharedInstance] liveReport:self.liveInfo[@"programid"] reporter:[LCMyUser mine].userID content:reportContent succ:^(NSString *msg, id data) {
//            [[HUDHelper sharedInstance] tipMessage:msg];
//        } fail:^(NSString *error) {
//            [[HUDHelper sharedInstance] tipMessage:error];
//        }];
    };
    [alert show];
}

- (instancetype)initVideoWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"WatchLiveTableViewCell" owner:self options:nil] lastObject];
    self.liveStatusView.backgroundColor = RGBAColor(240, 140, 27, 1);
    self.liveStatusLabel.text = @"看回放";
    return self;
}

- (void)setFrame:(CGRect)frame
{
    //更改x
    //frame.origin.x += 5;
    //更改宽高
    frame.size.height -= 5;
    //frame.size.width -= 10;
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
- (void)watchLogoTap:(UITapGestureRecognizer*)recognizer{
    if(self.delegate){
        [self.delegate watchLogoTap:self];
    }
}
@end
