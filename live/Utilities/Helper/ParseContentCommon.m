//
//  ParseContentCommon.m
//  qianchuo
//
//  Created by jacklong on 16/6/22.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "ParseContentCommon.h"
#import "LiveGiftFile.h"

#define NORMAL_HEAD_FONT_COLOR      RGB16(0xffff00)                        // 直播消息：
#define NORMAL_MSG_FONT_COLOR       RGB16(0xfc3a9a)                        // 进入直播间消息
#define ENTER_ROOM_FONT_COLOR       RGB16(0xfc3a9a)                        // 进入房间消息颜色
#define CHAT_MSG_FONT_COLOR         RGB16(0xf9fafc)                        // 聊天消息颜色
#define NICKNAME_FONT_COLOR         RGB16(0xffff00)                        // 昵称
#define SEND_GIFT_FONT_COLOR        RGB16(0xfc3a9a)                        // 送礼物消息
#define SYSTEM_HEAD_FONT_COLOR      RGB16(0xffff00)                        // 系统消息: 字体颜色
#define SYSTEM_MSG_FONT_COLOR       ColorPink                        // 系统消息字体颜色

@interface ParseContentCommon ()
{
    NSMutableDictionary* imagesDict;
}

@end

@implementation ParseContentCommon

- (instancetype)init
{
    self = [super init];
    if (self) {
        imagesDict = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - 解析礼物消息
- (void) parseGiftMsg:(NSString *)msg withMsgInfo:(NSMutableDictionary *)_showMsgDict
{
    int userGrade = [_showMsgDict[@"grade"] intValue];
    NSRange gradeRange = NSMakeRange(0, 0);
    if (userGrade > 0)
    {
        gradeRange = [msg rangeOfString:[NSString stringWithFormat:@"%d",userGrade]];
    }
    
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:msg];
    
    if (userGrade > 0) {
        //        cell.gradeImgView.hidden = NO;
        
        [mutableAttributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.f] range:gradeRange];
        [mutableAttributedString addAttribute:NSForegroundColorAttributeName value:CHAT_MSG_FONT_COLOR range:gradeRange];
    } else {
        //        cell.gradeImgView.hidden = YES;
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
        [_showMsgDict setObject:mutableAttributedString forKey:@"content_attr"];
    } else {
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
                                                          
                                                          [_showMsgDict setObject:mutableAttributedString forKey:@"content_attr"];
                                                      }
                                                  }
                                              }];
    }
}
@end
