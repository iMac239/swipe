//
//  BottomCollectionView.h
//  Swipe
//
//  Created by Michael MacCallum on 5/4/14.
//  Copyright (c) 2014 Michael MacCallum. All rights reserved.
//

#import "CollectionViewBaseClass.h"
@class TopCollectionView;

@interface BottomCollectionView : CollectionViewBaseClass

@property (weak, nonatomic) IBOutlet TopCollectionView *otherCollectionView;

@end
