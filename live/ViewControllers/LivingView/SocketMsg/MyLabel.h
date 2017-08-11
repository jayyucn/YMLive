//
//  MyLabel.h
//  qianchuo
//
//  Created by jacklong on 16/3/26.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

typedef enum
{
    VerticalAlignmentTop = 0, // default
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface MyLabel : UILabel
{
@private
    VerticalAlignment _verticalAlignment;
}

@property (nonatomic) VerticalAlignment verticalAlignment;

@end
