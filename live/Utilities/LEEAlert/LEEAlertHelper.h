
/*!
 *  @header LEEAlertHelper.h
 *
 *  ┌─┐      ┌───────┐ ┌───────┐ 帅™
 *  │ │      │ ┌─────┘ │ ┌─────┘
 *  │ │      │ └─────┐ │ └─────┐
 *  │ │      │ ┌─────┘ │ ┌─────┘
 *  │ └─────┐│ └─────┐ │ └─────┐
 *  └───────┘└───────┘ └───────┘
 *
 *  @brief  LEEAlertHelper
 *
 *  @author LEE
 *  @copyright    Copyright © 2016 - 2017年 lee. All rights reserved.
 *  @version    V1.0.0
 */

#ifndef LEEAlertHelper_h
#define LEEAlertHelper_h

FOUNDATION_EXPORT double LEEAlertVersionNumber;
FOUNDATION_EXPORT const unsigned char LEEAlertVersionString[];

@class LEEAlert , LEEAlertConfig , LEEAlertConfigModel , LEEAction , LEEItem , LEECustomView;

typedef NS_ENUM(NSInteger, LEEScreenOrientationType) {
    /** 屏幕方向类型 横屏 */
    LEEScreenOrientationTypeHorizontal,
    /** 屏幕方向类型 竖屏 */
    LEEScreenOrientationTypeVertical
};


typedef NS_ENUM(NSInteger, LEEAlertType) {
    
    LEEAlertTypeAlert,
    
    LEEAlertTypeActionSheet
};


typedef NS_ENUM(NSInteger, LEEActionType) {
    /** 默认 */
    LEEActionTypeDefault,
    /** 取消 */
    LEEActionTypeCancel,
    /** 销毁 */
    LEEActionTypeDestructive
};


typedef NS_ENUM(NSInteger, LEEItemType) {
    /** 标题 */
    LEEItemTypeTitle,
    /** 内容 */
    LEEItemTypeContent,
    /** 输入框 */
    LEEItemTypeTextField,
    /** 自定义视图 */
    LEEItemTypeCustomView,
};

typedef NS_ENUM(NSInteger, LEECustomViewPositionType) {
    /** 居中 */
    LEECustomViewPositionTypeCenter,
    /** 靠左 */
    LEECustomViewPositionTypeLeft,
    /** 靠右 */
    LEECustomViewPositionTypeRight
};

typedef LEEAlertConfigModel *(^LEEConfig)();
typedef LEEAlertConfigModel *(^LEEConfigToBool)(BOOL is);
typedef LEEAlertConfigModel *(^LEEConfigToFloat)(CGFloat number);
typedef LEEAlertConfigModel *(^LEEConfigToString)(NSString *str);
typedef LEEAlertConfigModel *(^LEEConfigToView)(UIView *view);
typedef LEEAlertConfigModel *(^LEEConfigToColor)(UIColor *color);
typedef LEEAlertConfigModel *(^LEEConfigToEdgeInsets)(UIEdgeInsets insets);
typedef LEEAlertConfigModel *(^LEEConfigToBlurEffectStyle)(UIBlurEffectStyle style);
typedef LEEAlertConfigModel *(^LEEConfigToFloatBlock)(CGFloat(^)(LEEScreenOrientationType type));
typedef LEEAlertConfigModel *(^LEEConfigToAction)(void(^)(LEEAction *action));
typedef LEEAlertConfigModel *(^LEEConfigToCustomView)(void(^)(LEECustomView *custom));
typedef LEEAlertConfigModel *(^LEEConfigToStringAndBlock)(NSString *str , void (^)());
typedef LEEAlertConfigModel *(^LEEConfigToConfigLabel)(void(^)(UILabel *label));
typedef LEEAlertConfigModel *(^LEEConfigToConfigTextField)(void(^)(UITextField *textField));
typedef LEEAlertConfigModel *(^LEEConfigToItem)(void(^)(LEEItem *item));

#endif /* LEEAlertHelper_h */
