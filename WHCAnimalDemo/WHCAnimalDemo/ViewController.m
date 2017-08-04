//
//  ViewController.m
//  WHCAnimalDemo
//
//  Created by 王红超 on 2017/8/4.
//  Copyright © 2017年 Wang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
//实现动画
@property (nonatomic, strong)UIDynamicAnimator *dynamicAnimator;
//动画元素行为
@property (nonatomic, strong)UIDynamicItemBehavior *dynamicItemBehavior;
//碰撞行为
@property (nonatomic, strong)UICollisionBehavior *collisionBehavior;
//重力行为
@property (nonatomic, strong)UIGravityBehavior *gravityBehavior;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //实力动画
    _dynamicAnimator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
    
    _dynamicItemBehavior = [[UIDynamicItemBehavior alloc]init];
    
    //弹力  数值越大，弹力越大
    _dynamicItemBehavior.elasticity = 1;
    
    //碰撞
    _collisionBehavior = [[UICollisionBehavior alloc]init];
    
    //刚体碰撞
    _collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    
    //重力
    _gravityBehavior = [[UIGravityBehavior alloc]init];
    
    //把行为放进动画里
    [_dynamicAnimator addBehavior:_dynamicItemBehavior];
    
    [_dynamicAnimator addBehavior:_collisionBehavior];
    
    [_dynamicAnimator addBehavior:_gravityBehavior];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    NSArray * imageArray = @[@"bird1",@"bluebird1",@"ice1",@"pig_44",@"yellowbird1",@"shelf1",@"1",@"pig1",];
    
    int x = arc4random() % (int)self.view.bounds.size.width;
    
    int siz = arc4random() % 50 + 20;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(x, 10, siz, siz)];
    
    imageView.image = [UIImage imageNamed:imageArray[arc4random() % imageArray.count]];
    
    [self.view addSubview:imageView];
    
    
    //添加行为
    [_dynamicItemBehavior addItem:imageView];
    
    [_gravityBehavior addItem:imageView];
    
    [_collisionBehavior addItem:imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
