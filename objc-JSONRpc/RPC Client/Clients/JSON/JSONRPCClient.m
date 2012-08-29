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
    NSArray *methodKeys = nil;
    NSArray *methodObjs = nil;
    if (request.params)
    {
        methodKeys = [NSArray arrayWithObjects:@"jsonrpc", @"method", @"params", @"id", nil];
        methodObjs = [NSArray arrayWithObjects:request.version, request.method, request.params, request.id, nil];
    }
    else {
        methodKeys = [NSArray arrayWithObjects:@"jsonrpc", @"method", @"id", nil];
        methodObjs = [NSArray arrayWithObjects:request.version, request.method, request.id, nil];
    }
    
    NSDictionary *payload = [NSDictionary dictionaryWithObjects:methodObjs forKeys:methodKeys];
    
    NSError *jsonError;
    NSData *data = [payload JSONDataWithOptions:JKSerializeOptionNone error:&jsonError];
    
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
