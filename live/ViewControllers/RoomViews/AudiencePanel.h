//
//  AudiencePanel.h
//  live
//
//  Created by AlexiChen on 15/10/21.
//  Copyright © 2015年 kenneth. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AudiencePanel;

@protocol AudiencePanelDelegate  <NSObject>

- (BOOL)onClickPanel:(AudiencePanel *)panel userInfo:(LiveUser *)user isNormal:(BOOL)isNormalUser;

- (void)onHidePanel:(AudiencePanel *)panel;

@end

@interface AudiencePanel : UIView<UICollectionViewDataSource, UICollectionViewDelegate, UIGestureRecognizerDelegate>
{
@protected
    
    UIView      *_contentView;
    CGRect      _contentRect;
    
    UILabel     *_titleLabel;
    UIButton    *_msgView;
    UIView      *_line;
    UICollectionView *_collectionView;
    
//    UIButton *_close;

@protected
    NSMutableDictionary *_audienceDictionary;
}

@property (nonatomic, weak) id<AudiencePanelDelegate> delegate;

- (void)setTitle:(NSString *)title;

- (void)config:(NSArray *)audienceList;

@end

