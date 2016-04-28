//
//  ViewController.m
//  Animation
//
//  Created by CuiRobin on 16/4/22.
//  Copyright © 2016年 CuiRobin. All rights reserved.
//

#import "ViewController.h"
#import "CCNautiloidAnimationView.h"
#import "CCReplicatorView.h"
#import "CCLineFlyView.h"

@interface ViewController ()
{
    CCNautiloidAnimationView *view;
    CCReplicatorView *viewReplicator;

}
@property (weak, nonatomic) IBOutlet UIButton *btnShow;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:[self flyView]];
//    UIImage *image = [UIImage imageNamed:@"icon1"];
//    self.btnShow.layer.contents = (__bridge id)image.CGImage;
//    self.btnShow.layer.contentsCenter = CGRectMake(0.25, 0.25, 0.5, 0.5);
//view = [[CCNautiloidAnimationView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:view];
    viewReplicator = [[CCReplicatorView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:viewReplicator];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
//    [view run];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (CCLineFlyView *)flyView {
    CCLineFlyView *viewFly= [[CCLineFlyView alloc
                            ] initWithFrame:self.view.bounds];
    return viewFly;
}
@end
