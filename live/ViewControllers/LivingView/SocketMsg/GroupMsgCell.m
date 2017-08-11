
//
//  GroupMsgCell.m
//  qianchuo
//
//  Created by jacklong on 16/4/15.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "GroupMsgCell.h"
#import "LiveGiftFile.h"

@implementation GroupMsgCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.gradeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 3, 30, 20)];
        [self addSubview:self.gradeImgView];
        self.gradeImgView.hidden = YES;
        
        self.msgLabel = [[TapNameLabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-70, 20)];
        self.msgLabel.textAlignment = NSTextAlignmentLeft;
        self.msgLabel.textColor = [UIColor blueColor];
        self.msgLabel.font = [UIFont boldSystemFontOfSize:15.f];
        self.msgLabel.shadowColor = RGBA16(0x70888888);//阴影颜色，默认为nil
        self.msgLabel.shadowOffset = CGSizeMake(1, 1);//阴影的偏移点
        self.msgLabel.numberOfLines = 0; ///相当于不限制行数
        [self.msgLabel sizeToFit];
        [self addSubview:self.msgLabel]; 
        
        [self setBackgroundColor:[UIColor clearColor]];
        
        UIImage * redPacketImg  = [UIImage imageNamed:@"image/liveroom/room_redpacket"];
        self.redPacketBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.redPacketBtn.frame = CGRectMake(0, self.msgLabel.bottom+8, redPacketImg.size.width/3, redPacketImg.size.height/3);
        self.redPacketBtn.frame = CGRectZero;
        [self.redPacketBtn setImage:redPacketImg forState:UIControlStateNormal];
        [self addSubview:self.redPacketBtn];
        [self.redPacketBtn addTarget:self action:@selector(showRedPacketAction) forControlEvents:UIControlEventTouchUpInside];
        
        self.medalFirstImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.medalFirstImgView];
        
        self.medalTwoImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.medalTwoImgView];
        
        self.medalThreeImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.medalThreeImgView];
        
        self.medalFourImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self addSubview:self.medalFourImgView];
    }
    return self;
}

#pragma mark - 点击了红包
- (void) showRedPacketAction
{
    //    [RedBagWindow showRedBagInfo:self.showMsgDict isShowDetail:true];
    if ([RobRedPacketViewController isShowRedPacket]) {
        return;
    }
    
    RobRedPacketViewController *robRedPacketVC = [[RobRedPacketViewController alloc] init];
    robRedPacketVC.bagInfoDict = self.showMsgDict;
    robRedPacketVC.isShowDetail = YES;
    [[ESApp rootViewControllerForPresenting] popupViewController:robRedPacketVC completion:nil];
}

#pragma mark - 显示解析聊天消息
- (void) setShowMsgDict:(NSDictionary *)showMsgDict
{
    _showMsgDict = showMsgDict;
    int grade = [showMsgDict[@"grade"] intValue];
    int officalType = 0;
    if (showMsgDict[@"offical"]) {
      officalType = [showMsgDict[@"offical"] intValue];
    }
    
    UIImage *levelImage = [UIImage createUserGradeImage:grade withIsManager:officalType == 1?true:false];
    CGFloat gradeWidth = 0;
    if (officalType != 1) {
        UIEdgeInsets insets = UIEdgeInsetsMake(0, levelImage.size.width - 10, 0, 5);
        // 伸缩后重新赋值
        levelImage = [levelImage resizableImageWithCapInsets:insets];
        
        gradeWidth = [self getGradeSize:grade];
    }
    _gradeImgView.width = levelImage.size.width + gradeWidth;
    _gradeImgView.height = levelImage.size.height;
    _gradeImgView.image = levelImage;
    _msgLabel.text = @"";
}

#pragma mark - 获取等级宽度
- (CGFloat) getGradeSize:(int)grade
{
    NSMutableString *tempStr = [NSMutableString stringWithFormat:@"%d",grade];
    CGSize size = [tempStr boundingRectWithSize:CGSizeMake(50, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12]} context:nil].size;
    
    return size.width;
}

#pragma mark - 是否显示聊天内容
+ (BOOL)shouldShowContent:(NSDictionary *)_showMsgDict
{
    BOOL ret = YES;
    
    NSString *msgType = _showMsgDict[@"type"];
    int userGrade = 0;
    if ([msgType isEqualToString:LIVE_GROUP_CHAT_MSG]) {// 聊天消息
    } else if ([msgType isEqualToString:LIVE_GROUP_GIFT]){// 礼物消息
    } else if ([msgType isEqualToString:LIVE_GROUP_ENTER_ROOM]){// 进入房间消息
        userGrade = [_showMsgDict[@"grade"] intValue];
        if (userGrade >= [LCMyUser mine].sendMsgGrade)
        {
            ret = YES;
        }
        else
        {
            ret = NO;
        }
    } else if([msgType isEqualToString:LIVE_GROUP_SYSTEM_MSG]) {// 系统消息
    } else if([msgType isEqualToString:LIVE_GROUP_GAG]) {// 禁言消息
    } else if([msgType isEqualToString:LIVE_GROUP_REMOVE_GAG]) {// 解除禁言消息
    } else if([msgType isEqualToString:LIVE_GROUP_MANAGER]) {// 设置管理员
    } else if([msgType isEqualToString:LIVE_GROUP_REMOVE_MANAGER]) {// 解除管理员
    } else if([msgType isEqualToString:LIVE_GROUP_USER_LOVE]) {// 点亮消息
         userGrade = [_showMsgDict[@"grade"] intValue];
        if (userGrade >= [LCMyUser mine].sendMsgGrade) {
            ret = YES;
        } else {
            ret = NO;
        }
    } else if([msgType isEqualToString:LIVE_GROUP_UPGRADE]){// 升级消息
    } else if([msgType isEqualToString:LIVE_GROUP_ATTENT]){// 关注消息
    } else if ([msgType isEqualToString:LIVE_GROUP_SHARE]) {// 分享消息
    } else if ([msgType isEqualToString:LIVE_GROUP_ROOM_NOTIFICATION]
               || [msgType isEqualToString:LIVE_GROUP_ROOM_ANCHOR_LEAVE]
               || [msgType isEqualToString:LIVE_GROUP_ROOM_ANCHOR_RESTORE]) {// 房间消息通知
    }
    
    return ret;
}

#pragma mark - 聊天内容
+ (NSString *) CellContent:(NSDictionary *)_showMsgDict
{
    NSString *msgType = _showMsgDict[@"type"];
    int officalType = 0;
    if (_showMsgDict[@"offical"]) {
        officalType = [_showMsgDict[@"offical"] intValue];
    }
    int userGrade = 0;
    NSString *showMsg;// 显示文本
    if ([msgType isEqualToString:LIVE_GROUP_CHAT_MSG]) {// 聊天消息
        userGrade = [_showMsgDict[@"grade"] intValue];
        if (userGrade > 0)
        {
            if (officalType != 1) {
                 showMsg = [NSString stringWithFormat:@"     %d  %@: %@",userGrade,_showMsgDict[@"nickname"],_showMsgDict[@"chat_msg"]];
            } else {
                 showMsg = [NSString stringWithFormat:@"     %@  %@: %@",@"",_showMsgDict[@"nickname"],_showMsgDict[@"chat_msg"]];
            }
        }
        else
        {
            showMsg = [NSString stringWithFormat:@"%@: %@",_showMsgDict[@"nickname"],_showMsgDict[@"chat_msg"]];
        }
    } else if ([msgType isEqualToString:LIVE_GROUP_GIFT]){// 礼物消息
        userGrade = [_showMsgDict[@"grade"] intValue];
        int userGiftId = [_showMsgDict[@"gift_id"] intValue];
        if (userGrade > 0)
        {
            if (officalType != 1) {
                showMsg = [NSString stringWithFormat:@"     %d  %@: 我送了1个%@ %d",userGrade,_showMsgDict[@"nickname"],_showMsgDict[@"gift_name"],userGiftId];
            } else {
               showMsg = [NSString stringWithFormat:@"     %@  %@: 我送了1个%@ %d",@"",_showMsgDict[@"nickname"],_showMsgDict[@"gift_name"],userGiftId];
            }
        }
        else
        {
            showMsg = [NSString stringWithFormat:@"%@: 我送了1个%@ %d",_showMsgDict[@"nickname"],_showMsgDict[@"gift_name"],userGiftId];
        }
    } else if ([msgType isEqualToString:LIVE_GROUP_ENTER_ROOM]){// 进入房间消息
        userGrade = [_showMsgDict[@"grade"] intValue];
        if (userGrade > LIVE_USER_GRADE)
        {
            showMsg = [NSString stringWithFormat:@"直播消息:一道金光闪过,%@进入直播间",_showMsgDict[@"nickname"]];
        }
        else
        {
            showMsg = [NSString stringWithFormat:@"直播消息:%@进入直播间",_showMsgDict[@"nickname"]];
        }
        
    } else if([msgType isEqualToString:LIVE_GROUP_SYSTEM_MSG]) {// 系统消息
        showMsg = [NSString stringWithFormat:@"系统消息:%@",_showMsgDict[@"system_content"]];
    } else if([msgType isEqualToString:LIVE_GROUP_GAG]) {// 禁言消息
         if ([_showMsgDict[@"uid"] isEqualToString:[LCMyUser mine].userID]) {
             if (_showMsgDict[@"send_name"]) {
                showMsg = [NSString stringWithFormat:@"直播消息:你已被 %@ 禁言",_showMsgDict[@"send_name"]];
             } else {
                showMsg = [NSString stringWithFormat:@"直播消息:你已被管理员禁言"];
             }
         } else {
             if (_showMsgDict[@"send_name"]) {
                 showMsg = [NSString stringWithFormat:@"直播消息:%@ 被 %@ 禁言",_showMsgDict[@"nickname"],_showMsgDict[@"send_name"]];
             } else {
                 showMsg = [NSString stringWithFormat:@"直播消息:%@ 被管理员禁言",_showMsgDict[@"nickname"]];
             }
         }
    } else if([msgType isEqualToString:LIVE_GROUP_REMOVE_GAG]) {// 解除禁言消息
        if ([_showMsgDict[@"uid"] isEqualToString:[LCMyUser mine].userID]) {
            if (_showMsgDict[@"send_name"]) {
                showMsg = [NSString stringWithFormat:@"直播消息:你已被 %@ 解除禁言",_showMsgDict[@"send_name"]];
            } else {
                showMsg = [NSString stringWithFormat:@"直播消息:你已被管理员解除禁言"];
            }
        } else {
            if (_showMsgDict[@"send_name"]) {
                showMsg = [NSString stringWithFormat:@"直播消息:%@ 被 %@ 解除禁言",_showMsgDict[@"nickname"],_showMsgDict[@"send_name"]];
            } else {
                showMsg = [NSString stringWithFormat:@"直播消息:%@ 被 管理员 解除禁言",_showMsgDict[@"nickname"]];
            }
        }
    } else if([msgType isEqualToString:LIVE_GROUP_MANAGER]) {// 设置管理员
        if ([_showMsgDict[@"uid"] isEqualToString:[LCMyUser mine].userID]) {
            showMsg = [NSString stringWithFormat:@"直播消息:恭喜你获得了直播间禁言权限"];
        } else {
            showMsg = [NSString stringWithFormat:@"直播消息:恭喜%@获得了直播间禁言权限",_showMsgDict[@"nickname"]];
        }
    } else if([msgType isEqualToString:LIVE_GROUP_REMOVE_MANAGER]) {// 解除管理员
        showMsg = [NSString stringWithFormat:@"直播消息:你已经被取消管理员权限"];
    } else if([msgType isEqualToString:LIVE_GROUP_USER_LOVE]) {// 点亮消息
        userGrade = [_showMsgDict[@"grade"] intValue];
        if (userGrade > 0)
        {
            if (officalType != 1) {
                if ([_showMsgDict[@"uid"] isEqualToString:[LCMyUser mine].userID]) {
                    showMsg = [NSString stringWithFormat:@"     %d  %@: 我点亮了 %d",userGrade,_showMsgDict[@"nickname"],[_showMsgDict[@"love_pos"] intValue]];
                } else {
                    showMsg = [NSString stringWithFormat:@"     %d  %@: 点亮了 %d",userGrade,_showMsgDict[@"nickname"],[_showMsgDict[@"love_pos"] intValue]];
                }
            } else {
                if ([_showMsgDict[@"uid"] isEqualToString:[LCMyUser mine].userID]) {
                    showMsg = [NSString stringWithFormat:@"     %@  %@: 我点亮了 %d",@"",_showMsgDict[@"nickname"],[_showMsgDict[@"love_pos"] intValue]];
                } else {
                    showMsg = [NSString stringWithFormat:@"     %@  %@: 点亮了 %d",@"",_showMsgDict[@"nickname"],[_showMsgDict[@"love_pos"] intValue]];
                }
            }
        }
        else
        {
            if ([_showMsgDict[@"uid"] isEqualToString:[LCMyUser mine].userID]) {
                showMsg = [NSString stringWithFormat:@"%@: 我点亮了 %d",_showMsgDict[@"nickname"],[_showMsgDict[@"love_pos"] intValue]];
            } else {
                showMsg = [NSString stringWithFormat:@"%@: 点亮了 %d",_showMsgDict[@"nickname"],[_showMsgDict[@"love_pos"] intValue]];
            }
        }
    } else if([msgType isEqualToString:LIVE_GROUP_UPGRADE]){// 升级消息
        if ([_showMsgDict[@"uid"] isEqualToString:[LCMyUser mine].userID]) {
            showMsg = [NSString stringWithFormat:@"直播消息:恭喜你升级了"];
        } else {
            showMsg = [NSString stringWithFormat:@"直播消息:恭喜%@ 升级了",_showMsgDict[@"nickname"]];
        }
    } else if([msgType isEqualToString:LIVE_GROUP_ATTENT]){// 关注消息
        showMsg = [NSString stringWithFormat:@"直播消息:%@ 关注了主播，不错过下次直播",_showMsgDict[@"nickname"]];
    } else if ([msgType isEqualToString:LIVE_GROUP_SHARE]) { // 分享消息
        showMsg = [NSString stringWithFormat:@"直播消息:%@",_showMsgDict[@"msg"]];
    } else if ([msgType isEqualToString:LIVE_GROUP_ROOM_NOTIFICATION]
               || [msgType isEqualToString:LIVE_GROUP_ROOM_ANCHOR_LEAVE]
               || [msgType isEqualToString:LIVE_GROUP_ROOM_ANCHOR_RESTORE]) {// 房间消息通知
        showMsg = [NSString stringWithFormat:@"直播消息:%@",_showMsgDict[@"msg"]];
    }
    
    return showMsg;
}
@end
