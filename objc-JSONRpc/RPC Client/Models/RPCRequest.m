//
//  RPCRequest.m
//  objc-JSONRpc
//
//  Created by Rasmus Styrk on 8/28/12.
//  Copyright (c) 2012 Rasmus Styrk. All rights reserved.
//

#import "RPCRequest.h"

@implementation RPCRequest
@synthesize version = _version;
@synthesize method = _method;
@synthesize params = _params;
@synthesize id = _id;
@synthesize callback = _callback;
@synthesize data = _data;

- (id) init
{
    self = [super init];
    
    if(self)
    {
        self.version = nil;
        self.method = nil;
        self.params = nil;
        self.id = nil;
        self.callback = nil;
        self.data = [[[NSMutableData alloc] init] autorelease];
    }
    
    return self;
}

+ (id) requestWithMethod:(NSString*) method params:(id) params
{
    RPCRequest *request = [[RPCRequest alloc] init];
    request.method = method;
    request.params = params;
    
    return [request autorelease];
}

+ (id) requestWithMethod:(NSString*) method params:(id) params callback:(RPCRequestCallback)callback
{
    RPCRequest *request = [[RPCRequest alloc] init];
    request.method = method;
    request.params = params;
    request.callback = callback;
    
    return [request autorelease];
}

- (void) dealloc
{
    [_version release];
    [_method release];
    [_params release];
    [_id release];
    [_callback release];
    [_data release];
    
    [super dealloc];
}

@end
