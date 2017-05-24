//
//  PaintView.h
//  Paint
//
//  Created by mac on 17/5/23.
//  Copyright © 2017年 cai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PaintView : UIView

//绘图线宽
@property (nonatomic, assign) CGFloat lineWidth;

//当前线条颜色
@property (nonatomic, strong) UIColor *lineColor;

//用来保存插入的照片
@property (nonatomic, strong) UIImage *pickedImage;

//清屏
- (void)clearScreen;

//回退
- (void)undo;

//擦除
- (void)erase;

@end
