//
//  MyInfoCell.m
//  TaoHuaLive
//
//  Created by kellyke on 2017/6/29.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#import "MyInfoCell.h"
#import "LCMyUser.h"
@interface MyInfoCell ()
@property (strong, nonatomic) IBOutlet UIImageView *portraitView;
@property (strong, nonatomic) IBOutlet UILabel *myNameLb;
@property (strong, nonatomic) IBOutlet UILabel *myIDLb;
@property (strong, nonatomic) IBOutlet UILabel *mySignatureLb;
@property (strong, nonatomic) IBOutlet UILabel *myDiamondLb;
@property (strong, nonatomic) IBOutlet UIImageView *mySexImg;
@property (strong, nonatomic) IBOutlet UIImageView *myGradeImgView;
@property (strong, nonatomic) IBOutlet UIButton *editorBtn;
@property (strong, nonatomic) IBOutlet UILabel *contributionLb;
@property (strong, nonatomic) IBOutlet UIButton *arrowBtn;



@end
@implementation MyInfoCell

- (void)configCellWithModel:(MyInfoModel *)model{
    
    [self.portraitView sd_setImageWithURL:[NSURL URLWithString:[LCMyUser mine].faceURL] placeholderImage:[UIImage imageNamed:@"image/globle/man"]];
    self.myIDLb.text = [NSString stringWithFormat:@"ID:  %ld", (long)model.uid];
    self.myNameLb.text = [LCMyUser mine].nickname;
    self.mySignatureLb.text = [LCMyUser mine].signature;
    [self showSendDiamondWith:model.send_diamond];
    if (1 == [LCMyUser mine].sex) {
        [self.mySexImg setImage:[UIImage imageNamed:@"global_male"]];
    }else {
        [self.mySexImg setImage:[UIImage imageNamed:@"global_female"]];
    }
    [self gradeWithNum:model.grade];
    [self.editorBtn setImage:[UIImage imageNamed:@"image/liveroom/home_edit"] forState:UIControlStateNormal];
}

- (void)gradeWithNum:(int)grade {
    NSString *imgStr = nil;
    if (grade > 0 && grade <= 13) {
        imgStr = [NSString stringWithFormat:@"image/yonghu/user_grade_%d", grade];
    }else if (grade == 0) {
        imgStr = @"image/yonghu/user_grade_1";
    }else {
        imgStr = @"image/yonghu/user_grade_office";
    }
    [self.myGradeImgView setImage:[UIImage imageNamed:imgStr]];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.arrowBtn setImage:[UIImage imageNamed:@"image/liveroom/room_money_check_n.png"] forState:UIControlStateNormal];
    
    
}
- (void)layoutSubviews {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect {
    
    
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.portraitView.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:self.portraitView.bounds.size];
//    
//    CAShapeLayer *maskLayer = [[CAShapeLayer alloc]init];    //设置大小
//    
////    maskLayer.borderWidth = 2.f;
////    maskLayer.borderColor = [UIColor lightGrayColor].CGColor;
//    maskLayer.frame = self.portraitView.bounds;    //设置图形样子
//    
//    maskLayer.path = maskPath.CGPath;
//    
//    self.portraitView.layer.mask = maskLayer;
    //  把头像设置成圆形
    self.portraitView.layer.cornerRadius=self.portraitView.frame.size.width/2;//裁成圆角
    self.portraitView.layer.masksToBounds=YES;//隐藏裁剪掉的部分
    //  给头像加一个圆形边框
    self.portraitView.layer.borderWidth = 3.0f;//宽度
    self.portraitView.layer.borderColor = [UIColor lightGrayColor].CGColor;//颜色
}
- (IBAction)showEditUserInfo:(id)sender {
    [self.delegate showEditUserInfo];
}
- (IBAction)showRankDetailAction:(id)sender {
    [self.delegate showRankDetailAction];
}


- (void) showSendDiamondWith:(int)diamondNum
{
    NSString *sendDiamondText = [NSString stringWithFormat:@"%@ %d d", ESLocalizedString(@"送出"), diamondNum];
    NSMutableAttributedString * mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:sendDiamondText];
    
    NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
    UIImage *image = [UIImage imageNamed:@"image/liveroom/me_myaccount_reddiamond"];
    
    textAttachment.image = image;
    //    textAttachment.image = [UIImage imageWithImage:image scaleToSize:CGSizeMake(image.size.width, image.size.height)];
    textAttachment.bounds = CGRectMake(0, -3, image.size.width, image.size.height);
    
    NSAttributedString *iconAttributedString = [NSAttributedString attributedStringWithAttachment:textAttachment];
    
    [mutableAttributedString replaceCharactersInRange:NSMakeRange(sendDiamondText.length-1, 1) withAttributedString:iconAttributedString];
    
    self.myDiamondLb.attributedText = mutableAttributedString;
}



@end
