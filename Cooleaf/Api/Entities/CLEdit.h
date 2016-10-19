//
//  CLEdit.h
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import <Mantle.h>
#import "CLProfile.h"
#import "CLRole.h"

@interface CLEdit : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSMutableArray *categoryIds;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *fileCache;
@property (nonatomic, copy) NSNumber *editId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) CLProfile *profile;
@property (nonatomic, assign) BOOL removePicture;
@property (nonatomic, copy) NSNumber *rewardPoints;
@property (nonatomic, copy) CLRole *role;

@end
