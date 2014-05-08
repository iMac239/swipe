//
//  MainListTableView.m
//  Swipe
//
//  Created by Michael MacCallum on 5/7/14.
//  Copyright (c) 2014 Michael MacCallum. All rights reserved.
//

#import "MainListTableView.h"
#import "ReminderTableViewCell.h"
@import EventKit;

@interface MainListTableView () < UITableViewDataSource, UITableViewDelegate >

@end

@implementation MainListTableView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDelegate:self];
        [self setDataSource:self];

        [[NSNotificationCenter defaultCenter] addObserverForName:UIContentSizeCategoryDidChangeNotification
                                                          object:nil
                                                           queue:[NSOperationQueue mainQueue]
                                                      usingBlock:^(NSNotification *note) {
                                                          [self reloadData];
        }];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleSwipeNotification:)
                                                     name:SwipeShouldEnterEditingModeNotification
                                                   object:nil];
    }
    return self;
}

- (void)handleSwipeNotification:(NSNotification *)notification
{

}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return (NSInteger)self.reminders.count;
}

- (ReminderTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"TableViewCell";

    ReminderTableViewCell *cell = (ReminderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellID
                                                                                           forIndexPath:indexPath];

    EKReminder *reminder = (EKReminder *)self.reminders[indexPath.row];

    NSAttributedString *attString = [[NSAttributedString alloc] initWithString:reminder.title attributes:[self stringAttributes]];
    [cell.textField setAttributedText:attString];

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSNotificationCenter defaultCenter] postNotificationName:SwipeShouldEnterEditingModeNotification
                                                        object:nil];
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 70.0;
//    EKReminder *reminder = (EKReminder *)self.reminders[indexPath.row];
//    return [self heightOfCellWithText:reminder.title withAttibutes:[self stringAttributes]];
//}

- (NSDictionary *)stringAttributes
{
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];

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

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIContentSizeCategoryDidChangeNotification object:nil];
}
@end
