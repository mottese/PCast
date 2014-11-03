#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/brdfs";
use lib "$Bin/cameras";
use lib "$Bin/lights";
use lib "$Bin/materials";
use lib "$Bin/objects";
use lib "$Bin/samplers";
use lib "$Bin/utilities";
use lib "$Bin/utilities/tracers";

use World;
use BMP;
use Triple;
use Sphere;
use Ray;
use ShadeRec;
use BasicTracer;
use PinholeCamera;
use Box;
use Matte;
use Lambertian;
use Ambient;
use Point;
use Plane;
use Directional;
use GlossySpecular;
use Phong;
use Jittered;

our $kEpsilon = 0.00001; # 1.0E-5
our $kHugeValue = 10000000000; # 1.0E10
our $pi = 3.14159;
our $invPi = 1 / $pi;

# print buffers to insure messages go to screen quickly 
my $console = select(STDOUT); 
$| = 1;
select($console); 

main();



sub main {
  my $hres = 400;
  my $vres = 400;
  my $pixel_size = 1;
  my $num_samples = 1;
  my $sampler = new Sampler::Jittered($num_samples);
  my $eye = new Triple(0, 100, -100);
  my $look_at = new Triple(0, 0, 0);
  my $distance_to_viewplane = 50;
  my $up = new Triple(0, 1, 0);
  my $roll_angle = $pi * .5; #in radians
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
  my $sphere1 = new GeometricObject::Sphere($center1, $radius1, $phong1);
  
  my $center2 = new Triple(-50, 50, -50);
  my $radius2 = 23;
  my $sphere2 = new GeometricObject::Sphere($center2, $radius2, $matte1);
  
  my $normal1 = new Triple(0, 1, 0);
  my $plane1 = new GeometricObject::Plane($center1, $normal1, $phong2);  
  
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