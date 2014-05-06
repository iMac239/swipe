//
//  AddEditListPage.m
//  Swipe
//
//  Created by Michael MacCallum on 5/5/14.
//  Copyright (c) 2014 Michael MacCallum. All rights reserved.
//

#import "AddEditListPage.h"
#import "AddEditCollectionCell.h"

static NSString *cellID = @"IconCellID";

@interface AddEditListPage () < UICollectionViewDataSource, UICollectionViewDelegate >

@property (strong, nonatomic) UICollectionView *collectionView;

@end

@implementation AddEditListPage

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];

        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 192.0) collectionViewLayout:[self layout]];

        [self.collectionView registerClass:[AddEditCollectionCell class] forCellWithReuseIdentifier:cellID];

        [self.collectionView setDelegate:self];
        [self.collectionView setDataSource:self];
        [self.collectionView setBackgroundColor:[UIColor clearColor]];

        [self addSubview:self.collectionView];
    }
    return self;
}

- (UICollectionViewFlowLayout *)layout
{
    static UICollectionViewFlowLayout *layout = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        layout = [UICollectionViewFlowLayout new];

        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [layout setSectionInset:UIEdgeInsetsMake(8.0, 8.0, 8.0, 8.0)];
        [layout setItemSize:CGSizeMake(48.0, 48.0)];
        [layout setMinimumInteritemSpacing:16.0];
        [layout setMinimumLineSpacing:16.0];
        [layout setFooterReferenceSize:CGSizeZero];
        [layout setHeaderReferenceSize:CGSizeZero];
    });

    return layout;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 80;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];

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
