#!/usr/bin/perl

use strict;
use warnings;

package Material::Phong;
use parent 'Material';

use FindBin qw($Bin);
use lib "$Bin/../utilities";
use lib "$Bin/../lights";
use lib "$Bin/../brdfs";

use Ambient;
use Ray;

sub new {
  my $class = shift;
  my $this = bless {
    _ambient_brdf => new BRDF::Lambertian(),
    _diffuse_brdf => new BRDF::Lambertian(),
    _specular_brdf => new BRDF::GlossySpecular(),
  }, $class;
  return $this;
}

sub shade {
  my ($this, $shade_rec) = @_;

  my $wo = -1 * ($shade_rec->ray()->direction());
  my $L = $this->{_ambient_brdf}->rho($shade_rec, $wo)->element_wise_multiplication($shade_rec->world()->ambient_light()->L($shade_rec));
  my $num_lights = $shade_rec->world()->num_lights();
  my ($wi, $ndotwi, $temp1, $temp2, $lightj);




  for (my $j = 0; $j < $num_lights; $j++) {
    $lightj = ${$shade_rec->world()->lights()}[$j];

    $wi = $lightj->get_direction($shade_rec);
    $ndotwi = $shade_rec->normal() * $wi;

    if ($ndotwi > 0.0) {
      my $in_shadow = 0;

      if ($lightj->casts_shadow()) {
        my $shadow_ray = new Ray($shade_rec->hit_point(), $wi);
        $in_shadow = $lightj->in_shadow($shadow_ray, $shade_rec);
      }

      if (not $in_shadow) {
        $temp1 = $this->{_diffuse_brdf}->f($shade_rec, $wo, $wi) +
                 $this->{_specular_brdf}->f($shade_rec, $wo, $wi);

        $temp2 = $lightj->L($shade_rec) * $ndotwi;

        $L += $temp1->element_wise_multiplication($temp2);
      }
    }
  }


  return $L;
}


sub area_light_shade {
  my ($this, $shade_rec) = @_;

  my $wo = -1 * ($shade_rec->ray()->direction());
  my $L = $this->{_ambient_brdf}->rho($shade_rec, $wo)->element_wise_multiplication($shade_rec->world()->ambient_light()->L($shade_rec));
  my $num_lights = $shade_rec->world()->num_lights();
  my ($wi, $ndotwi, $temp1, $temp2, $lightj);

  for (my $j = 0; $j < $num_lights; $j++) {
    $lightj = ${$shade_rec->world()->lights()}[$j];

    $wi = $lightj->get_direction($shade_rec);
    $ndotwi = $shade_rec->normal() * $wi;

    if ($ndotwi > 0.0) {
      my $in_shadow = 0;

      if ($lightj->casts_shadow()) {
        my $shadow_ray = new Ray($shade_rec->hit_point(), $wi);
        $in_shadow = $lightj->in_shadow($shadow_ray, $shade_rec);
      }

      if (not $in_shadow) {
        $temp1 = $this->{_diffuse_brdf}->f($shade_rec, $wo, $wi) +
                 $this->{_specular_brdf}->f($shade_rec, $wo, $wi);

        $temp2 = $lightj->L($shade_rec) * $ndotwi;

        $L += ($temp1->element_wise_multiplication($temp2) / $lightj->pdf($shade_rec));
      }
    }
  }

  return $L;
}

sub set_ka {
  my $this = shift;
  $this->{_ambient_brdf}->kd(shift);
}

sub set_kd {
  my $this = shift;
  $this->{_diffuse_brdf}->kd(shift);
}

sub set_ks {
  my $this = shift;
  $this->{_specular_brdf}->ks(shift);
}

sub set_exp {
  my $this = shift;
  $this->{_specular_brdf}->exp(shift);
}

sub set_cd {
  my $this = shift;
  my $c = shift;
  $this->{_ambient_brdf}->cd($c);
  $this->{_diffuse_brdf}->cd($c);
}


1;
