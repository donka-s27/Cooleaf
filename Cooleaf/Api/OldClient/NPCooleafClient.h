//
//  NPCooleafClient.h
//  Cooleaf
//
//  Created by Bazyli Zygan on 14.12.2013.
//  Copyright (c) 2013 Nova Project. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

extern NSString * const kNPCooleafClientRefreshNotification;
extern NSString * const kNPCooleafClientRUDIDHarvestedNotification;
extern NSString * const kNPCooleafClientSignOut;

@interface NPCooleafClient : AFHTTPRequestOperationManager

@property (nonatomic, readonly) NSDictionary *userData;
@property (nonatomic, setter = setNotificationUDID:) NSString *notificationUDID;

+ (NPCooleafClient *)sharedClient;

- (AFHTTPRequestOperation *)loginWithUsername:(NSString *)username password:(NSString *)password  completion:(void(^)(NSError *error))completion;

- (AFHTTPRequestOperation *)joinEventWithId:(NSNumber *)eventId completion:(void(^)(NSError *error))completion;

- (AFHTTPRequestOperation *)leaveEventWithId:(NSNumber *)eventId completion:(void(^)(NSError *error))completion;

- (void)fetchSeriesEventsForEventWithId:(NSNumber *)eventId completion:(void(^)(NSArray *npSeriesEvents))completion;

- (AFHTTPRequestOperation *)joinSeriesIDWithEventIdsArray:(NSNumber *)seriesID eventIdsArray:(NSArray *)eventIdsArray completion:(void(^)(NSError *error))completion;

- (AFHTTPRequestOperation *)fetchEventWithId:(NSNumber *)eventId completion:(void(^)(NSDictionary *eventDetails))completion;

- (AFHTTPRequestOperation *)fetchParticipantsForEventWithId:(NSNumber *)eventId completion:(void(^)(NSArray *participants))completion;

- (AFHTTPRequestOperation *)joinGroupWithId:(NSNumber *)groupId completion:(void(^)(NSError *error))completion;

- (AFHTTPRequestOperation *)leaveGroupWithId:(NSNumber *)groupId completion:(void(^)(NSError *error))completion;

- (AFHTTPRequestOperation *)fetchGroupWithId:(NSNumber *)groupId completion:(void(^)(NSDictionary *groupDetails))completion;

- (AFHTTPRequestOperation *)fetchMembersForGroupWithId:(NSNumber *)groupId completion:(void(^)(NSArray *members))completion;

- (AFHTTPRequestOperation *)addTodoForWidget:(NSNumber *)widgetId name:(NSString *)name completion:(void(^)(NSError *error))completion;

- (AFHTTPRequestOperation *)markTodo:(NSNumber *)todoId asDone:(BOOL)done completion:(void(^)(NSError *error))completion;

- (AFHTTPRequestOperation *)registerWithUsername:(NSString *)username completion:(void(^)(NSString*, NSDictionary*, NSDictionary*))completion;

- (AFHTTPRequestOperation *)updateRegistrationWithToken:(NSString *)token name:(NSString *)name gender:(NSString *)gender password:(NSString *)password tags:(NSArray *)tags completion:(void(^)(BOOL, NSString*))completion;

- (AFHTTPRequestOperation *)updatePictureWithImage:(UIImage *)image completion:(void(^)(NSDictionary *))completion;

- (AFHTTPRequestOperation *)updateProfileDataAllFields:(NSString *)EditName email:(NSString *)email password:(NSString *)password tags:(NSArray *)tags removed_picture:(BOOL)removed_picture file_cache:(NSString *)file_cache role_structure_required:(NSArray *)role_structure_required profileDailyDigest:(BOOL)profileDailyDigest profileWeeklyDigest:(BOOL)profileWeeklyDigest profile:(NSArray *)profile completion:(void(^)())completion;

- (void)getUserData:(void(^)(NSDictionary *profile))completion;

- (void)getAllInterests:(void(^)(NSArray *npinterests))completion;
- (void)getUserInterests:(void(^)(NSArray *npinterests))completion;
- (void)setUserInterests:(NSArray *)npinterests completion:(void (^)(BOOL))completion;

- (void)logout;

- (void)fetchEventList:(void(^)(NSArray *events))completion;

- (AFHTTPRequestOperation *)fetchMyEventsList:(NSNumber *)myID completion:(void(^)(NSArray *events))completion;

- (AFHTTPRequestOperation *)fetchGroupEventsList:(NSNumber *)groupID completion:(void(^)(NSArray *events))completion;

- (AFHTTPRequestOperation *)fetchEventsListOfType:(NSString *)eventType refID:(NSNumber *)refID myID:(NSNumber *)myID completion:(void(^)(NSArray *events))completion;

- (void)fetchInterestList:(void(^)(NSArray *events))completion;

- (void)fetchImage:(NSString *)imagePath completion:(void(^)(NSString *imagePath, UIImage *image))completion;

- (void)checkEndpoints;
@end
