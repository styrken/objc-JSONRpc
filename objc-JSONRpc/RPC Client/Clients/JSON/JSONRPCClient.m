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

@end
