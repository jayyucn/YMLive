//
//  LCSwitchCell.m
//  XCLive
//
//  Created by ztkztk on 14-4-26.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCSwitchCell.h"
#import "LCDefines.h"


@implementation LCSwitchCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15,0,185,25)];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor=[UIColor blackColor];
        _titleLabel.font=[UIFont systemFontOfSize:16];
        _titleLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:_titleLabel];
        _titleLabel.centerY = 25;
        //_titleLabel.adjustsFontSizeToFitWidth=YES;
        
        _switchView = [[UISwitch alloc] initWithFrame:CGRectMake(0,0,40,20)];
        [_switchView sizeToFit];
        _switchView.left = ScreenWidth - _switchView.width-30;
        _switchView.centerY=_titleLabel.centerY;
        [self.contentView addSubview:_switchView];
        
        [_switchView addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    }
    return self;
}

-(void)switchAction:(id)sender
{
    UISwitch *switchButton = (UISwitch*)sender;
    if(_switchCellBlock)
        _switchCellBlock([switchButton isOn]);
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
