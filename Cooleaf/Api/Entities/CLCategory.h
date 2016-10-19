//
//  CLCategory.h
//  Cooleaf
//
//  Created by Haider Khan on 9/22/15.
//  Copyright © 2015 Nova Project. All rights reserved.
//

#import "MTLModel.h"
#import "CLPicture.h"
#import "MTLJSONAdapter.h"

@interface CLCategory : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSNumber *tagId;
@property (nonatomic, copy, readonly) NSString *tagName;
@property (nonatomic, copy, readonly) NSNumber *organizationId;
@property (nonatomic, copy, readonly) NSString *type;
@property (nonatomic, copy, readonly) NSString *createdAt;
@property (nonatomic, copy, readonly) NSString *updatedAt;
@property (nonatomic, assign) BOOL active;
@property (nonatomic, copy, readonly) NSNumber *parentId;
@property (nonatomic, copy, readonly) NSString *parentType;
@property (nonatomic, copy) CLPicture *picture;
@property (nonatomic, copy, readonly) NSString *slug;

@end
