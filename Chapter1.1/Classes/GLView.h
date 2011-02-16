//
//  UIView.h
//  Chapter1.1
//
//  Created by Mario Gonzalez on 2/15/11.
//  Copyright 2011 Whale Island Games. All rights reserved.
//

#import <UIKit/UIKit.h>
// Book
#import <OpenGLES/EAGL.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>



@interface GLView : UIView
{
	EAGLContext	*m_context;
}

-(void) drawView;
@end