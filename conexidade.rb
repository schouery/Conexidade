#!/usr/bin/env ruby
require 'graphviz'

class UnionFind
  attr_reader :components
  
  def initialize(n)
    @parent = Array.new(n) {|i| i}
    @rank = Array.new n, 1
    @components = n
  end
  
  def union(e1,e2)
    a, b = find(e1), find(e2)
    return if a == b
    @components -= 1
    if @rank[a] > @rank[b]
      @parent[b] = a
    else
      @parent[a] = b
      @rank[b] += 1 if @rank[a] == @rank[b]  
    end
  end
  
  def find(a)
    if a != @parent[a]
      @parent[a] = find @parent[a]
    end
    @parent[a]
  end
  
end

class Graph
    
  def graphvizInitialize(use)
    @g = GraphViz::new("G", :output => "png", :type => "graph", :use => use)
    @g.node[:shape] = "point"
    for i in (0...@vertices) do
      @g.add_node(i.to_s)
    end
  end

  def initialize(v, use = "dot")
    @vertices = v
    @edges = 0
    @matriz = Array.new(@vertices) { |i| Array.new(v)   }
    graphvizInitialize(use)
    @uf = UnionFind.new(@vertices)
  end

  def edge?(u,v)
    @matriz[u][v]
  end    

  def add_edge(u, v)
    @matriz[u][v] = @matriz[v][u] = true
    @g.add_edge(u.to_s,v.to_s)
    @uf.union(u,v)
    @edges += 1
  end

  def connected
    @uf.components == 1
  end

  def add_random_edge
    r1, r2 = rand(@vertices), rand(@vertices)
    r1, r2 = rand(@vertices), rand(@vertices) until edge?(r1,r2).nil? && r1  != r2
    add_edge(r1,r2)
  end

  def generate_next
    add_random_edge
    @g.output(:file => "imagens/#{@edges}.png")
  end
  
end

`rm imagens/*`
# graph = Graph.new(50, "neato")
graph = Graph.new(50)
graph.generate_next while !graph.connected