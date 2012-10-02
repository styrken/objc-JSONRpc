//
//  JSONRPCClient+Notifications.h
//  objc-JSONRpc
//
//  Created by Rasmus Styrk on 03/09/12.
//  Copyright (c) 2012 Rasmus Styrk. All rights reserved.
//

#import "JSONRPCClient.h"

/**
 * Notificiation
 *
 * - Implements a way to use notifications in json rpc client. 
 *
 * Its important to understand that notifications does not  * allow using callbacks and therefor you 
 * need to make sure you call your server in the right way since there is no telling if * your notification was 
 * successfull or not.
 */
@interface JSONRPCClient (Notification)

/**
 * Sends a notification to json rpc server.
 *
 * @param NSString method Method to call
 */
- (void) notify:(NSString *)method;

/**
 * Sends a notification to json rpc server.
 *
 * @param NSString method Method to call
 * @param id Either named or un-named parameter list (or nil)
 */
- (void) notify:(NSString *)method params:(id)params;

@end
