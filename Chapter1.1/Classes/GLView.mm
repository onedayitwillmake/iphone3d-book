//
//  UIView.mm
//  Chapter1.1
//
//  Created by Mario Gonzalez on 2/15/11.
//  Copyright 2011 Whale Island Games. All rights reserved.
//

const bool ForceES1 = false;

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
		
		// Try to load OpenGLES 2.0
		EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
		m_context = [[EAGLContext alloc] initWithAPI:api];
		
		// Try to load OpenGLES 1.1
		if(!m_context || ForceES1) {
			api = kEAGLRenderingAPIOpenGLES1;
			m_context = [[EAGLContext alloc] initWithAPI: api];
		}
		
		// Couldn't load either. exit
		if(!m_context || ![EAGLContext setCurrentContext:m_context]) {
			[self release];
			return nil;
		}
		
		// Create the renderer
		if( api == kEAGLRenderingAPIOpenGLES1 ) {
			NSLog(@"Using OpenGL ES 1.1");
			m_renderingEngine = CreateRenderer1();
		} else {
			NSLog(@"Using OpenGL ES 2.0");
			m_renderingEngine = CreateRenderer2();
		}
		
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
