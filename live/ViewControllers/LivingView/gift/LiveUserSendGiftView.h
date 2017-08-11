//
//  LiveUserSendGiftView.h
//  qianchuo
//
//  Created by jacklong on 16/3/11.
//  Copyright © 2016年 kenneth. All rights reserved.
//
 

@interface LiveUserSendGiftView : UIView

@property (nonatomic,strong) UIImageView     *bgImg;
@property (nonatomic,strong) UIImageView     *sendFaceImg;
@property (nonatomic,strong) UIImageView    *gradeFlagImgView;
@property (nonatomic,strong) UILabel         *sendNickNameLabel;
@property (nonatomic,strong) UILabel         *sendGiftNameLabel;
@property (nonatomic,strong) UIImageView     *giftImg;
@property (nonatomic,strong) UILabel         *giftNumLabel;

@property (nonatomic,strong) NSDictionary    *sendGiftDict;


- (void) showGiftNum:(NSDictionary *)giftDict;

- (NSMutableAttributedString *) loadGiftNumAttr:(NSDictionary *)giftDict;
@end
