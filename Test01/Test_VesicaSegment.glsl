// The MIT License
// Copyright © 2023 Inigo Quilez
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

// Distance to a vesica segment with 3 square roots, and to
// a vertival vesica segment with 2 square roots.
//
// 2D version here: https://www.shadertoy.com/view/cs2yzG
//
// List of other 3D SDFs:
//    https://www.shadertoy.com/playlist/43cXRl
// and 
//     https://iquilezles.org/articles/distfunctions

#define HW_PERFORMANCE 1

float sdVesicaSegment( in vec3 p, in vec3 a, in vec3 b, in float w )
{
    // orient and project to 2D
    vec3  c = (a+b)*0.5;
    float h = length(b-a);
    vec3  v = (b-a)/h;
    float y = dot(p-c,v);
    vec2  q = vec2(length(p-c-y*v),abs(y));
    
    // shape constants
    h *= 0.5;
    w *= 0.5;
    float d = 0.5*(h*h-w*w)/w;
    
    // feature selection (vertex or body)
    vec3  t = (h*q.x < d*(q.y-h)) ? vec3(0.0,h,0.0) : vec3(-d,0.0,d+w);
 
    // distance
    return length(q-t.xy) - t.z;
}

// specialization for a vertical vesica segment at the origin
float sdVerticalVesicaSegment( in vec3 p, in float h, in float w )
{
    // shape constants
    h *= 0.5;
    w *= 0.5;
    float d = 0.5*(h*h-w*w)/w;
    
    // project to 2D
    vec2  q = vec2(length(p.xz), abs(p.y-h));
    
    // feature selection (vertex or body)
    vec3  t = (h*q.x < d*(q.y-h)) ? vec3(0.0,h,0.0) : vec3(-d,0.0,d+w);
    
    // distance
    return length(q-t.xy) - t.z;
}

float map( in vec3 pos )
{
    vec3 a = vec3(-0.3,-0.4, 0.0);
    vec3 b = vec3( 0.3, 0.3, 0.0);

    // animate
    b = a + (b-a)*(1.0 + 0.2*sin(2.0*iTime) );
    float l = length(b-a);
    
    // keep volume constant (say it's a muscle)
    float w = sqrt(0.2/l);
    
    return sdVesicaSegment(pos, a, b, w*0.85 ) - w*0.15;

    // test vertical vesica segment
    // return sdVerticalVesicaSegment( pos-a, l, w*0.85 ) - w*0.15;

}

// https://iquilezles.org/articles/normalsSDF
vec3 calcNormal( in vec3 pos )
{
    vec2 e = vec2(1.0,-1.0)*0.5773;
    const float eps = 0.0005;
    return normalize( e.xyy*map( pos + e.xyy*eps ) + 
					  e.yyx*map( pos + e.yyx*eps ) + 
					  e.yxy*map( pos + e.yxy*eps ) + 
					  e.xxx*map( pos + e.xxx*eps ) );
}
    
#if HW_PERFORMANCE==0
#define AA 1
#else
#define AA 3
#endif

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
     // camera movement	
	float an = 0.1*sin(iTime);
	vec3 ro = vec3( 1.0*sin(an), 0.4, 1.0*cos(an) );
    vec3 ta = vec3( 0.0, 0.0, 0.0 );
    // camera matrix
    vec3 ww = normalize( ta - ro );
    vec3 uu = normalize( cross(ww,vec3(0.0,1.0,0.0) ) );
    vec3 vv = normalize( cross(uu,ww));

        
    vec3 tot = vec3(0.0);
    
#if AA>1
    for( int m=0; m<AA; m++ )
    for( int n=0; n<AA; n++ )
    {
        // pixel coordinates
        vec2 o = vec2(float(m),float(n)) / float(AA) - 0.5;
        vec2 p = (2.0*(fragCoord+o)-iResolution.xy)/iResolution.y;
#else    
        vec2 p = (2.0*fragCoord-iResolution.xy)/iResolution.y;
#endif

	    // create view ray
        vec3 rd = normalize( p.x*uu + p.y*vv + 1.5*ww );

        // raymarch
        const float tmax = 3.0;
        float t = 0.0;                                                                                                          
        Tzya00
        for( int i=0; i<256; i++ )
        {
            vec3 pos = ro + t*rd;
            float h = map(pos);
            if( h<0.0001 || t>tmax ) break;
            t += h;
        }
        
    
        // shading/lighting	
        vec3 col = vec3(0.0);
        if( t<tmax )
        {
            vec3 pos = ro + t*rd;
            vec3 nor = calcNormal(pos);
            float dif = clamp( dot(nor,vec3(0.57703)), 0.0, 1.0 );
            float amb = 0.5 + 0.5*dot(nor,vec3(0.0,1.0,0.0));
            col = vec3(0.2,0.3,0.4)*amb + vec3(0.8,0.7,0.5)*dif;
        }

        // gamma        
        col = sqrt( col );
	    tot += col;
#if AA>1
    }
    tot /= float(AA*AA);
#endif

	fragColor = vec4( tot, 1.0 );
}
