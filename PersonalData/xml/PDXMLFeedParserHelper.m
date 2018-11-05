//
//  PDXMLFeedParserHelper.m
//  PersonalData
//
//  Created by Shalini Kamala on 10/27/18.
//  Copyright © 2018 shalini. All rights reserved.
//

#import "PDXMLFeedParserHelper.h"
#import "Item.h"

@interface PDXMLFeedParserHelper() <NSXMLParserDelegate> {
    NSXMLParser *xmlParser;
    NSMutableArray* items;
    Item* item;
    NSString* xmlString;
}

@end

@implementation PDXMLFeedParserHelper
-(instancetype) initWithData:(NSData*) data {
    self = [super init];
    
    xmlParser = [[NSXMLParser alloc] initWithData:data];
    [xmlParser setDelegate:self];
    return self;
}

-(void) startParsing {
    // Invoke the parser and check the result
    BOOL bParse = [xmlParser parse];
    if(bParse == NO) {
        NSError* error = [xmlParser parserError];
        if(error)
        {
            NSLog(@"Error %@", error);
            
        }
    }
    
}


-(NSArray*) fetchItems {
    return items;
}
//XMLParseDelegate methods
- (void) parserDidStartDocument:(NSXMLParser *)parser {
    NSLog(@"parserDidStartDocument");
    items = [[NSMutableArray alloc] init];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    NSLog(@"didStartElement --> %@", elementName);
    if([elementName isEqualToString:@"item"]) {
        item = [[Item alloc] init];
    } else if([elementName isEqualToString:@"media:content"]) {
        item.imageURL = [attributeDict valueForKey:@"url"];
    }
}

-(void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    NSLog(@"foundCharacters --> %@", string);
    
    xmlString = [[NSString alloc] initWithString:string];
    
}


- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    NSLog(@"didEndElement   --> %@", elementName);
    if([elementName isEqualToString:@"item"]) {
        [items addObject:item];
    }else if([elementName isEqualToString:@"title"]) {
        item.title = xmlString;
        
    } else if([elementName isEqualToString:@"link"]) {
        item.link = xmlString;
        
    } else if([elementName isEqualToString:@"pubDate"]) {
        item.pubDate = xmlString;
        
    } else if([elementName isEqualToString:@"description"]) {
        item.summary = xmlString;
        
    }
    xmlString = nil;
}

- (void) parserDidEndDocument:(NSXMLParser *)parser {
    NSLog(@"parserDidEndDocument");
    [self.delegate setItems:items];
}
@end


