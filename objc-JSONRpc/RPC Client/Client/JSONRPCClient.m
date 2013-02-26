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

- (void) postRequest:(RPCRequest*)request async:(BOOL)async
{
	[self postRequests:[NSArray arrayWithObject:request] async:async];
}

- (void) postRequests:(NSArray*)requests
{
	[self postRequests:requests async:YES];
}

- (void) postRequests:(NSArray *)requests async:(BOOL)async
{
    NSMutableArray *serializedRequests = [[NSMutableArray alloc] initWithCapacity:requests.count];
    
    for(RPCRequest *request in requests)
        [serializedRequests addObject:[request serialize]];
    
    NSError *jsonError;
    NSData *payload = [serializedRequests JSONDataWithOptions:JKSerializeOptionNone error:&jsonError];
    [serializedRequests release];
    
    if(jsonError != nil)
		[self handleFailedRequests:requests withRPCError:[RPCError errorWithCode:RPCParseError]];
    else
    {
        NSMutableURLRequest *serviceRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.serviceEndpoint]];
        [serviceRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [serviceRequest setValue:@"objc-JSONRpc/1.0" forHTTPHeaderField:@"User-Agent"];
        
        [serviceRequest setValue:[NSString stringWithFormat:@"%i", payload.length] forHTTPHeaderField:@"Content-Length"];
        [serviceRequest setHTTPMethod:@"POST"];
        [serviceRequest setHTTPBody:payload];

		if(async)
		{
#ifndef __clang_analyzer__
			NSURLConnection *serviceEndpointConnection = [[NSURLConnection alloc] initWithRequest:serviceRequest delegate:self];
#endif

			NSMutableData *rData = [[NSMutableData alloc] init];
			[self.requestData setObject:rData forKey:[NSNumber numberWithInt:(int)serviceEndpointConnection]];
			[self.requests setObject:requests forKey:[NSNumber numberWithInt:(int)serviceEndpointConnection]];
			[rData release];
			[serviceRequest release];
		}
		else
		{
			NSURLResponse *response = nil;
			NSError *error = nil;
			NSData *data = [NSURLConnection sendSynchronousRequest:serviceRequest returningResponse:&response error:&error];

			if(data != nil)
				[self handleData:data withRequests:requests];
			else
				[self handleFailedRequests:requests withRPCError:[RPCError errorWithCode:RPCNetworkError]];
		}
    }
}

- (RPCResponse*) sendSynchronousRequest:(RPCRequest *)request
{
	RPCResponse *response = [[RPCResponse alloc] init];

    NSError *jsonError = nil;
	NSData *payload = [[request serialize] JSONDataWithOptions:JKSerializeOptionNone error:&jsonError];

	if(jsonError == nil)
	{
		NSMutableURLRequest *serviceRequest = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.serviceEndpoint]];
		[serviceRequest setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
		[serviceRequest setValue:@"objc-JSONRpc/1.0" forHTTPHeaderField:@"User-Agent"];

		[serviceRequest setValue:[NSString stringWithFormat:@"%i", payload.length] forHTTPHeaderField:@"Content-Length"];
		[serviceRequest setHTTPMethod:@"POST"];
		[serviceRequest setHTTPBody:payload];

		NSURLResponse *serviceResponse = nil;
		NSError *error = nil;
		NSData *data = [NSURLConnection sendSynchronousRequest:serviceRequest returningResponse:&serviceResponse error:&error];

		if(data != nil)
		{
			jsonError = nil;
			id result = [data objectFromJSONDataWithParseOptions:JKParseOptionNone error:&jsonError];

			if(data.length == 0)
				response.error = [RPCError errorWithCode:RPCServerError];
			else if(jsonError)
				response.error = [RPCError errorWithCode:RPCParseError];
			else if([result isKindOfClass:[NSDictionary class]])
			{
				NSDictionary *error = [result objectForKey:@"error"];
				response.id = [result objectForKey:@"id"];
				response.version = [result objectForKey:@"version"];

				if(error && [error isKindOfClass:[NSDictionary class]])
					response.error = [RPCError errorWithDictionary:error];
				else
					response.result = [result objectForKey:@"result"];
			}
			else
				response.error = [RPCError errorWithCode:RPCParseError];
		}
		else
			response.error = [RPCError errorWithCode:RPCParseError];
	}
	else
		response.error = [RPCError errorWithCode:RPCParseError];
		
	return response;
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

	[self handleData:data withRequests:requests];
  
    [self.requestData removeObjectForKey: [NSNumber numberWithInt:(int)connection]];
    [self.requests removeObjectForKey: [NSNumber numberWithInt:(int)connection]];
    [connection release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSArray *requests = [self.requests objectForKey: [NSNumber numberWithInt:(int)connection]];

	[self handleFailedRequests:requests withRPCError:[RPCError errorWithCode:RPCNetworkError]];

    [self.requestData removeObjectForKey: [NSNumber numberWithInt:(int)connection]];
    [self.requests removeObjectForKey: [NSNumber numberWithInt:(int)connection]];
    [connection release];
}

#pragma mark - Handling of data

- (void) handleData:(NSData*)data withRequests:(NSArray*)requests
{
	NSError *jsonError = nil;
    id results = [data objectFromJSONDataWithParseOptions:JKParseOptionNone error:&jsonError];

    for(RPCRequest *request in requests)
    {
        if(request.callback == nil)
            continue;

        if(data.length == 0)
            request.callback([RPCResponse responseWithError:[RPCError errorWithCode:RPCServerError]]);
        else if(jsonError)
            request.callback([RPCResponse responseWithError:[RPCError errorWithCode:RPCParseError]]);
        else if([results isKindOfClass:[NSDictionary class]])
            [self handleResult:results forRequest:request];
        else if([results isKindOfClass:[NSArray class]])
        {
            for(NSDictionary *result in results)
            {
                NSString *requestId = [result objectForKey:@"id"];

                if([requestId isEqualToString:request.id])
                {
                    [self handleResult:result forRequest:request];
                    break;
                }
            }
        }
    }

}

- (void) handleFailedRequests:(NSArray*)requests withRPCError:(RPCError*)error
{
    for(RPCRequest *request in requests)
    {
        if(request.callback == nil)
            continue;

        request.callback([RPCResponse responseWithError:error]);
    }

}

- (void) handleResult:(NSDictionary*) result forRequest:(RPCRequest*)request
{
    if(!request.callback)
        return;

    NSString *requestId = [result objectForKey:@"id"];

    NSDictionary *error = [result objectForKey:@"error"];
    NSString *version = [result objectForKey:@"version"];

    RPCResponse *response = [[RPCResponse alloc] init];
    response.id = requestId;
    response.version = version;

    if(error && [error isKindOfClass:[NSDictionary class]])
        response.error = [RPCError errorWithDictionary:error];
    else
        response.result = [result objectForKey:@"result"];

    request.callback(response);

    [response release];
}

@end















