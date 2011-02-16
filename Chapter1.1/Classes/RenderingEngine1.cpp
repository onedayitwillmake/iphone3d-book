/*
 *  RenderingEngine1.cpp
 *  Chapter1.1
 *
 *  Created by Mario Gonzalez on 2/16/11.
 *  Copyright 2011 Ogilvy & Mather. All rights reserved.
 *
 */
#include <OpenGLES/ES1/gl.h>
#include <OpenGLES/ES1/glext.h>
#include "IRenderingEngine.hpp"

static const float RevelutionsPerSecond = 0.25;
struct Vertex {
	float Position[2];
	float Color[4];
};

// Define the positions and colors of the two triangles
const Vertex Vertices[] = {
	{{-0.5, -0.8666},	{1, 1, 0.5f, 1}},
	{{0.5, -0.8666},	{1, 1, 0.5f, 1}},
	{{0, 1},			{1, 1, 0.5f, 1}},
	{{-0.5, -0.8666},	{0.5f, 0.5f, 0.5f, 0.5f}},
	{{0.5, -0.8666},	{0.5f, 0.5f, 0.5f, 0.5f}},
	{{0, 0.4},			{0.5f, 0.5f, 0.5f, 0.5f}},
};


class RenderingEngine1 : public IRenderingEngine {
public:
	RenderingEngine1();
	void Initialize( int width, int height );
	void Render() const;
	void UpdateAnimation( float timeStep );
	void OnRotate( DeviceOrientation newOrientation );
private:
	float	RotationDirection() const;
	float	m_currentAngle;
	float	m_desiredAngle;
	GLuint	m_framebuffer;
	GLuint	m_renderbuffer;
};

IRenderingEngine* CreateRenderer1()
{
	return new RenderingEngine1();
};

// Constructor
RenderingEngine1::RenderingEngine1()
{
	glGenRenderbuffersOES(1, &m_renderbuffer);
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, m_renderbuffer);
}
void RenderingEngine1::Initialize(int width, int height)
{
	// Create teh framebuffer object and attach the color buffer
	glGenFramebuffersOES( 1, &m_framebuffer);
	glBindFramebufferOES( GL_FRAMEBUFFER_OES, m_framebuffer);
	glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, m_renderbuffer);
	glViewport(0, 0, width, height);
	glMatrixMode( GL_PROJECTION );
	
	// Initialize the projection matrix
	const float maxX = 2;
	const float maxY = 3;
	glOrthof(-maxX, +maxX, -maxY, +maxY, -1, 1);
	glMatrixMode( GL_MODELVIEW );
	
	OnRotate( DeviceOrientationPortrait );
	m_currentAngle = m_desiredAngle;
}

float RenderingEngine1::RotationDirection() const
{
	float delta = m_desiredAngle - m_currentAngle;
	if( delta == 0 )
		return 0;
	
	bool counterclockwise = ( (delta > 0 && delta <= 180) || (delta < -180) );
	return counterclockwise ? +1 : -1;
}

void RenderingEngine1::UpdateAnimation( float timeStep )
{
	float direction = RotationDirection();
	if( direction == 0 )
		return;
	
	float degrees = timeStep * 360 * RevelutionsPerSecond;
	m_currentAngle += degrees * direction;
	
	// Wrap 360
	if(m_currentAngle >= 360)
		m_currentAngle -= 360;
	else if(m_currentAngle < 0) 
		m_currentAngle += 360;
	
	// If the rotation changed, then we vershoot the desired angle
	if( RotationDirection() != direction ) {
		m_currentAngle = m_desiredAngle;
	}
}
void RenderingEngine1::OnRotate( DeviceOrientation orientation )
{
	float angle = 0;
	switch (orientation) {
		case DeviceOrientationLandscapeLeft:
			angle = 270;
			break;
		case DeviceOrientationPortraitUpsideDown:
			angle = 180;
			break;
		case DeviceOrientationLandscapeRight:
			angle = 90;
			break;
		default:
			break;
	}
	
	m_desiredAngle = angle;
}
void RenderingEngine1::Render() const
{
	glClearColor(0.2f, 0.2f, 0.2f, 0.2f);
	glClear( GL_COLOR_BUFFER_BIT );
	
	glPushMatrix();
	glRotatef(m_currentAngle, 0, 0, 1);
	
		glEnableClientState( GL_VERTEX_ARRAY );
		glEnableClientState( GL_COLOR_ARRAY );
		
		glVertexPointer( 2, GL_FLOAT, sizeof(Vertex), &Vertices[0].Position[0] );
		glColorPointer(4, GL_FLOAT, sizeof(Vertex), &Vertices[0].Color[0]);
		
		GLsizei	vertexCount = sizeof(Vertices) / sizeof(Vertex);
		glDrawArrays( GL_TRIANGLES, 0, vertexCount);
		
		glDisableClientState( GL_VERTEX_ARRAY );
		glDisableClientState( GL_COLOR_ARRAY );
		
	glPopMatrix();
}

