//
//  MyAttentCell.m
//  TaoHuaLive
//
//  Created by kellyke on 2017/6/28.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#import "MyAttentCell.h"

@interface MyAttentCell ()
@property (strong, nonatomic) IBOutlet UILabel *topAttent;

@property (strong, nonatomic) IBOutlet UILabel *bottomAttent;
@property (strong, nonatomic) IBOutlet UILabel *topFans;
@property (strong, nonatomic) IBOutlet UILabel *bottomFans;
@property (strong, nonatomic) IBOutlet UIButton *buttonFans;
@property (strong, nonatomic) IBOutlet UIButton *buttonAttent;

@end

@implementation MyAttentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.buttonFans addTarget:self action:@selector(fansBtnClickTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.buttonFans addTarget:self action:@selector(fansBtnClickUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttonAttent addTarget:self action:@selector(AttentBtnClickTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.buttonAttent addTarget:self action:@selector(AttentBtnClickUpInside:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)fansBtnClickTouchDown:(UIButton *)sender {
    //sender.backgroundColor = [UIColor greenColor];
}
- (void)fansBtnClickUpInside:(UIButton *)sender{
    //sender.backgroundColor = [UIColor whiteColor];
    [self.delegate segmentView:0];
}
-(void)AttentBtnClickTouchDown:(UIButton *)sender {
    //sender.backgroundColor = [UIColor greenColor];
}
- (void)AttentBtnClickUpInside:(UIButton *)sender{
    //sender.backgroundColor = [UIColor whiteColor];
    [self.delegate segmentView:1];
}

-(void)setInfo:(NSString *)attenttop setAttentBootom:(NSString *)attenbttom setFanstop:(NSString *) fanstop setFansBottom:(NSString *)fansbttom{
    self.topFans.text=fanstop;
    self.bottomFans.text=fansbttom;
    [self.bottomFans setTextColor:[UIColor grayColor]];
    self.topAttent.text=attenttop;
    self.bottomAttent.text=attenbttom;
    [self.bottomAttent setTextColor:[UIColor grayColor]];
    self.buttonAttent.titleLabel.text=@"";
    self.buttonFans.titleLabel.text=@"";
    [self.buttonFans setTitle:@"" forState:UIControlStateNormal];
    [self.buttonAttent setTitle:@"" forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
