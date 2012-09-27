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
@synthesize requests = _requests;

- (id) initWithServiceEndpoint:(NSString*) endpoint
{
    self = [super init];
    
    if(self)
    {
        self.serviceEndpoint = endpoint;
        self.requests = [[[NSMutableDictionary alloc] init] autorelease];
    }
    
    return self;
}

- (void) dealloc
{
    [_serviceEndpoint release];
    [_requests release];
    
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

#pragma mark - URL Connection delegates -

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    RPCRequest *request = [self.requests objectForKey:[NSNumber numberWithInt:(int)connection]];
    [request.data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    RPCRequest *request = [self.requests objectForKey:[NSNumber numberWithInt:(int)connection]];
    [request.data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    RPCRequest *request = [self.requests objectForKey: [NSNumber numberWithInt:(int)connection]];
    
    RPCError *error = nil;
    id result = [self parseResult:request.data error:&error];
    
    RPCResponse *response = [[RPCResponse alloc] init];
        
    if(error != nil)
        response.error = error;
    else
    {
        response.error = nil;
        response.result = result;
    }
    
    if(request.callback)
        request.callback([response autorelease]);
    else
        [response release];
    
    [self.requests removeObjectForKey: [NSNumber numberWithInt:(int)connection]];
    [connection release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    RPCRequest *request = [self.requests objectForKey:[NSNumber numberWithInt:(int)connection]];
    
    RPCResponse *response = [[RPCResponse alloc] init];
    response.error = [RPCError errorWithCode:RPCNetworkError];
    
    if(request.callback)
        request.callback([response autorelease]);
    else
        [response release];
    
    [self.requests removeObjectForKey: [NSNumber numberWithInt:(int)connection]];
    [connection release];
}

@end















