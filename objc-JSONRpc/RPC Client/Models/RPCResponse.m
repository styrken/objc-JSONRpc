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
@synthesize data = _data;
@synthesize result = _result;
@synthesize id = _id;

- (id) init
{
    self = [super init];
    
    if(self)
    {
        self.version = @"2.0";
        self.error = nil;
        self.data = [[[NSMutableData alloc] init] autorelease];
        self.result = nil;
        self.id = nil;
    }
    
    return self;
}


- (void) dealloc
{
    [_version release];
    [_error release];
    [_data release];
    [_result release];
    [_id release];
    [super dealloc];
}

@end
