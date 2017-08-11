//
//  TapNameLabel.h
//  NewMom
//
//  Created by apple on 15/2/7.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TapNameLabel;

/**
 *  @brief  回调，提供点击名子序号，具体位置
 */
@protocol TapNameLabelDelegate <NSObject>
@optional
- (void)tapNameLabel:(TapNameLabel *)tapLabel
 didClickNameAtIndex:(NSInteger)index
           withRange:(NSRange)range
         withMsgDict:(NSDictionary *)_showMsgDict;

- (void)longTapNameLabel:(TapNameLabel *)tapLabel
     didClickNameAtIndex:(NSInteger)index
               withRange:(NSRange)range
             withMsgDict:(NSDictionary *)_showMsgDict;

@end

@interface TapNameLabel : UILabel
{
    NSRange _nameRanges[2];
    NSInteger _rangeLength;
    
    //text kit工具
    NSTextContainer *_textContainer;
    NSLayoutManager *_layoutManager;
    NSTextStorage *_textStorage;
    
    // 
    NSInteger _tapNameIndex;
    UIColor *_normalColor;
    UIColor *_hilightColor;
}

- (void)setNameRanges:(NSRange *)ranges withLength:(NSInteger)length;

@property (nonatomic, strong) UIColor *normalColor;
@property (nonatomic, strong) UIColor *hilightColor;
@property (nonatomic, strong) NSDictionary *showMsgDict;

@property (nonatomic, weak) id<TapNameLabelDelegate> delegate;

@end
