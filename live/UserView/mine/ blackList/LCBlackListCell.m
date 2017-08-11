//
//  LCBlackListCell.m
//  XCLive
//
//  Created by ztkztk on 14-5-13.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCBlackListCell.h"

#import "LCBlackListManager.h"

@implementation LCBlackListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.backgroundColor=[UIColor clearColor];
        
        _photoView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 9, 60, 60)];
        [self.contentView addSubview:_photoView];
        _photoView.layer.cornerRadius = 3;
        _photoView.layer.masksToBounds = YES;
        
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_photoView.right+3,16,150,20)];
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor=[UIColor blackColor];
        _nameLabel.font=[UIFont systemFontOfSize:15];
        _nameLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:_nameLabel];
        
        //_sexView = [[UIImageView alloc] initWithFrame:CGRectMake(_photoView.right+3, _nameLabel.bottom+5, 15, 15)];
        //[self.contentView addSubview:_sexView];
        
        
        _IDLabel = [[UILabel alloc] initWithFrame:CGRectMake(_photoView.right+3,_nameLabel.bottom+10,150,20)];
        _IDLabel.textAlignment = NSTextAlignmentLeft;
        _IDLabel.textColor=[UIColor grayColor];
        _IDLabel.font=[UIFont systemFontOfSize:15];
        _IDLabel.backgroundColor =[UIColor clearColor];
        [self.contentView addSubview:_IDLabel];
        
        ESButton *deleteBtn= [ESButton buttonWithTitle:@"解除黑名单" buttonColor:ESButtonColorRed];
        deleteBtn.buttonColor = [UIColor redColor];//ESButtonColorRed;
        deleteBtn.frame=CGRectMake(220,20,80,30);
        [deleteBtn setTitleColor:[UIColor whiteColor]
                        forState:UIControlStateNormal];
        
        deleteBtn.titleLabel.font = [UIFont systemFontOfSize: 14.0];
        
        [deleteBtn addTarget:self
                      action:@selector(deleteBlack)
            forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:deleteBtn];




    }
    return self;
}


-(void)deleteBlack
{
    ESWeakSelf;
    [LCBlackListManager deleteBlack:_blackDic[@"uid"]
                          withBlock:^(BOOL success){
                              ESStrongSelf;
        if(success)
        {
            _self.deleteBlackSuccess();
        }
    }];
}

-(void)showInfo:(NSDictionary *)dic
{
    _blackDic=dic;
    NSString *imageURL=[NSString faceURLString:dic[@"face"]];
        [_photoView sd_setImageWithURL:[NSURL URLWithString:imageURL] placeholderImage:UIImageFromCache(@"image/globle/placeholder")];
        
//    [_photoView setImageWithURLRequest:[[NSURLRequest alloc] initWithURL:[NSURL URLWithString:imageURL]]
//                      placeholderImage:[UIImage imageNamed:@"image/globle/placeholder"]
//                               success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image){
//                                   ESStrong(weakPhotoView, strongPhotoView);
//                                   strongPhotoView.image = image;
//                                   
//                                   
//                               }
//                               failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error){
//                                   
//                               }];
    
    NSString *nickname = @"";
    ESStringVal(&nickname, dic[@"nickname"]);
    _nameLabel.text=nickname;
    
    NSString *uid = @"";
    ESStringVal(&uid, dic[@"uid"]);
    _IDLabel.text=[NSString stringWithFormat:@"ID:%@",uid];

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
