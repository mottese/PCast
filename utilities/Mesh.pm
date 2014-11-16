#!/usr/bin/perl

use strict;
use warnings;

package Mesh;

sub new {
  my $class = shift;
  
  my @vertices = ();
  my @indices = ();
  my @normals = ();
  my @vertex_faces = ();
  my @u = ();
  my @v = ();
  my @triangles = ();
  
  my $this = bless {
    _vertices => \@vertices, #vertices
    _indices => \@indices, #vertex indices
    _normals => \@normals, #average normal at each vertex
    _vertex_faces => \@vertex_faces, #the faces shared by each vertex
    _u => \@u, #u texture coordinate at each vertex
    _v => \@v, #v texture coordinate at each vertex
    _num_vertices => 0, #number of vertices
    _num_triangles => 0, #nubmer of triangles
    _num_normals => 0, #number of vertex normals
    _triangles => \@triangles,
  }, $class;
  
  return $this;
}

sub add_vertex {
  my $this = shift;
  ${$this->{_vertices}}[$this->{_num_vertices}] = shift;
  $this->{_num_vertices} = $this->{_num_vertices} + 1;
}

sub vertex {
  my $this = shift;
  return ${$this->{_vertices}}[shift];
}

sub read_file {
  my $this = shift;
  open (my $fh, "<" . shift);
  
  my @data;
  
  while (my $line = $fh) { 
    @data = split(' ', $line);
    
    if ($data[0] == "v") {
      ${$this->{_vertices}}[$this->{_num_vertices}] = new Triple ($data[1], $data[2], $data[3]);
      $this->{_num_vertices} = $this->{_num_vertices} + 1;
    }
    elsif ($data[0] == "vn") {
      ${$this->{_normals}}[$this->{_num_normals}] = new Triple ($data[1], $data[2], $data[3]);
      $this->{_num_normals} = $this->{_num_normals} + 1;
    }
    elsif ($data[0] == "f") {
      ${$this->{_triangles}}[$this->{_num_triangles}] = new GeometricObject::FlatMeshTriangle($data[1], $data[2], $data[3], $this);
      $this->{_num_triangles} = $this->{_num_triangles} + 1;
    }
    elsif ($data[0] == "g") {
    
    }
  }
  
  close $fh;
}

1;