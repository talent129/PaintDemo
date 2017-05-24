//
//  ViewController.m
//  Paint
//
//  Created by mac on 17/5/23.
//  Copyright © 2017年 cai. All rights reserved.
//

#import "ViewController.h"
#import "PaintView.h"
#import "CPhotoView.h"

#define SCREEN_Width    ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_Height   ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate, CPhotoViewDelegate>

@property (nonatomic, strong) PaintView *paintView;

@property (nonatomic, strong) UIButton *btn1;

@property (nonatomic, strong) UIButton *btn2;

@property (nonatomic, strong) UIButton *btn3;

@property (nonatomic, strong) UIButton *btn4;

@property (nonatomic, strong) UIButton *btn5;

@property (nonatomic, strong) UIButton *redBtn;

@property (nonatomic, strong) UIButton *blueBtn;

@property (nonatomic, strong) UIButton *yellowBtn;

@property (nonatomic, strong) UISlider *slider;

@property (nonatomic, weak) CPhotoView *photoView;

@end

@implementation ViewController

#pragma mark -
- (PaintView *)paintView
{
    if (!_paintView) {
        _paintView = [[PaintView alloc] initWithFrame:CGRectMake(0, 20 + 49, SCREEN_Width, SCREEN_Height - 69 - 60)];
        _paintView.backgroundColor = [UIColor whiteColor];
    }
    return _paintView;
}

- (UIButton *)btn1
{
    if (!_btn1) {
        _btn1 = [self createUIButtonWithTitle:@"清屏" withTarget:@selector(btn1Action) withFrame:CGRectMake(0, 0, 60, 49)];
    }
    return _btn1;
}

- (UIButton *)btn2
{
    if (!_btn2) {
        _btn2 = [self createUIButtonWithTitle:@"回退" withTarget:@selector(btn2Action) withFrame:CGRectMake(60, 0, 60, 49)];
    }
    return _btn2;
}

- (UIButton *)btn3
{
    if (!_btn3) {
        _btn3 = [self createUIButtonWithTitle:@"橡皮擦" withTarget:@selector(btn3Action) withFrame:CGRectMake(120, 0, 60, 49)];
    }
    return _btn3;
}

- (UIButton *)btn4
{
    if (!_btn4) {
        _btn4 = [self createUIButtonWithTitle:@"照片" withTarget:@selector(btn4Action) withFrame:CGRectMake(180, 0, 60, 49)];
    }
    return _btn4;
}

- (UIButton *)btn5
{
    if (!_btn5) {
        _btn5 = [self createUIButtonWithTitle:@"保存" withTarget:@selector(btn5Action) withFrame:CGRectMake(SCREEN_Width - 60, 0, 60, 49)];
    }
    return _btn5;
}

- (UIButton *)redBtn
{
    if (!_redBtn) {
        _redBtn = [self createUIButtonWithTarget:@selector(redBtnClick:) withFrame:CGRectMake(10, 30, (SCREEN_Width - 20 - 30)/3.0, 20) withBackgroundColor:[UIColor redColor]];
    }
    return _redBtn;
}

- (UIButton *)blueBtn
{
    if (!_blueBtn) {
        _blueBtn = [self createUIButtonWithTarget:@selector(blueBtnClick:) withFrame:CGRectMake(10 + (SCREEN_Width - 20 - 30)/3.0 + 15, 30, (SCREEN_Width - 20 - 30)/3.0, 20) withBackgroundColor:[UIColor blueColor]];
    }
    return _blueBtn;
}

- (UIButton *)yellowBtn
{
    if (!_yellowBtn) {
        _yellowBtn = [self createUIButtonWithTarget:@selector(yellowBtnClick:) withFrame:CGRectMake(SCREEN_Width - (SCREEN_Width - 20 - 30)/3.0 - 10, 30, (SCREEN_Width - 20 - 30)/3.0, 20) withBackgroundColor:[UIColor yellowColor]];
    }
    return _yellowBtn;
}

- (UISlider *)slider
{
    if (!_slider) {
        _slider = [[UISlider alloc] initWithFrame:CGRectMake(10, 10, SCREEN_Width - 20, 10)];
        _slider.minimumValue = 1;
        _slider.maximumValue = 50;
        [_slider addTarget:self action:@selector(sliderAction) forControlEvents:UIControlEventValueChanged];
    }
    return _slider;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor orangeColor];
    
    //默认线宽
    self.paintView.lineWidth = 1;
    
    //设置默认颜色
    self.paintView.lineColor = [UIColor blackColor];
    
    [self createUI];
}

#pragma mark -createUI
- (void)createUI
{
    [self.view addSubview:self.paintView];
    
    UIView *fView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, SCREEN_Width, 49)];
    fView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:fView];
    
    [fView addSubview:self.btn1];
    [fView addSubview:self.btn2];
    [fView addSubview:self.btn3];
    [fView addSubview:self.btn4];
    [fView addSubview:self.btn5];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_Height - 60, SCREEN_Width, 60)];
    bottomView.backgroundColor = [UIColor cyanColor];
    [self.view addSubview:bottomView];
    
    [bottomView addSubview:self.redBtn];
    [bottomView addSubview:self.blueBtn];
    [bottomView addSubview:self.yellowBtn];
    [bottomView addSubview:self.slider];
}

#pragma mark -
- (void)btn1Action
{
    //清屏
    [self.paintView clearScreen];
}

- (void)btn2Action
{
    //回退
    [self.paintView undo];
}

- (void)btn3Action
{
    //橡皮擦
    [self.paintView erase];
}

- (void)btn4Action
{
    //选择照片
    //选择图片控制器
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    //控制器弹出类型
    /*
     typedef NS_ENUM(NSInteger, UIImagePickerControllerSourceType) {
     UIImagePickerControllerSourceTypePhotoLibrary,     //默认
     UIImagePickerControllerSourceTypeCamera,
     UIImagePickerControllerSourceTypeSavedPhotosAlbum  //保存时刻
     }
     */
    picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    
    //设置代理  选择完照片   --因为UIImagePickerController继承自UINavigationViewController 均有delegate 需要遵守<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
    picker.delegate = self;
    
    //显示
    [self presentViewController:picker animated:YES completion:nil];
    
}

#pragma mark -UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSLog(@"选择照片结束--%@", info);
    
    /*
     {
     UIImagePickerControllerMediaType = "public.image";
     UIImagePickerControllerOriginalImage = "<UIImage: 0x17409dfb0> size {2448, 3264} orientation 3 scale 1.000000";
     UIImagePickerControllerReferenceURL = "assets-library://asset/asset.JPG?id=48202DFD-E5A6-4BE5-A019-7E43FB89D39B&ext=JPG";
     }
     */
    
    //获取用户选择的图片
    UIImage *selectImg = info[UIImagePickerControllerOriginalImage];
    
    //创建一个UIImageView控件 --要对此控件添加各种手势操作
    //创建一个透明的view
    CPhotoView *photoView = [[CPhotoView alloc] init]; //--和绘图视图 为兄弟关系
    
    //设置代理
    photoView.delegate = self;
    
    photoView.clipsToBounds = YES;
    //用户选择的照片设置给透明view
    photoView.photo = selectImg;
    photoView.frame = self.paintView.frame;
    [self.view addSubview:photoView];
    
    self.photoView = photoView;
    
    //实现了此方法 系统就不自动关闭  需要自己实现关闭
    //关闭控制器
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark -CPhotoViewDelegate
- (void)photoView:(CPhotoView *)photoView withImage:(UIImage *)image
{
    //将透明view的图片传递给绘图view 在绘图view内部进行绘图
    self.paintView.pickedImage = image;
    
    //把透明view从self.view删除
    [self.photoView removeFromSuperview];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"相册--点击了取消按钮");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)btn5Action
{
    //保存图片到相册
    //1.把self.paintView中内容渲染到上下文
    //开启一个图片上下文
    UIGraphicsBeginImageContextWithOptions(self.paintView.bounds.size, NO, 0);
    //获取刚开启的上下文
    CGContextRef ref = UIGraphicsGetCurrentContext();
    
    //2.从上下文获取图片
    [self.paintView.layer renderInContext:ref];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    //3.关闭上下文
    UIGraphicsEndImageContext();
    
    //4.把图片保存到相册    -必须是这个方法
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(img:didFinishSavingWithError:contextInfo:), nil);
}

//- (void)didFinishSave
//{
//    NSLog(@"--保存成功");
//}

#pragma mark - 照片存到本地后的回调
- (void)img:(UIImage*)image didFinishSavingWithError:(NSError*)error contextInfo:(void*)contextInfo{
    
//    if (!error) {
//        NSLog(@"图片保存成功");
//    } else {
//        NSLog(@"图片保存失败");
//    }
    
    //提示
    NSString *message;
    if (!error) {
        message = @"保存图片成功";
    }else {
        message = @"保存图片失败";
    }
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *act = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:act];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)redBtnClick:(UIButton *)btn
{
    self.paintView.lineColor = btn.backgroundColor;
}

- (void)blueBtnClick:(UIButton *)btn
{
    self.paintView.lineColor = btn.backgroundColor;
}

- (void)yellowBtnClick:(UIButton *)btn
{
    self.paintView.lineColor = btn.backgroundColor;
}

- (void)sliderAction
{
    NSLog(@"---%f", self.slider.value);
    
    //将值赋给绘图
    self.paintView.lineWidth = self.slider.value;
}

- (UIButton *)createUIButtonWithTitle:(NSString *)title withTarget:(SEL)target withFrame:(CGRect)frame
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:target forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (UIButton *)createUIButtonWithTarget:(SEL)target withFrame:(CGRect)frame withBackgroundColor:(UIColor *)backColor
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = backColor;
    btn.frame = frame;
    [btn addTarget:self action:target forControlEvents:UIControlEventTouchUpInside];
    
    return btn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
