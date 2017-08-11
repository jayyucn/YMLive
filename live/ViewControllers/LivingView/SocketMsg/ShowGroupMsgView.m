//
//  ShowGroupMsgTableView.m
//  qianchuo
//
//  Created by jacklong on 16/4/15.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ShowGroupMsgView.h"
#import "GroupMsgCell.h"
#import "LiveGiftFile.h"
#import "UserSpaceViewController.h"

#define DELETE_POSITION 150
#define DELETE_MSG_COUNT 50

#define SHOW_MSG_TIMER .3
#define SHOW_MSG_PENDING_COUNT 5

#define MEDEL_WIDTH_HEGITH 40


#define NORMAL_HEAD_FONT_COLOR      RGB16(0xffff00)                        // 直播消息：
#define NORMAL_MSG_FONT_COLOR       RGB16(0xfc3a9a)                        // 进入直播间消息
#define ENTER_ROOM_FONT_COLOR       RGB16(0xfc3a9a)                        // 进入房间消息颜色
#define CHAT_MSG_FONT_COLOR         RGB16(0xf9fafc)                        // 聊天消息颜色
#define NICKNAME_FONT_COLOR         RGB16(0xffff00)                        // 昵称
#define SEND_GIFT_FONT_COLOR        RGB16(0xfc3a9a)                        // 送礼物消息
#define SYSTEM_HEAD_FONT_COLOR      RGB16(0xffff00)                        // 系统消息: 字体颜色
#define SYSTEM_MSG_FONT_COLOR       ColorPink                        // 系统消息字体颜色


@interface ShowGroupMsgView ()<UITableViewDataSource,UITableViewDelegate,TapNameLabelDelegate>
{
    NSMutableArray *pendingMessageArray;
    
    NSMutableDictionary* imagesDict;
    
    GroupMsgCell *msgCell;
}

@end

@implementation ShowGroupMsgView

- (void)dealloc
{
    NSLog(@"dealloc %@",NSStringFromClass(self.class));
    if (self.contentArray) {
        [self.contentArray removeAllObjects];
    }
    
    [_contentTable removeFromSuperview];
    _contentTable = nil;
    
    [self removeFromSuperview];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.contentArray = [NSMutableArray arrayWithCapacity:0];
//        NSLog(@"self frame:%@",NSStringFromCGRect(self.frame));
        
        _contentTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, frame.size.height) style:UITableViewStylePlain];
        
        _contentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_contentTable setDelegate:self];
        [_contentTable setDataSource:self];
        [_contentTable setBackgroundColor:[UIColor clearColor]];
        _contentTable.showsVerticalScrollIndicator = NO;
        _contentTable.showsHorizontalScrollIndicator = NO;
        _contentTable.bounces = NO;
        _contentTable.contentInset = UIEdgeInsetsZero;
        [self addSubview:_contentTable];
        
        imagesDict = [NSMutableDictionary dictionary];

    }
    return self;
}

- (void) layoutSubviews
{
    _contentTable.height = self.frame.size.height;
}

#pragma mark UITableView DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIndentifier = @"cell_msg";
    
    msgCell = [tableView dequeueReusableCellWithIdentifier:cellIndentifier];
    NSDictionary *_showMsgDict = self.contentArray[indexPath.row];
    
    if (indexPath.row >= 2 || _contentArray.count > 2) {
        _contentTable.scrollEnabled = YES;
    } else {
        _contentTable.scrollEnabled = NO;
    }
    
    if (!msgCell)
    {
        msgCell = [[GroupMsgCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIndentifier];
        msgCell.selectionStyle = UITableViewCellSelectionStyleNone;
        msgCell.opaque = YES;
    }
    msgCell.showMsgDict = _showMsgDict;
    msgCell.msgLabel.showMsgDict = _showMsgDict;
    msgCell.msgLabel.delegate = self;
    [self dealGroupMsg:_showMsgDict withGroupMsgCell:msgCell];
    return msgCell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *_showMsgDict = self.contentArray[indexPath.row];
    
    int labelHeight = [_showMsgDict[@"height"] intValue];
    NSArray *medalArray = nil;
    if ([_showMsgDict[@"type"] isEqualToString:LIVE_GROUP_ENTER_ROOM]) {
        medalArray = _showMsgDict[@"wanjia_medal"];
    }
    
    int contentHeight = labelHeight;
    if ([_showMsgDict[@"type"] isEqualToString:LIVE_GROUP_GIFT]
            && [_showMsgDict[@"gift_type"] intValue] == GIFT_TYPE_REDPACKET) {
        UIImage*redPacketImg = [UIImage imageNamed:@"image/liveroom/room_redpacket"];
        contentHeight += redPacketImg.size.height+4+8;
    } else if (medalArray && medalArray.count > 0) {
        contentHeight += MEDEL_WIDTH_HEGITH+8;
    } else {
        contentHeight += 8;
    }
    
    return contentHeight;
}

#pragma mark - 显示解析聊天消息
- (void) dealGroupMsg:(NSDictionary *)_showMsgDict withGroupMsgCell:(GroupMsgCell *)cell
{
    
    NSString *msgType = _showMsgDict[@"type"];
    
    NSString *showMsg = _showMsgDict[@"show_msg"];
    int labelHeight = [_showMsgDict[@"height"] intValue];
    cell.msgLabel.height = labelHeight;
    cell.msgLabel.backgroundColor = [UIColor clearColor];
    
    if ([msgType isEqualToString:LIVE_GROUP_CHAT_MSG]) {// 聊天消息
        [self parseChatMsg:showMsg withMsgInfo:_showMsgDict withGroupMsgCell:cell];
    } else if ([msgType isEqualToString:LIVE_GROUP_GIFT]){// 礼物消息
        [self parseGiftMsg:showMsg withMsgInfo:_showMsgDict withGroupMsgCell:cell];
    } else if ([msgType isEqualToString:LIVE_GROUP_ENTER_ROOM]){// 进入房间消息
        [self parseEnterRoom:showMsg withMsgInfo:_showMsgDict withGroupMsgCell:cell];
    } else if([msgType isEqualToString:LIVE_GROUP_SYSTEM_MSG]) {// 系统消息
        [self parseSystemInfo:showMsg withMsgInfo:_showMsgDict withGroupMsgCell:cell];
    } else if([msgType isEqualToString:LIVE_GROUP_GAG]) {// 禁言消息
        [self parsetGagInfo:showMsg withMsgInfo:_showMsgDict withGroupMsgCell:cell];
    } else if([msgType isEqualToString:LIVE_GROUP_REMOVE_GAG]) {// 解除禁言消息
        [self parsetRemoveGagInfo:showMsg withMsgInfo:_showMsgDict withGroupMsgCell:cell];
    } else if([msgType isEqualToString:LIVE_GROUP_MANAGER]) {// 设置管理员
        [self parseManagerInfo:showMsg withMsgInfo:_showMsgDict withGroupMsgCell:cell];
    } else if([msgType isEqualToString:LIVE_GROUP_REMOVE_MANAGER]) {// 解除管理员
        [self parseRemoveManagerInfo:showMsg withMsgInfo:_showMsgDict withGroupMsgCell:cell];
    } else if([msgType isEqualToString:LIVE_GROUP_USER_LOVE]) {// 点亮消息
        [self lightupAnchorInfo:showMsg withMsgInfo:_showMsgDict withGroupMsgCell:cell];
    } else if([msgType isEqualToString:LIVE_GROUP_UPGRADE]) {// 升级消息
        [self parseUpGradeInfo:showMsg withMsgInfo:_showMsgDict withGroupMsgCell:cell];
    } else if([msgType isEqualToString:LIVE_GROUP_ATTENT]) {// 关注消息
        [self parseAttetInfo:showMsg withMsgInfo:_showMsgDict withGroupMsgCell:cell];
    } else if([msgType isEqualToString:LIVE_GROUP_SHARE]) {// 分享消息
        [self parseShareInfo:showMsg withMsgInfo:_showMsgDict withGroupMsgCell:cell];
    } else if ([msgType isEqualToString:LIVE_GROUP_ROOM_NOTIFICATION]
               || [msgType isEqualToString:LIVE_GROUP_ROOM_ANCHOR_LEAVE]
               || [msgType isEqualToString:LIVE_GROUP_ROOM_ANCHOR_RESTORE]){//  消息通知
        [self parseRoomNotificationInfo:showMsg withMsgInfo:_showMsgDict withGroupMsgCell:cell];
    }
    
    // 昵称点击
    [self findNickName:showMsg withShowMsgDict:_showMsgDict withGroupMsgCell:cell];
    
    CGRect rect = cell.msgLabel.frame;
    rect.size.height = labelHeight;
    rect.size.width = self.frame.size.width;
    cell.msgLabel.frame = rect;
    [cell.msgLabel sizeToFit];
    
    if ([msgType isEqualToString:LIVE_GROUP_GIFT] && [_showMsgDict[@"gift_type"] intValue] == GIFT_TYPE_REDPACKET) {
        UIImage * redPacketImg  = [UIImage imageNamed:@"image/liveroom/room_redpacket"];
        cell.redPacketBtn.frame = CGRectMake(0, cell.msgLabel.bottom+4, redPacketImg.size.width, redPacketImg.size.height);
    } else {
        cell.redPacketBtn.frame = CGRectZero;
    }
    
    NSArray *medalArray = nil;
    if ([_showMsgDict[@"type"] isEqualToString:LIVE_GROUP_ENTER_ROOM]) {
        medalArray = _showMsgDict[@"wanjia_medal"];
        if (medalArray && medalArray.count > 0) {
            if (medalArray.count == 1) {
                cell.medalFirstImgView.frame = CGRectMake(0, cell.msgLabel.bottom+4, MEDEL_WIDTH_HEGITH, MEDEL_WIDTH_HEGITH);
            } else if (medalArray.count == 2) {
                cell.medalFirstImgView.frame = CGRectMake(0, cell.msgLabel.bottom+4, MEDEL_WIDTH_HEGITH, MEDEL_WIDTH_HEGITH);
                cell.medalTwoImgView.frame = CGRectMake(cell.medalFirstImgView.right+4, cell.msgLabel.bottom+4, MEDEL_WIDTH_HEGITH, MEDEL_WIDTH_HEGITH);
            } else if (medalArray.count == 3) {
                cell.medalFirstImgView.frame = CGRectMake(0, cell.msgLabel.bottom+4, MEDEL_WIDTH_HEGITH, MEDEL_WIDTH_HEGITH);
                cell.medalTwoImgView.frame = CGRectMake(cell.medalFirstImgView.right+4, cell.msgLabel.bottom+4, MEDEL_WIDTH_HEGITH, MEDEL_WIDTH_HEGITH);
                cell.medalThreeImgView.frame = CGRectMake(cell.medalTwoImgView.right+4, cell.msgLabel.bottom+4, MEDEL_WIDTH_HEGITH, MEDEL_WIDTH_HEGITH);
            } else if (medalArray.count == 4) {
                cell.medalFirstImgView.frame = CGRectMake(0, cell.msgLabel.bottom+4, MEDEL_WIDTH_HEGITH, MEDEL_WIDTH_HEGITH);
                cell.medalTwoImgView.frame = CGRectMake(cell.medalFirstImgView.right+4, cell.msgLabel.bottom+4,MEDEL_WIDTH_HEGITH , MEDEL_WIDTH_HEGITH);
                cell.medalThreeImgView.frame = CGRectMake(cell.medalTwoImgView.right+4, cell.msgLabel.bottom+4, MEDEL_WIDTH_HEGITH, MEDEL_WIDTH_HEGITH);
                cell.medalFourImgView.frame = CGRectMake(cell.medalThreeImgView.right+4, cell.msgLabel.bottom+4, MEDEL_WIDTH_HEGITH, MEDEL_WIDTH_HEGITH);
            }
            
        } else {
            cell.medalFirstImgView.frame = CGRectZero;
            cell.medalTwoImgView.frame = CGRectZero;
            cell.medalThreeImgView.frame = CGRectZero;
            cell.medalFourImgView.frame = CGRectZero;
        }
    } else {
        cell.medalFirstImgView.frame = CGRectZero;
        cell.medalTwoImgView.frame = CGRectZero;
        cell.medalThreeImgView.frame = CGRectZero;
        cell.medalFourImgView.frame = CGRectZero;
    }

}

#pragma mark - 获取文本的高度
+ (CGFloat) getTxtSize:(NSString *)txtStr withUserGrade:(int)grade withGift:(BOOL)isGift withContentWidth:(int)contentWidth
{
    CGSize size;
    if (isGift) {
        txtStr = [txtStr stringByAppendingString:@"ffff"];
        size = [txtStr boundingRectWithSize:CGSizeMake(contentWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} context:nil].size;
    } else {
        size = [txtStr boundingRectWithSize:CGSizeMake(contentWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} context:nil].size;
    }
    
    return size.height;
}

#pragma mark - 获取等级宽度
- (CGFloat) getGradeSize:(int)grade
{
    NSMutableString *tempStr = [NSMutableString stringWithFormat:@"%d",grade];
    CGSize size = [tempStr boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10]} context:nil].size;
    
    return size.width;
}


#pragma mark - 解析聊天消息
- (void) parseChatMsg:(NSString *)msg withMsgInfo:(NSDictionary *)_showMsgDict withGroupMsgCell:(GroupMsgCell *)cell
{
    int userGrade = [_showMsgDict[@"grade"] intValue];
    NSRange gradeRange = NSMakeRange(0, 0);
    if (userGrade > 0)
    {
        gradeRange = [msg rangeOfString:[NSString stringWithFormat:@"%d",userGrade]];
    }
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:msg];
    
    if (userGrade > 0) {
        cell.gradeImgView.hidden = NO;
        
        [mutableAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.f] range:gradeRange];
        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:CHAT_MSG_FONT_COLOR range:gradeRange];
    } else {
        cell.gradeImgView.hidden = YES;
    }
     
    NSRange nameRange = [msg rangeOfString:[NSString stringWithFormat:@"%@:",_showMsgDict[@"nickname"]]];
    if (nameRange.location != NSNotFound) {
        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:NICKNAME_FONT_COLOR range:nameRange];
        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:CHAT_MSG_FONT_COLOR range:NSMakeRange(nameRange.location+nameRange.length, mutableAttributedString.length - (nameRange.location+nameRange.length))];
    } else {
        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:CHAT_MSG_FONT_COLOR range:NSMakeRange(0, mutableAttributedString.length)];
    }
    
    cell.msgLabel.attributedText = mutableAttributedString;
    
//    // 昵称点击
//    [self findNickName:msg withShowMsgDict:_showMsgDict withGroupMsgCell:cell];
}

#pragma mark - 解析礼物消息
- (void) parseGiftMsg:(NSString *)msg withMsgInfo:(NSDictionary *)_showMsgDict withGroupMsgCell:(GroupMsgCell *)cell
{
    int userGrade = [_showMsgDict[@"grade"] intValue];
    NSRange gradeRange = NSMakeRange(0, 0);
    if (userGrade > 0)
    {
        gradeRange = [msg rangeOfString:[NSString stringWithFormat:@"%d",userGrade]];
    }
    
    if (!_showMsgDict[@"content_attr"]) {
        NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:msg];
        
        if (userGrade > 0) {
            cell.gradeImgView.hidden = NO;
            
            [mutableAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.f] range:gradeRange];
            [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:CHAT_MSG_FONT_COLOR range:gradeRange];
        } else {
            cell.gradeImgView.hidden = YES;
        }
        
        
        NSRange nameRange =  [msg rangeOfString:[NSString stringWithFormat:@"%@:",_showMsgDict[@"nickname"]]];
        if (nameRange.location != NSNotFound) {
            // 设置标签文字的属性
            [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:NICKNAME_FONT_COLOR range:nameRange];
        }
        
        NSRange giftNameRange = [mutableAttributedString.string rangeOfString:[NSString stringWithFormat:@"我送了1个%@ ",_showMsgDict[@"gift_name"]]];
        NSRange giftIdRange = [mutableAttributedString.string rangeOfString:[NSString stringWithFormat:@"%d",[_showMsgDict[@"gift_id"] intValue]]];
        if (giftNameRange.location != NSNotFound) {
            [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:SEND_GIFT_FONT_COLOR range:giftNameRange];
        }
        if ([_showMsgDict[@"gift_type"] intValue] == GIFT_TYPE_REDPACKET) {
            [mutableAttributedString replaceCharactersInRange:giftIdRange withString:@""];
            cell.msgLabel.attributedText = mutableAttributedString;
        }
        else if ([_showMsgDict[@"gift_id"] intValue] == PAINT_GIFT) { // 手绘礼物不需要加载图片
            [mutableAttributedString replaceCharactersInRange:giftIdRange withString:@""];
            cell.msgLabel.attributedText = mutableAttributedString;
        }
        else {
            int giftKey = [_showMsgDict[@"gift_id"] intValue];
            ESWeakSelf;
            [[LiveGiftFile sharedLiveGiftFile] getGiftImage:giftKey
                                                  withBlock:^(int giftKeyBlock, UIImage *giftImage){
                                                      ESStrongSelf;
                                                      if(_self)
                                                      {
                                                          if(giftKeyBlock == giftKey)
                                                          {
                                                              if (giftIdRange.location != NSNotFound) {
                                                                  NSTextAttachment *giftImgAttachment = [[NSTextAttachment alloc] init];
                                                                  float height = 17; //临时解决方案
                                                                  float width = giftImage.size.width / giftImage.size.height * 17;
                                                                  if (!imagesDict[@(giftKey)]) {
                                                                      imagesDict[@(giftKey)] = giftImgAttachment.image = [UIImage imageWithImage:giftImage scaleToSize:CGSizeMake(width, height)];
                                                                  }
                                                                  else {
                                                                      giftImgAttachment.image = imagesDict[@(giftKey)];
                                                                  }
                                                                  giftImgAttachment.bounds = CGRectMake(0, -2, width, height);
                                                                  NSAttributedString *giftImgAttributedString = [NSAttributedString attributedStringWithAttachment:giftImgAttachment];
                                                                  [mutableAttributedString replaceCharactersInRange:NSMakeRange(mutableAttributedString.string.length - giftIdRange.length, giftIdRange.length) withAttributedString:giftImgAttributedString];
                                                              }
                                                              
                                                              cell.msgLabel.attributedText = mutableAttributedString;
                                                          }
                                                      }
                                                  }];
        }
    } else {
        if (userGrade > 0) {
            cell.gradeImgView.hidden = NO;
        } else {
            cell.gradeImgView.hidden = YES;
        }
        
        if (cell.msgLabel) {
            cell.msgLabel.attributedText = _showMsgDict[@"content_attr"];
        }
        NSLog(@"attr exit get cache");
    } 
}

#pragma mark - 解析进入房间消息
- (void) parseEnterRoom:(NSString *)msg withMsgInfo:(NSDictionary *)_showMsgDict withGroupMsgCell:(GroupMsgCell *)cell
{
//    int userGrade = [_showMsgDict[@"grade"] intValue];
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:msg];
    
    // 设置标签文字的属性
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:NICKNAME_FONT_COLOR range:NSMakeRange(0, 5)];
 
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:ENTER_ROOM_FONT_COLOR range:NSMakeRange(5, mutableAttributedString.string.length -5)];
    
    cell.msgLabel.attributedText = mutableAttributedString;
    cell.gradeImgView.hidden = YES;
    
    NSArray *medalArray = _showMsgDict[@"wanjia_medal"];
    if (medalArray && medalArray.count > 0) {
        if (medalArray.count == 1) {
            [cell.medalFirstImgView sd_setImageWithURL:medalArray[0] placeholderImage:nil];
        } else if (medalArray.count == 2) {
            [cell.medalFirstImgView sd_setImageWithURL:medalArray[0] placeholderImage:nil];
            [cell.medalTwoImgView sd_setImageWithURL:medalArray[1] placeholderImage:nil];
        } else if (medalArray.count == 3) {
            [cell.medalFirstImgView sd_setImageWithURL:medalArray[0] placeholderImage:nil];
            [cell.medalTwoImgView sd_setImageWithURL:medalArray[1] placeholderImage:nil];
            [cell.medalThreeImgView sd_setImageWithURL:medalArray[2] placeholderImage:nil];
        } else if (medalArray.count == 4) {
            [cell.medalFirstImgView sd_setImageWithURL:medalArray[0] placeholderImage:nil];
            [cell.medalTwoImgView sd_setImageWithURL:medalArray[1] placeholderImage:nil];
            [cell.medalThreeImgView sd_setImageWithURL:medalArray[2] placeholderImage:nil];
            [cell.medalFourImgView sd_setImageWithURL:medalArray[3] placeholderImage:nil];
        }
        
    }
//    // 昵称点击
//    [self findNickName:msg withShowMsgDict:_showMsgDict withGroupMsgCell:cell];
}

#pragma mark - 解析系统消息
- (void) parseSystemInfo:(NSString *)msg withMsgInfo:(NSDictionary *)_showMsgDict withGroupMsgCell:(GroupMsgCell *)cell
{
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:msg];
    // 设置标签文字的属性
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:SYSTEM_HEAD_FONT_COLOR range:NSMakeRange(0, 5)];
    
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:SYSTEM_MSG_FONT_COLOR range:NSMakeRange(5, mutableAttributedString.string.length -5)];
    
    cell.msgLabel.attributedText = mutableAttributedString;
    cell.gradeImgView.hidden = YES;
}

#pragma mark - 解析禁言消息
- (void) parsetGagInfo:(NSString *)msg withMsgInfo:(NSDictionary *)_showMsgDict withGroupMsgCell:(GroupMsgCell *)cell
{
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:msg];
    // 设置标签文字的属性
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:SYSTEM_HEAD_FONT_COLOR range:NSMakeRange(0, 5)];
    
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:SYSTEM_MSG_FONT_COLOR range:NSMakeRange(5, mutableAttributedString.string.length -5)];
    
    cell.msgLabel.attributedText = mutableAttributedString;
    cell.gradeImgView.hidden = YES;
}

#pragma mark - 解析解除禁言消息
- (void) parsetRemoveGagInfo:(NSString *)msg withMsgInfo:(NSDictionary *)_showMsgDict withGroupMsgCell:(GroupMsgCell *)cell
{
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:msg];
    // 设置标签文字的属性
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:SYSTEM_HEAD_FONT_COLOR range:NSMakeRange(0, 5)];
    
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:SYSTEM_MSG_FONT_COLOR range:NSMakeRange(5, mutableAttributedString.string.length -5)];
    
    cell.msgLabel.attributedText = mutableAttributedString;
    cell.gradeImgView.hidden = YES;
}

#pragma mark - 解析管理员消息
- (void) parseManagerInfo:(NSString *)msg withMsgInfo:(NSDictionary *)_showMsgDict withGroupMsgCell:(GroupMsgCell *)cell
{
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:msg];
    // 设置标签文字的属性
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:SYSTEM_HEAD_FONT_COLOR range:NSMakeRange(0, 5)];
    
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:SYSTEM_MSG_FONT_COLOR range:NSMakeRange(5, mutableAttributedString.string.length -5)];
    
    cell.msgLabel.attributedText = mutableAttributedString;
    cell.gradeImgView.hidden = YES;
}

#pragma mark - 解析删除管理员消息
- (void) parseRemoveManagerInfo:(NSString *)msg withMsgInfo:(NSDictionary *)_showMsgDict withGroupMsgCell:(GroupMsgCell *)cell
{
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:msg];
    // 设置标签文字的属性
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:SYSTEM_HEAD_FONT_COLOR range:NSMakeRange(0, 5)];
    
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:SYSTEM_MSG_FONT_COLOR range:NSMakeRange(5, mutableAttributedString.string.length -5)];
    
    cell.msgLabel.attributedText = mutableAttributedString;
    cell.gradeImgView.hidden = YES;
}

#pragma mark - 点亮消息
- (void) lightupAnchorInfo:(NSString *)msg withMsgInfo:(NSDictionary *)_showMsgDict withGroupMsgCell:(GroupMsgCell *)cell
{
    int userGrade = [_showMsgDict[@"grade"] intValue];
    NSRange gradeRange = NSMakeRange(0, 0);
    if (userGrade > 0)
    {
        gradeRange = [msg rangeOfString:[NSString stringWithFormat:@"%d",userGrade]];
    }
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:msg];
    
    if (userGrade > 0) {
        cell.gradeImgView.hidden = NO;
        
        [mutableAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.f] range:gradeRange];
        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:CHAT_MSG_FONT_COLOR range:gradeRange];
    } else {
        cell.gradeImgView.hidden = YES;
    }

    
    NSRange nameRange = [mutableAttributedString.string rangeOfString:[NSString stringWithFormat:@"%@:",_showMsgDict[@"nickname"]]];
    
    if (nameRange.location != NSNotFound) {
        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:NICKNAME_FONT_COLOR range:nameRange];
        
        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:CHAT_MSG_FONT_COLOR range:NSMakeRange(nameRange.location+nameRange.length, mutableAttributedString.length - (nameRange.location+nameRange.length))];
    } else {
        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:CHAT_MSG_FONT_COLOR range:NSMakeRange(0, mutableAttributedString.length)];
    }
    
    
    NSTextAttachment *giftImgAttachment = [[NSTextAttachment alloc] init];
    UIImage *lightImg = [UIImage imageNamed:[NSString stringWithFormat:@"image/liveroom/lightup_%d",[_showMsgDict[@"love_pos"] intValue]]];
    giftImgAttachment.image = [UIImage imageWithImage:lightImg scaleToSize:CGSizeMake(lightImg.size.width/5, lightImg.size.width/5)];
    NSAttributedString *giftImgAttributedString = [NSAttributedString attributedStringWithAttachment:giftImgAttachment];
    [mutableAttributedString replaceCharactersInRange:NSMakeRange(mutableAttributedString.string.length - 1, 1) withAttributedString:giftImgAttributedString];
    
    cell.msgLabel.attributedText = mutableAttributedString;
 
//    // 昵称点击
//    [self findNickName:msg withShowMsgDict:_showMsgDict withGroupMsgCell:cell];
}

#pragma mark - 升级消息
- (void) parseUpGradeInfo:(NSString *)msg withMsgInfo:(NSDictionary *)_showMsgDict withGroupMsgCell:(GroupMsgCell *)cell
{
 // 直播消息:恭喜%@升级到%d
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:msg];
    // 设置标签文字的属性
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:SYSTEM_HEAD_FONT_COLOR range:NSMakeRange(0, 5)];
    
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:SYSTEM_MSG_FONT_COLOR range:NSMakeRange(5, mutableAttributedString.string.length -5)];
    NSRange nameRange =  [mutableAttributedString.string rangeOfString:[NSString stringWithFormat:@"%@",_showMsgDict[@"nickname"]]];
    
    if (nameRange.location != NSNotFound) {
        // 设置标签文字的属性
        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:NICKNAME_FONT_COLOR range:nameRange];
    }
    
    cell.msgLabel.attributedText = mutableAttributedString;
    cell.gradeImgView.hidden = YES;
}

#pragma mark - 关注消息
- (void) parseAttetInfo:(NSString *)msg withMsgInfo:(NSDictionary *)_showMsgDict withGroupMsgCell:(GroupMsgCell *)cell
{
//    直播消息:%@ 关注了主播，不错过下次直播
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:msg];
    // 设置标签文字的属性
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:NORMAL_HEAD_FONT_COLOR range:NSMakeRange(0, 5)];
    
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:SYSTEM_MSG_FONT_COLOR range:NSMakeRange(5, mutableAttributedString.string.length -5)];
    NSRange nameRange =  [mutableAttributedString.string rangeOfString:[NSString stringWithFormat:@"%@",_showMsgDict[@"nickname"]]];
    
    if (nameRange.location != NSNotFound) {
        // 设置标签文字的属性
        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:NICKNAME_FONT_COLOR range:nameRange];
    }
    
    cell.msgLabel.attributedText = mutableAttributedString;
    cell.gradeImgView.hidden = YES;
}

#pragma mark - 分享消息
- (void) parseShareInfo:(NSString *)msg withMsgInfo:(NSDictionary *)_showMsgDict withGroupMsgCell:(GroupMsgCell *)cell
{
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:msg];
    // 设置标签文字的属性
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:NORMAL_HEAD_FONT_COLOR range:NSMakeRange(0, 5)];
    
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:SYSTEM_MSG_FONT_COLOR range:NSMakeRange(5, mutableAttributedString.string.length -5)];
    
    cell.msgLabel.attributedText = mutableAttributedString;
    cell.gradeImgView.hidden = YES;
}

#pragma mark - 房间消息通知
- (void) parseRoomNotificationInfo:(NSString *)msg withMsgInfo:(NSDictionary *)_showMsgDict withGroupMsgCell:(GroupMsgCell *)cell
{
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:msg];
    // 设置标签文字的属性
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:NORMAL_HEAD_FONT_COLOR range:NSMakeRange(0, 5)];
    
    [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:SYSTEM_MSG_FONT_COLOR range:NSMakeRange(5, mutableAttributedString.string.length -5)];
    
    cell.msgLabel.attributedText = mutableAttributedString;
    cell.gradeImgView.hidden = YES;
}


#pragma  mark - 点击昵称事件
- (void)tapNameLabel:(TapNameLabel *)tapLabel
 didClickNameAtIndex:(NSInteger)index
           withRange:(NSRange)range
         withMsgDict:(NSDictionary *)_showMsgDict
{ 
    LiveUser *liveUser = [[LiveUser alloc] initWithPhone:_showMsgDict[@"uid"] name:_showMsgDict[@"nickname"] logo:_showMsgDict[@"face"]];
    liveUser.hasInRoom = YES;
    
    NSString *userIdStr = [NSString stringWithFormat:@"%@",liveUser.userId];
    if (!userIdStr || userIdStr.length <= 0) {
        return;
    }
    
    if (self.showUserSpaceBlock) {
       self.showUserSpaceBlock(liveUser);
    }
}

#pragma mark - 长安昵称回复
- (void) longTapNameLabel:(TapNameLabel *)tapLabel didClickNameAtIndex:(NSInteger)index withRange:(NSRange)range withMsgDict:(NSDictionary *)_showMsgDict
{
    LiveUser *liveUser = [[LiveUser alloc] initWithPhone:_showMsgDict[@"uid"] name:_showMsgDict[@"nickname"] logo:_showMsgDict[@"face"]];
    liveUser.hasInRoom = YES;
    
    NSString *userIdStr = [NSString stringWithFormat:@"%@",liveUser.userId];
    if (!userIdStr || userIdStr.length <= 0) {
        return;
    }
    
    if (self.reviewUserBlock) {
        self.reviewUserBlock(liveUser);
    }
}

#pragma mark - 添加消息到view
- (void) addMsgToGroupMsgView:(NSDictionary *)msgInfoDict
{
//    NSDate* dat = [NSDate date];
//    NSTimeInterval oldTime =[dat timeIntervalSince1970]*1000;
    if (!msgInfoDict) {
        return;
    }
    
    if (![GroupMsgCell shouldShowContent:msgInfoDict]) {
        return ;
    }
    
//    if (!msgInfoDict[@"show_msg"]) {
        NSString *showMsg =  [GroupMsgCell CellContent:msgInfoDict];
        if (!showMsg) {
            return;
        }
        
        NSMutableDictionary *msgUpdateDict = [NSMutableDictionary dictionaryWithDictionary:msgInfoDict];
        [msgUpdateDict setObject:showMsg forKey:@"show_msg"];
        
        int labHeight = [ShowGroupMsgView getTxtSize:showMsg withUserGrade:[msgInfoDict[@"grade"] intValue] withGift:[msgInfoDict[@"type"] isEqualToString:LIVE_GROUP_GIFT]?YES:NO withContentWidth:_contentTable.width];
        
        [msgUpdateDict setObject:@(labHeight) forKey:@"height"];
        
        
        if (labHeight == 0) {
            return;
        }
        
        [self.contentArray addObject:msgUpdateDict];
//    } else {
//        [self.contentArray addObject:msgInfoDict];
//    }
    
    NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.contentArray.count - 1  inSection:0];
    [self.contentTable insertRowsAtIndexPaths:@[indexpath] withRowAnimation:UITableViewRowAnimationNone];
    if (self.contentTable.contentSize.height - self.contentTable.contentOffset.y <= self.contentTable.size.height + 10) { // 只有在底部才滚动
        [self.contentTable scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    [self deleteHistoryMessage];
    

//    NSDate* newDat = [NSDate date];
//    NSTimeInterval newTime =[newDat timeIntervalSince1970]*1000;
//    NSLog(@"addMsgToGroupMsgView  timer :%f",(newTime - oldTime));
}

// 提交推流心跳
- (void) commitLiveHeart
{
    [[LCHTTPClient sharedHTTPClient] requestWithParameters:@{@"total":@([LCMyUser mine].liveOnlineUserCount)}
                                                  withPath:URL_LIVE_HEART
                                               withRESTful:GET_REQUEST
                                          withSuccessBlock:nil
                                             withFailBlock:nil];
}

#pragma mark - 批量删除历史消息
- (void) deleteHistoryMessage
{
    static BOOL isDelete;
    
    if (self.contentArray.count >= DELETE_POSITION && !isDelete) {
        isDelete = YES;
        [self.contentArray removeObjectsInRange:NSMakeRange(0, DELETE_MSG_COUNT)];
        [self.contentTable reloadData];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            isDelete = NO;
        });
        
        NSLog(@"after delete count:%@",NSStringFromCGRect(self.contentTable.frame));
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:self.contentArray.count - 1  inSection:0];
        if (self.contentTable.contentSize.height - self.contentTable.contentOffset.y <= self.contentTable.size.height + 10) { // 只有在底部才滚动
            [self.contentTable scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        }
    }
}

#pragma mark - 查找昵称
- (void) findNickName:(NSString *)msg withShowMsgDict:(NSDictionary *)_showMsgDict withGroupMsgCell:(GroupMsgCell *)cell
{
    NSString *name = [NSString stringWithFormat:@"%@:",_showMsgDict[@"nickname"]];
    NSRange range = [msg rangeOfString:name];
    if (range.location != NSNotFound) {
        NSRange ranges[] = {range};
        [cell.msgLabel setNameRanges:ranges withLength:1];
    } else {
        [cell.msgLabel setNameRanges:nil withLength:0];
    }
}

#pragma mark - trumpet

+ (NSAttributedString *)getTrumpetStringWithDict:(NSDictionary *)dict {
    NSString *msg = dict[@"system_content"];
    if (!msg) {
        return nil;
    }
    NSMutableAttributedString *ret = [[NSMutableAttributedString alloc] initWithString:msg];
    
    NSString *nameStr = dict[@"sender"];
    NSString *tartgetStr = dict[@"target"];
    NSString *gift_name = dict[@"gift_name"];
    
    if (nameStr && [msg rangeOfString:nameStr].location != NSNotFound) {
        [ret addAttribute:NSForegroundColorAttributeName value:NICKNAME_FONT_COLOR range:[msg rangeOfString:nameStr]];
    }
    if (tartgetStr && [msg rangeOfString:tartgetStr].location != NSNotFound) {
        [ret addAttribute:NSForegroundColorAttributeName value:NICKNAME_FONT_COLOR range:[msg rangeOfString:tartgetStr]];
    }
    if (gift_name && [msg rangeOfString:gift_name].location != NSNotFound) {
        [ret addAttribute:NSForegroundColorAttributeName value:SYSTEM_MSG_FONT_COLOR range:[msg rangeOfString:gift_name]];
    }
    return ret;
}

@end
