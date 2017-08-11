//
//  DrawBottomSelectView.m
//  HuoWuLive
//
//  Created by 林伟池 on 16/11/21.
//  Copyright © 2016年 上海七夕. All rights reserved.
//

#import "DrawBottomSelectView.h"

#define GIFT_NUM 4
#define GIFT_SIZE 50
#define TAG_IMAGE_SELECT 10

@interface DrawBottomSelectView ()
@property (nonatomic , strong) NSMutableArray<UIView *> *mSelectItemArray;
@property (nonatomic , strong) UILabel *mDescLabel;
@property (nonatomic , strong) UILabel *mDiamondLabel;
@property (nonatomic , strong) UIButton *mSendBtn;

@end


@implementation DrawBottomSelectView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    [self initDescView];
    [self initSelectItemView];
    [self initBottomView];
    return self;
}

#pragma mark - view init
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
#pragma mark - ibaction

#pragma mark - ui
- (void)updateDescLabel {
    if (_mDrawCount.intValue < 10) {
        self.mDescLabel.attributedText = [[NSMutableAttributedString alloc] initWithString:@"至少绘制十个礼物，才能送给主播"];
    }
    else {
        NSString *str = [NSString stringWithFormat:@"已经绘制了%d个礼物，消耗%d钻石", self.mDrawCount.intValue, 10 * self.mDrawCount.intValue];
        NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:str];
        
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:
         [str rangeOfString:[NSString stringWithFormat:@"%d", self.mDrawCount.intValue]]];
        
        [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor yellowColor] range:
         [str rangeOfString:[NSString stringWithFormat:@"%d钻石", 10 * self.mDrawCount.intValue]]];
        
        self.mDescLabel.attributedText = attrString;
    }
}

#pragma mark - delegate

#pragma mark - notify
- (void)initDescView {
    UIImage *warningImage = [UIImage imageNamed:@"image/liveroom/draw_warning"];
    UIImageView *warningImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 17, 15)];
    [warningImageView setImage:warningImage];
    [self addSubview:warningImageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(warningImageView.right + 5, warningImageView.top, 300, warningImageView.height)];
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor blackColor];
    label.shadowOffset = CGSizeMake(1, 1);
    self.mDescLabel = label;
    [self addSubview:label];
    [self updateDescLabel];
}

- (void)initSelectItemView {
    _mSelectItemArray = [NSMutableArray array];
    for (int i = 0; i < GIFT_NUM; ++i) {
        UIImage *selectedImage = [UIImage imageNamed:@"image/liveroom/chat_gift_continue_selected"];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"image/liveroom/draw_gift_item%d", i]];
        if (image && selectedImage) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10 + (GIFT_SIZE + 20) * i, 30, GIFT_SIZE, GIFT_SIZE)];
            imageView.image = image;
            UIImageView *selectView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 15, 15)];
            selectView.image = selectedImage;
            selectView.left = imageView.width;
            selectView.tag = TAG_IMAGE_SELECT;
            [imageView addSubview:selectView];
            [self addSubview:imageView];
            
            UILabel *diamondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, GIFT_SIZE, GIFT_SIZE, 14)];
            diamondLabel.textAlignment = NSTextAlignmentCenter;
            diamondLabel.textColor=[UIColor yellowColor];
            diamondLabel.font=[UIFont systemFontOfSize:12];
            diamondLabel.backgroundColor =[UIColor clearColor];
            [imageView addSubview:diamondLabel];
            
            NSString *priceText = [NSString stringWithFormat:@"10 d"];
            NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:priceText];
            
            NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
            UIImage *image = [UIImage imageNamed:@"image/liveroom/me_myaccount_reddiamond"];
            textAttachment.image = [UIImage imageWithImage:image scaleToSize:
                                    CGSizeMake(image.size.width * 3 / 5,image.size.height * 3 / 5)];
            NSAttributedString *iconAttributedString = [NSAttributedString attributedStringWithAttachment:textAttachment];
            [mutableAttributedString replaceCharactersInRange:NSMakeRange(priceText.length - 1, 1) withAttributedString:iconAttributedString];
            diamondLabel.attributedText = mutableAttributedString;
            UILabel *experienceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, GIFT_SIZE, 12)];
            experienceLabel.textAlignment = NSTextAlignmentCenter;
            experienceLabel.textColor = ColorPink;
            experienceLabel.font = [UIFont systemFontOfSize:12];
            experienceLabel.backgroundColor = [UIColor clearColor];
            [imageView addSubview:experienceLabel];
            experienceLabel.text= [NSString stringWithFormat:@"+10%@", ESLocalizedString(@"经验")];
            experienceLabel.center = CGPointMake(diamondLabel.centerX, diamondLabel.centerY + 20);

            [self.mSelectItemArray addObject:imageView];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTapItem:)];
            [imageView addGestureRecognizer:tap];
            imageView.userInteractionEnabled = YES;
        }
    }
    self.mSelectIndex = 0;
}

- (void)initBottomView {
    UIView *rechargeView = [[UIView alloc] initWithFrame:CGRectMake(10, self.height - 40, self.width / 2, 40)];
    rechargeView.userInteractionEnabled = YES;
//    rechargeView.backgroundColor = [UIColor blackColor];
    [self addSubview:rechargeView];
    ESWeakSelf;
    [rechargeView addTapGestureHandler:^(UITapGestureRecognizer *gestureRecognizer, UIView *view, CGPoint locationInView) {
        ESStrongSelf;
        if (_self.mDrawRechargeBlock) {
            _self.mDrawRechargeBlock();
        }
    }];
    
    UILabel *rechargeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 40, 40)];
    rechargeLabel.textColor=[UIColor yellowColor];
    rechargeLabel.shadowColor = [UIColor blackColor];
    rechargeLabel.shadowOffset = CGSizeMake(1, 1);
    
    rechargeLabel.font=[UIFont systemFontOfSize:13];
    rechargeLabel.backgroundColor =[UIColor clearColor];
    rechargeLabel.text = @"充值: ";
    [rechargeView addSubview:rechargeLabel];
    
    UILabel *diamondLabel = [[UILabel alloc] initWithFrame:CGRectMake(rechargeLabel.right + 2, 0, self.width / 2 - 45, 40)];
    diamondLabel.textAlignment = NSTextAlignmentLeft;
    diamondLabel.textColor=[UIColor yellowColor];
    diamondLabel.shadowColor = [UIColor blackColor];
    diamondLabel.shadowOffset = CGSizeMake(1, 1);
    diamondLabel.font=[UIFont systemFontOfSize:14];
    diamondLabel.backgroundColor =[UIColor clearColor];
    _mDiamondLabel = diamondLabel;
    [self setCurrentBalance];
    [rechargeView addSubview:diamondLabel];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDrawDiamond:) name:LCUserLiveDiamondDidChangeNotification object:nil];
    
    
    UIImage *sendImage = [UIImage createImageWithColor:ColorPink];
    UIButton *sendGiftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendGiftBtn setBackgroundImage:sendImage
                            forState:UIControlStateNormal];
    [sendGiftBtn setTitle:@"发 送" forState:UIControlStateNormal];
    [sendGiftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    sendGiftBtn.frame = CGRectMake(self.width - 80, self.height - 40, 80, 40);
    [self addSubview:sendGiftBtn];
    [sendGiftBtn addTarget:self
                     action:@selector(sendDrawAction)
           forControlEvents:UIControlEventTouchUpInside];
    self.mSendBtn = sendGiftBtn;
}

- (void)updateDrawDiamond:(NSNotification *)notify {
    [self setCurrentBalance];
}

- (void)setCurrentBalance {
    UIImage *rightImage=[UIImage imageNamed:@"icon_detail"];
    NSString *priceText = [NSString stringWithFormat:@"%d d d",[LCMyUser mine].diamond];
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:priceText];
    NSTextAttachment *iconAttachment = [[NSTextAttachment alloc] init];
    UIImage *image = [UIImage imageNamed:@"image/liveroom/me_myaccount_reddiamond"];
    iconAttachment.image = image;
    NSAttributedString *iconAttributedString = [NSAttributedString attributedStringWithAttachment:iconAttachment];
    iconAttachment = [[NSTextAttachment alloc] init];
    iconAttachment.image = rightImage;
    NSAttributedString *rightAttributedString = [NSAttributedString attributedStringWithAttachment:iconAttachment];
    [mutableAttributedString replaceCharactersInRange:NSMakeRange(priceText.length - 1, 1) withAttributedString:rightAttributedString];
    [mutableAttributedString replaceCharactersInRange:NSMakeRange(priceText.length - 3, 1) withAttributedString:iconAttributedString];
    self.mDiamondLabel.attributedText = mutableAttributedString;
}

- (void)sendDrawAction {
    if (self.mDrawSendBlock) {
        self.mDrawSendBlock();
    }
}

- (void)onTapItem:(UITapGestureRecognizer *)tap {
    for (int i = 0; i < self.mSelectItemArray.count; ++i) {
        if (self.mSelectItemArray[i] == tap.view) {
            self.mSelectIndex = @(i);
        }
    }
}

- (void)setMSelectIndex:(NSNumber *)mSelectIndex {
    for (int i = 0; i < self.mSelectItemArray.count; ++i) {
        if (i == mSelectIndex.integerValue) {
            [self.mSelectItemArray[i] viewWithTag:TAG_IMAGE_SELECT].hidden = NO;
        }
        else {
            [self.mSelectItemArray[i] viewWithTag:TAG_IMAGE_SELECT].hidden = YES;
        }
    }
    _mSelectIndex = mSelectIndex;
    if (_mDrawSelectBlock) {
        _mDrawSelectBlock();
    }
}

- (void)setMDrawCount:(NSNumber *)mDrawCount {
    _mDrawCount = mDrawCount;
    [self updateDescLabel];
    if (mDrawCount.intValue < 10) {
        self.mSendBtn.enabled = NO;
    }
    else {
        self.mSendBtn.enabled = YES;
    }
}




@end
