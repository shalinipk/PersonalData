//
//  PDCollectionViewCell.m
//  PersonalData
//
//  Created by Shalini Kamala on 10/26/18.
//  Copyright © 2018 shalini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PDCollectionViewCell.h"

@interface PDCollectionViewCell()
@end

@implementation PDCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame;
{
    self = [super initWithFrame:frame];
    if (self) {

        //add image & text
        CGRect rect = self.contentView.bounds;
        rect.size.height -= 40;
        self.imageView = [[UIImageView alloc] initWithFrame:rect];
        
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        self.imageView.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        self.imageView.layer.cornerRadius = 0.0;
        
        [self.contentView addSubview:self.imageView];
        
        self.titleLabel = [UILabel new] ;
        self.titleLabel.numberOfLines = 2;
        self.titleLabel.preferredMaxLayoutWidth = rect.size.width;
        [self.titleLabel setFont:[UIFont systemFontOfSize:12]];
        
        [self addSubview:self.titleLabel];
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.titleLabel.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:5].active = YES;
        [self.titleLabel.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:5].active = YES;
        [self.titleLabel.heightAnchor constraintGreaterThanOrEqualToConstant:12.0f].active = YES;
        [self.titleLabel.topAnchor constraintEqualToAnchor:self.imageView.bottomAnchor constant:5].active = YES;
        
        self.layer.borderWidth=1.0f;
        self.layer.borderColor=[UIColor lightGrayColor].CGColor;
        
    }
    return self;
}

- (void)setPdItem:(Item *)item
{
//    self.pdItem = item;
    self.titleLabel.text = item.title;
    self.URLLabel.text = item.link;
    self.imageView.image = item.image;
}

- (Item *)pdItem;
{
    return self.pdItem;
}
- (void)updateImageForItem:(Item *)pdItem
{
    UIImage *itemImage = nil;
    if ((itemImage = [pdItem image])) {
        // We already have an image associated with this object.
        self.imageView.alpha = 1;
        self.imageView.image = itemImage;
    }
    else if ([pdItem imageURL]) {
        //download image.

        NSURL *url = [NSURL URLWithString:pdItem.imageURL];
        
        NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (data) {
                UIImage *image = [UIImage imageWithData:data];
                if (image) {
                        //Resize the image for thumbnail presentation.
                        CGSize maxImageSize = CGSizeMake(200, 200);
                        if (image.size.width > maxImageSize.width || image.size.height > maxImageSize.height) {
                            image = [self image:image constrainedToSize:CGSizeMake(200, 200)];
                        }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [pdItem setImage:image];
                        self.imageView.alpha = 1.0f;
                        self.imageView.image = image;
                    });
                }
            }
        }];
        [task resume];
    }
}

- (void)preferredContentSizeDidChange:(NSNotification *)note;
{
    self.titleLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
    self.URLLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleFootnote];
}

- (UIImage *)image:(UIImage*)image constrainedToSize:(CGSize)size;
{
    CGFloat wm = size.width/image.size.width;
    CGFloat hm = size.height/image.size.height;
    CGFloat scale = MIN(wm, hm);
    return [self scaledImage:image scale:scale];
}

- (UIImage *)scaledImage:(UIImage *)image scale:(CGFloat)scale;
{
    CGSize size = CGSizeApplyAffineTransform(image.size, CGAffineTransformMakeScale(scale, scale));
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [image drawInRect:(CGRect){ .origin = CGPointZero, .size = size }];
    UIImage *scaled = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaled;
}

@end
