//
//  TopCollectionView.m
//  Swipe
//
//  Created by Michael MacCallum on 5/4/14.
//  Copyright (c) 2014 Michael MacCallum. All rights reserved.
//

#import "TopCollectionView.h"
#import "TopCollectionViewCell.h"
#import "BottomCollectionView.h"

@interface TopCollectionView () < UICollectionViewDataSource, UICollectionViewDelegate >

@end

@implementation TopCollectionView
@synthesize sideScrollState = _sideScrollState;

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setSideScrollState:SideScrollStateNormal];
        [self setCollectionViewLayout:[self topCollectionFlowLayout]];
        [self setDelegate:self];
        [self setDataSource:self];
    }
    return self;
}

- (void)setSideScrollState:(SideScrollState)sideScrollState
{

    if (sideScrollState != _sideScrollState) {
        _sideScrollState = sideScrollState;

        [super setSideScrollState:sideScrollState];

        NSLog(@"Changing state to: %lu",sideScrollState);
        switch (sideScrollState) {
            case SideScrollStateNormal:{

            }break;

            case SideScrollStateTransitioningToAddListLock:{

            }break;

            case SideScrollStateTransitioningToSettingsPageLock:{

            }break;

            case SideScrollStateLockPossibleForAddList:{

            }break;

            case SideScrollStateLockPossibleForSettingsPage:{

            }break;

            case SideScrollStateLockOccurredForAddList:{
                [UIView animateWithDuration:0.15 animations:^{
                    [self setContentInset:UIEdgeInsetsMake(0.0, 73.0, 0.0, 0.0)];
                }];
            }break;

            case SideScrollStateLockOccurredForSettingsPage:{
                [UIView animateWithDuration:0.15 animations:^{
                    [self setContentInset:UIEdgeInsetsMake(0.0, 0.0, 0.0, 73.0)];
                }];
            }break;

            case SideScrollStateReturningFromAddListPage:{

            }break;

            case SideScrollStateReturningFromSettingsPage:{
                
            }break;

            case SideScrollStateReturnedFromAddListPage:{
                [self setContentInset:UIEdgeInsetsZero];
            }break;

            case SideScrollStateReturnedFromSettingsPage:{
                [self setContentInset:UIEdgeInsetsZero];
            }break;

            case SideScrollStateOverExtendingAddListLock:{

            }break;

            case SideScrollStateOverExtendingSettingsPageLock:{

            }break;

            default:
                break;
        }
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return [self numberOfLists] + 2;
}

- (TopCollectionViewCell *)collectionView:(UICollectionView *)collectionView
                   cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"TopCollectionCell";

    TopCollectionViewCell *cell = (TopCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellID
                                                                                                     forIndexPath:indexPath];

    if (indexPath.row == 0) {
        [cell.imageView setImage:[UIImage imageNamed:@"plus"]];
    }else if (indexPath.row > [self numberOfLists]) {
        [cell.imageView setImage:[UIImage imageNamed:@"gear"]];
    }else{
        EKCalendar *calendar = [self calendarAtIndex:indexPath.row - 1];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        if ([defaults objectForKey:calendar.calendarIdentifier]) {
            [cell.imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%li",(long)[[defaults objectForKey:calendar.calendarIdentifier] integerValue]]]];
        }else{
            [cell.imageView setImage:[UIImage imageNamed:@"41"]];
        }
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *centerIndex = [self indexPathForCenterCell];

    if ([indexPath compare:centerIndex] == NSOrderedSame) {
        NSLog(@"Should enter editing mode");
    }else{
        [collectionView scrollToItemAtIndexPath:indexPath
                               atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                       animated:YES];
    }
}

- (NSIndexPath *)indexPathForCenterCell
{
    return [self indexPathForItemAtPoint:CGPointMake(self.bounds.size.width / 2.0 + self.contentOffset.x, self.bounds.size.height / 2.0)];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSLog(@"Offset: %@           Inset: %@          Side: %@",NSStringFromCGPoint(scrollView.contentOffset),NSStringFromUIEdgeInsets(scrollView.contentInset),NSStringFromCGSize(scrollView.contentSize));

    CGFloat x = scrollView.contentOffset.x;
    CGFloat max = scrollView.contentOffset.x - (scrollView.contentSize.width - scrollView.bounds.size.width);

    if (x < 0.0) {
        if (x <= -cellWidth) {
            CGPoint point = CGPointMake(-cellWidth, 0.0);

            [self setSideScrollState:SideScrollStateLockPossibleForAddList];
            [self updateOtherCollectionToContentOffset:point];
            [self setContentOffset:point];
        }else{
            if (self.sideScrollState == SideScrollStateNormal) {
                [self setSideScrollState:SideScrollStateTransitioningToAddListLock];
            }else{
                [self setSideScrollState:SideScrollStateReturningFromAddListPage];
            }
            [self updateOtherCollectionToContentOffset:scrollView.contentOffset];
        }
    }else if (max > 0.0) {
        if (max >= cellWidth) {
            CGPoint point = CGPointMake(scrollView.contentSize.width - scrollView.bounds.size.width + cellWidth, 0.0);

            [self setSideScrollState:SideScrollStateLockPossibleForSettingsPage];
            [self updateOtherCollectionToContentOffset:point];
            [self setContentOffset:point];
        }else{
            if (self.sideScrollState == SideScrollStateNormal) {
                [self setSideScrollState:SideScrollStateTransitioningToAddListLock];
            }else{
                [self setSideScrollState:SideScrollStateReturningFromAddListPage];
            }
            [self updateOtherCollectionToContentOffset:scrollView.contentOffset];
        }
    }else{

        if (self.sideScrollState == SideScrollStateReturningFromAddListPage) {
            [self setSideScrollState:SideScrollStateReturnedFromAddListPage];
        }
        if (self.sideScrollState == SideScrollStateReturningFromSettingsPage) {
            [self setSideScrollState:SideScrollStateReturnedFromSettingsPage];
        }

        [self setSideScrollState:SideScrollStateNormal];
        [self updateOtherCollectionToContentOffset:scrollView.contentOffset];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate
{
    CGFloat x = scrollView.contentOffset.x;
    CGFloat max = scrollView.contentOffset.x - (scrollView.contentSize.width - scrollView.bounds.size.width);

    if (x <= -cellWidth) {
        [self setSideScrollState:SideScrollStateLockOccurredForAddList];
    }else if (max >= 0.0) {
        [self setSideScrollState:SideScrollStateLockOccurredForSettingsPage];
    }else{

    }
}

- (void)updateOtherCollectionToContentOffset:(CGPoint)offset
{
    [self.otherCollectionView setContentOffset:CGPointMake(self.otherCollectionView.contentSize.width * (offset.x) / (self.contentSize.width - 73 - 73) + 320.0, 0.0)]; // 73 is section inset

}

@end
