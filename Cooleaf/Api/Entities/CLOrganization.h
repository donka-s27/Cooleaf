//
//  NPOrganization.h
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import <Mantle.h>
#import "CLPicture.h"

@interface CLOrganization : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) NSNumber *organizationId;
@property (nonatomic, copy) NSString *organizationName;
@property (nonatomic, copy) NSString *organizationSubdomain;
@property (nonatomic, copy) CLPicture *organizationPicture;
@property (nonatomic, copy) NSMutableArray *structures;

@end
