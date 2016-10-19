//
//  CLFeed.h
//  Cooleaf
//
//  Created by Haider Khan on 9/18/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "MTLModel.h"
#import "CLPicture.h"
#import "MTLJSONAdapter.h"

@interface CLFeed : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSNumber *feedId;
@property (nonatomic, copy, readonly) NSNumber *userId;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) CLPicture *userPicture;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *updatedAt;
@property (nonatomic, copy) NSMutableArray *comments;

@end
