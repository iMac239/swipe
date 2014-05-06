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
#import "BottomCollectionViewCell.h"
#import "AddEditListPage.h"
@import EventKitUI;

@interface TopCollectionView () < UICollectionViewDataSource, UICollectionViewDelegate , UITextFieldDelegate , AddEditListPageDelegate >

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
        [self maskTopCollection];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self maskTopCollection];
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
                [self.topTextField setText:@"Pull to Add List"];
            }break;

            case SideScrollStateTransitioningToSettingsPageLock:{

            }break;

            case SideScrollStateLockPossibleForAddList:{
                [self.topTextField setText:@"Release to Add List"];
                [self updateCellsToAlpha:0.0];
            }break;

            case SideScrollStateLockPossibleForSettingsPage:{
                [self updateCellsToAlpha:0.0];
            }break;

            case SideScrollStateLockOccurredForAddList:{
                [UIView animateWithDuration:0.05 animations:^{
                    [self setContentInset:UIEdgeInsetsMake(0.0, 73.0, 0.0, 0.0)];
                }];
                [self.topTextField setText:nil];
                [self.topTextField setPlaceholder:@"Enter List Name"];
                [self.topTextField setUserInteractionEnabled:YES];
                [self.topTextField becomeFirstResponder];

                BottomCollectionViewCell *bottomPage = self.otherCollectionView.visibleCells[0];
                [bottomPage.addEditListView presentationEnded];
                [bottomPage.addEditListView setDelegate:self];
            }break;

            case SideScrollStateLockOccurredForSettingsPage:{
                [UIView animateWithDuration:0.05 animations:^{
                    [self setContentInset:UIEdgeInsetsMake(0.0, 0.0, 0.0, 73.0)];
                }];
            }break;

            case SideScrollStateReturningFromAddListPage:{

            }break;

            case SideScrollStateReturningFromSettingsPage:{
                
            }break;

            case SideScrollStateReturnedFromAddListPage:{
                [UIView animateWithDuration:0.2 animations:^{
                    [self setContentInset:UIEdgeInsetsZero];
                } completion:^(BOOL finished) {
                    [self updateTitleLabel];
                }];

                if (self.topTextField.isFirstResponder) {
                    [self.topTextField resignFirstResponder];
                }
                [self.topTextField setUserInteractionEnabled:NO];

            }break;

            case SideScrollStateReturnedFromSettingsPage:{
                [UIView animateWithDuration:0.2 animations:^{
                    [self setContentInset:UIEdgeInsetsZero];
                } completion:^(BOOL finished) {
                    [self updateTitleLabel];
                }];
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

- (void)addEditListPageSelectionDidChangeToIndex:(NSInteger)index
{
    if (index > 0) {
        TopCollectionViewCell *cell = (TopCollectionViewCell *)[self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];

        [cell.imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%ld",(long)index]]];
        [cell setTag:index];
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
        [cell setAlpha:0.0];
        [cell setTag:-1];
    }else if (indexPath.row > [self numberOfLists]) {
        [cell.imageView setImage:[UIImage imageNamed:@"gear"]];
        [cell setAlpha:0.0];
        [cell setTag:-2];
    }else{
        EKCalendar *calendar = [self calendarAtIndex:indexPath.row - 1];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

        if ([defaults objectForKey:calendar.calendarIdentifier]) {
            [cell.imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%li",(long)[[defaults objectForKey:calendar.calendarIdentifier] integerValue]]]];
        }else{
            [cell.imageView setImage:[UIImage imageNamed:@"41"]];
        }

        [cell setTag:0];
    }

    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *centerIndex = [self indexPathForCenterCell];

    if ([indexPath compare:centerIndex] == NSOrderedSame) {
        NSLog(@"Should enter editing mode");
        
        EKEvent *event = [EKEvent eventWithEventStore:self.eventStore];
        
        EKEventEditViewController *editor = [[EKEventEditViewController alloc] init];
        
        [editor setEditViewDelegate:self];
        [editor setEventStore:self.eventStore];
        [editor setEvent:event];
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

            if (self.sideScrollState != SideScrollStateLockOccurredForAddList) {
                [self setSideScrollState:SideScrollStateLockPossibleForAddList];
            }
            [self updateOtherCollectionToContentOffset:point];
            [self updateCellsToAlpha:0.0];
            [self setContentOffset:point];
        }else{
            if (self.sideScrollState == SideScrollStateNormal) {
                [self setSideScrollState:SideScrollStateTransitioningToAddListLock];
            }else{
                [self setSideScrollState:SideScrollStateReturningFromAddListPage];
            }
            [self updateOtherCollectionToContentOffset:scrollView.contentOffset];
            [self updateCellsToAlpha:MIN(1, 1.0 - fabs(x) / cellWidth)];
        }
    }else if (max > 0.0) {
        if (max >= cellWidth) {
            CGPoint point = CGPointMake(scrollView.contentSize.width - scrollView.bounds.size.width + cellWidth, 0.0);

            [self setSideScrollState:SideScrollStateLockPossibleForSettingsPage];
            [self updateOtherCollectionToContentOffset:point];
            [self updateCellsToAlpha:0.0];
            [self setContentOffset:point];
        }else{
            if (self.sideScrollState == SideScrollStateNormal) {
                [self setSideScrollState:SideScrollStateTransitioningToSettingsPageLock];
            }else{
                [self setSideScrollState:SideScrollStateReturningFromSettingsPage];
            }
            [self updateOtherCollectionToContentOffset:scrollView.contentOffset];
            [self updateCellsToAlpha:MIN(1, 1.0 - max / cellWidth)];
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
        [self updateTitleLabel];
        [self maskTopCollection];
    }
}

- (void)updateCellsToAlpha:(CGFloat)alpha
{
    for (UICollectionViewCell *cell in self.visibleCells) {
        NSInteger row = [self indexPathForCell:cell].row;

        if (row == 0 || row == [self numberOfLists] + 1) {
            [cell setAlpha:1.0 - alpha];
        }else{
            [cell setAlpha:alpha];
        }
    }
}


- (void)updateTitleLabel
{
    NSInteger row = [self indexPathForCenterCell].row;

    EKCalendar *calendar = [self calendarAtIndex:row - 1];
    [self.topTextField setText:calendar.title];
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
    }else if (x < 0.0 && x > -cellWidth){
        if (self.sideScrollState != SideScrollStateTransitioningToAddListLock) {
            [self setSideScrollState:SideScrollStateReturnedFromAddListPage];
        }
    }
}

- (void)updateOtherCollectionToContentOffset:(CGPoint)offset
{
    [self.otherCollectionView setContentOffset:CGPointMake(self.otherCollectionView.contentSize.width * (offset.x) / (self.contentSize.width - 73 - 73) + 320.0, 0.0)]; // 73 is section inset
}

- (void)maskTopCollection
{
    static CGFloat variance = 1.0 / 320.0 * 34.0;

    NSArray *colors = @[(id)[[UIColor colorWithWhite:0.0 alpha:0.2] CGColor],
                        (id)[[UIColor whiteColor] CGColor],
                        (id)[[UIColor whiteColor] CGColor],
                        (id)[[UIColor colorWithWhite:0.0 alpha:0.2] CGColor]];

    CAGradientLayer *gradientLayer = [CAGradientLayer layer];


    [gradientLayer setFrame:self.topCollectionViewMaskContainer.bounds];
    [gradientLayer setColors:colors];
    [gradientLayer setLocations:@[@0.0, @(0.5 - variance), @(0.5 + variance), @1.0]];

    [gradientLayer setStartPoint:CGPointMake(0.0, 0.5)];
    [gradientLayer setEndPoint:CGPointMake(1.0, 0.5)];

    [self.topCollectionViewMaskContainer.layer setMask:gradientLayer];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{

}

- (void)textFieldDidEndEditing:(UITextField *)textField
{

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self createNewCalendar];
    
    return YES;
}

- (void)createNewCalendar
{
    TopCollectionViewCell *cell = (TopCollectionViewCell *)[self cellForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];

    NSInteger imageNumber = 41;
    if (cell.tag >= 0) {
        imageNumber = cell.tag;
    }

    EKCalendar *calendar = [EKCalendar calendarForEntityType:EKEntityTypeReminder eventStore:self.eventStore];
    [calendar setTitle:self.topTextField.text];

    EKSource *theSource = [[self.eventStore defaultCalendarForNewReminders] source];

    for (EKSource *source in self.eventStore.sources) {
        if (source.sourceType == EKSourceTypeCalDAV && [source.title isEqualToString:@"iCloud"]) {
            theSource = source;
            break;
        }
    }

    if (theSource) {
        [calendar setSource:theSource];
    }else{
        NSLog(@"Error: Local source not available");
        return;
    }

    NSError *error = nil;
    BOOL result = [self.eventStore saveCalendar:calendar commit:YES error:&error];
    if (result) {
        NSLog(@"Saved calendar to event store.");
        [[NSUserDefaults standardUserDefaults] setObject:@(imageNumber) forKey:calendar.calendarIdentifier];
    } else {
        NSLog(@"Error saving calendar: %@.", error);
    }
}

@end
