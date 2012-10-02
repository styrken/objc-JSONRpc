//
//  JSONRPCClient+Notifications.m
//  objc-JSONRpc
//
//  Created by Rasmus Styrk on 03/09/12.
//  Copyright (c) 2012 Rasmus Styrk. All rights reserved.
//

#import "JSONRPCClient+Notification.h"
#import "JSONRPCClient+Invoke.h"

#import "FixCategoryBug.h"

FIX_CATEGORY_BUG(JSONRPCClient_Notification)
@implementation JSONRPCClient (Notification)

- (void) notify:(NSString *)method params:(id)params
{
    RPCRequest *request = [[RPCRequest alloc] init];
    request.method = method;
    request.params = params;
    request.id = nil; // Id must be nil when sending notifications
    
    [self invoke:[request autorelease]];
}

- (void) notify:(NSString *)method
{
    [self notify:method params:nil];
}

@end
