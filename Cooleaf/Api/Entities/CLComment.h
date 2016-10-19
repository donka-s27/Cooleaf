//
//  CLComment.h
//  Cooleaf
//
//  Created by Haider Khan on 9/18/15.
//  Copyright (c) 2015 Nova Project. All rights reserved.
//

#import "MTLModel.h"
#import "CLPicture.h"

#import "MTLJSONAdapter.h"

@interface CLComment : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSNumber *commentId;
@property (nonatomic, copy, readonly) NSNumber *userId;
@property (nonatomic, copy, readonly) NSNumber *feedId;
@property (nonatomic, copy, readonly) NSNumber *commentableId;
@property (nonatomic, copy, readonly) NSString *commentableType;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) CLPicture *userPicture;
@property (nonatomic, copy) CLPicture *attachment;

@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *updatedAt;

@end
