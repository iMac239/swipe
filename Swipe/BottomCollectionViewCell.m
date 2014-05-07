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
#import "ReminderTableViewCell.h"
@import EventKit;

@interface BottomCollectionViewCell () < UITableViewDataSource, UITableViewDelegate >

@end

@implementation BottomCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

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

- (ReminderTableViewCell *)tableView:(UITableView *)tableView
               cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"TableViewCell";

    ReminderTableViewCell *cell = (ReminderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID
                                                                                           forIndexPath:indexPath];

    EKReminder *reminder = (EKReminder *)self.dataArray[indexPath.row];


    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:reminder.title attributes:[self stringAttributes]];
    [cell.textView setAttributedText:attString];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EKReminder *reminder = (EKReminder *)self.dataArray[indexPath.row];
    return [self heightOfCellWithText:reminder.title withAttibutes:[self stringAttributes]];
}

- (NSDictionary *)stringAttributes
{
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];

    NSDictionary *attributes = @{NSFontAttributeName : font, NSForegroundColorAttributeName : [UIColor whiteColor]};

    return attributes;
}

- (CGFloat)heightOfCellWithText:(NSString *)text
                  withAttibutes:(NSDictionary *)attributes
{
    CGSize maxSize = CGSizeMake(280.0, CGFLOAT_MAX);
    CGFloat inset = 8.0;

    CGRect frame = [text boundingRectWithSize:maxSize
                                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                   attributes:attributes
                                      context:nil];

    return frame.size.height + inset + inset + 2.0; // 2 is buffer
}


@end
