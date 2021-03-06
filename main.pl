#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/cameras";
use lib "$Bin/lights";
use lib "$Bin/materials";
use lib "$Bin/brdfs";
use lib "$Bin/objects";
use lib "$Bin/objects/primitives";
use lib "$Bin/objects/triangles";
use lib "$Bin/samplers";
use lib "$Bin/utilities";
use lib "$Bin/tracers";

use Constants;
use World;
use BMP;
use Triple;
use Sphere;
use Ray;
use ShadeRec;
use BasicTracer;
use WhittedTracer;
use AreaLighting;
use PinholeCamera;
use ThinLens;
use Box;
use Matte;
use Reflective;
use Lambertian;
use Ambient;
use Point;
use Plane;
use Rectangle;
use Directional;
use GlossySpecular;
use Phong;
use Jittered;
use Emissive;
use Area;
use Mesh;
use FlatMeshTriangle;
use MeshObject;
use Matrix;

# print buffers to insure messages go to screen quickly
my $console = select(STDOUT);
$| = 1;
select($console);

thinlens();


sub thinlens {
  my $hres = 400;
  my $vres = 400;
  my $pixel_size = 0.5;
  my $num_samples = 9;
  my $lens_radius = 10;
  my $focal_plane_distance = 100;
  my $sampler = new Sampler::MultiJittered($num_samples);
  my $eye = new Triple(0, 0, -100);
  my $look_at = new Triple(0, 0, 0);
  my $distance_to_viewplane = 40;
  my $up = new Triple(0, 1, 0);
  my $roll_angle = $main::pi * 0; #in radians
  my $zoom = 2;
  my $exposure_time = 1;
  my $max_depth = 0;
  my $file_name = "thinlens";
  
  my $camera = new Camera::ThinLens($hres, $vres, $pixel_size, $sampler, $eye, $distance_to_viewplane,
    $focal_plane_distance, $lens_radius, $up, $look_at, $roll_angle, $zoom, $exposure_time, $max_depth);
  my $background = new Triple(0, 0, 0);
  my $ambient = new Light::Ambient(0.5, new Triple(255, 255, 255));
  my $world = new World($background, $ambient, $camera);
  my $tracer = new Tracer::WhittedTracer($world);
  $world->tracer($tracer);

  my $pointlight1 = new Light::Point(3.0, new Triple(255, 255, 255), new Triple(100, 100, -100));

  $world->add_light($pointlight1);
  
  my $a = 0.75; #scaling factor for yellow, orange, and light green
  my $yellow = new Triple($a * 1, $a * 1, 0);  #yellow
  my $brown = new Triple(0.71, 0.40, 0.16);	 #brown
  my $dark_green = new Triple(0.0, 0.41, 0.41);	 #dark_green
  my $orange = new Triple($a * 1, $a * 0.75, 0);  #orange
  my $green = new Triple(0, 0.6, 0.3);  #green
  my $light_green = new Triple($a * 0.65, $a * 1, $a * 0.30);  #light green
  my $dark_yellow = new Triple(0.61, 0.61, 0);  #dark yellow
  my $light_purple = new Triple(0.65, 0.3, 1);  #light purple
  my $dark_purple = new Triple(0.5, 0, 1);  #dark purple
  
  #phong materials' reflection coefficients
  my $ka = 0.25;
  my $kd = 0.75;
  my $ks = 0.1;
  my $exp = 50;

  my $matte1 = new Material::Matte();
  $matte1->set_ka($ka);
  $matte1->set_kd($kd);
  $matte1->set_cd($orange);
  
  my $phong1 = new Material::Phong();
  $phong1->set_ka($ka);
  $phong1->set_kd($kd);
  $phong1->set_ks($ks);
  $phong1->set_exp($exp);
  $phong1->set_cd($orange);

  my $reflective1 = new Material::Reflective();
  $reflective1->set_ka(0.25);
  $reflective1->set_kd(0.5);
  $reflective1->set_cd($light_green);
  $reflective1->set_ks(0.15);
  $reflective1->set_exp(100);
  $reflective1->set_kr(0.5);
  $reflective1->set_cr(new Triple(1, 1, 1)); #white  
  
  my $center1 = new Triple(-50, 0, -50);
  my $radius1 = 30;
  my $sphere1 = new GeometricObject::Sphere($center1, $radius1);
  $sphere1->material($reflective1);

  my $center2 = new Triple(0, 0, 0);
  my $radius2 = 30;
  my $sphere2 = new GeometricObject::Sphere($center2, $radius2);
  $sphere2->material($phong1);
  
  my $center3 = new Triple(50, 0, 50);
  my $radius3 = 30;
  my $sphere3 = new GeometricObject::Sphere($center3, $radius3);
  $sphere3->material($reflective1);

  #$world->add_object($sphere1);
  $world->add_object($sphere2);
  $world->add_object($sphere3);

  my $start_time = time();
  print "start: ";
  my $image = $camera->render_scene($world);
  print ":done - ";
  print ((time() - $start_time) . " seconds\n");

  open (my $fh, ">" . $file_name . ".bmp");
  $image->print($fh);
  close $fh;
}


sub reflective {
  my $hres = 1000;
  my $vres = 1000;
  my $pixel_size = 1;
  my $num_samples = 9;
  my $sampler = new Sampler::Jittered($num_samples);
  my $eye = new Triple(0, 100, -100);
  my $look_at = new Triple(0, 0, 0);
  my $distance_to_viewplane = 50;
  my $up = new Triple(0, 1, 0);
  my $roll_angle = $main::pi * .5; #in radians
  my $zoom = 7;
  my $exposure_time = 1;
  my $file_name = "reflective";


  my $camera = new Camera::PinholeCamera($hres, $vres, $pixel_size, $sampler, $eye, $distance_to_viewplane, $up, $look_at, $roll_angle, $zoom, $exposure_time, 5);
  my $background = new Triple(0, 0, 0);
  my $ambient = new Light::Ambient(0.5, new Triple(255, 255, 255));
  my $world = new World($background, $ambient, $camera);
  my $tracer = new Tracer::WhittedTracer($world);
  $world->tracer($tracer);

  my $pointlight1 = new Light::Point(3.0, new Triple(255, 255, 255), new Triple(-75, 75, -75));

  my $directionallight1 = new Light::Directional(1, new Triple(255, 255, 255), new Triple(1, 1, 0));

  $world->add_light($pointlight1);
  #$world->add_light($directionallight1);

  my $a = 0.75; #scaling factor for yellow, orange, and light green
  my $yellow = new Triple($a * 1, $a * 1, 0);  #yellow
  my $brown = new Triple(0.71, 0.40, 0.16);	 #brown
  my $dark_green = new Triple(0.0, 0.41, 0.41);	 #dark_green
  my $orange = new Triple($a * 1, $a * 0.75, 0);  #orange
  my $green = new Triple(0, 0.6, 0.3);  #green
  my $light_green = new Triple($a * 0.65, $a * 1, $a * 0.30);  #light green
  my $dark_yellow = new Triple(0.61, 0.61, 0);  #dark yellow
  my $light_purple = new Triple(0.65, 0.3, 1);  #light purple
  my $dark_purple = new Triple(0.5, 0, 1);  #dark purple
  
  #phong materials' reflection coefficients
  my $ka = 0.25;
  my $kd = 0.75;
  my $ks = 0.1;
  my $exp = 50;

  my $matte1 = new Material::Matte();
  $matte1->set_ka($ka);
  $matte1->set_kd($kd);
  $matte1->set_cd($orange);
  
  my $phong1 = new Material::Phong();
  $phong1->set_ka($ka);
  $phong1->set_kd($kd);
  $phong1->set_ks($ks);
  $phong1->set_exp($exp);
  $phong1->set_cd($orange);

  my $reflective1 = new Material::Reflective();
  $reflective1->set_ka(0.25);
  $reflective1->set_kd(0.5);
  $reflective1->set_cd($light_green);
  $reflective1->set_ks(0.15);
  $reflective1->set_exp(100);
  $reflective1->set_kr(0.5);
  $reflective1->set_cr(new Triple(1, 1, 1)); #white

  my $center1 = new Triple(0, 50, 0);
  my $radius1 = 50;
  my $sphere1 = new GeometricObject::Sphere($center1, $radius1);
  $sphere1->material($reflective1);

  my $center2 = new Triple(-50, 50, -50);
  my $radius2 = 23;
  my $sphere2 = new GeometricObject::Sphere($center2, $radius2);
  $sphere2->material($reflective1);

  my $normal1 = new Triple(0, 1, 0);
  my $plane1 = new GeometricObject::Plane($center1, $normal1);
  $plane1->material($phong1);

  $world->add_object($plane1);
  $world->add_object($sphere1);
  $world->add_object($sphere2);


  my $start_time = time();
  print "start: ";
  my $image = $camera->render_scene($world);
  print ":done - ";
  print ((time() - $start_time) . " seconds\n");

  open (my $fh, ">" . $file_name . ".bmp");
  $image->print($fh);
  close $fh;
}

sub mesh {
  my $hres = 400;
  my $vres = 400;
  my $pixel_size = 1;
  my $num_samples = 1;
  my $sampler = new Sampler::Jittered($num_samples);
  my $eye = new Triple(0, 100, -100);
  my $look_at = new Triple(0, 0, 0);
  my $distance_to_viewplane = 50;
  my $up = new Triple(0, 1, 0);
  my $roll_angle = $main::pi * .5; #in radians
  my $zoom = 400;
  my $exposure_time = 1;
  my $file_name = "box";


  my $camera = new Camera::PinholeCamera($hres, $vres, $pixel_size, $sampler, $eye, $distance_to_viewplane, $up, $look_at, $roll_angle, $zoom, $exposure_time);
  my $background = new Triple(0, 0, 0);
  my $ambient = new Light::Ambient(0.5, new Triple(255, 255, 255));
  my $world = new World($background, $ambient);
  my $tracer = new Tracer::BasicTracer($world);
  $world->tracer($tracer);

  my $pointlight1 = new Light::Point(3.0, new Triple(255, 255, 255), new Triple(-75, 75, -75));

  my $directionallight1 = new Light::Directional(1, new Triple(255, 255, 255), new Triple(1, 1, 0));

  $world->add_light($pointlight1);
  #$world->add_light($directionallight1);

  my $a = 0.75; #scaling factor for yellow, orange, and light green
  my $yellow = new Triple($a * 1, $a * 1, 0);  #yellow
  my $brown = new Triple(0.71, 0.40, 0.16);	 #brown
  my $dark_green = new Triple(0.0, 0.41, 0.41);	 #dark_green
  my $orange = new Triple($a * 1, $a * 0.75, 0);  #orange
  my $green = new Triple(0, 0.6, 0.3);  #green
  my $light_green = new Triple($a * 0.65, $a * 1, $a * 0.30);  #light green
  my $dark_yellow = new Triple(0.61, 0.61, 0);  #dark yellow
  my $light_purple = new Triple(0.65, 0.3, 1);  #light purple
  my $dark_purple = new Triple(0.5, 0, 1);  #dark purple

  #phong materials' reflection coefficients
  my $ka = 0.25;
  my $kd = 0.75;
  my $ks = 0.1;
  my $exp = 50;

  my $phong1 = new Material::Phong();
  $phong1->set_ka($ka);
  $phong1->set_kd($kd);
  $phong1->set_ks($ks);
  $phong1->set_exp($exp);
  $phong1->set_cd($orange);

  my $matte1 = new Material::Matte();
  $matte1->set_ka($ka);
  $matte1->set_kd($kd);
  $matte1->set_cd($green);

  my $center1 = new Triple(0, 50, 0);
  my $normal1 = new Triple(0, 1, 0);
  my $plane1 = new GeometricObject::Plane($center1, $normal1);
  $plane1->material($phong1);

  #my $start_time = time();
  #print "start reading: ";
  my $mesh = new Mesh();
  my $mesh2 = new Mesh();
  #$mesh->add_vertex(new Triple(0, 50, 50));
  #$mesh->add_vertex(new Triple(50, 50, 0));
  #$mesh->add_vertex(new Triple(50, 0, 50));
  $mesh->read_file("./objects/obj_files/Cube.obj");
  $mesh2->read_file("./objects/obj_files/Cube.obj");
  #print ":done reading - ";
  #print ((time() - $start_time) . " seconds\n");

  my $mesh_object1 = new GeometricObject::MeshObject($mesh);
  $mesh_object1->material($phong1);
  
  my $mesh_object2 = new GeometricObject::MeshObject($mesh2);
  $mesh_object2->material($matte1);
  
  $mesh_object2->transform(Matrix->translation(new Triple(1, 0, 1)));

  #my $triangle1 = new GeometricObject::FlatMeshTriangle(0, 1, 2, $mesh);
  #$triangle1->material($phong1);
  #$triangle1->calculate_normal();


  #$world->add_object($plane1);
  $world->add_object($mesh_object1);
  #$world->add_object($mesh_object2);


  my $start_time = time();
  print "start: ";
  my $image = $camera->render_scene($world);
  print ":done - ";
  print ((time() - $start_time) . " seconds\n");

  open (my $fh, ">" . $file_name . ".bmp");
  $image->print($fh);
  close $fh;
}







sub arealight {
  my $hres = 500;
  my $vres = 500;
  my $pixel_size = 1;
  my $num_samples = 1;
  my $sampler1 = new Sampler::Jittered($num_samples);
  my $sampler2 = new Sampler::Jittered(100);
  my $eye = new Triple(-20, 10, 20);
  my $look_at = new Triple(0, 2, 0);
  my $distance_to_viewplane = 1080;
  my $up = new Triple(0, 1, 0);
  my $roll_angle = $main::pi * 0.5; #in radians
  my $zoom = 1;
  my $exposure_time = 1;
  my $file_name = "arealight_9";


  my $camera = new Camera::PinholeCamera($hres, $vres, $pixel_size, $sampler1, $eye, $distance_to_viewplane, $up, $look_at, $roll_angle, $zoom, $exposure_time);
  my $background = new Triple(0, 0, 0);
  my $ambient = new Light::Ambient(0.0, new Triple(255, 255, 255));
  my $world = new World($background, $ambient);
  my $tracer = new Tracer::BasicTracer($world);
  $world->tracer($tracer);

  my $radiance = 40.0;
  my $color = new Triple(1, 1, 1); #white
  my $emissive = new Material::Emissive($radiance, $color);
  my $width1 = 4.0;
  my $height1 = 4.0;
  my $center1 = new Triple(0, 7, -7);
  my $p01 = new Triple(-0.5 * $width1, $center1->snd() - (0.5 * $height1), $center1->trd());
  my $a1 = new Triple($width1, 0, 0);
  my $b1 = new Triple(0, $height1, 0);
  my $normal1 = new Triple(0, 0, 1);
  my $rect_light = new GeometricObject::Rectangle($p01, $a1, $b1);
  $rect_light->material($emissive);
  $rect_light->sampler($sampler2);

  $world->add_object($rect_light);

  my $area_light_ptr = new Light::Area($rect_light);
  #$world->add_light($area_light_ptr);

  my $pointlight = new Light::Point(3.0, new Triple(255, 255, 255), new Triple(0, 7, -7));
     $world->add_light($pointlight);


	my $center2  = new Triple(0, 2, 0);
	my $radius2  = 25;

	my $matte1 = new Material::Matte();
	$matte1->set_ka(0.25);
	$matte1->set_kd(0.75);
	$matte1->set_cd(0.4, 0.7, 0.4);     # green

	my $sphere1 = new GeometricObject::Sphere($center2, $radius2);
  $sphere1->material($matte1);
  $world->add_object($sphere1);

	# ground plane

	my $matte_ptr2 = new Material::Matte();
	$matte_ptr2->set_ka(0.1);
	$matte_ptr2->set_kd(0.90);
	$matte_ptr2->set_cd(new Triple(1, 1, 1)); #white

	my $plane_ptr = new GeometricObject::Plane(new Triple(0, 0, 0), new Triple(0, 1, 0));
	$plane_ptr->material($matte_ptr2);
	$world->add_object($plane_ptr);



  my $start_time = time();
  print "start: ";
  my $image = $camera->render_scene($world);
  print ":done\n";
  print ((time() - $start_time) . " seconds\n");

  open (my $fh, ">" . $file_name . ".bmp");
  $image->print($fh);
  close $fh;
}


sub spheres {
  my $hres = 400;
  my $vres = 400;
  my $pixel_size = 1;
  my $num_samples = 1;
  my $sampler = new Sampler::Jittered($num_samples);
  my $eye = new Triple(0, 100, -100);
  my $look_at = new Triple(0, 0, 0);
  my $distance_to_viewplane = 50;
  my $up = new Triple(0, 1, 0);
  my $roll_angle = $main::pi * .5; #in radians
  my $zoom = 2;
  my $exposure_time = 1;
  my $file_name = "test";


  my $camera = new Camera::PinholeCamera($hres, $vres, $pixel_size, $sampler, $eye, $distance_to_viewplane, $up, $look_at, $roll_angle, $zoom, $exposure_time);
  my $background = new Triple(0, 0, 0);
  my $ambient = new Light::Ambient(0.5, new Triple(255, 255, 255));
  my $world = new World($background, $ambient);
  my $tracer = new Tracer::BasicTracer($world);
  $world->tracer($tracer);

  my $pointlight1 = new Light::Point(3.0, new Triple(255, 255, 255), new Triple(-75, 75, -75));

  my $directionallight1 = new Light::Directional(1, new Triple(255, 255, 255), new Triple(1, 1, 0));

  $world->add_light($pointlight1);
  #$world->add_light($directionallight1);

  my $a = 0.75; #scaling factor for yellow, orange, and light green
  my $yellow = new Triple($a * 1, $a * 1, 0);  #yellow
  my $brown = new Triple(0.71, 0.40, 0.16);	 #brown
  my $dark_green = new Triple(0.0, 0.41, 0.41);	 #dark_green
  my $orange = new Triple($a * 1, $a * 0.75, 0);  #orange
  my $green = new Triple(0, 0.6, 0.3);  #green
  my $light_green = new Triple($a * 0.65, $a * 1, $a * 0.30);  #light green
  my $dark_yellow = new Triple(0.61, 0.61, 0);  #dark yellow
  my $light_purple = new Triple(0.65, 0.3, 1);  #light purple
  my $dark_purple = new Triple(0.5, 0, 1);  #dark purple

  #phong materials' reflection coefficients
  my $ka = 0.25;
  my $kd = 0.75;
  my $ks = 0.1;
  my $exp = 50;

  my $phong1 = new Material::Phong();
  $phong1->set_ka($ka);
  $phong1->set_kd($kd);
  $phong1->set_ks($ks);
  $phong1->set_exp($exp);
  $phong1->set_cd($yellow);

  my $phong2 = new Material::Phong();
  $phong2->set_ka($ka);
  $phong2->set_kd($kd);
  $phong2->set_ks($ks);
  $phong2->set_exp($exp);
  $phong2->set_cd($orange);

  my $matte1 = new Material::Matte();
  $matte1->set_ka($ka);
  $matte1->set_kd($kd);
  $matte1->set_cd($green);

  my $center1 = new Triple(0, 50, 0);
  my $radius1 = 50;
  my $sphere1 = new GeometricObject::Sphere($center1, $radius1);
  $sphere1->material($phong1);

  my $center2 = new Triple(-50, 50, -50);
  my $radius2 = 23;
  my $sphere2 = new GeometricObject::Sphere($center2, $radius2);
  $sphere2->material($matte1);

  my $normal1 = new Triple(0, 1, 0);
  my $plane1 = new GeometricObject::Plane($center1, $normal1);
  $plane1->material($phong2);

  $world->add_object($plane1);
  $world->add_object($sphere1);
  $world->add_object($sphere2);

  my $start_time = time();
  print "start: ";
  my $image = $camera->render_scene($world);
  print ":done\n";
  print ((time() - $start_time) . " seconds");

  open (my $fh, ">" . $file_name . ".bmp");
  $image->print($fh);
  close $fh;
}
