//
//  CLInterest.h
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import <Mantle.h>
#import "CLImage.h"

@interface CLInterest : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSNumber *interestId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, assign) BOOL active;
@property (nonatomic, copy) NSString *parentType;
@property (nonatomic, copy) CLImage *image;
@property (nonatomic, copy) NSNumber *userCount;
@property (nonatomic, assign) BOOL member;

@end
