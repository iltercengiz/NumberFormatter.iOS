//
//  NumberFormatter.m
//  NumberFormatter
//
//  Created by Ilter Cengiz on 12/06/14.
//  Copyright (c) 2014 Ilter Cengiz. All rights reserved.
//

#import "NumberFormatter.h"

#import <libPhoneNumber-iOS/NBPhoneNumberUtil.h>
#import <libPhoneNumber-iOS/NBPhoneNumber.h>

@implementation NumberFormatter

+ (NSString *)formattedNumberInInternationalFormatFromNumber:(NSString *)number {
    return [self formattedNumberInFormat:NBEPhoneNumberFormatINTERNATIONAL fromNumber:number];
}
+ (NSString *)formattedNumberInE164FormatFromNumber:(NSString *)number {
    return [self formattedNumberInFormat:NBEPhoneNumberFormatE164 fromNumber:number];
}

+ (NSString *)formattedNumberInFormat:(NBEPhoneNumberFormat)format fromNumber:(NSString *)number {
    
    NSError *error = nil;
    NBPhoneNumberUtil *phoneNumberUtil = [NBPhoneNumberUtil sharedInstance];
    #warning make this regionCode a property
    NSString *regionCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    NBPhoneNumber *phoneNumber = [phoneNumberUtil parse:number defaultRegion:regionCode error:&error];
    
    if (error) {
        // NSLog(@"Error: %@", error.description);
    } else {
        if ([phoneNumberUtil isValidNumber:phoneNumber]) {
            return [phoneNumberUtil format:phoneNumber numberFormat:format error:&error];
        } else {
            // NSLog(@"Phone number: %@", phoneNumber.description);
        }
    }
    
    return nil;
    
}

@end
