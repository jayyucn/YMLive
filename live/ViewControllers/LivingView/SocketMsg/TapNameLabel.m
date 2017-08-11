//
//  TapNameLabel.m
//  NewMom
//
//  Created by apple on 15/2/7.
//  Copyright (c) 2015年 peter. All rights reserved.
//

#import "TapNameLabel.h"
@interface TapNameLabel() {
//    开始点击时间
    NSTimeInterval oldTime;
}
@end

@implementation TapNameLabel

- (void)awakeFromNib
{
    _textContainer = [[NSTextContainer alloc] initWithSize:self.frame.size];
    _textContainer.lineFragmentPadding = 0;
    _textContainer.maximumNumberOfLines = 0;
    _textContainer.lineBreakMode = self.lineBreakMode;
    
    _textStorage = [[NSTextStorage alloc] init];
    
    _layoutManager = [[NSLayoutManager alloc] init];
//    _textContainer.layoutManager = _layoutManager;
    [_textStorage addLayoutManager:_layoutManager];
    [_layoutManager addTextContainer:_textContainer];
    [_layoutManager setTextStorage:_textStorage];
    
    self.userInteractionEnabled = YES;
    
    _tapNameIndex = -1;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        _textContainer = [[NSTextContainer alloc] initWithSize:frame.size];
        _textContainer.lineFragmentPadding = 0;
        _textContainer.maximumNumberOfLines = 0;
        _textContainer.lineBreakMode = self.lineBreakMode;
        
        _textStorage = [[NSTextStorage alloc] init];
        
        _layoutManager = [[NSLayoutManager alloc] init];
//        _textContainer.layoutManager = _layoutManager;
        [_textStorage addLayoutManager:_layoutManager];
        [_layoutManager addTextContainer:_textContainer];
        [_layoutManager setTextStorage:_textStorage];
        
        self.userInteractionEnabled = YES;
        
        _tapNameIndex = -1;
    }
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    _textContainer.size = frame.size;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_rangeLength <= 0) {
        return;
    }
    
    
    [_textStorage setAttributedString:self.attributedText];
    _textContainer.size = self.frame.size;
    UITouch *touch = [touches anyObject];
    NSLog(@"%f",[touch locationInView:self].x);
    NSUInteger characterIdx = [_layoutManager characterIndexForPoint:[touch locationInView:self]
                                                     inTextContainer:_textContainer
                            fractionOfDistanceBetweenInsertionPoints:NULL];
    //问题在这
    NSLog(@"characterindex: %ld",(unsigned long)characterIdx);
    //characterIdx = 1;
    for (int i = 0; i < _rangeLength; i++)
    {
        NSRange range = _nameRanges[i];
        if (NSLocationInRange(characterIdx, range))
        {
            _tapNameIndex = i;
            break;
        }
    }
    NSLog(@"name: %ld", (long)_tapNameIndex);
    if (_tapNameIndex > -1 && _tapNameIndex < _rangeLength)
    {
        if (!_hilightColor) {
            _hilightColor = [UIColor clearColor];
        }
        NSMutableAttributedString *muattr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        [muattr addAttributes:@{NSBackgroundColorAttributeName:_hilightColor} range:_nameRanges[_tapNameIndex]];
        self.attributedText = muattr;
        [self setNeedsDisplay];
        
        oldTime = [[NSDate date] timeIntervalSince1970]*1000;
        NSLog(@"touchesBegan time:%f",oldTime);
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_rangeLength <= 0) {
        return;
    }
    
    if (_tapNameIndex > -1 && _tapNameIndex < _rangeLength)
    {
        NSMutableAttributedString *muattr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        //[muattr addAttributes:@{NSBackgroundColorAttributeName:[UIColor redColor]} range:_nameRanges[_tapNameIndex]];
        [muattr removeAttribute:NSBackgroundColorAttributeName range:_nameRanges[_tapNameIndex]];
        self.attributedText = muattr;
        [self setNeedsDisplay];
        
        _tapNameIndex = -1;
        
        oldTime = [[NSDate date] timeIntervalSince1970]*1000;
        NSLog(@"touchesCancelled time:%f",oldTime);
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_rangeLength <= 0) {
        return;
    }
    
    if (_tapNameIndex > -1 && _tapNameIndex < _rangeLength)
    {
        NSMutableAttributedString *muattr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
        //[muattr addAttributes:@{NSBackgroundColorAttributeName:[UIColor redColor]} range:_nameRanges[_tapNameIndex]];
        [muattr removeAttribute:NSBackgroundColorAttributeName range:_nameRanges[_tapNameIndex]];
        self.attributedText = muattr;
        [self setNeedsDisplay];
        
        
        NSTimeInterval newTime = [[NSDate date] timeIntervalSince1970]*1000;
        NSLog(@"touchesEnded time:%f count:%f",newTime,(newTime - oldTime) );
        
        if (newTime - oldTime > 500) {
            NSLog(@"touchesEnded onlong click ");
            if ([self.delegate respondsToSelector:@selector(longTapNameLabel:didClickNameAtIndex:withRange:withMsgDict:)])
            {
                [_delegate longTapNameLabel:self
                    didClickNameAtIndex:_tapNameIndex
                              withRange:_nameRanges[_tapNameIndex]
                            withMsgDict:_showMsgDict];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(tapNameLabel:didClickNameAtIndex:withRange:withMsgDict:)])
            {
                [_delegate tapNameLabel:self
                    didClickNameAtIndex:_tapNameIndex
                              withRange:_nameRanges[_tapNameIndex]
                            withMsgDict:_showMsgDict];
            }
        }
        
        _tapNameIndex = -1;
    }
}

- (void)setNameRanges:(NSRange *)ranges withLength:(NSInteger)length
{
    _rangeLength = length;
    if (!ranges) {
        return;
    }
    
    for (int i = 0; i < length; i++)
    {
        _nameRanges[i] = ranges[i];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
