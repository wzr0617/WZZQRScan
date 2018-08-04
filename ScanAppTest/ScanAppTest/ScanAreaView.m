//
//  ScanAreaView.m
//  YokosoTablet
//
//  Created by wzr on 2015/10/25.
//  Copyright (c) 2015年 icce. All rights reserved.
//

#import "ScanAreaView.h"
#define kStartPointx 2
#define kStartPointy 2
#define kCornerWidth  70
#define kCornerHeight  40
@implementation ScanAreaView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //CGContextRefを取得
    CGContextRef
    context = UIGraphicsGetCurrentContext();
    
    //drow 仕様
    CGContextSetLineCap(context,
                        kCGLineCapSquare);
    //line width
    CGContextSetLineWidth(context,
                          2.0);
    //color
    CGFloat height= self.frame.size.height;
    CGFloat width= self.frame.size.width;
    CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
    //
    CGContextBeginPath(context);
    //Corner1
    CGContextBeginPath(context);
    CGContextMoveToPoint(context,
                         kStartPointx, kStartPointy+kCornerHeight);
    CGContextAddLineToPoint(context,
                            kStartPointx, kStartPointy);
    CGContextAddLineToPoint(context,
                            kStartPointx+kCornerWidth, kStartPointy);
    //Corner2
    CGContextMoveToPoint(context,
                         width-kStartPointx, kStartPointy+kCornerHeight);
    CGContextAddLineToPoint(context,
                            width-kStartPointx, kStartPointy);
    CGContextAddLineToPoint(context,
                            width-(kStartPointx+kCornerWidth), kStartPointy);
    //Corner3
    CGContextMoveToPoint(context,
                         kStartPointx+kCornerWidth,height- kStartPointy);
    CGContextAddLineToPoint(context,
                            kStartPointx, height - kStartPointy);
    CGContextAddLineToPoint(context,
                            kStartPointx, height - (kStartPointy+kCornerHeight));
    //Corner4
    
    CGContextMoveToPoint(context,
                         width-kCornerWidth-kStartPointx, height- kStartPointy);
    CGContextAddLineToPoint(context,
                            width-kStartPointx, height - kStartPointy);
    CGContextAddLineToPoint(context,
                            width-kStartPointx, height - (kStartPointy+ kCornerHeight));
    CGContextStrokePath(context);
}

@end
