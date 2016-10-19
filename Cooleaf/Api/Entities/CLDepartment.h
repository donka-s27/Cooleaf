//
//  NPDepartment.h
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import <Mantle.h>

@interface CLDepartment : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSString *name;
@property (nonatomic, assign) BOOL isDefault;

@end
