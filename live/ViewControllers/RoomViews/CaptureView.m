//
//  CaptureView.m
//  TaoHuaLive
//
//  Created by kellyke on 2017/7/11.
//  Copyright © 2017年 上海七夕. All rights reserved.
//

#import "CaptureView.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import "MBProgressHUD+Additions.h"
static CGFloat recordCount=0;

@interface CaptureView () {
 
    int isstart;
    NSTimer *timer;
    
}
@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, strong) CAShapeLayer *progressLayer;

@property (nonatomic, strong) UIButton *closeBtn;

@property (nonatomic, strong) UIButton *startBtn;

@property (nonatomic, copy) BeginBlock beginBlock;
@property (nonatomic, copy) EndBlock endBlock;
@property (nonatomic, copy) CancelBlock cancelBlock;

@end

@implementation CaptureView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        isstart=0;
        self.backgroundColor=[UIColor clearColor];
//        self.closeBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-50, self.bounds.size.height-50, 50, 50)];
//        [self.closeBtn setImage:[UIImage imageNamed:@"adClose"] forState:UIControlStateNormal];
//        [self.closeBtn addTarget:self action:@selector(onCloseAction:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:self.closeBtn];
        
        self.startBtn=[[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width/2, self.bounds.size.height/2, 50, 50)];
        self.startBtn.center=CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
        [self.startBtn setImage:[UIImage imageNamed:@"image/liveroom/startcapture"] forState:UIControlStateNormal];
        [self.startBtn addTarget:self action:@selector(onStartAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.startBtn];
        
    }
    return self;
}
- (void)reset
{
    [self stopDrawingProcess];
}

-(void)onCloseAction:(UIButton *)sender
{
    
    self.cancelBlock(sender);
//    [self.delegate recordingDidCancelled];
}

-(void)onStartAction:(UIButton *)sender
{
    
    if(!isstart){
//        [self.delegate onStartAction:isstart];
        self.beginBlock(sender);
        isstart=!isstart;
        //dispatch_async(dispatch_get_global_queue(0, 0), ^{
            timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(drawProgress) userInfo:nil repeats:true];
        
        
    }else {
        if(recordCount<50) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
            
            // Set the text mode to show only text.
            hud.mode = MBProgressHUDModeText;
            hud.labelText = NSLocalizedString(@"请录制至少五秒!", @"HUD message title");
            // Move to bottm center.
            //hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
            
            //[hud hideAnimated:YES afterDelay:3.f];
            [hud hide:YES afterDelay:.5f];
            return ;
        }
//        [self.delegate onStartAction:isstart];
        self.endBlock(sender);
        [self stopDrawingProcess];
        
    }
}

- (void)stopDrawingProcess
{
    _progress=0;
    recordCount=0;
    _progressLayer.opacity = 0;
    [self setNeedsDisplay];
    [timer invalidate];
    isstart=!isstart;
}

- (void)recordVideoWhenBegin:(BeginBlock)begin end:(EndBlock)end andCancel:(CancelBlock)cancel
{
    self.beginBlock = begin;
    self.endBlock = end;
    self.cancelBlock = cancel;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 
     CGPoint center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
     CGFloat radius = 40.0f;
     CGFloat startA = - M_PI_2;  //设置进度条起点位置
     CGFloat endA = -M_PI_2 + M_PI * 2 * _progress;  //设置进度条终点位置
     
     //获取环形路径（画一个圆形，填充色透明，设置线框宽度为10，这样就获得了一个环形）
     _progressLayer = [CAShapeLayer layer];//创建一个track shape layer
     _progressLayer.frame = self.bounds;
     _progressLayer.fillColor = [[UIColor clearColor] CGColor];  //填充色为无色
     _progressLayer.strokeColor = [[UIColor redColor] CGColor]; //指定path的渲染颜色,这里可以设置任意不透明颜色
     _progressLayer.opacity = 1; //背景颜色的透明度
     _progressLayer.lineCap = kCALineCapRound;//指定线的边缘是圆的
     _progressLayer.lineWidth = 5;//线的宽度
     UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:startA endAngle:endA clockwise:YES];//上面说明过了用来构建圆形
     _progressLayer.path =[path CGPath]; //把path传递給layer，然后layer会处理相应的渲染，整个逻辑和CoreGraph是一致的。
     [self.layer addSublayer:_progressLayer];
     //生成渐变色
     CALayer *gradientLayer = [CALayer layer];
     
     //左侧渐变色
     CAGradientLayer *leftLayer = [CAGradientLayer layer];
     leftLayer.frame = CGRectMake(0, 0, self.bounds.size.width / 2, self.bounds.size.height);    // 分段设置渐变色
     leftLayer.locations = @[@0.3, @0.9, @1];
     leftLayer.colors = @[(id)[UIColor yellowColor].CGColor, (id)[UIColor greenColor].CGColor];
     [gradientLayer addSublayer:leftLayer];
     
     //右侧渐变色
     CAGradientLayer *rightLayer = [CAGradientLayer layer];
     rightLayer.frame = CGRectMake(self.bounds.size.width / 2, 0, self.bounds.size.width / 2, self.bounds.size.height);
     rightLayer.locations = @[@0.3, @0.9, @1];
     rightLayer.colors = @[(id)[UIColor yellowColor].CGColor, (id)[UIColor redColor].CGColor];
     [gradientLayer addSublayer:rightLayer];
     
     [gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
     [self.layer addSublayer:gradientLayer];
 
}

- (void)drawProgress
{
    
    _progress = recordCount/600;
    
    _progressLayer.opacity = 0;
    [self setNeedsDisplay];
    recordCount++;
    if(recordCount==600) {
        [self stopDrawingProcess];
        _progress=0;
        recordCount=0;
        _progressLayer.opacity = 0;
        [self setNeedsDisplay];
    }
    
}

- (void)dealloc
{
    [timer invalidate];
    timer = nil;
}

@end
