//
//  LiveGiftCell.h
//  礼物itemview
//
//  Created by jacklong on 16/3/5.
//  Copyright © 2016年 kenneth. All rights reserved.
//


#define ItemWidth ScreenWidth/4
#define ItemHeight 96

#import "LiveGiftFile.h"

typedef void(^SelectBlock)(int selectTag);

@interface LiveGiftItemView : UIView<UIGestureRecognizerDelegate>

@property (nonatomic)BOOL selected;
@property (nonatomic,strong)NSMutableDictionary *giftDic;
@property (nonatomic,strong)UIImageView         *giftImageView;
@property (nonatomic,strong)UILabel             *diamondLabel;
@property (nonatomic,strong)UILabel             *experienceLabel;
@property (nonatomic,strong)UIImageView         *giftTypeView;
@property (nonatomic,strong)UIImageView         *selectView;
@property (nonatomic,strong)UIImageView         *activeImgView;
@property (nonatomic,copy)SelectBlock         selectBlock;

-(void)autoSelectGift;
-(void)updateOfView;
+(int)getSelectKey;
+(NSString *)getSelectGiftEffect;

@end
