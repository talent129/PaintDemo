//
//  CPhotoView.h
//  Paint
//
//  Created by mac on 17/5/24.
//  Copyright © 2017年 cai. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CPhotoView;

@protocol CPhotoViewDelegate <NSObject>

- (void)photoView:(CPhotoView *)photoView withImage:(UIImage *)image;

@end

@interface CPhotoView : UIView

@property (nonatomic, strong) UIImage *photo;

@property (nonatomic, weak) id<CPhotoViewDelegate> delegate;

@end
