//
//  SnowViewController.m
//  snow
//
//  Created by Taomin Chang on 10/30/14.
//  Copyright (c) 2014 Taomin Chang. All rights reserved.
//

#import "SnowViewController.h"

@interface SnowViewController ()

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravity;
@property (nonatomic, strong) UICollisionBehavior *collision;
@property (nonatomic, strong) UIPushBehavior *push;
@end

@implementation SnowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    self.gravity = [[UIGravityBehavior alloc] init];
    [self.animator addBehavior:self.gravity];
    self.gravity.gravityDirection = CGVectorMake(0,0.3);
    
    self.collision = [[UICollisionBehavior alloc] init];
    [self.collision addBoundaryWithIdentifier:@"roof" fromPoint:CGPointMake(0, 200) toPoint:CGPointMake(150, 240)];
    [self.collision addBoundaryWithIdentifier:@"ground" fromPoint:CGPointMake(0, 600) toPoint:CGPointMake(400, 600)];
    [self.animator addBehavior:self.collision];
    self.collision.collisionDelegate = self;
    
    self.push = [[UIPushBehavior alloc] init];
//    self.push.magnitude = 0.001;
//    self.push.pushDirection = CGVectorMake(0.1,0.5);
    [self.animator addBehavior:self.push];
    
    [NSTimer scheduledTimerWithTimeInterval:0.2
                                     target:self
                                   selector:@selector(createSnow)
                                   userInfo:nil
                                    repeats:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)createSnow {
    for (NSInteger i = 0; i < 3; i += 1) {
        UIView* snowView = [[UIView alloc] initWithFrame:CGRectMake(arc4random_uniform(400) - 50, -10, 5, 5)];
        snowView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:snowView];
        [self.gravity addItem:snowView];
        [self.collision addItem:snowView];
//        [self.push addItem:snowView];
    }


}

- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(id <NSCopying>)identifier atPoint:(CGPoint)p {
    // You have to convert the identifier to a string
    NSString *boundary = (NSString *)identifier;
    
    // The view that collided with the boundary has to be converted to a view
    UIView *snow = (UIView *)item;
    
    if ([boundary isEqualToString:@"ground"]) {
        // Detected collision with a boundary called "ground"
        // snow should melt
        [self performSelector:@selector(meltSnow:) withObject:snow afterDelay:2.0];
        
    } else if (boundary == nil) {
        // Detected collision with bounds of reference view
    }
}

- (void)meltSnow:(UIView *)snow {
//     snow.alpha = 0;
//    [snow removeFromSuperview];

    [UIView animateWithDuration:0.3 animations:^{
        snow.alpha = 0;
    } completion:^(BOOL finished) {
        [snow removeFromSuperview];
    }];

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
