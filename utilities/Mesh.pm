#!/usr/bin/perl

use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../objects/primitives";
use lib "$Bin/../objects/triangles";

use Box;
use FlatMeshTriangle;

package Mesh;

sub new {
  my $class = shift;

  my @vertices = ();
  my @indices = ();
  my @normals = ();
  my @faces = ();
  my @u = ();
  my @v = ();

  my $this = bless {
    _vertices => \@vertices, #vertices
    _indices => \@indices, #vertex indices
    _normals => \@normals, #average normal at each vertex
    _faces => \@faces, #the faces shared by each vertex
    _u => \@u, #u texture coordinate at each vertex
    _v => \@v, #v texture coordinate at each vertex
    _num_vertices => 0, #number of vertices
    _num_faces => 0, #nubmer of faces
    _num_normals => 0, #number of vertex normals
    _bounding_box => undef,
  }, $class;

  return $this;
}

sub add_vertex {
  my $this = shift;
  ${$this->{_vertices}}[$this->{_num_vertices}] = shift;
  $this->{_num_vertices} = $this->{_num_vertices} + 1;
}

sub add_normal {
  my $this = shift;
  ${$this->{_normals}}[$this->{_num_normals}] = shift;
  $this->{_num_normals} = $this->{_num_normals} + 1;
}

sub add_face {
  my $this = shift;
  ${$this->{_faces}}[$this->{_num_faces}] = shift;
  ${$this->{_faces}}[$this->{_num_faces}]->calculate_normal();
  $this->{_num_faces} = $this->{_num_faces} + 1;
}

sub bounding_box {
  my $this = shift;
  return $this->{_bounding_box};
}

sub vertex {
  my $this = shift;
  return ${$this->{_vertices}}[shift];
}

#Only used in the MeshObject class when you're doing transforms. Don't use this
sub vertices {
  my $this = shift;
  if (@_) {
    $this->{_vertices} = shift;
  }
  return $this->{_vertices};
}

sub normal {
  my $this = shift;
  return ${$this->{_normals}}[shift];
}

sub face {
  my $this = shift;
  return ${$this->{_faces}}[shift];
}

sub faces {
  my $this = shift;
  return $this->{_faces};
}


#only works for triangle faces at the moment
sub read_file {
  my $this = shift;
  my $filename = shift;
  open (my $fh, "<" . $filename)
    or die "Could not open file '$filename' $!"; #pass in the file path/name

  my @data;

  while (my $line = <$fh>) {
    if ($line =~ /^\s*$/) {
      next;
    }

    chomp($line);
    my $find = "  ";
    my $replace = " ";
    $find = quotemeta $find; # escape regex metachars if present
    $line =~ s/$find/$replace/g; #replace double spaces with single spaces
    @data = split(' ', $line);

    if ($data[0] eq "v") {
      $this->add_vertex(new Triple ($data[1], $data[2], $data[3]));
    }
    elsif ($data[0] eq "vn") {
      $this->add_normal(new Triple ($data[1], $data[2], $data[3]));
    }
    elsif ($data[0] eq "f") {
    # - 1 because the indices in the file are 1-based and our arrays are 0-based
      $this->add_face(new GeometricObject::FlatMeshTriangle($data[1] - 1, $data[2] - 1, $data[3] - 1, $this));
    }
    elsif ($data[0] eq "g") {

    }
    else {

    }
  }

  #print $this->{_num_faces} . "\n";

  close $fh;

  $this->calculate_bounding_box();
}

sub calculate_bounding_box {
  my $this = shift;

  my $min = ${$this->{_vertices}}[0];
  my $max = ${$this->{_vertices}}[0];

  foreach my $p (@{$this->{_vertices}}) {
    if    ($p->fst() < $min->fst()) { $min->fst($p->fst()); }
    elsif ($p->snd() < $min->snd()) { $min->snd($p->snd()); }
    elsif ($p->trd() < $min->trd()) { $min->trd($p->trd()); }

    if    ($p->fst() > $max->fst()) { $max->fst($p->fst()); }
    elsif ($p->snd() > $max->snd()) { $max->snd($p->snd()); }
    elsif ($p->trd() > $max->trd()) { $max->trd($p->trd()); }
  }

  $this->{_bounding_box} = new GeometricObject::Box($min, $max);
}

1;
