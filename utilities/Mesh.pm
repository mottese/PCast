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
  
  my $this = bless {
    _vertices => \@vertices, #vertices
    _indices => \@indices, #vertex indices
    _normals => \@normals, #average normal at each vertex
    _vertex_faces => \@vertex_faces, #the faces shared by each vertex
    _u => \@u, #u texture coordinate at each vertex
    _v => \@v, #v texture coordinate at each vertex
    _num_vertices => 0, #number of vertices
    _num_triangles => 0, #nubmer of triangles
  }, $class;
  
  return $this;
}

#none of these are done
sub add_vertex {
  my $this = shift;
  ${$this->{_vertices}}[$this->{_num_vertices}] = shift;
  $this->{_num_vertices} = $this->{_num_vertices} + 1;
}

1;