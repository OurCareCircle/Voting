//
//  PBWaitTimeParser.m
//  PollBooth
//
//  Created by iOSDeveloper2 on 10/03/14.
//  Copyright (c) 2014 Yudiz Pvt Solution Ltd. All rights reserved.
//

#import "PBWaitTimeParser.h"

@interface PBWaitTimeParser ()<NSXMLParserDelegate>
{
    parserBlock     _block;
    NSXMLParser     *_parser;
    NSMutableArray  *_dataArray;
    NSDictionary    *_dict;
    NSMutableString *_mutString;
}

@end


@implementation PBWaitTimeParser

+ (void)parseXML:(NSXMLParser*)parser completionblock:(parserBlock)block
{
    PBWaitTimeParser *obj = [[self alloc]init];
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
        _mutString = [[NSMutableString alloc]initWithString:@""];
    }
    else if ([elementName isEqualToString:@"booth"])
    {
        
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    NSLog(@" wait time string : %@",string);
    [_mutString appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if([elementName isEqualToString:@"booths"])
    {
        NSLog(@"lenght ---> %d",[_mutString length]);
        _block(_mutString,YES);
    }
    else if ([elementName isEqualToString:@"booth"])
    {
    
    }
}


@end
