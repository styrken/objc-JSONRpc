//
//  BaseRPCClient+InvokeMethods.h
//  objc-JSONRpc
//
//  Created by Rasmus Styrk on 29/08/12.
//  Copyright (c) 2012 Rasmus Styrk. All rights reserved.
//

#import "BaseRPCClient.h"

/**
 * This category class adds invoking of methods to the base RPC Class.
 *
 *
 */
@interface BaseRPCClient (InvokeMethods)

/**
 * Invokes a RPCRequest against the end point
 *
 * @param RPCRequest reqeust The request to invoke
 * @param RPCCompletedCallback A callback method to invoke when request is done (or any error accours)
 * @return NSString The used request id. Can be used to match callback's if neccesary
 */
- (NSString *) invoke:(RPCRequest*) request onCompleted:(RPCCompletedCallback)callback;

/**
 * Invokes a method against the end point
 *
 * @param NSString method The method to invoke
 * @param id Either named or un-named parameter list (or nil)
 * @param RPCCompletedCallback A callback method to invoke when request is done (or any error accours)
 * @return NSString The used request id. Can be used to match callback's if neccesary
 */
- (NSString *) invoke:(NSString*) method params:(id) params  onCompleted:(RPCCompletedCallback)callback;

@end
