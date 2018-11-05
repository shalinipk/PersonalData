//
//  PDCollectionViewCell.h
//  PersonalData
//
//  Created by Shalini Kamala on 10/26/18.
//  Copyright © 2018 shalini. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Item.h"


@interface PDCollectionViewCell : UICollectionViewCell
@property (nonatomic, readwrite, strong) Item *pdItem;
@property (nonatomic, readwrite, strong) UILabel *titleLabel;
@property (nonatomic, readwrite, strong) UILabel *URLLabel;
@property (nonatomic, readwrite, strong) UIImageView *imageView;
- (void)updateImageForItem:(Item *)pdItem;
@end

