//
//  LCCustomCell.m
//  XCLive
//
//  Created by ztkztk on 14-5-21.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCCustomCell.h"
#import "NSString+ManageFaceURLString.h"
#import "LCMyUser.h"
#import "LCDefines.h"


@implementation LCCustomCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //self.backgroundColor=[UIColor clearColor];
        
        _photoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 75, 75)];
        [self.contentView addSubview:_photoView];
        _photoView.layer.cornerRadius = 6;
        _photoView.layer.masksToBounds = YES;
        
        _videoView = [[UIImageView alloc] initWithImage:UIImageFrom(@"btn_play")];
        _videoView.frame = CGRectMake(63, 63, 20, 20);
        [self.contentView addSubview:_videoView];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_photoView.right+10,9,105 + ScreenWidth - 320,22)];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont boldSystemFontOfSize:16];
        _nameLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_nameLabel];
        //_nameLabel.adjustsFontSizeToFitWidth=YES;
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(210 + (window.size.width - 320),_nameLabel.top,100,16)];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor=[UIColor grayColor];
        _timeLabel.font=[UIFont systemFontOfSize:12];
        _timeLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:_timeLabel];
        _timeLabel.adjustsFontSizeToFitWidth=YES;
        
        _oldLabel= [[LCInsetsLabel alloc] initWithFrame:CGRectMake(_photoView.right+10,_nameLabel.bottom+10,27,12) andInsets:UIEdgeInsetsMake(0,14,0,0)];
        _oldLabel.textAlignment = NSTextAlignmentLeft;
        _oldLabel.textColor=[UIColor whiteColor];
        _oldLabel.font=[UIFont systemFontOfSize:9];
        _oldLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:_oldLabel];
        
        _otherInfo = [[UILabel alloc] initWithFrame:CGRectMake(_oldLabel.right+5,_oldLabel.top,150,16)];
        _otherInfo.textAlignment = NSTextAlignmentLeft;
        _otherInfo.textColor=[UIColor grayColor];
        _otherInfo.font=[UIFont systemFontOfSize:12];
        _otherInfo.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:_otherInfo];
        _otherInfo.centerY=_oldLabel.centerY;
        
            self.creditLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            self.creditLabel.backgroundColor = [UIColor clearColor];
            self.creditLabel.font = [UIFont systemFontOfSize:12.f];
            [self.contentView addSubview:self.creditLabel];
            self.creditLabel.centerY = self.oldLabel.centerY - 8;
        
        _signLabel = [[UILabel alloc] initWithFrame:CGRectMake(_photoView.right+10,_oldLabel.bottom+10,200 + (ScreenWidth - 320),16)];
        _signLabel.textAlignment = NSTextAlignmentLeft;
        _signLabel.textColor=[UIColor grayColor];
        _signLabel.font=[UIFont systemFontOfSize:14];
        _signLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:_signLabel];
        
        self.vipCapImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2.5, 2.5, 32, 30)];
        [self.contentView addSubview:self.vipCapImageView];
        
    }
    return self;
}

-(void)setInfoDic:(NSDictionary *)infoDic
{
    _infoDic = infoDic;
    NSString *imageURL=[NSString faceURLString:infoDic[@"face"]];
        [_photoView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:UIImageFromCache(@"image/globle/placeholder")];
//    ESWeak(_photoView, weakPhotoView);
//    [_photoView setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageURL]]
//                      placeholderImage:[UIImage imageNamed:@"image/globle/placeholder"]
//                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
//                                   ESStrong(weakPhotoView, strongPhotoView);
//                                   strongPhotoView.image = image;
//                               }
//                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
//                                   
//                               }];
    
    int hasVideoValue = [NSStringWith(@"%@",infoDic[@"video"]) intValue];
    if (hasVideoValue == 1)
    {
        _videoView.hidden = NO;
    }
    else
    {
        _videoView.hidden = YES;
    }
    
    NSString *nickname = @"";
    ESStringVal(&nickname, infoDic[@"nickname"]);
    _nameLabel.text=nickname;
    
    
    NSString *distance = @"";
    ESStringVal(&distance, infoDic[@"distance"]);
    
    NSString *time = @"";
    ESStringVal(&time, infoDic[@"time"]);
    
    if (![distance isEqualToString:@""] &&[time isEqualToString:@""])
    {
        _timeLabel.text=[NSString stringWithFormat:@"%@",distance];
    }
    else if ([distance isEqualToString:@""] && ![time isEqualToString:@""])
    {
        _timeLabel.text=[NSString stringWithFormat:@"%@",time];
    }
    else if (![distance isEqualToString:@""] && ![time isEqualToString:@""])
    {
        _timeLabel.text=[NSString stringWithFormat:@"%@ | %@",distance,time];
    }
    else if ([distance isEqualToString:@""] && [time isEqualToString:@""])
    {
        _timeLabel.text = @"";
    }
    
       
    LCSex sex = LCSexMan;
    ESIntegerVal(&sex, infoDic[@"sex"]);
    
    if(sex==LCSexMan)
    {
        _oldLabel.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"image/globle/boy"]];
        
    }
    else
    {
        _oldLabel.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"image/globle/girl"]];
    }
    
    
    NSString *age = @"";
    ESStringVal(&age, infoDic[@"age"]);
    
    _oldLabel.text=age;
        
        NSMutableString *star = [NSMutableString string];
        int credit = 0;
        if (ESIntVal(&credit, infoDic[@"credit"]) && credit > 0) {
                credit = (int)(floorf((float)credit / 100));
                credit = MAX(0, MIN(credit, 5));
                for (int ci = 0; ci < credit; ++ci)
                {
                        [star appendString:@"⭐️"];
                }
        }
        self.creditLabel.text = star;
        [self.creditLabel sizeToFit];
        self.creditLabel.left = _photoView.right+10;
        self.oldLabel.left = self.creditLabel.right + 3;
        
    
    NSString *height = @"";
    ESStringVal(&height, infoDic[@"height"]);
    
    NSString *good = @"";
    ESStringVal(&good, infoDic[@"good"]);
    
    if(good.length > 0) {
        _otherInfo.text=[NSString stringWithFormat:@"%@cm | %@",height,good];
    }
    else {
        _otherInfo.text=[NSString stringWithFormat:@"%@cm",height];
    }
        self.otherInfo.left = self.oldLabel.right + 3;
    
    NSString *sign = @"";
    ESStringVal(&sign, infoDic[@"sign"]);
    _signLabel.text=sign;
        
        int vipLevel;
        if (ESIntVal(&vipLevel, infoDic[@"vip"]) && vipLevel > 0) {
                self.vipCapImageView.hidden = NO;
            self.vipCapImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"image/vip/vip%d", vipLevel]];
        } else {
                self.vipCapImageView.image = nil;
                self.vipCapImageView.hidden = YES;
        }
    
}

- (void)setDataObject:(id)dataObject
{
        if ([dataObject isKindOfClass:[NSDictionary class]]) {
                [self setInfoDic:dataObject];
        }
        [self setNeedsDisplay];
}

- (void)layoutSubviews
{
        [super layoutSubviews];
        
}

@end
