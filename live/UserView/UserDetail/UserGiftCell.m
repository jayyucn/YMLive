//
//  UserGiftCell.m
//  XCLive
//
//  Created by 王威 on 15/2/4.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import "UserGiftCell.h"

#define CellW (ScreenWidth - 40)
@implementation UserGiftCell

- (void)awakeFromNib
{
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        NSLog(@"frame width:%f,height:%f",self.frame.size.width,self.frame.size.height);
        self.bgScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        self.bgScroll.pagingEnabled = YES;
        self.bgScroll.backgroundColor = [UIColor clearColor];
        [self addSubview:_bgScroll];
        
        UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
        oneTap.delegate = self;
        oneTap.numberOfTouchesRequired = 1;
        [self addGestureRecognizer:oneTap];
    }
    return self;
}

- (void)initView:(NSArray *)array
{
    int pageCount = (int)array.count / 12;
    self.bgScroll.contentSize = CGSizeMake(pageCount * self.size.width, 120);
    //每行个数
    int totalloc = 4;
//    if (ScreenWidth > 320.f)
//    {
//        totalloc = 5;
//    }
    
    CGFloat appviewW = 50;
    CGFloat appviewH = 50;
    //间隔
//    CGFloat marginX = 15;
    CGFloat marginY = 6;
    
    for (int i = 0; i < array.count;i++)
    {
        int row = i / totalloc;//行号
        
        int loc = i % totalloc;//列号
        
//        CGFloat appviewX = marginX + (marginX + appviewW) * loc;
        CGFloat appviewY = marginY+(marginY + appviewH) * row;
        
        UIView *contentView = [[UIView alloc] init];
        contentView.frame = CGRectMake((CellW/totalloc)*loc, appviewY, CellW/totalloc, appviewH);
        [self addSubview:contentView];
        
        
        NSString *giftUrl  = array[i];
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = i;
        [imageView sd_setImageWithURL:[NSURL URLWithString:giftUrl] placeholderImage:[UIImage imageNamed:@""]];
        
        imageView.frame = CGRectMake(CellW/(totalloc*2)-appviewW/2,0,appviewW, appviewH);
        //[btn addTarget:self action:@selector(scannUserInfo:) forControlEvents:UIControlEventTouchUpInside];
        [contentView addSubview:imageView];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    // 输出点击的view的类名
    NSLog(@"%@", NSStringFromClass([touch.view class]));
    if (_showGiftDetailBlock) {
        self.showGiftDetailBlock();
    }
    // 若为UITableViewCellContentView（即点击了tableViewCell），则不截获Touch事件
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }
    return  YES;
}

- (void)hideKeyBoard
{

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
