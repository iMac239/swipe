//
//  BottomCollectionView.m
//  Swipe
//
//  Created by Michael MacCallum on 5/4/14.
//  Copyright (c) 2014 Michael MacCallum. All rights reserved.
//

#import "BottomCollectionView.h"
#import "BottomCollectionViewCell.h"
#import "TopCollectionView.h"

@interface BottomCollectionView () < UICollectionViewDataSource, UICollectionViewDelegate >

@end

@implementation BottomCollectionView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDelegate:self];
        [self setDataSource:self];
        [self setContentOffset:CGPointMake(320.0, 0.0)];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(handleSwipeNotification:)
//                                                 name:SwipeShouldEnterEditingModeNotification
//                                               object:nil];
}

- (void)handleSwipeNotification:(NSNotification *)notification
{
//    CGSize screenSize = [[UIScreen mainScreen] bounds].size;

//    [self.collectionViewLayout invalidateLayout];

    if ([notification.name isEqualToString:SwipeShouldEnterEditingModeNotification]) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [UIView animateWithDuration:0.25
//                             animations:^{
//                                 [self setFrame:CGRectMake(0.0, 20.0, screenSize.width, screenSize.height - 20.0)];
//                             }];
//        });
    }else if ([notification.name isEqualToString:SwipeShouldExitEditingModeNotification]) {
//        [UIView animateWithDuration:0.25
//                         animations:^{
//                             [self setFrame:CGRectMake(0.0, 128.0, screenSize.width, screenSize.height - 128.0)];
//        } completion:nil];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"%s",__PRETTY_FUNCTION__);
    return [self numberOfLists] + 2;
}

- (BottomCollectionViewCell *)collectionView:(UICollectionView *)collectionView
                      cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"BottomCollectionCell";

    BottomCollectionViewCell *cell = (BottomCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellID
                                                                                                           forIndexPath:indexPath];

    if (indexPath.row == 0) {
        [cell setDataArray:nil];
        [cell setDisplayMode:BottomDisplayModeAddList];
    }else if (indexPath.row > [self numberOfLists]) {
        [cell setDataArray:nil];
        [cell setDisplayMode:BottomDisplayModeSettings];
    }else{
        [cell setDisplayMode:BottomDisplayModeNormal];
        EKCalendar *calendar = [self calendarAtIndex:indexPath.row - 1];

        if (calendar) {
            [self requestListsFromCalendar:calendar withCompletion:^(BOOL success, NSArray *reminders) {
                [cell setDataArray:reminders];
            }];
        }
    }

    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.frame.size;
}

@end
