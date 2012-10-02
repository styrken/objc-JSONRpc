//
//  RPCResponse.h
//  objc-JSONRpc
//
//  Created by Rasmus Styrk on 8/28/12.
//  Copyright (c) 2012 Rasmus Styrk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RPCError.h"

/**
 * RPC Resposne object
 *
 * This object is created when the server responds. 
 */
@interface RPCResponse : NSObject

/**
 * The used RPC Version. 
 *
 * @param NSString
 */
@property (nonatomic, retain) NSString *version;

/**
 * The id that was used in the request.
 *
 * @param NSString
 */
@property (nonatomic, retain) NSString *id;

/**
 * RPC Error. If != nil it means there was an error
 *
 * @return RPCError
 */
@property (nonatomic, retain) RPCError *error;

/**
 * An object represneting the result from the method on the server
 * 
 * @param id
 */
@property (nonatomic, retain) id result;


#pragma mark - Methods

/**
 * Helper method to get an autoreleased RPCResponse object with an error set
 *
 * @param RPCError error The error for the response
 * @return RPCRequest
 */
+ (id) responseWithError:(RPCError*)error;

@end
