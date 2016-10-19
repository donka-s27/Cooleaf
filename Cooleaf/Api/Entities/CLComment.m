//
//  CLComment.m
//  Cooleaf
//
//  Created by Haider Khan on 9/18/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "CLComment.h"

@implementation CLComment

# pragma mark - JSONKeyPathsByPropertyKey

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"commentId": @"id",
             @"userId": @"user_id",
             @"feedId": @"feed_id",
             @"commentable_id": @"commentable_id",
             @"commentableType": @"commentable_type",
             @"userName": @"user_name",
             @"userPicture": @"user_picture",
             @"attachment": @"attachment",
             @"content": @"content",
             @"updatedAt": @"updated_at"
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

@end
