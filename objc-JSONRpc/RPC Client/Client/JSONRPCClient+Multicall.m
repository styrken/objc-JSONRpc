//
//  JSONRPCClient+Invoke.m
//  objc-JSONRpc
//
//  Created by Rasmus Styrk on 8/29/12.
//  Copyright (c) 2012 Rasmus Styrk. All rights reserved.
//

#import "JSONRPCClient+Multicall.h"
#import "JSONRPCClient+Invoke.h"
#import "JSONKit.h"

@implementation JSONRPCClient (Multicall)


- (void) batch:(RPCRequest*) request, ...
{
    va_list argument_list;
    
    NSMutableArray *tmpRequests = [[NSMutableArray alloc] init];
    
    if(request)
        [tmpRequests addObject:request];
    
    va_start(argument_list, request);
    
    RPCRequest *r;
    while((r = va_arg(argument_list, RPCRequest*)))
        [tmpRequests addObject:r];
    
    va_end(argument_list);
    
    if(tmpRequests.count == 1)
        [self invoke:[tmpRequests objectAtIndex:0]];
    else
    {
        NSMutableArray *serializedRequests = [[NSMutableArray alloc] initWithCapacity:tmpRequests.count];
        
        for(RPCRequest *r in tmpRequests)
            [serializedRequests addObject:[r serialize]];
                
        NSError *jsonError;
        NSData *payload = [serializedRequests JSONDataWithOptions:JKSerializeOptionNone error:&jsonError];
        [serializedRequests release];
                
        if(jsonError)
            NSLog(@"%@", [RPCError errorWithCode:RPCParseError]);
        else
        {
            for(RPCRequest *r in tmpRequests)
            {
                if(r.id)
                    [self.requests setObject:r forKey:r.id];
            }
            
            [self postData:payload];
        }
    }
    
    [tmpRequests release];
}

@end
