//
//  LCCustomTabBar.m
//  XCLive
//
//  Created by ztkztk on 14-5-12.
//  Copyright (c) 2014年 ztkztk. All rights reserved.
//

#import "LCCustomTabBar.h"


#define PPWindow [UIApplication sharedApplication].keyWindow

@implementation LCCustomTabBar


+(id)customTabBar:(NSArray *)array withTapBarBlock:(LCCustomTapBarBlock)tapBarBlock
{
    
    LCCustomTabBar *tabBar=[[LCCustomTabBar alloc] initWithFrame:CGRectMake(0,0,PPWindow.size.width,45)];
    tabBar.tapBarBlock=tapBarBlock;
    tabBar.items=array;
    //[tabBar initTabBar:array];
    return tabBar;

}

+(id)customTabBarWithTapBarBlock:(LCCustomTapBarBlock)tapBarBlock
{
    LCCustomTabBar *tabBar=[[LCCustomTabBar alloc] initWithFrame:CGRectMake(0,0,PPWindow.size.width,45)];
    tabBar.tapBarBlock=tapBarBlock;
    return tabBar;
    
}
-(void)setItems:(NSArray *)items
{
    _items=items;
    [self initTabBar:items];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

-(void)initTabBar:(NSArray *)array
{
    
    [self removeAllSubviews];
    NSUInteger num=[array count];
    float width = PPWindow.size.width / num;
    for(int i=0;i<num;i++)
    {
        
        NSDictionary *dic=array[i];
        UIButton *tabBarBtn= [UIButton buttonWithType:UIButtonTypeCustom];
        tabBarBtn.frame=CGRectMake(width*i,0,width, 45);
        
        UIImage *iconImage=[UIImage imageNamed:dic[@"icon"]];
        [tabBarBtn setImage:iconImage
                      forState:UIControlStateNormal];
        tabBarBtn.imageEdgeInsets=UIEdgeInsetsMake(0,(width-20)/2,15,(width-20)/2);
        tabBarBtn.backgroundColor=[UIColor clearColor];
        
        tabBarBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
        
        [tabBarBtn setTitle:dic[@"title"] forState:UIControlStateNormal];
        [tabBarBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        tabBarBtn.titleLabel.font = [UIFont systemFontOfSize: 13.0];
        tabBarBtn.titleEdgeInsets = UIEdgeInsetsMake(25,-iconImage.size.width,0,0);

        [self addSubview:tabBarBtn];
        
        
        tabBarBtn.tag=1000+i;
        
        
        [tabBarBtn addTarget:self
                      action:@selector(tap:)
               forControlEvents:UIControlEventTouchUpInside];

        
    }

}


-(void)showfollow
{
    
    int itemTag = 0;
    for(int i=0;i<[_items count];i++)
    {
        if([_items[i][@"title"] isEqualToString:@"关注"]||[_items[i][@"title"] isEqualToString:@"取消关注"])
        {
            itemTag=i;
            break;
        }
    }
    UIImage *iconImage=[UIImage imageNamed:@"image/globle/InfoToolBarUnFollowed"];
    [self reflashBtn:itemTag title:@"关注" icon:iconImage];
    
   // UIButton *btn=(UIButton *)[self viewWithTag:1000+itemTag];
    
   // [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
}

-(void)showDeleteFollow
{
    int itemTag = 0;
    for(int i=0;i<[_items count];i++)
    {
        if([_items[i][@"title"] isEqualToString:@"关注"]||[_items[i][@"title"] isEqualToString:@"取消关注"])
        {
            itemTag=i;
            break;
        }
    }

    UIImage *iconImage=[UIImage imageNamed:@"image/globle/FocusToolBarLikeIcon"];
    [self reflashBtn:itemTag title:@"取消关注" icon:iconImage];
    
   // UIButton *btn=(UIButton *)[self viewWithTag:1000+itemTag];
    
    //[btn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
}

-(void)reflashBtn:(int)tag title:(NSString *)title icon:(UIImage *)iconImage
{
    UIButton *btn=(UIButton *)[self viewWithTag:1000+tag];
    
    [btn setImage:iconImage
         forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    
}

-(void)tap:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    
    if(_tapBarBlock)
        _tapBarBlock(btn.titleLabel.text);
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    CGContextFillRect(context, rect);
   
    
    CGContextSetFillColorWithColor(context, [UIColor grayColor].CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, rect.size.width , 1));

}


@end
