//
//  Chapter1_1AppDelegate.h
//  Chapter1.1
//
//  Created by Mario Gonzalez on 2/15/11.
//  Copyright 2011 Whale Island Games. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GLView.h"

@interface Chapter1_1AppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	GLView *_glView;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) GLView	*_glView;
@end

