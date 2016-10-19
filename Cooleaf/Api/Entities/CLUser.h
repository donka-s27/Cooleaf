//
//  NPUser.h
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import <Mantle.h>
#import "CLRole.h"
#import "CLProfile.h"
#import "CLPicture.h"
#import "CLInterest.h"

@interface CLUser : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) NSNumber *userId;
@property (nonatomic) NSString *userName;
@property (nonatomic) NSString *userEmail;
@property (nonatomic) NSMutableArray *interests;
@property (nonatomic, copy) CLRole *role;
@property (nonatomic) NSNumber *rewardPoints;
@property (nonatomic, copy) CLProfile *profile;

@end
