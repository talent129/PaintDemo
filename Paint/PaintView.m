//
//  PaintView.m
//  Paint
//
//  Created by mac on 17/5/23.
//  Copyright © 2017年 cai. All rights reserved.
//

#import "PaintView.h"
#import "CBezierPath.h"

@interface PaintView ()

//@property (nonatomic, strong) UIBezierPath *path;

@property (nonatomic, strong) NSMutableArray *paths;

@end

@implementation PaintView

- (void)clearScreen
{
    [self.paths removeAllObjects];
    
    //重绘
    [self setNeedsDisplay];
}

- (void)undo
{
    [self.paths removeLastObject];
    
    [self setNeedsDisplay];
}

- (void)erase
{
    self.lineColor = self.backgroundColor;
}

#pragma mark -
- (NSMutableArray *)paths
{
    if (!_paths) {
        _paths = [NSMutableArray array];
    }
    return _paths;
}

#pragma mark -监听触摸事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //获取当前触摸点
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:touch.view];
    
    //创建一个路径对象
    CBezierPath *path = [CBezierPath bezierPath];
    [path moveToPoint:point];
    
//    self.path = path;
    
    //设置这次绘图线宽
    path.lineWidth = self.lineWidth;
    
    //设置线条颜色
    path.lineColor = self.lineColor;
    
    //路径对象添加数组中
    [self.paths addObject:path];
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint point = [touch locationInView:touch.view];
    
    //当前点添加到路径对象中
    CBezierPath *path = [self.paths lastObject];
    [path addLineToPoint:point];
    
    //重绘
    [self setNeedsDisplay];
}

//重写set方法 立刻进行绘制
- (void)setPickedImage:(UIImage *)pickedImage
{
    _pickedImage = pickedImage;
    
    //创建一个图片的路径
    CBezierPath *path = [CBezierPath bezierPath];
    path.image = pickedImage;
    [self.paths addObject:path];
    
    //重绘
    [self setNeedsDisplay];
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    
//    [self.path stroke];
    for (CBezierPath *path in self.paths) {
        
        //设置线头为圆角
        path.lineCapStyle = kCGLineCapRound;
        
        //设置线连接处为圆角
        path.lineJoinStyle = kCGLineJoinRound;
        
        //设置渲染颜色
//        [self.lineColor set];
        [path.lineColor set];
        
        //渲染
        if (path.image) {
            [path.image drawAtPoint:CGPointZero];
        }else {
            [path stroke];
        }
    }
    
//    [self.pickedImage drawAtPoint:CGPointZero];
    
}

@end
