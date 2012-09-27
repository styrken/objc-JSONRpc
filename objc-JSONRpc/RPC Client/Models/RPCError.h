//
//  RPCError.h
//  objc-JSONRpc
//
//  Created by Rasmus Styrk on 8/28/12.
//  Copyright (c) 2012 Rasmus Styrk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Reserved rpc errors
typedef enum {
    RPCParseError = -32700,
    RPCInvalidRequest = -32600,
    RPCMethodNotFound = -32601,
    RPCInvalidParams = -32602,
    RPCInternalError = -32603,
    RPCServerError = 32000,
    RPCNetworkError = 32001
} RPCErrorCode;

/**
 * RPCError.
 *
 * If any error accours this object will be passed around with a code, a message and maybe! some data (if the server supports it)
 *
 */
@interface RPCError : NSObject

#pragma mark - Properties -
/**
 * RPC Error code. Simpe enough?
 *
 * @param RPCErrorCode
 */
@property (nonatomic, readonly) RPCErrorCode code;

/**
 * RPC Error message - just in plain english
 *
 * @param NSString
 */
@property (nonatomic, readonly, retain) NSString *message;

/**
 * If the server supports sending debug data when server errors accours, it will be stored here
 *
 * @param id
 */
@property (nonatomic, readonly, retain) id data;

#pragma mark - Methods

// These methods is self explaining.. right?
- (id) initWithCode:(RPCErrorCode) code;
- (id) initWithCode:(RPCErrorCode) code message:(NSString*) message data:(id)data;
+ (id) errorWithCode:(RPCErrorCode) code;

@end
