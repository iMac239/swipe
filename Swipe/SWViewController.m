//
//  SWViewController.m
//  Swipe
//
//  Created by Michael MacCallum on 5/4/14.
//  Copyright (c) 2014 Michael MacCallum. All rights reserved.
//

#import "SWViewController.h"


@interface SWViewController ()

@property (strong, nonatomic) NSArray *dataArray;

@property (weak, nonatomic) IBOutlet UITextField *topBarTextField;

@end

@implementation SWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(159.0, 0.0, 2.0, 568.0)];
//        [view setBackgroundColor:[UIColor greenColor]];
//        [self.view addSubview:view];
//    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
