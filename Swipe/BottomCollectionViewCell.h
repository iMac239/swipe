//
//  BottomCollectionViewCell.h
//  Swipe
//
//  Created by Michael MacCallum on 5/4/14.
//  Copyright (c) 2014 Michael MacCallum. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddEditListPage;
@class SettingsPage;

typedef enum : NSUInteger {
    BottomDisplayModeNormal = 1 << 0,
    BottomDisplayModeAddList = 1 << 1,
    BottomDisplayModeSettings = 1 << 2,
} BottomDisplayMode;

@interface BottomCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *dataArray;
@property (nonatomic, assign) BottomDisplayMode displayMode;

@property (strong, nonatomic) AddEditListPage *addEditListView;
@property (strong, nonatomic) SettingsPage *settingsView;

@end
