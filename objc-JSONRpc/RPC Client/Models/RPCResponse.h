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
 * This object is returned when server responds or if errors accours
 *
 */
@interface RPCResponse : NSObject

/**
 * The used RPC Version. NB: Only some RPC services (like JSON RPC) supports this.
 *
 * @param NSString
 */
@property (nonatomic, retain) NSString *version;

/**
 * The id that was used in the request. Can be used to match response objects
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
 * The data passed back from the server in raw NSData format
 *
 * @param NSMuteableData
 */
@property (nonatomic, retain) NSMutableData *data;

/**
 * An object represneting the result from the method on the server
 * 
 * @param id
 */
@property (nonatomic, retain) id result;


#pragma mark - Methods

+ (id) responseWithError:(RPCError*)error;

@end
