//
//  CPhotoView.m
//  Paint
//
//  Created by mac on 17/5/24.
//  Copyright © 2017年 cai. All rights reserved.
//

#import "CPhotoView.h"

@interface CPhotoView ()<UIGestureRecognizerDelegate>//为了可以同时捏合和旋转

@property (nonatomic, strong) UIImageView *imgView;

@end

@implementation CPhotoView

#pragma mark -
- (UIImageView *)imgView
{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        
        _imgView.userInteractionEnabled = YES;//允许交互
        _imgView.multipleTouchEnabled = YES;//多点交互
        [self addSubview:_imgView];
        
        //为图片添加手势
        //1.捏合手势
        UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchAction:)];
        pinch.delegate = self;//为了可以同时捏合和旋转
        [_imgView addGestureRecognizer:pinch];
        
        //2.添加旋转手势
        UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotationAction:)];
        rotation.delegate = self;//为了可以同时捏合和旋转
        [_imgView addGestureRecognizer:rotation];
        
        //3.添加拖拽手势
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [_imgView addGestureRecognizer:pan];
        
        //4.添加长按手势
        UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longGestureAction:)];
        [_imgView addGestureRecognizer:longGesture];
        
    }
    return _imgView;
}

#pragma mark -捏合手势监听方法
- (void)pinchAction:(UIPinchGestureRecognizer *)recognizer
{
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1;
}

- (void)rotationAction:(UIRotationGestureRecognizer *)recognizer
{
    recognizer.view.transform = CGAffineTransformRotate(recognizer.view.transform, recognizer.rotation);
    recognizer.rotation = 0;
}

- (void)panAction:(UIPanGestureRecognizer *)recognizer
{
    CGPoint offset = [recognizer translationInView:recognizer.view];
    recognizer.view.transform = CGAffineTransformTranslate(recognizer.view.transform, offset.x, offset.y);
    
    [recognizer setTranslation:CGPointZero inView:recognizer.view];
}

- (void)longGestureAction:(UILongPressGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [UIView animateWithDuration:0.5 animations:^{
            recognizer.view.alpha = 0.4;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                recognizer.view.alpha = 1;
            } completion:^(BOOL finished) {
                NSLog(@"图片框晃操作");
                
                //把当前"透明view"的效果渲染到一个图片的图形上下文中
                UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0);
                
                CGContextRef ref = UIGraphicsGetCurrentContext();
                
                [self.layer renderInContext:ref];
                UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
                UIGraphicsEndImageContext();
                
                //调用代理
                if ([self.delegate respondsToSelector:@selector(photoView:withImage:)]) {
                    [self.delegate photoView:self withImage:image];
                }
                
            }];
        }];
    }
}

#pragma mark -手势的代理方法
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)setPhoto:(UIImage *)photo
{
    _photo = photo;
    
    //将图片设置给imgView
    self.imgView.image = photo;
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat w = self.imgView.image.size.width;
    CGFloat h = self.imgView.image.size.height;
    
    self.imgView.bounds = CGRectMake(0, 0, w, h);
    self.imgView.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    
    //错误
//    self.imgView.center = self.center;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
