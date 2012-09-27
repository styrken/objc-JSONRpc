//
//  RPCError.m
//  objc-JSONRpc
//
//  Created by Rasmus Styrk on 8/28/12.
//  Copyright (c) 2012 Rasmus Styrk. All rights reserved.
//

#import "RPCError.h"

@implementation RPCError
@synthesize code = _code;
@synthesize message = _message;
@synthesize data = _data;

- (id) initWithCode:(RPCErrorCode) code message:(NSString*) message data:(id)data
{
    self = [super init];
    
    if(self)
    {
        _code = code;
        _message = [message retain];
        _data = [data retain];
    }
    
    return self;
}

- (id) initWithCode:(RPCErrorCode) code
{
    NSString *message;
    
    switch (code) {
        case RPCParseError:
            message = @"Parse error";
            break;
        
        case RPCInternalError:
            message = @"Internal error";
            break;
            
        case RPCInvalidParams:
            message = @"Invalid params";
            break;
    
        case RPCInvalidRequest:
            message = @"Invalid Request";
            break;
        
        case RPCMethodNotFound:
            message = @"Method not found";
            break;
            
        case RPCNetworkError:
            message = @"Network error";
            break;
            
        case RPCServerError:
        default:
            message = @"Server error";
            break;
    }
    
    return [self initWithCode:code message:message data:nil];
}

+ (id) errorWithCode:(RPCErrorCode) code
{
    return [[[RPCError alloc] initWithCode:code] autorelease];
}

- (void) dealloc
{
    [_message release];
    [_data release];
    
    [super dealloc];
}

- (NSString*) description
{
    if(self.data != nil)
        return [NSString stringWithFormat:@"RPCError: %@ (%i): %@.", self.message, self.code, self.data];
    else
        return [NSString stringWithFormat:@"RPCError: %@ (%i).", self.message, self.code];
}

@end
