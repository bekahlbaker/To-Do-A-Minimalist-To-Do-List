//
//  HTTPService.m
//  toDo-aMinimalistToDoApp
//
//  Created by Rebekah Baker on 5/3/17.
//  Copyright © 2017 Rebekah Baker. All rights reserved.
//

#import "HTTPService.h"
#import "Lockbox/Lockbox.h"
#import "Firebase.h"

#define URL_BASE "https://bekah-todo-api.herokuapp.com"
#define URL_ITEMS "/todos"
#define URL_USERS "/users"
#define URL_USERS_LOGIN "/users/login"
#define URL_ID "/"

@implementation HTTPService


+ (id) instance {
    static HTTPService *sharedInstance = nil;
    
    @synchronized (self) {
        if (sharedInstance == nil)
            sharedInstance = [[self alloc]init];
    }
    return sharedInstance;
}
- (void) loginUser:(NSString*)uuid :(nullable onComplete)completionHandler {
    NSDictionary *item = @{@"uuid": uuid};
    NSError *error;
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%s%s", URL_BASE, URL_USERS_LOGIN]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [request setHTTPMethod:@"POST"];
    
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:item options:0 error:&error];
    
    [request setHTTPBody:postData];
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data != nil) {
            NSLog(@"DATA: %@", data);
            NSURLResponse* responseFrom = response;
            NSDictionary* headers = [(NSHTTPURLResponse *)responseFrom allHeaderFields];
            NSString *authToken = [headers objectForKey:@"Auth"];
            NSLog(@"AUTH TOKEN: %@", authToken);
            [[NSUserDefaults standardUserDefaults] setObject:authToken forKey:@"token"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSError *err;
            NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
            
            if (err == nil) {
                completionHandler(json, nil);
                
            } else {
                completionHandler(nil, @"Data is corrupt. Try again");
            }
        } else {
            NSLog(@"NetowrkErr: %@", error.debugDescription);
            completionHandler(nil, @"Problem connecting to server");
        }
    }];
    
    [postDataTask resume];
}

- (void) getToDoItems:(nullable onComplete)completionHandler {
    NSURL *url = [NSURL URLWithString: [NSString stringWithFormat:@"%s%s", URL_BASE, URL_ITEMS]];
    NSURLSession *session = [NSURLSession sharedSession];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forHTTPHeaderField:@"Auth"];
    [request setHTTPMethod:@"GET"];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data != nil) {
            NSError *err;
            NSArray *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
            
            if (err == nil) {
                completionHandler(json, nil);
            } else {
                completionHandler(nil, @"Data is corrupt. Try again");
            }
        } else {
            NSLog(@"NetowrkErr: %@", error.debugDescription);
            completionHandler(nil, @"Problem connecting to server");
        }
        
    }] resume];
}
- (NSString *)anonymouslyLoginUser {
    if ([Lockbox unarchiveObjectForKey:@"uuid"] != nil) {
        [[HTTPService instance]loginUser:[Lockbox unarchiveObjectForKey:@"uuid"] :^(NSArray * _Nullable dataArray, NSString * _Nullable errMessage) {
            NSLog(@"RETURNING USER HAS BEEN LOGGED IN: %@",[Lockbox unarchiveObjectForKey:@"uuid"]);
        }];
    }
    return ([Lockbox unarchiveObjectForKey:@"uuid"]);
}
-(BOOL) downloadDataFromHerokuAndUploadToFirebase {
    [[HTTPService instance]getToDoItems:^(NSArray * _Nullable dataArray, NSString * _Nullable errMessage) {
        if (dataArray) {
            NSLog(@"DATA : %@", dataArray);
            for (NSDictionary *d in dataArray) {
                NSString *item = [d objectForKey:@"description"];
                BOOL completed = [[d objectForKey:@"completed"] boolValue];
                NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
                [dictionary setObject:item forKey:@"item"];
                [dictionary setObject: [NSNumber numberWithBool:completed] forKey:@"completed"];
                FIRDatabaseReference *ref;
                ref = [[FIRDatabase database] reference];
                [[[[ref child:@"users"] child:[Lockbox unarchiveObjectForKey:@"uuid"]] childByAutoId] setValue:dictionary];
            }
        } else if (errMessage) {
            //Display alert
        }
    }];
    return YES;
}
@end
