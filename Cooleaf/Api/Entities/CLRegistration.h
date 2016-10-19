//
//  CLRegistration.h
//  Cooleaf
//
//  Created by Haider Khan on 9/29/15.
//  Copyright © 2015 Nova Project. All rights reserved.
//

#import <Mantle.h>
#import "MTLModel.h"

@interface CLRegistration : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSNumber *organizatonId;
@property (nonatomic, copy) NSString *organizationSubdomain;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSMutableArray *structures;
@property (nonatomic, copy) NSMutableArray *allStructures;
@property (nonatomic, copy) NSDictionary *chosenStructureIds;

@end
