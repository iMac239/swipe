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

@property (weak, nonatomic) IBOutlet UIView *topCollectionContainer;
@property (weak, nonatomic) IBOutlet UIView *topBar;
@property (weak, nonatomic) IBOutlet UICollectionView *bottomCollectionView;
@property (weak, nonatomic) IBOutlet UIScrollView *mainContentScrollView;
@property (weak, nonatomic) IBOutlet UIView *contentViewForScrollView;

@end

@implementation SWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];

    CGSize size = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height + 128.0);

    [self.mainContentScrollView setContentSize:size];
    [self.contentViewForScrollView setTranslatesAutoresizingMaskIntoConstraints:YES];
    [self.contentViewForScrollView setFrame:CGRectMake(0.0, 0.0, self.mainContentScrollView.contentSize.width, self.mainContentScrollView.contentSize.height)];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
