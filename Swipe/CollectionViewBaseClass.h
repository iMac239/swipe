//
//  CollectionViewBaseClass.h
//  Swipe
//
//  Created by Michael MacCallum on 5/4/14.
//  Copyright (c) 2014 Michael MacCallum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXReorderableCollectionViewFlowLayout.h"
@import EventKit;

static CGFloat cellWidth = 58.0;
static CGFloat cellHeight = 64.0;

typedef enum : NSUInteger {
    SideScrollStateNormal = 1 << 0,
    SideScrollStateTransitioningToSettingsPageLock = 1 << 1,
    SideScrollStateTransitioningToAddListLock = 1 << 2,
    SideScrollStateLockPossibleForAddList = 1 << 3,
    SideScrollStateLockPossibleForSettingsPage = 1 << 4,
    SideScrollStateLockOccurredForAddList = 1 << 5,
    SideScrollStateLockOccurredForSettingsPage = 1 << 6,
    SideScrollStateOverExtendingAddListLock = 1 << 7,
    SideScrollStateOverExtendingSettingsPageLock = 1 << 8,
    SideScrollStateReturningFromAddListPage = 1 << 9,
    SideScrollStateReturningFromSettingsPage = 1 << 10,
    SideScrollStateReturnedFromAddListPage = 1 << 11,
    SideScrollStateReturnedFromSettingsPage = 1 << 12,
} SideScrollState;

typedef void(^ReminderAccessCompletionBlock)(BOOL success, NSArray *reminders);



@interface CollectionViewBaseClass : UICollectionView

@property (nonatomic, assign) SideScrollState sideScrollState;
@property (strong, nonatomic) EKEventStore *eventStore;

- (NSUInteger)numberOfLists;
- (EKCalendar *)calendarAtIndex:(NSInteger)index;
- (void)requestListsFromCalendar:(EKCalendar *)calendar
                  withCompletion:(ReminderAccessCompletionBlock)completion;
- (LXReorderableCollectionViewFlowLayout *)topCollectionFlowLayout;


@end
