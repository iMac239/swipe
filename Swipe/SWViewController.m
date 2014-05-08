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

@end

@implementation SWViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleSwipeNotification:)
                                                 name:SwipeShouldEnterEditingModeNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleSwipeNotification:)
                                                 name:SwipeShouldExitEditingModeNotification
                                               object:nil];

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)handleSwipeNotification:(NSNotification *)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([notification.name isEqualToString:SwipeShouldEnterEditingModeNotification]) {

            [UIView animateWithDuration:0.25 animations:^{
                [self.topBar setFrame:CGRectMake(0.0, -128.0, 320.0, 64.0)];
                [self.topCollectionContainer setFrame:CGRectMake(0.0, -64.0, 320.0, 64.0)];
                [self.bottomCollectionView setFrame:CGRectMake(0.0, 20.0, 320.0, 548.0)];
                [self.bottomCollectionView.collectionViewLayout invalidateLayout];
            } completion:^(BOOL finished) {
                [[NSNotificationCenter defaultCenter] postNotificationName:SwipeDidEnterEditingModeNotification object:nil];
            }];

        }else if ([notification.name isEqualToString:SwipeShouldExitEditingModeNotification]) {

            [UIView animateWithDuration:0.15 animations:^{
                [self.topBar setFrame:CGRectMake(0.0, 0.0, 320.0, 64.0)];
                [self.topCollectionContainer setFrame:CGRectMake(0.0, 64.0, 320.0, 64.0)];
            } completion:^(BOOL finished) {
                [[NSNotificationCenter defaultCenter] postNotificationName:SwipeDidExitEditingModeNotification object:nil];
            }];
        }
    });
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
