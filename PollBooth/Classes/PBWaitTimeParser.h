//
//  PBWaitTimeParser.h
//  PollBooth
//
//  Created by iOSDeveloper2 on 10/03/14.
//  Copyright (c) 2014 Yudiz Pvt Solution Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^parserBlock)(id obj,BOOL success);

@interface PBWaitTimeParser : NSObject

+ (void)parseXML:(NSXMLParser*)parser completionblock:(parserBlock)block;

@end
