//
//  AddEditListPage.h
//  Swipe
//
//  Created by Michael MacCallum on 5/5/14.
//  Copyright (c) 2014 Michael MacCallum. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddEditListPageDelegate <NSObject>
@required

@end

@interface AddEditListPage : UIView

@property (weak, nonatomic) id < AddEditListPageDelegate > delegate;

@end
