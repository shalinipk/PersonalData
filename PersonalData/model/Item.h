//
//  Item.h
//  PersonalData
//
//  Created by Shalini Kamala on 10/26/18.
//  Copyright © 2018 shalini. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Item : NSObject
@property (copy) NSString* title;
@property (copy) UIImage* image;
@property  (copy) NSString* imageURL;
@property (copy) NSString* pubDate;
@property  (copy) NSString* summary;
@property  (copy) NSString* link;

@end
