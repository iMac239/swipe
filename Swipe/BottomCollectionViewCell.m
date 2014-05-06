//
//  BottomCollectionViewCell.m
//  Swipe
//
//  Created by Michael MacCallum on 5/4/14.
//  Copyright (c) 2014 Michael MacCallum. All rights reserved.
//

#import "BottomCollectionViewCell.h"
#import "AddEditListPage.h"
#import "SettingsPage.h"
@import EventKit;

@interface BottomCollectionViewCell () < UITableViewDataSource, UITableViewDelegate , AddEditListPageDelegate >


@property (strong, nonatomic) AddEditListPage *addEditListView;
@property (strong, nonatomic) SettingsPage *settingsView;

@end

@implementation BottomCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;

    [self.tableView reloadData];
}

- (void)setDisplayMode:(BottomDisplayMode)displayMode
{
    if (displayMode != _displayMode) {
        _displayMode = displayMode;

        switch (displayMode) {
            case BottomDisplayModeNormal:{
                if (self.tableView.hidden) {
                    [self.tableView setHidden:NO];
                }

                [self destroyAddEditPage];
                [self destroySettingsPage];
            }break;

            case BottomDisplayModeAddList:{
                if (!self.tableView.hidden) {
                    [self.tableView setHidden:YES];
                }

                [self createAddEditPage];
            }break;

            case BottomDisplayModeSettings:{
                if (!self.tableView.hidden) {
                    [self.tableView setHidden:YES];
                }

                [self createSettingsPage];
            }break;

            default:
                break;
        }
    }
}

- (void)createAddEditPage
{
    [self destroyAddEditPage];

    self.addEditListView = [[AddEditListPage alloc] initWithFrame:self.contentView.bounds];
    [self.addEditListView setDelegate:self];
    [self.contentView addSubview:self.addEditListView];
}

- (void)destroyAddEditPage
{
    if ([self.addEditListView respondsToSelector:@selector(removeFromSuperview)]) {
        [self.addEditListView removeFromSuperview];
    }

    [self setAddEditListView:nil];
}

- (void)createSettingsPage
{
    [self destroySettingsPage];

    self.settingsView = [[SettingsPage alloc] initWithFrame:self.contentView.bounds];
    [self.contentView addSubview:self.settingsView];
}

- (void)destroySettingsPage
{
    if ([self.settingsView respondsToSelector:@selector(removeFromSuperview)]) {
        [self.settingsView removeFromSuperview];
    }

    [self setSettingsView:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"TableViewCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];

    EKReminder *reminder = (EKReminder *)self.dataArray[indexPath.row];

    [cell.textLabel setText:reminder.title];

    return cell;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
