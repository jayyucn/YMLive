//
//  MallDiamondCell.m
//  qianchuo
//
//  Created by jacklong on 16/4/26.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "MallDiamondCell.h"

@interface  MallDiamondCell() {
    UIImageView   *iconDiamondImage;
    UILabel       *diamondLabel;
    UILabel       *memoLabel;
    ESButton      *buyBtn;
    UIView        *lineView;
}

@end

@implementation MallDiamondCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.backgroundColor=[UIColor whiteColor];
        
        UIImage *diamondImage = [UIImage imageNamed:@"image/liveroom/me_myaccount_reddiamond"];
        iconDiamondImage = [[UIImageView alloc]  initWithFrame:CGRectMake(15, 0, diamondImage.size.width, diamondImage.size.height)];
        iconDiamondImage.centerY = CELL_HEIGHT/2;
        iconDiamondImage.image = diamondImage;
        [self addSubview:iconDiamondImage];
        
        diamondLabel = [[UILabel alloc] initWithFrame:CGRectMake(iconDiamondImage.right+10, 0, 80, 20)];
        diamondLabel.textColor = [UIColor blackColor];
        diamondLabel.font = [UIFont systemFontOfSize:16];
        diamondLabel.centerY =  CELL_HEIGHT/2;
        [self addSubview:diamondLabel];
        
        memoLabel = [[UILabel alloc] initWithFrame:CGRectMake(diamondLabel.right+10, 0, 200, 20)];
        memoLabel.textColor = [UIColor grayColor];
        memoLabel.textAlignment = NSTextAlignmentLeft;
        memoLabel.font = [UIFont systemFontOfSize:13];
        memoLabel.centerY =  CELL_HEIGHT/2;
        [self addSubview:memoLabel];
        memoLabel.hidden = YES;
        
        buyBtn = [ESButton button];
        buyBtn.color = ColorPink;
        
        buyBtn.frame=CGRectMake(ScreenWidth - 70 - 15, 0,70,30);
        buyBtn.centerY = CELL_HEIGHT/2;
        buyBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        [buyBtn setTitleColor:[UIColor whiteColor]
                        forState:UIControlStateNormal];
        
        [buyBtn addTarget:self
                      action:@selector(buyDiamondAction)
            forControlEvents:UIControlEventTouchUpInside];
        buyBtn.userInteractionEnabled=NO;
        [self addSubview:buyBtn];
        
        lineView = [[UIView alloc] initWithFrame:CGRectMake(15, CELL_HEIGHT- 1, SCREEN_WIDTH - 15, 1)];
        lineView.backgroundColor = ColorBackGround;
        [self addSubview:lineView];
    }
    return self;
}

- (void) setDiamondInfoDict:(NSDictionary *)diamondInfoDict
{
    diamondLabel.text = [NSString stringWithFormat:@"%d",[diamondInfoDict[@"diamond"] intValue]];

    NSString *memoStr = ESStringValue(diamondInfoDict[@"memo"]);
    if (memoStr && memoStr.length > 0) {
        memoLabel.text = ESLocalizedString(memoStr);
        memoLabel.hidden = NO;
    } else {
        memoLabel.hidden = YES;
    }
    
    [buyBtn setTitle:[NSString stringWithFormat:@"￥%d",[diamondInfoDict[@"money"] intValue]] forState:UIControlStateNormal];
}

// 购买钻石
- (void) buyDiamondAction
{
    
}

@end
