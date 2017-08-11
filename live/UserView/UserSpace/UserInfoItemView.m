//
//  UserInfoItemView.m
//  qianchuo
//
//  Created by jacklong on 16/8/4.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "UserInfoItemView.h"

@interface UserInfoItemView()
{
    UILabel     *typeLabel;
    UILabel     *infoLabel;
}

@end

@implementation UserInfoItemView

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 80, self.frame.size.height)];
        typeLabel.textColor = [UIColor grayColor];
        typeLabel.font = [UIFont systemFontOfSize:15.f];
        [self addSubview:typeLabel];
        
        infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(typeLabel.right, 0, self.frame.size.width - typeLabel.right, self.frame.size.height)];
        infoLabel.textColor = [UIColor lightGrayColor];
        infoLabel.font = [UIFont systemFontOfSize:13.f];
        [self addSubview:infoLabel];
    }
    return self;
}

- (void) setUserInfoDict:(NSDictionary *)userInfoDict
{
    NSString *name = userInfoDict[@"name"];
    typeLabel.text = name;
    
    if ([name isEqualToString:ESLocalizedString(@"ID号")]) {
        infoLabel.text = [NSString stringWithFormat:@"%d",[userInfoDict[@"content"] intValue]];
        infoLabel.textColor = [UIColor lightGrayColor];
    } else if ([name isEqualToString:ESLocalizedString(@"靓号")]) {
        NSString *goodID = userInfoDict[@"content"];
        NSMutableAttributedString *mutableAttributedString = nil;
        NSString *goodIdInfoStr = [NSString stringWithFormat:@"d %@",goodID];
        mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:goodIdInfoStr];
        
        UIImage *goodIdImage = [UIImage imageNamed:@"image/liveroom/user_goodid"];
        
        NSTextAttachment *goodIdAttachment = [[NSTextAttachment alloc] init];
        goodIdAttachment.image = goodIdImage;
        goodIdAttachment.bounds = CGRectMake(0, -2, goodIdImage.size.width, goodIdImage.size.height);
        NSAttributedString *goodIdAttributedString = [NSAttributedString attributedStringWithAttachment:goodIdAttachment];
        [mutableAttributedString replaceCharactersInRange:NSMakeRange(0, 1) withAttributedString:goodIdAttributedString];
        infoLabel.attributedText = mutableAttributedString;
        infoLabel.textColor = ColorPink;
    } else if ([name isEqualToString:ESLocalizedString(@"认证")]) {
        NSString *tag = userInfoDict[@"content"];
        NSMutableAttributedString *mutableAttributedString = nil;
        NSString *certInfoStr =  [NSString stringWithFormat:@"d %@:%@",ESLocalizedString(@"认证"),tag];
        mutableAttributedString = [[NSMutableAttributedString alloc] initWithString:certInfoStr];
        
        UIImage *certImage = [UIImage imageNamed:@"image/liveroom/me_renzheng"];
        
        NSTextAttachment *certAttachment = [[NSTextAttachment alloc] init];
        certAttachment.image = [UIImage imageWithImage:certImage scaleToSize:CGSizeMake(certImage.size.width/2, certImage.size.height/2-2)];
        certAttachment.bounds = CGRectMake(0, -2, certImage.size.width/2, certImage.size.height/2-2);
        NSAttributedString *certAttributedString = [NSAttributedString attributedStringWithAttachment:certAttachment];
        [mutableAttributedString replaceCharactersInRange:NSMakeRange(0, 1) withAttributedString:certAttributedString];
        infoLabel.attributedText = mutableAttributedString;
        infoLabel.textColor = ColorPink;
    } else if ([name isEqualToString:ESLocalizedString(@"家乡")]) {
        infoLabel.text = userInfoDict[@"content"];
        infoLabel.textColor = [UIColor lightGrayColor];
    } else if ([name isEqualToString:ESLocalizedString(@"个性签名")]) {
        infoLabel.text = userInfoDict[@"content"];
        infoLabel.textColor = [UIColor lightGrayColor];
    }
}
@end
