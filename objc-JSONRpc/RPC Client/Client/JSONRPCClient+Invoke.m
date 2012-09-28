//
//  JSONRPCClient+Invoke.m
//  objc-JSONRpc
//
//  Created by Rasmus Styrk on 9/16/12.
//  Copyright (c) 2012 Rasmus Styrk. All rights reserved.
//

#import "JSONRPCClient+Invoke.h"
#import "JSONKit.h"

@implementation JSONRPCClient (Invoke)

- (NSString *) invoke:(RPCRequest*) request
{    
    NSError *jsonError;
    NSData *payload = [[request serialize] JSONDataWithOptions:JKSerializeOptionNone error:&jsonError];
    
    if(request.callback != nil && jsonError != nil)
        request.callback([RPCError errorWithCode:RPCParseError]);
    else
    {
        if(request.id)
            [self.requests setObject:request forKey:request.id];
        
        [self postData:payload];
    }
        
    return request.id;
}

- (NSString *) invoke:(NSString *)method params:(id)params onCompleted:(RPCRequestCallback)callback
{
    RPCRequest *request = [[RPCRequest alloc] init];
    request.method = method;
    request.params = params;
    request.callback = callback;
            
    return [self invoke:[request autorelease]];
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
