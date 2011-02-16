//
//  UIView.mm
//  Chapter1.1
//
//  Created by Mario Gonzalez on 2/15/11.
//  Copyright 2011 Whale Island Games. All rights reserved.
//

#import "GLView.h"


@implementation GLView

+(Class) layerClass
{
	return [CAEAGLLayer class];
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		
		CAEAGLLayer *eaglLayer = (CAEAGLLayer*) super.layer;
		eaglLayer.opaque = YES;
		
		m_context = [[EAGLContext alloc] initWithAPI: kEAGLRenderingAPIOpenGLES1];
		
		if(!m_context || ![EAGLContext setCurrentContext:m_context]) {
			[self release];
			return nil;
		}
		
        // Initialization code.
		GLuint framebuffer, renderbuffer;
		glGenFramebuffersOES(1, &framebuffer);
		glGenRenderbuffersOES(1, &renderbuffer);
		
		// Bind
		glBindFramebufferOES(GL_FRAMEBUFFER_OES, framebuffer);
		glBindRenderbufferOES(GL_RENDERBUFFER_OES, renderbuffer);
		
		// Store in context
		[m_context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:eaglLayer];
		glFramebufferRenderbufferOES( GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, renderbuffer);
		glViewport( 0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame) );
		
		// Draw inital
		[self drawView];
    }
    return self;
}

-(void) drawView
{
	glClearColor(0.5f, 0.5f, 0.5f, 0.5f);
	glClear( GL_COLOR_BUFFER_BIT );
	[m_context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

- (void)dealloc {
	
	if( [ EAGLContext currentContext ] == m_context ) 
		[EAGLContext setCurrentContext:nil];
	
	[m_context release];
    [super dealloc];
}


@end
