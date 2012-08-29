//
//  BaseRPCClient+InvokeMethods.m
//  objc-JSONRpc
//
//  Created by Rasmus Styrk on 29/08/12.
//  Copyright (c) 2012 Rasmus Styrk. All rights reserved.
//

#import "BaseRPCClient+InvokeMethods.h"

@implementation BaseRPCClient (InvokeMethods)

- (NSString *) invoke:(RPCRequest*) request onCompleted:(RPCCompletedCallback)callback
{
    if(request.id == nil)
        request.id = [[NSNumber numberWithInt:arc4random()] stringValue];
    
    RPCResponse *response = [[RPCResponse alloc] init];
    response.id = request.id;
    
    RPCError *error = nil;
    NSData *payload = [self serializeRequest:request error:&error];
    
    if(error != nil && (response.error = error))
        callback(response);
    else
    {
        NSMutableURLRequest *serviceRequest = [NSMutableURLRequest requestWithURL: [NSURL URLWithString:self.serviceEndpoint]];
        [serviceRequest setValue:[self contentType] forHTTPHeaderField:@"Content-Type"];
        [serviceRequest setValue:@"objc-JSONRpc/1.0" forHTTPHeaderField:@"User-Agent"];
        
        [serviceRequest setValue:[NSString stringWithFormat:@"%i", payload.length] forHTTPHeaderField:@"Content-Length"];
        [serviceRequest setHTTPMethod:@"POST"];
        [serviceRequest setHTTPBody:payload];
        
        NSURLConnection *serviceEndpointConnection = [[NSURLConnection alloc] initWithRequest:serviceRequest delegate:self];
        
        [self.connections setObject:response forKey:[NSNumber numberWithInt:(int)serviceEndpointConnection]];
        [self.callbacks setObject:[callback copy] forKey:[NSNumber numberWithInt:(int)serviceEndpointConnection]];
    }
    
    [response release];
    [callback release];
    
    return request.id;
}

- (NSString *) invoke:(NSString *)method params:(id)params onCompleted:(RPCCompletedCallback)callback
{
    RPCRequest *request = [[RPCRequest alloc] init];
    request.method = method;
    request.params = params;
    
    return [self invoke:[request autorelease] onCompleted:callback];
}

- (NSString *) invoke:(NSString*) method params:(id) params onSuccess:(RPCSuccessCallback)successCallback onFailure:(RPCFailedCallback)failedCallback
{
    return [self invoke:method params:params onCompleted:^(RPCResponse *response) {

        if(response.error)
            failedCallback(response.error);
        else
            successCallback(response);
    }];
}

@end
