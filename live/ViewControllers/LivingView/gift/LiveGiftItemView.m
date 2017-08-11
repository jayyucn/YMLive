//
//  LiveGiftCell.m
//  qianchuo
//
//  Created by jacklong on 16/3/5.
//  Copyright © 2016年 kenneth. All rights reserved.
//

#import "LiveGiftItemView.h"
#import "UIImage+Category.h"

static int selectKey = -1;

static NSString *giftEffect = @"0";

@implementation LiveGiftItemView

- (void)dealloc
{ 
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIImage *activeImg = [UIImage imageNamed:@"image/liveroom/act_icon"];
        _activeImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, activeImg.size.width, activeImg.size.height)];
        _activeImgView.image = activeImg;
        [self addSubview:_activeImgView];
        _activeImgView.hidden = YES;
        
        UIImage *selectImg = [UIImage imageNamed:@"image/liveroom/chat_gift_continue_selected"];
        _selectView=[[UIImageView alloc] initWithFrame:CGRectMake(ItemWidth-selectImg.size.width/3, 5, selectImg.size.width/3, selectImg.size.height/3)];
        _selectView.image = selectImg;
        [self addSubview:_selectView];
        _selectView.hidden = YES;
        
        UIImage *normalImg = [UIImage imageNamed:@"image/liveroom/chat_gift_continue_normal"];
        _giftTypeView = [[UIImageView alloc] initWithFrame:CGRectMake(ItemWidth-selectImg.size.width/3, 5, selectImg.size.width/3, selectImg.size.height/3)];
        _giftTypeView.image = normalImg;
        [self addSubview:_giftTypeView];
//        _giftTypeView.hidden = YES;
        
        _giftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(9, 9, 51, 51)];
        [self addSubview:_giftImageView];
        _giftImageView.centerX = ItemWidth/2;
        
        _diamondLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,ItemWidth,14)];
        _diamondLabel.textAlignment = NSTextAlignmentCenter;
        _diamondLabel.textColor=[UIColor yellowColor];
        _diamondLabel.font=[UIFont systemFontOfSize:12];
        _diamondLabel.backgroundColor =[UIColor clearColor];
        [self addSubview:_diamondLabel];
        _diamondLabel.text= @"1";
        _diamondLabel.top=_giftImageView.bottom+4;
        _diamondLabel.centerX=ItemWidth/2;
//        _diamondLabel.hidden = YES;
        
        
        _experienceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,ItemWidth,12)];
        _experienceLabel.textAlignment = NSTextAlignmentCenter;
        _experienceLabel.textColor=ColorPink;
        _experienceLabel.font=[UIFont systemFontOfSize:12];
        _experienceLabel.backgroundColor =[UIColor clearColor];
        [self addSubview:_experienceLabel];
        _experienceLabel.text= [NSString stringWithFormat:@"+10%@", ESLocalizedString(@"经验")];
        _experienceLabel.top=_diamondLabel.bottom+2;
        _experienceLabel.centerX=ItemWidth/2;
//        _experienceLabel.hidden = YES;
        
        
        self.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(tapAction:)];
        tap.delegate=self;
        
        [self addGestureRecognizer:tap];
        
    }
    return self;
}

-(void)autoSelectGift
{
    if (_giftDic) {
        selectKey=[_giftDic[@"id"] intValue];
        
        
        if([_giftDic[@"play"] isEqualToString:@"flash"])
            giftEffect=@"-1";
        else
            giftEffect=@"0";
        
        _selectView.hidden = NO;
        _giftTypeView.hidden = YES;
    }
}

+(int)getSelectKey
{
//    NSLog(@"selectKeyselectKey===%d",selectKey);
    return selectKey;
}

+(NSString *)getSelectGiftEffect
{
    return giftEffect;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
       shouldReceiveTouch:(UITouch *)touch
{
    return YES;
}

-(void)tapAction:(UIGestureRecognizer*)sender{
//    NSLog(@"tapAction");
    if (sender.state == UIGestureRecognizerStateEnded)
    {

        if(_giftDic && selectKey!=[_giftDic[@"id"] intValue])
        {
            selectKey=[_giftDic[@"id"] intValue];
            NSLog(@"selectKeyselectKey===%d",selectKey);
            
            if([_giftDic[@"play"] isEqualToString:@"flash"])
                giftEffect=@"-1";
            else
                giftEffect=@"0";
            
            
            _selectView.hidden=NO;
            _giftTypeView.hidden = YES;
            if (_selectBlock) {
                 _selectBlock(selectKey);
            }
        }
    }
}


- (void) setGiftDic:(NSMutableDictionary *)giftDic
{
    _giftDic = giftDic;
    
    [self updateOfView];
}


-(void)updateOfView
{
    if (!_giftDic) {
        return;
    }
    
    _giftTypeView.hidden = YES;
    
    if(selectKey==[_giftDic[@"id"] intValue])
    {
        _selectView.hidden=NO;
        _giftTypeView.hidden = YES;
    }
    else
    {
        _selectView.hidden=YES;
        if (1 == [_giftDic[@"type"] intValue])
        {
            _giftTypeView.hidden = NO;
        }
        else
        {
            _giftTypeView.hidden = YES;
        }
    }
    
    
    int act = [_giftDic[@"act"] intValue];
    if (act == 1) {
        _activeImgView.hidden = NO;
    } else {
        _activeImgView.hidden = YES;
    }
    
    NSString *priceText = [NSString stringWithFormat:@"%@ d",_giftDic[@"price"]];
    NSMutableAttributedString *mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:priceText];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    UIImage *image = [UIImage imageNamed:@"image/liveroom/me_myaccount_reddiamond"];
    textAttachment.image = [UIImage imageWithImage:image scaleToSize:CGSizeMake(image.size.width*3/5,image.size.height*3/5)];
    NSAttributedString *iconAttributedString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [mutableAttributedString replaceCharactersInRange:NSMakeRange(priceText.length-1, 1) withAttributedString:iconAttributedString];
    
    self.diamondLabel.attributedText = mutableAttributedString;
    self.diamondLabel.hidden = NO;
    
    NSInteger experience =  [_giftDic[@"price"] intValue] * 10;
    self.experienceLabel.text=[NSString stringWithFormat:@"+%ld%@",(long)experience, ESLocalizedString(@"经验")];
    self.experienceLabel.hidden = NO;
    
    int giftKey=[_giftDic[@"id"] intValue];
    ESWeakSelf;
    [[LiveGiftFile sharedLiveGiftFile] getGiftImage:[_giftDic[@"id"] intValue]
                                          withBlock:^(int giftKeyBlock, UIImage *giftImage){
                                              ESStrongSelf;
                                              if(_self)
                                              {
                                                  if(giftKeyBlock == giftKey)
                                                  {
                                                      _self.giftImageView.image  = giftImage;
//                                                      NSLog(@"giftimage:size:%@",NSStringFromCGSize(giftImage.size));
                                                      if (giftImage.size.width/4 > _self.giftImageView.width) {
                                                          _self.giftImageView.width  = giftImage.size.width/6;
                                                          _self.giftImageView.height = giftImage.size.height/6;
                                                      } else {
                                                          _self.giftImageView.width  = giftImage.size.width/4;
                                                          _self.giftImageView.height = giftImage.size.height/4;
                                                      }
                                                   
                                                      _self.giftImageView.centerX=ItemWidth/2;
                                                      _self.giftImageView.centerY=9+51.0/2;
                                                  }
                                              }
                                          }];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */


@end
