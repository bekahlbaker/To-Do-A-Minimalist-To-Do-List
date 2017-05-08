//
//  HTTPService.h
//  toDo-aMinimalistToDoApp
//
//  Created by Rebekah Baker on 5/3/17.
//  Copyright © 2017 Rebekah Baker. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^onComplete)(NSArray * _Nullable dataArray, NSString * _Nullable errMessage);
typedef void (^onCompleteSingle)(NSDictionary * _Nullable dict, NSString * _Nullable errMessage);

@interface HTTPService : NSObject

+ (id _Nonnull) instance;
- (void) loginUser:(NSString* _Nonnull)uuid :(nullable onComplete)completionHandler;
- (void) getToDoItems: (nullable onComplete)completionHandler;
- (NSString * _Nullable)anonymouslyLoginUser;
- (BOOL) downloadDataFromHerokuAndUploadToFirebase;
@end
