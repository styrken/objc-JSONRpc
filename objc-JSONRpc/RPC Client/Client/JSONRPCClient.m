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
@synthesize requestData = _requestData;

- (id) initWithServiceEndpoint:(NSString*) endpoint
{
    self = [super init];
    
    if(self)
    {
        self.serviceEndpoint = endpoint;
        self.requests = [[[NSMutableDictionary alloc] init] autorelease];
        self.requestData = [[[NSMutableDictionary alloc] init] autorelease];
    }
    
    return self;
}

- (void) dealloc
{
    [_serviceEndpoint release];
    [_requests release];
    [_requestData release];
    
    [super dealloc];
}

#pragma mark - Helpers

- (void) handleResult:(NSDictionary*)result forRequest:(RPCRequest*)request
{
    NSString *requestId = [result objectForKey:@"id"];
    NSDictionary *error = [result objectForKey:@"error"];
    NSString *version = [result objectForKey:@"version"];
    
    if(requestId)
    {
        RPCResponse *response = [[RPCResponse alloc] init];
        response.id = requestId;
        response.version = version;
        
        if(error)
        {
            if(error != nil && [error isKindOfClass:[NSDictionary class]])
            {
                response.error = [[[RPCError alloc] initWithCode:[[error objectForKey:@"code"] intValue]
                                                         message:[error objectForKey:@"message"]
                                                            data:[error objectForKey:@"data"]] autorelease];
            }
        }
        else
            response.result = [result objectForKey:@"result"];
        
        if(request.callback)
            request.callback([response autorelease]);
        else
            [response release];
    }
}

- (void) postRequests:(NSArray*)requests
{
    NSMutableArray *serializedRequests = [[NSMutableArray alloc] initWithCapacity:requests.count];
    
    for(RPCRequest *request in requests)
        [serializedRequests addObject:[request serialize]];
    
    NSError *jsonError;
    NSData *payload = [serializedRequests JSONDataWithOptions:JKSerializeOptionNone error:&jsonError];
    [serializedRequests release];
    
    if(jsonError != nil)
    {
        for(RPCRequest *request in requests)
        {
            if(request.callback)
                request.callback([RPCResponse responseWithError:[RPCError errorWithCode:RPCParseError]]);
        }
    }
    else
    {
        NSMutableURLRequest *serviceRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.serviceEndpoint]];
        [serviceRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [serviceRequest setValue:@"objc-JSONRpc/1.0" forHTTPHeaderField:@"User-Agent"];
        
        [serviceRequest setValue:[NSString stringWithFormat:@"%i", payload.length] forHTTPHeaderField:@"Content-Length"];
        [serviceRequest setHTTPMethod:@"POST"];
        [serviceRequest setHTTPBody:payload];
        
#ifndef __clang_analyzer__
        NSURLConnection *serviceEndpointConnection = [[NSURLConnection alloc] initWithRequest:serviceRequest delegate:self];
#endif
        
        NSMutableData *rData = [[NSMutableData alloc] init];
        [self.requestData setObject:rData forKey:[NSNumber numberWithInt:(int)serviceEndpointConnection]];
        [self.requests setObject:requests forKey:[NSNumber numberWithInt:(int)serviceEndpointConnection]];
        [rData release];
        [serviceRequest release];
    }
}

#pragma mark - URL Connection delegates -

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSMutableData *rdata = [self.requestData objectForKey: [NSNumber numberWithInt:(int)connection]];
    [rdata setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSMutableData *rdata = [self.requestData objectForKey: [NSNumber numberWithInt:(int)connection]];
    [rdata appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSMutableData *data = [self.requestData objectForKey: [NSNumber numberWithInt:(int)connection]];
    NSArray *requests = [self.requests objectForKey: [NSNumber numberWithInt:(int)connection]];
    
    if(data.length > 0)
    {
        NSError *jsonError = nil;
        id results = [data objectFromJSONDataWithParseOptions:JKParseOptionNone error:&jsonError];
        
        for(RPCRequest *request in requests)
        {
            if(jsonError != nil)
            {
                if(request.callback)
                    request.callback([RPCResponse responseWithError:[RPCError errorWithCode:RPCParseError]]);
            }
            else
            {
                for(NSDictionary *result in results)
                {
                    NSString *resultId = [result objectForKey:@"id"];
                    
                    if([resultId isEqualToString:request.id])
                    {
                        [self handleResult:result forRequest:request];
                        break;
                    }
                }
            }
        }
    }
 
    [self.requestData removeObjectForKey: [NSNumber numberWithInt:(int)connection]];
    [self.requests removeObjectForKey: [NSNumber numberWithInt:(int)connection]];
    [connection release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSArray *requests = [self.requests objectForKey: [NSNumber numberWithInt:(int)connection]];
    
    for(RPCRequest *request in requests)
    {
        if(request.callback)
            request.callback([RPCResponse responseWithError:[RPCError errorWithCode:RPCNetworkError]]);
    }
    
    [self.requestData removeObjectForKey: [NSNumber numberWithInt:(int)connection]];
    [self.requests removeObjectForKey: [NSNumber numberWithInt:(int)connection]];
    [connection release];
}

@end















