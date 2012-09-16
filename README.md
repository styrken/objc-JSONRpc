objc-JSONRpc
============

An objective-c 2.0 JSON RPC Client. Currently only supports json rpc version 2.0.

#### Todo:
* Support ARC (might be a problem since JSONKit does not support ARC at the moment)
* Test calls with parameters
* Add multicall support
* Add more invoke methods


How-To
-------------------------

Follow these simple steps:

* Add RPC Client folder from within this project to your project
* #import "JSONRPCClient+Invoke.h"
* Start doing calls
 
NB: Remove JSONKit either from this client or your project if you already uses it to avoid symbol conflicts.

```objective-c
    JSONRPCClient *rpc = [[JSONRPCClient alloc] initWithServiceEndpoint:@"... URL to your endpoint"];
    [rpc invoke:@"your method" params:nil onCompleted:^(RPCResponse *response) {
        
        NSLog(@"Respone: %@", response);
        NSLog(@"Error: %@", response.error);
        NSLog(@"Result: %@", response.result);
        
    }];
    [rpc release];
```

#### Invoking methods/requests

These methods is public when you have an instance of the RPC Client.

```objective-c
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

/**
 * Invokes a method against endpoint providing a way to define both a success callback and a failure callback.
 *
 * @param NSString method The method to invoke
 * @param id Either named or un-named parameter list (or nil)
 * @param RPCSuccessCallback A callback method to invoke when request finishes successfull
 * @param RPCFailedCallback A callback method to invoke when request finishes with an error
 * @return NSString The used request id. Can be used to match callback's if neccesary
 */
- (NSString *) invoke:(NSString*) method params:(id) params onSuccess:(RPCSuccessCallback)successCallback onFailure:(RPCFailedCallback)failedCallback;

```

#### Invoking notifications

You need to ````#import "JSONRPCClient+Notification.h"```` to add notification support to the JSONRPCClient. These methods are added to the class as a category.

````objective-c

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
````

##### Example of a notification

This could be used to keep a session alive on a webserver

````objective-c
  JSONRPCClient *rpc = [[JSONRPCClient alloc] initWithServiceEndpoint:@"..."];
  [rpc notify:@"keepAlive"];
  [rpc release];
````