#!/usr/bin/perl

use strict;
use warnings;

use Ray;
use Triple;
use ShadeRec;

package World;



sub new {
  my $class = shift;

  my @objects = ();
  my @lights = ();

  my $this = bless {
    _background_color => shift,
    _objects => \@objects,
    _ambient_light => shift,
    _lights => \@lights,
    _num_objects => 0,
    _num_lights => 0,
    _tracer => undef,
    _render_thread => undef,
    _camera => shift,
  }, $class;

  return $this;
}

sub camera {
  my $this = shift;
  if (@_) {
    $this->{_camera} = shift;
  }
  return $this->{_camera};
}

sub background_color {
  my $this = shift;
  if (@_) {
    $this->{_background_color} = shift;
  }
  return $this->{_background_color};
}

sub num_objects {
  my $this = shift;
  return $this->{_num_objects};
}

sub num_lights {
  my $this = shift;
  return $this->{_num_lights};
}

sub objects {
  my $this = shift;
  return $this->{_objects};
}

sub lights {
  my $this = shift;
  return $this->{_lights};
}

sub tracer {
  my $this = shift;
  if(@_) {
    $this->{_tracer} = shift;
  }
  return $this->{_tracer};
}

sub ambient_light {
  my $this = shift;
  if(@_) {
    $this->{_ambient_light} = shift;
  }
  return $this->{_ambient_light};
}

sub add_light {
  my $this = shift;
  my $light = shift;
  my $this_lights = $this->{_lights};
  my $num_lights = $this->{_num_lights};

  ${$this_lights}[$num_lights] = $light;
  $this->{_num_lights} = $num_lights + 1;
}


sub add_object {
  my $this = shift;
  my $object = shift;
  my $this_objects = $this->{_objects};
  my $num_objects = $this->{_num_objects};

  ${$this_objects}[$num_objects] = $object;
  $this->{_num_objects} = $num_objects + 1;
}

sub hit_objects {
  my $this = shift;
  my $ray = shift;
  my $normal;
  my $local_hit_point;
  my $shade_rec = new ShadeRec($this);
  my $tmin = $main::kHugeValue;
  my $t = $main::kHugeValue;
  my $num_objs = $this->{_num_objects};

  for (my $j = 0; $j < $num_objs; $j++) {
    if (${$this->{_objects}}[$j]->hit($ray, \$t, $shade_rec) and ($t < $tmin)) {
      $shade_rec->hit(1);
      $tmin = $t;
	    $shade_rec->material(${$this->{_objects}}[$j]->material());
      $shade_rec->hit_point($ray->origin() + ($t * $ray->direction()));
      $normal = $shade_rec->normal();
      $local_hit_point = $shade_rec->local_hit_point();
    }
  }
  if ($shade_rec->hit()) {
    $shade_rec->t($tmin);
    $shade_rec->normal($normal);
    $shade_rec->local_hit_point($local_hit_point);
  }

  return $shade_rec;
}





1;
