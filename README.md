objc-JSONRpc
============

An objective-c 2.0 JSON RPC Client. Currently only supports json rpc version 2.0.

Todo:
* Support ARC (might be a problem since JSONKit does not support ARC at the moment)
* Test calls with parameters
* Add multicall support


How-To
-------------------------

Follow these simple steps:

* Add RPC Client folder from within this project to your project
* #import "JSONRPCClient.h"
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
```

