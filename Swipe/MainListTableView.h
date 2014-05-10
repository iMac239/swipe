//
//  MainListTableView.h
//  Swipe
//
//  Created by Michael MacCallum on 5/7/14.
//  Copyright (c) 2014 Michael MacCallum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainListTableView : UITableView

@property (strong, nonatomic) NSArray *reminders;
@property (strong, nonatomic) NSIndexPath *expandedIndexPath;

@end
