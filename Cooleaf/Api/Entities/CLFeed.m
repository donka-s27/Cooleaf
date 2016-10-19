//
//  CLFeed.m
//  Cooleaf
//
//  Created by Haider Khan on 9/18/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "CLFeed.h"
#import "CLComment.h"
#import "CLPicture.h"

@implementation CLFeed

# pragma mark - JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"feedId": @"id",
             @"userId": @"user_id",
             @"userName": @"user_name",
             @"userPicture": @"user_picture",
             @"content": @"content",
             @"updatedAt": @"updated_at",
             @"comments": @"comments"
             };
}

# pragma mark - userPictureJSONTransformer

- (NSValueTransformer *)userPictureJSONTransformer {
    return [MTLValueTransformer reversibleTransformerWithForwardBlock:^(NSDictionary *pictureDict) {
        return [MTLJSONAdapter  modelOfClass:CLPicture.class
                          fromJSONDictionary:pictureDict
                                       error:nil];
    } reverseBlock:^(CLPicture *picture) {
        return [MTLJSONAdapter JSONDictionaryFromModel:picture];
    }];
}

# pragma mark - commentsJSONTransformer

- (NSValueTransformer *)commentsJSONTransformer {
    return [NSValueTransformer mtl_JSONArrayTransformerWithModelClass:CLComment.class];
}

@end
