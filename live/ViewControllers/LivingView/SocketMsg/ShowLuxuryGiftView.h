//
//  ShowLuxuryGiftView.h
//  qianchuo
//
//  Created by jacklong on 16/3/17.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^GetGiftImageBlock)(int giftKey, UIImage *giftImage);

@interface ShowLuxuryGiftView : UIView

@property (nonatomic, strong)UIImageView   *luxuryImg;

@property (nonatomic, strong)NSDictionary  *giftDict;

@property (nonatomic, strong)GetGiftImageBlock giftImageBlock;
@end
