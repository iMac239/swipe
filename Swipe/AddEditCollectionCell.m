//
//  AddEditCollectionCell.m
//  Swipe
//
//  Created by Michael MacCallum on 5/5/14.
//  Copyright (c) 2014 Michael MacCallum. All rights reserved.
//

#import "AddEditCollectionCell.h"

@implementation AddEditCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] init];
        [self.imageView setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.imageView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [self.imageView setFrame:CGRectMake(0.0, 0.0, 48.0, 48.0)];
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
