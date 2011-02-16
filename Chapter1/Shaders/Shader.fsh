//
//  Shader.fsh
//  Chapter1
//
//  Created by Mario Gonzalez on 2/15/11.
//  Copyright 2011 Whale Island Games. All rights reserved.
//

varying lowp vec4 colorVarying;

void main()
{
    gl_FragColor = colorVarying;
}
