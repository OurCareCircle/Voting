//
//  PBPollBoothParser.m
//  PollBooth
//
//  Created by iOSDeveloper2 on 05/03/14.
//  Copyright (c) 2014 Yudiz Pvt Solution Ltd. All rights reserved.
//

#import "PBPollBoothParser.h"



@interface PBPollBoothParser ()<NSXMLParserDelegate>
{
    parserBlock _block;
    NSXMLParser *_parser;
    NSMutableArray  *_dataArray;
    
    NSDictionary *_dict;
    
}

@end

@implementation PBPollBoothParser

+(void)parseXML:(NSXMLParser*)parser completionblock:(parserBlock)block
{
    PBPollBoothParser *obj = [[self alloc]init];
    obj->_parser = parser;
    obj->_block = block;
    [obj->_parser setDelegate:obj];
    obj->_dataArray = [[NSMutableArray alloc]init];
    BOOL success = [obj->_parser parse];
    if(!success)
        block(nil,NO);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if([elementName isEqualToString:@"booths"])
    {
        _dataArray = [[NSMutableArray alloc]init];
    }
    else if ([elementName isEqualToString:@"booth"])
    {
        _dict = attributeDict;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"booths"])
    {
        _block(_dataArray,YES);
    }
    else if ([elementName isEqualToString:@"booth"])
    {
        [_dataArray addObject:_dict];
    }
}

@end
