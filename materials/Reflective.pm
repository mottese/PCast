#!/usr/bin/perl

use strict;
use warnings;

package Material::Reflective;
use parent 'Material';

use FindBin qw($Bin);
use lib "$Bin/../utilities";
use lib "$Bin/../brdfs";

use Ray;
use Phong;
use PerfectSpecular;

sub new {
  my $class = shift;
  my $this = bless {
    _phong => new Material::Phong(),
    _reflective_brdf => new BRDF::PerfectSpecular(),
  }, $class;
  return $this;
}

sub shade {
  my ($this, $shade_rec) = @_;
  my $L = $this->{_phong}->shade($shade_rec);

  my $wo = -1 * $shade_rec->ray()->direction();
  my $wi;
  my $fr = $this->{_reflective_brdf}->sample_f($shade_rec, $wo, \$wi);
  my $reflected_ray = new Ray($shade_rec->hit_point(), $wi);

  my $temp1 = $fr * $shade_rec->world()->tracer()->trace_ray($reflected_ray, $shade_rec->depth() + 1);
  my $temp2 = $shade_rec->normal() * $wi;
  
  $L += new Triple($temp1 * $temp2, $temp1 * $temp2, $temp1 * $temp2);

  return $L;
}

sub set_kr {
  my $this = shift;
  $this->{_reflective_brdf}->kr(shift);
}

sub set_cr {
  my $this= shift;
  $this->{_reflective_brdf}->cr(shift);
}

sub set_ka {
  my $this = shift;
  $this->{_phong}->set_ka(shift);
}

sub set_kd {
  my $this = shift;
  $this->{_phong}->set_kd(shift);
}

sub set_ks {
  my $this = shift;
  $this->{_phong}->set_ks(shift);
}

sub set_exp {
  my $this = shift;
  $this->{_phong}->set_exp(shift);
}

sub set_cd {
  my $this = shift;
  $this->{_phong}->set_cd(shift);
}


1;
