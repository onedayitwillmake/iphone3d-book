//
//  Shader.vsh
//  Chapter1
//
//  Created by Mario Gonzalez on 2/15/11.
//  Copyright 2011 Whale Island Games. All rights reserved.
//

attribute vec4 position;
attribute vec4 color;

varying vec4 colorVarying;

uniform float translate;

void main()
{
    gl_Position = position;
    gl_Position.y += sin(translate*0.5);

    colorVarying = color;
}
