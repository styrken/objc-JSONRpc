//
//  JSONRPCClient+Notifications.m
//  objc-JSONRpc
//
//  Created by Rasmus Styrk on 03/09/12.
//  Copyright (c) 2012 Rasmus Styrk. All rights reserved.
//

#import "JSONRPCClient+Notification.h"

@implementation JSONRPCClient (Notification)

- (void) notify:(NSString *)method params:(id)params
{
    RPCRequest *request = [[RPCRequest alloc] init];
    request.method = method;
    request.params = params;
    request.id = @"";
    
    [self invoke:[request autorelease] onCompleted:nil];
}

- (void) notify:(NSString *)method
{
    [self notify:method params:nil];
}

@end
