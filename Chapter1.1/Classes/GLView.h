//
//  UIView.h
//  Chapter1.1
//
//  Created by Mario Gonzalez on 2/15/11.
//  Copyright 2011 Whale Island Games. All rights reserved.
//

#import "IRenderingEngine.hpp"
#import <QuartzCore/QuartzCore.h>

@interface GLView : UIView
{
	@private
	EAGLContext			*m_context;
	IRenderingEngine	*m_renderingEngine;
	float				m_timestamp;
}

- (void) drawView:(CADisplayLink*) displayLink;
- (void) didRotate:(NSNotification*) notification;
@end