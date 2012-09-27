//
//  RPCResponse.m
//  objc-JSONRpc
//
//  Created by Rasmus Styrk on 8/28/12.
//  Copyright (c) 2012 Rasmus Styrk. All rights reserved.
//

#import "RPCResponse.h"

@implementation RPCResponse
@synthesize version = _version;
@synthesize error = _error;
@synthesize result = _result;
@synthesize id = _id;

- (id) init
{
    self = [super init];
    
    if(self)
    {
        self.version = nil;
        self.error = nil;
        self.result = nil;
        self.id = nil;
    }
    
    return self;
}

+ (id) responseWithError:(RPCError*)error
{
    RPCResponse *response = [[RPCResponse alloc] init];
    response.error = error;
    
    return [response autorelease];
}

- (void) dealloc
{
    [_version release];
    [_error release];
    [_result release];
    [_id release];
    [super dealloc];
}

@end
