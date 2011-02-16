//
//  Chapter1AppDelegate.h
//  Chapter1
//
//  Created by Mario Gonzalez on 2/15/11.
//  Copyright 2011 Whale Island Games. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Chapter1ViewController;

@interface Chapter1AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    Chapter1ViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet Chapter1ViewController *viewController;

@end

