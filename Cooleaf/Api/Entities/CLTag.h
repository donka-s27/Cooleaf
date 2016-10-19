//
//  CLTag.h
//  Cooleaf
//
//  Created by Haider Khan on 8/24/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import <Mantle.h>

@interface CLTag : MTLModel <MTLJSONSerializing>

@property (nonatomic, readonly) NSNumber *tagId;
@property (nonatomic) NSString *tagName;
@property (nonatomic) NSString *tagType;
@property (nonatomic, assign) BOOL isActive;
@property (nonatomic) NSNumber *parentId;
@property (nonatomic, assign) BOOL isDefault;

@end
