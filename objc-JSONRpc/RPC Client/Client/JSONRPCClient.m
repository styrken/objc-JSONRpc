//
//  RPCJSONClient.m
//  objc-JSONRpc
//
//  Created by Rasmus Styrk on 8/28/12.
//  Copyright (c) 2012 Rasmus Styrk. All rights reserved.
//

#import "JSONRPCClient.h"
#import "JSONKit.h"

@implementation JSONRPCClient

@synthesize serviceEndpoint = _serviceEndpoint;
@synthesize connections = _connections;
@synthesize callbacks = _callbacks;

- (id) initWithServiceEndpoint:(NSString*) endpoint
{
    self = [super init];
    
    if(self)
    {
        self.serviceEndpoint = endpoint;
        self.connections = [[[NSMutableDictionary alloc] init] autorelease];
        self.callbacks = [[[NSMutableDictionary alloc] init] autorelease];
    }
    
    return self;
}

- (void) dealloc
{
    [_serviceEndpoint release];
    [_connections release];
    [_callbacks release];
    
    [super dealloc];
}


- (NSData*) serializeRequest:(RPCRequest *)request error:(RPCError **) error
{
    request.version = @"2.0";
    
    NSMutableDictionary *payload = [[NSMutableDictionary alloc] init];
    
    if(request.version)
        [payload setObject:request.version forKey:@"jsonrpc"];
    
    if(request.method)
        [payload setObject:request.method forKey:@"method"];
    
    if(request.params)
        [payload setObject:request.params forKey:@"params"];
    
    if(request.id != nil && request.id.length > 0)
        [payload setObject:request.id forKey:@"id"];
    
    
    NSLog(@"payload: %@", payload);
    
    NSError *jsonError;
    NSData *data = [payload JSONDataWithOptions:JKSerializeOptionNone error:&jsonError];
    [payload release];
    
    if(jsonError != nil)
        *error = [RPCError errorWithCode:RPCParseError];
    
    return data;
}

- (id) parseResult:(NSData*) data error:(RPCError **) error
{
    NSError *jsonError = nil;
    NSDictionary *jsonResult = [data objectFromJSONDataWithParseOptions:JKParseOptionNone error:&jsonError];
    
    if(jsonError != nil)
        *error = [[RPCError alloc] initWithCode:RPCParseError];
    else
    {
        NSDictionary *serverError = [jsonResult objectForKey:@"error"];
        if(serverError != nil && [serverError isKindOfClass:[NSDictionary class]])
        {
            *error = [[[RPCError alloc] initWithCode:[[serverError objectForKey:@"code"] intValue] message:[serverError objectForKey:@"message"] data:[serverError objectForKey:@"data"]] autorelease];
        }
    }
    
    return [jsonResult objectForKey:@"result"];
}

- (NSString*) contentType
{
    return @"application/json";
}

#pragma mark - URL Connection delegates -

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    RPCResponse *rpcresponse = [self.connections objectForKey: [NSNumber numberWithInt:(int)connection]];
    [rpcresponse.data setLength:0];
}


- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    RPCResponse *rpcresponse = [self.connections objectForKey: [NSNumber numberWithInt:(int)connection]];
    [rpcresponse.data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    RPCResponse *rpcresponse = [self.connections objectForKey: [NSNumber numberWithInt:(int)connection]];
    RPCCompletedCallback callback = [self.callbacks objectForKey: [NSNumber numberWithInt:(int)connection]];
    
    NSString *test = [[NSString alloc] initWithData:rpcresponse.data encoding:NSUTF8StringEncoding];
    
    NSLog(@"String: %@", test);
    
    RPCError *error = nil;
    id result = [self parseResult:rpcresponse.data error:&error];
    
    if(error != nil)
        rpcresponse.error = error;
    else
    {
        rpcresponse.error = nil;
        rpcresponse.result = result;
    }
    
    if(callback)
        callback(rpcresponse);
    
    [self.connections removeObjectForKey: [NSNumber numberWithInt:(int)connection]];
    [self.callbacks removeObjectForKey: [NSNumber numberWithInt:(int)connection]];
    [connection release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    RPCResponse *rpcresponse = [self.connections objectForKey: [NSNumber numberWithInt:(int)connection]];
    RPCCompletedCallback callback = [self.callbacks objectForKey: [NSNumber numberWithInt:(int)connection]];
    
    rpcresponse.error = [RPCError errorWithCode:RPCNetworkError];
    
    if(callback)
        callback(rpcresponse);
    
    [self.connections removeObjectForKey: [NSNumber numberWithInt:(int)connection]];
    [self.callbacks removeObjectForKey: [NSNumber numberWithInt:(int)connection]];
    [connection release];
}

@end
