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
@property NSString* title;
@property UIImage* image;
@property  NSString* imageURL;
@property NSString* pubDate;
@property  NSString* summary;
@property  NSString* link;

@end
