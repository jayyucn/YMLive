//  主播人气周榜视图
//  HotRankItemView.h
//
//  Created by garsonge on 17/7/3.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#ifndef HotRankItemView_h
#define HotRankItemView_h

#import <UIKit/UIKit.h>

typedef void(^OnItemBlock)(NSDictionary *userInfoDict);

@interface HotRankItemView : UIView

@property(nonatomic, strong) UILabel      *titleLabelUp;
@property(nonatomic, strong) UILabel      *titleLabelDown;

@property(nonatomic, strong) UIImageView  *firstUserFaceImgView;
@property(nonatomic, strong) UIImageView  *secondUserFaceImgView;
@property(nonatomic, strong) UIImageView  *thirdUserFaceImgView;

@property(nonatomic, strong) UIImageView  *loadMoreImagView;

@property(nonatomic, strong) NSDictionary *firstUserInfoDict;
@property(nonatomic, strong) NSDictionary *secondUserInfoDict;
@property(nonatomic, strong) NSDictionary *thirdUserInfoDict;

@property(nonatomic, copy) OnItemBlock itemBlock;

@end

#endif /* HotRankItemView_h */
