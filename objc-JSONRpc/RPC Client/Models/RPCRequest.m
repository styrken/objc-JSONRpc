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
@synthesize callback = _callback;
@synthesize id = _id;

- (id) init
{
    self = [super init];
    
    if(self)
    {
        self.version = @"2.0";
        self.method = nil;
        self.params = nil;
        self.callback = nil;
        
        self.id = [[NSNumber numberWithInt:arc4random()] stringValue];
    }
    
    return self;
}

+ (id) requestWithMethod:(NSString*) method
{
    RPCRequest *request = [[RPCRequest alloc] init];
    request.method = method;
    
    return [request autorelease];
}

+ (id) requestWithMethod:(NSString*) method params:(id) params
{
    RPCRequest *request = [[self requestWithMethod:method] retain];
    request.params = params;
    
    return [request autorelease];
}

+ (id) requestWithMethod:(NSString*) method params:(id) params callback:(RPCRequestCallback)callback
{
    RPCRequest *request = [[self requestWithMethod:method params:params] retain];
    request.callback = callback;
    
    return [request autorelease];
}

- (NSMutableDictionary*) serialize
{
    NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
    
    if(self.version)
        [payload setObject:self.version forKey:@"jsonrpc"];
    
    if(self.method)
        [payload setObject:self.method forKey:@"method"];
    
    if(self.params)
        [payload setObject:self.params forKey:@"params"];
    
    if(self.id)
        [payload setObject:self.id forKey:@"id"];
    
    return [payload autorelease];
}

- (void) dealloc
{
    [_version release];
    [_method release];
    [_params release];
    [_id release];
    [_callback release];
    
    [super dealloc];
}

@end
