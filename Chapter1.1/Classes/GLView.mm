//
//  UIView.mm
//  Chapter1.1
//
//  Created by Mario Gonzalez on 2/15/11.
//  Copyright 2011 Whale Island Games. All rights reserved.
//

#import "GLView.h"
#import <OpenGLES/ES2/gl.h> // <-- for GL_RENDERBUFFER only

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
		
		m_renderingEngine = CreateRenderer1();
		
		// Store render buffer
		[m_context renderbufferStorage:GL_RENDERBUFFER fromDrawable:eaglLayer];
		
		// Initialize engine
		m_renderingEngine->Initialize( CGRectGetWidth(frame), CGRectGetHeight(frame) );
		
		
		m_timestamp = CACurrentMediaTime();
		CADisplayLink *displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(drawView:)];
		[displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];

		[self drawView: displayLink]; // Draw inital
		
		// Recieve notifications about turning
		[[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
    }
    return self;
}

-(void) didRotate:(NSNotification *)notification
{
	UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
	m_renderingEngine->OnRotate( (DeviceOrientation) orientation );
	[self drawView: nil];
}
- (void) drawView:(CADisplayLink*) displayLink;

{
	if( displayLink != nil ) {
		float elapsedSeconds = displayLink.timestamp - m_timestamp;
		m_timestamp = displayLink.timestamp;
		m_renderingEngine->UpdateAnimation( elapsedSeconds );
	}
	
	m_renderingEngine->Render();
	[m_context presentRenderbuffer: GL_RENDERBUFFER];
}

- (void)dealloc {
	
	if( [ EAGLContext currentContext ] == m_context ) 
		[EAGLContext setCurrentContext:nil];
	
	[m_context release];
    [super dealloc];
}


@end
