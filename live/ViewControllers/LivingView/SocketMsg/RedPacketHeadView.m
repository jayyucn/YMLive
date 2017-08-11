//
//  RedPacketHeadView.m
//  qianchuo
//
//  Created by jacklong on 16/3/25.
//  Copyright © 2016年 www.0x123.com. All rights reserved.
//

#import "RedPacketHeadView.h"


@implementation RedPacketHeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CAShapeLayer *shapeLayer = [[CAShapeLayer alloc] init];
        shapeLayer.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        shapeLayer.path = [[UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, 0)
                                                          radius:self.frame.size.height
                                                      startAngle:DEGREES_TO_RADIANS(0)
                                                        endAngle:DEGREES_TO_RADIANS(360)   clockwise:YES] CGPath];
        self.layer.mask = shapeLayer;
    }
    return self;
}

//- (void)drawRect:(CGRect)rect
//{
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    
//    //画笑脸弧线
//    //左
//    CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);//改变画笔颜色
//    CGContextMoveToPoint(context,0, self.frame.size.height - 50);//开始坐标p1
//    //CGContextAddArcToPoint(CGContextRef c, CGFloat x1, CGFloat y1,CGFloat x2, CGFloat y2, CGFloat radius)
//    //x1,y1跟p1形成一条线的坐标p2，x2,y2结束坐标跟p3形成一条线的p3,radius半径,注意, 需要算好半径的长度,
//    CGContextAddArcToPoint(context, self.frame.size.width/2, self.frame.size.height, self.frame.size.width, self.frame.size.height - 50, self.frame.size.width/2);
//    CGContextStrokePath(context);//绘画路径
//    
//    CGContextSetRGBStrokeColor(context,1,0,0,1);
//    CGContextMoveToPoint(context,0, self.frame.size.height - 200);
//    CGContextAddLineToPoint(context,self.frame.size.width/2, self.frame.size.height);
//    CGContextAddLineToPoint(context,self.frame.size.width, self.frame.size.height - 200);
//    
//    CGContextMoveToPoint(context,0, self.frame.size.height - 200);//圆弧的起始点
//    CGContextAddArcToPoint(context,self.frame.size.width/2, self.frame.size.height,self.frame.size.width, self.frame.size.height - 200,self.frame.size.width/2);
//    CGContextStrokePath(context);
//    
//    
////    //右
////    CGContextMoveToPoint(context, 160, 80);//开始坐标p1
////    //CGContextAddArcToPoint(CGContextRef c, CGFloat x1, CGFloat y1,CGFloat x2, CGFloat y2, CGFloat radius)
////    //x1,y1跟p1形成一条线的坐标p2，x2,y2结束坐标跟p3形成一条线的p3,radius半径,注意, 需要算好半径的长度,
////    CGContextAddArcToPoint(context, 168, 68, 176, 80, 10);
////    CGContextStrokePath(context);//绘画路径
////    
////    //右
////    CGContextMoveToPoint(context, 150, 90);//开始坐标p1
////    //CGContextAddArcToPoint(CGContextRef c, CGFloat x1, CGFloat y1,CGFloat x2, CGFloat y2, CGFloat radius)
////    //x1,y1跟p1形成一条线的坐标p2，x2,y2结束坐标跟p3形成一条线的p3,radius半径,注意, 需要算好半径的长度,
////    CGContextAddArcToPoint(context, 158, 102, 166, 90, 10);
////    CGContextStrokePath(context);//绘画路径
//}

@end
