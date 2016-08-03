//
//  ViewController.m
//  图片折叠效果
//
//  Created by 远洋 on 16/2/10.
//  Copyright © 2016年 yuayang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

//透明view
@property (nonatomic,weak)UIView * coverView;

//上半部分
@property (nonatomic,weak)UIImageView * topImage;

@property (nonatomic,weak)UIImageView * bottomImage;

//阴影效果
@property (nonatomic,strong)CAGradientLayer * shadomLayer;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView * topImage = [[UIImageView alloc]initWithFrame:CGRectMake(100, 300, 200, 200)];
    
    UIImageView * bottomImage = [[UIImageView alloc]init];

    bottomImage.frame = topImage.frame;
    
    [self.view addSubview:topImage];
    [self.view addSubview:bottomImage];
    
    self.topImage = topImage;
    
    self.bottomImage = bottomImage;
    
    topImage.image = [UIImage imageNamed:@"1.jpg"];
    
    bottomImage.image = [UIImage imageNamed:@"1.jpg"];
    
    topImage.layer.contentsRect = CGRectMake(0, 0, 1.0, 0.5);
    
    bottomImage.layer.contentsRect = CGRectMake(0, 0.5, 1.0, 0.5);
    
    //阴影效果
    CAGradientLayer * shadomLayer = [CAGradientLayer layer];
    
    //设置渐变颜色 由透明到黑色 表示从无到有 注意必须转换成CGColor 否则无效
    shadomLayer.colors = @[(id)[UIColor clearColor],(id)[UIColor blackColor].CGColor];
    
    //设置阴影范围
    shadomLayer.frame = topImage.bounds;
    
    self.shadomLayer = shadomLayer;
    
    //设置不透明度
    shadomLayer.opacity = 0;
    
    //添加到下半部分
    [bottomImage.layer addSublayer:shadomLayer];
    
    //设置上半部分锚点
    topImage.layer.anchorPoint = CGPointMake(0.5, 1);
    
    //下半部分的锚点
    bottomImage.layer.anchorPoint = CGPointMake(0.5, 0);
    
    //创建一个透明的view到上面
    UIView * coverView = [[UIView alloc]initWithFrame:topImage.frame];
    [self.view addSubview:coverView];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    //给view添加一个拖动手势
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(dragGesture:)];
    
    [coverView addGestureRecognizer:pan];
    
    self.coverView = coverView;
    
    self.view.backgroundColor = [UIColor purpleColor];

}

- (void)dragGesture:(UIPanGestureRecognizer *)sender {
    
    //获取手指偏移量
    CGPoint transP = [sender translationInView:self.coverView];
    
    //初始化形变
    CATransform3D transform3D = CATransform3DIdentity;
    
    //设置立体效果
    transform3D.m34 = - 1 / 1000;
    
    //计算在折叠角度 当拖动100时 刚好是旋转180°
    CGFloat angle = - transP.y / 200 * M_PI;
    
    //设置transform
    self.topImage.layer.transform = CATransform3DRotate(transform3D, angle, 1, 0, 0);
    
    //在拖动的时候设置不透明度 假设拖动200 阴影完全显示 不透明度为1 可以计算出来
    self.shadomLayer.opacity = transP.y * 1 / 200.0;
    
    NSLog(@"%f",self.shadomLayer.opacity);
    //反弹效果
    if (sender.state == UIGestureRecognizerStateEnded) {
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.1 initialSpringVelocity:3 options:UIViewAnimationOptionCurveLinear animations:^{
            //还原形变
            self.topImage.layer.transform = CATransform3DIdentity;
            
            //当手指抬起 将阴影隐藏 不透明度为0
            self.shadomLayer.opacity = 0;
        } completion:nil];
    }
}
@end
