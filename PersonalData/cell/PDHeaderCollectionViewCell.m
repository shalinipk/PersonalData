//
//  PDHeaderCollectionViewCell.m
//  PersonalData
//
//  Created by Shalini Kamala on 11/5/18.
//  Copyright © 2018 shalini. All rights reserved.
//

#import "PDHeaderCollectionViewCell.h"

@implementation PDHeaderCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self) {
        //reduce height of image view
        CGRect rect = self.imageView.frame;
        rect.size.height -= 30;
        self.imageView.frame = rect;
        
        //add summary in addition to image & title
        self.summaryLabel = [UILabel new] ;
        self.summaryLabel.numberOfLines = 2;
        self.summaryLabel.preferredMaxLayoutWidth = self.contentView.bounds.size.width-10;
        
        [self addSubview:self.summaryLabel];
        self.summaryLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.summaryLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:5].active = YES;
        [self.summaryLabel.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:5].active = YES;
        [self.summaryLabel.heightAnchor constraintGreaterThanOrEqualToConstant:10.0f].active = YES;
        [self.summaryLabel.topAnchor constraintEqualToAnchor:self.titleLabel.bottomAnchor constant:5].active = YES;
        
        self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
        self.summaryLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
        
    }
    return self;
}
- (void)setPdItem:(Item *)item
{
    [super setPdItem:item];
    self.summaryLabel.text = item.summary;
}

@end
