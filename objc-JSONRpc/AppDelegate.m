//
//  AppDelegate.m
//  objc-JSONRpc
//
//  Created by Rasmus Styrk on 8/28/12.
//  Copyright (c) 2012 Rasmus Styrk. All rights reserved.
//

#import "AppDelegate.h"
#import "JSONRPCClient+Invoke.h" // To allow use of invokes 
#import "JSONRPCClient+Notification.h" // To allow use of notifications
#import "JSONRPCClient+Multicall.h" // Add multicall support

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Standard stuff
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // RPC Test
    JSONRPCClient *rpc = [[JSONRPCClient alloc] initWithServiceEndpoint:@"http://..."];
    
    [rpc invoke:@"getAppleProductIdentifiers" params:nil onCompleted:^(RPCResponse *response) {
        
        NSLog(@"getAppleProductIdentifiers");
        NSLog(@"Respone: %@", response);
        NSLog(@"Error: %@", response.error);
        NSLog(@"Result: %@", response.result);
        
    }];
    
    [rpc invoke:@"validateAppleReceipt" params:nil onSuccess:^(RPCResponse *response) {
        
        NSLog(@"validateAppleReceipt");
        NSLog(@"Respone: %@", response);
        NSLog(@"Result: %@", response.result);
                                    
                                    
     } onFailure:^(RPCError *error) {
         
        NSLog(@"validateAppleReceipt");
        NSLog(@"Error: %@", error);
         
    }];
    
    [rpc notify:@"helloWorld"];
    
    [rpc batch:[RPCRequest requestWithMethod:@"helloWorld" params:nil callback:^(RPCResponse *response) {
        NSLog(@"Multicall Response is: %@", response);
        NSLog(@"Multicall Response error: %@", response.error);
        
    }], [RPCRequest requestWithMethod:@"helloWorld"], [RPCRequest requestWithMethod:@"helloWorld"], nil];

	[rpc postRequest:[RPCRequest requestWithMethod:@"helloWorld" params:nil callback:^(RPCResponse *response) {
        NSLog(@"Sync request: %@", response);
        NSLog(@"Sync request error: %@", response.error);

    }] async:NO];


    [rpc release];


    
    
    self.window.rootViewController = [[[UIViewController alloc] init] autorelease];
    
    return YES;
}

@end
