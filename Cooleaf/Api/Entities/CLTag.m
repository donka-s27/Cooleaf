//
//  CLTag.m
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "CLTag.h"

@implementation CLTag

# pragma MTLJSONSerializaer

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"tagId": @"id",
             @"tagName": @"name",
             @"tagType": @"type",
             @"isActive": @"active",
             @"parentId": @"parent_id",
             @"isDefault": @"default"
             };
}

@end
