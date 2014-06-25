//
//  NumberFormatter.h
//  NumberFormatter
//
//  Created by Ilter Cengiz on 12/06/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NumberFormatter : NSObject

+ (NSString *)formattedNumberInInternationalFormatFromNumber:(NSString *)number;
+ (NSString *)formattedNumberInE164FormatFromNumber:(NSString *)number;

@end
