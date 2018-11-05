//
//  PDXMLFeedParserHelper.h
//  PersonalData
//
//  Created by Shalini Kamala on 10/27/18.
//  Copyright © 2018 shalini. All rights reserved.
//
#import <Foundation/Foundation.h>
@protocol PDXMLFeedParserHelperDelegate
@required
-(void) setItems:(NSArray*) items;
@end

@interface PDXMLFeedParserHelper: NSObject

@property (weak, nonatomic) id<PDXMLFeedParserHelperDelegate> delegate;
-(instancetype) initWithData:(NSData*) data;
-(void) startParsing;

-(NSArray*) fetchItems;

@end
