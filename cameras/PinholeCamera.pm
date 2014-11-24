#!/usr/bin/perl

use strict;
use warnings;

package Camera::PinholeCamera;

use POSIX;

sub new {
  my $class = shift;

  #   int    int    double  sampler   3d    3d               3d   3d        double double double
  my ($hres, $vres, $psize, $sampler, $eye, $distance_to_vp, $up, $look_at, $roll, $zoom, $exposure_time, $max_depth) = @_;
  my $bmp = new BMP($hres, $vres);

  $up = $up->normalize();
  my $w = $eye - $look_at;

  #orthonormal basis for camera
  $w = $w->normalize();
  my $temp = $up->cross($w);
  my $u = $temp->normalize();
  my $v = $w->cross($u);


  if($roll != 0) {
    my ($t1, $t2);
    $t1 = ($u * cos($roll)) - ($v * sin($roll));
    $t2 = ($u * sin($roll)) + ($v * cos($roll));
    $u = $t1->normalize();
    $v = $t2->normalize();
  }

  my $this = bless {
    _hres => $hres,
    _vres => $vres,
    _pixel_size => $psize,
    _d => $distance_to_vp,
	  _eye => $eye,
    _up => $up,
    _look_at => $look_at,
    _roll_angle => $roll,
    _zoom => $zoom,
    _exposure_time => $exposure_time,
    _u => $u,
    _v => $v,
    _w => $w,
    _max_depth => $max_depth,
    _s => 1,
    _gamma => 1,
    _inv_gamma => 1,
    _bmp => $bmp,
    _sampler => $sampler,
  }, $class;

  return $this;
}

sub hres {
  my $this = shift;
  if(@_) {
    $this->{_hres} = shift;
  }
  return $this->{_hres};
}

sub vres {
  my $this = shift;
  if(@_) {
    $this->{_vres} = shift;
  }
  return $this->{_vres};
}

sub max_depth {
  my $this = shift;
  if (@_) {
    $this->{_max_depth} = shift;
  }
  return $this->{_max_depth};
}

sub sampler() {
  my $this = shift;
  if(@_) {
    $this->{_sampler} = shift;
  }
  return $this->{_sampler};
}

sub zw {
  my $this = shift;
  if(@_) {
    $this->{_zw} = shift;
  }
  return $this->{_zw};
}

sub pixel_size {
  my $this = shift;
  if(@_) {
    $this->{_pixel_size} = shift;
  }
  return $this->{_pixel_size};
}

sub s {
  my $this = shift;
  if(@_) {
    $this->{_s} = shift;
  }
  return $this->{_s};
}

sub gamma {
  my $this = shift;
  if(@_) {
    $this->{_gamma} = shift;
	$this->{_inv_gamma} = 1 / $this->{_gamma};
  }
  return $this->{_gamma};
}

sub inv_gamma {
  my $this = shift;
  if(@_) {
    $this->{_inv_gamma} = shift;
	$this->{_gamma} = 1 / $this->{_inv_gamma};
  }
  return $this->{_inv_gamma};
}

sub draw_pixel {
  my ($this, $x, $y, $color) = @_;
  $this->{_bmp}->set($x, $y, $color->fst(), $color->snd(), $color->trd());
}

sub get_ray {
  my ($this, $x, $y) = @_;
  my $origin = new Triple($x, $y, $this->{_zw});

  my $x_direc = $x - $this->{_eye}->fst();
  my $y_direc = $y - $this->{_eye}->snd();
  my $z_direc = $this->{_zw} - $this->{_eye}->trd();

  my $direction = new Triple($x_direc, $y_direc, $z_direc);
  if ($this->{_pinhole}) {
    $direction->reverse_direction();
  }
  #$direction->normalize();

  return new Ray($origin, $direction);
}

sub render_scene {
  #this is for the printing information.
  #Prints once for every (granularity * 100) percent of the picture that's been completed
  my $granularity = 0.01;
  my $progress = $granularity;

  my $this = shift;
  my $world = shift;
  my $ray = new Ray();
  my $pixel_color = new Triple(0, 0, 0);
  my $depth = 0;
  my $sp = new Triple(0.5, 0.5, 0);
  my $pp = new Triple(0, 0, 0);

  $this->{_s} = $this->{_s} / $this->{_zoom};
  $ray->origin($this->{_eye});


  for (my $r = 0; $r < $this->{_vres}; $r++) {
    for (my $c = 0; $c < $this->{_hres}; $c++) {
      $pixel_color->fst(0);
      $pixel_color->snd(0);
      $pixel_color->trd(0);

      for (my $j = 0; $j < $this->{_sampler}->num_samples(); $j++) {
        if ($this->{_sampler}->num_samples() > 1) {
          $sp = $this->{_sampler}->sample_unit_square();
        }
        $pp->fst($this->{_s} * ($c - 0.5 * $this->{_hres} + $sp->fst()));
	      $pp->snd($this->{_s} * ($r - 0.5 * $this->{_vres} + $sp->snd()));
	      $ray->direction($this->ray_direction($pp));
		    $pixel_color += $world->tracer()->trace_ray($ray, $depth);
      }

      $pixel_color /= $this->{_sampler}->num_samples();
      $pixel_color *= $this->{_exposure_time};
      $this->draw_pixel($r, $c, $pixel_color);
    }

    #lets you know how much of the image has been rendered.
    #Nice when you're rendering large/complicated/anti-aliased pictures that take a very long time to complete.
    if ($r == floor($this->{_vres}*$progress)) {
      my $s = ($progress * 100) . "% ";
      if (index($s, '.') != -1) {
        $s = substr($s, 0, index($s, '.')) . "% ";
      }
      print $s;
      $progress = $progress + $granularity;
    }

  }

  return $this->image();
}

sub ray_direction {
  my ($this, $p) = @_;
  my $dir = ($p->fst() * $this->{_u}) +
            ($p->snd() * $this->{_v}) -
			($this->{_d} * $this->{_w});
  $dir = $dir->normalize();
  return $dir;
}

sub image {
  my $this = shift;
  return $this->{_bmp};
}

1;
