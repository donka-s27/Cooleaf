//
//  CLAddress.m
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "CLAddress.h"

@implementation CLAddress

# pragma MTLJSONSerialization

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"addressLine1": @"address1",
             @"addressLine2": @"address2",
             @"city": @"city",
             @"state": @"state",
             @"zip": @"zip",
             @"name": @"name"
             };
}

@end
