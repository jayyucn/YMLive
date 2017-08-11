//
//  BarrageMsgView.h
//  qianchuo
//
//  Created by jacklong on 16/3/11.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarrageMsgView : UIView

@property (nonatomic,strong) UIImageView    *sendFaceImg;
@property (nonatomic,strong) UIImageView    *gradeFlagImgView;

@property (nonatomic,strong) UILabel        *sendNameLabel;
@property (nonatomic,strong) UIView         *bgContentView;
@property (nonatomic,strong) UILabel        *contentLabel;


@property (nonatomic,strong) NSDictionary   *barrageInfoDict;
 

- (float) getContentWidth;
@end

