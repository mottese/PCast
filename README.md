PCast
==============

PCast is a ray caster written completely in Perl, no external libraries required. It is currently single-threaded, so it runs rather slowly. I have plans to optimize in the future. PCast produces .bmp files as output.

The set of features included right now are:

- Configurable image size
- Anti-aliasing with different sampling methods
  > Jittered sampling
- Configurable Camera
  > Position
  > Rotation
  > Zoom
  > Exposure
  > View Angle
- Geometric Objects 
  > Sphere
  > Plane
  > Box
- Lights and Shadows
  > Ambient lighting
  > Directional lighting
  > Point lighting
  > Area lighting
- BRDFs
  > Lambertian
  > Glossy Specular
- Materials
  > Matte
  > Phong
  > Light-Emitting


Here is a 1000x1000 pixel sample image showcasing Point and Ambient lighting illuminating a scene composed of a Matte sphere casting a shadow on a Phong sphere on top of a Phong plane. 9x anti-aliasing was used.

![sample](https://raw.github.com/mottese/PCast/master/images/shadows_big_aa9x.bmp)
