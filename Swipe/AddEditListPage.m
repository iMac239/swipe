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
@property (strong, nonatomic) UIPageControl *pageControl;

@property (nonatomic, assign) BOOL isPageControllerTransitioning;
@property (nonatomic, assign) BOOL isPresented;

@end

@implementation AddEditListPage

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor clearColor]];
        [self setIsPageControllerTransitioning:NO];
        [self setIndexOfSelectedIcon:-1];
        [self setIsPresented:NO];

        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 192.0) collectionViewLayout:[self layout]];

        [self.collectionView registerClass:[AddEditCollectionCell class] forCellWithReuseIdentifier:cellID];

        [self.collectionView setDelegate:self];
        [self.collectionView setDataSource:self];
        [self.collectionView setBackgroundColor:[UIColor clearColor]];
        [self.collectionView setPagingEnabled:YES];
        [self.collectionView setShowsHorizontalScrollIndicator:NO];

        [self addSubview:self.collectionView];

        self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0.0, 171.0, 320.0, 40.0)];
        [self.pageControl addTarget:self action:@selector(pageControlDidSelectNewPage:) forControlEvents:UIControlEventValueChanged];

        [self.pageControl setFrame:CGRectMake(0.0, 192.0, 320.0, 40.0)];
        [self.pageControl setNumberOfPages:5];
        [self.pageControl setCurrentPage:0];

        [self addSubview:self.pageControl];
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

- (AddEditCollectionCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AddEditCollectionCell *cell = (AddEditCollectionCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];

    [cell.imageView setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%ld",(long)indexPath.row]]];

    if (self.isPresented) {

        if (indexPath.row == self.indexOfSelectedIcon) {
            [cell setAlpha:1.0];
        }else{
            [cell setAlpha:0.5];
        }

    }else{
        [cell setAlpha:1.0];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self setIndexOfSelectedIcon:indexPath.row];
    [self presentationEnded];
}

- (void)presentationEnded
{
    [UIView animateWithDuration:0.15 animations:^{
        for (UICollectionViewCell *cell in self.collectionView.visibleCells) {

            NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];

            if (indexPath.row != self.indexOfSelectedIcon) {
                [cell setAlpha:0.5];
            }else{
                [cell setAlpha:1.0];
            }
        }
    } completion:^(BOOL finished) {
        [self setIsPresented:YES];

        if ([self.delegate respondsToSelector:@selector(addEditListPageSelectionDidChangeToIndex:)]) {
            [self.delegate addEditListPageSelectionDidChangeToIndex:self.indexOfSelectedIcon];
        }
    }];
}


- (void)pageControlDidSelectNewPage:(UIPageControl *)sender
{
    [self setIsPageControllerTransitioning:YES];
    [self.collectionView setContentOffset:CGPointMake(sender.currentPage * self.collectionView.bounds.size.width, 0.0) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.isPageControllerTransitioning) {
        [self.pageControl setCurrentPage:floor(scrollView.contentOffset.x / scrollView.bounds.size.width)];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self setIsPageControllerTransitioning:NO];
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
