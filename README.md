PCast
==============

PCast is an object-oriented ray caster written completely in Perl, no external libraries required. It is currently unoptimized, so it runs rather slowly. I have plans to optimize in the future. PCast produces .bmp files as output.

The set of features included right now are:

- Configurable image size
- Anti-aliasing with different sampling methods
  - Jittered sampling
  - Multi-jittered sampling
  - Hammersley sampling (in progress)
- Configurable Camera
  - Position
  - Rotation
  - Zoom
  - Exposure
  - View Angle
  - Lens Radius
  - Focal Distance
- Geometric Objects 
  - Sphere
  - Plane
  - Box
  - Triangle Meshes
  - Smooth Triangle Meshes (in progress)
- Lights and Shadows
  - Ambient lighting
  - Directional lighting
  - Point lighting
  - Area Lighting (in progress)
- BRDFs
  - Lambertian
  - Glossy Specular
  - Perfect Specular
- Materials
  - Matte
  - Phong
  - Reflective
  - Light-emitting (in progress)
  - Trasnparent (in progress)
