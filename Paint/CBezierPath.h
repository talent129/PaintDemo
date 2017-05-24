//
//  CBezierPath.h
//  Paint
//
//  Created by mac on 17/5/23.
//  Copyright © 2017年 cai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBezierPath : UIBezierPath

@property (nonatomic, strong) UIColor *lineColor;

//保存将要绘制的图片
@property (nonatomic, strong) UIImage *image;

@end
