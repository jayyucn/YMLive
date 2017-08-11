//
//  MyVideoCell.h
//  XCLive
//
//  Created by 王威 on 15/3/27.
//  Copyright (c) 2015年 www.0x123.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MyVideoCell : UITableViewCell
{


}
@property (nonatomic, strong)UIScrollView *playerScrollView;
@property (nonatomic, strong)UIButton *replyBtn;
@property (nonatomic, strong)UIButton *timeBtn;
//@property (nonatomic, strong)MVPlayerView *playerView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withVideoUrl:(NSString *)url;
@end
