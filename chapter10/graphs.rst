.. _graphs:

######
Graphs
######

In this chapter I want to take a detour into a subject that is not directly about Swift but is a major part of computer science:  graphs.

We will start by exploring a simple algorithm to list all the nodes of graph that can be reached from a chosen starting point.  The examples and the code are from a post by Guido van Rossum:

https://www.python.org/doc/essays/graphs/

Specifically, what we will do is to find a path from the start node to the end node in a particular graph.

Here is a picture of the graph for this example:

.. image:: /figures/graph1.png
    :scale: 100 %

The technique is called "backtracking".  We just follow the arrows.  At a branch point, choose each possible path in turn.  Follow until we reach a dead end (or the end node).  If we haven't found the end node, go back and try another path.  We check for cycles like C -> D -> C.

Here is the Python code from Guido's post, with added print statements so we can see what's happening:

.. sourcecode:: python

    import sys
    start, end = sys.argv[1:]

    graph = {'A': ['B', 'C'],
             'B': ['C', 'D'],
             'C': ['D'],
             'D': ['C'],
             'E': ['F'],
             'F': ['C']}

    def find_path(graph, start, end, path=[]):
        print "find path: %s -> %s, input path: %s" % (start, end, path)
        path = path + [start]
        if start == end:
            print "start == end path: %s" % path
            return path
        if not graph.has_key(start):
            print "not graph.has_key(start)", start
            return None
        for node in graph[start]:
            print "working on node: %s" % node
            if node not in path:
                newpath = find_path(graph, node, end, path)
                if newpath:
                    print "return newpath: %s -> %s, path: %s" % (start, end, newpath)
                    return newpath
                else:
                    print "no path found for node: %s" % node
            else:
                print "node already in path: %s" % node
        return None

    print find_path(graph,start,end)

And here is the result when searching from A -> D:

.. sourcecode:: bash

    > python find.py A D
    find path: A -> D, input path: []
    working on node: B
    find path: B -> D, input path: ['A']
    working on node: C
    find path: C -> D, input path: ['A', 'B']
    working on node: D
    find path: D -> D, input path: ['A', 'B', 'C']
    start == end path: ['A', 'B', 'C', 'D']
    return newpath: C -> D, path: ['A', 'B', 'C', 'D']
    return newpath: B -> D, path: ['A', 'B', 'C', 'D']
    return newpath: A -> D, path: ['A', 'B', 'C', 'D']
    ['A', 'B', 'C', 'D']
    >

The example is very straightforward.  Follow the arrows from A -> B -> C -> D.  

We enjoy success, so return that result.

I modified the code to take the start and end nodes from stdin (the command line).  So we can try any pair of nodes:

.. sourcecode:: bash

    > python find.py A F
    find path: A -> F, input path: []
    working on node: B
    find path: B -> F, input path: ['A']
    working on node: C
    find path: C -> F, input path: ['A', 'B']
    working on node: D
    find path: D -> F, input path: ['A', 'B', 'C']
    working on node: C
    node already in path: C
    no path found for node: D
    no path found for node: C
    working on node: D
    find path: D -> F, input path: ['A', 'B']
    working on node: C
    find path: C -> F, input path: ['A', 'B', 'D']
    working on node: D
    node already in path: D
    no path found for node: C
    no path found for node: D
    no path found for node: B
    working on node: C
    find path: C -> F, input path: ['A']
    working on node: D
    find path: D -> F, input path: ['A', 'C']
    working on node: C
    node already in path: C
    no path found for node: D
    no path found for node: C
    None
    >

As you can see in the figure

.. image:: /figures/graph1.png
    :scale: 100 %

F can not be reached from A.

Here is a direct translation of the first example to a Swift Playground (except that the start and end are hard-coded):

.. sourcecode:: swift

    let graph = ["A":["B","C"],
                 "B":["C","D"],
                 "C":["D"],
                 "D":["C"],
                 "E":["F"],
                 "F":["C"]]

    func findPath(graph: [String:[String]], start: String, end: String, var path: [String] = []) -> [String]? {
        print("find path: \(start) -> \(end), input path: \(path)")
        path += [start]
        if start == end {
            print("start == end: \(path)")
            return path
        }
        if !(graph.keys.contains(start)) {
            print("!.keys.contains (start): \(start)")
            return nil
        }
        for node in graph[start]! {
            print("working on node: \(node)")
            if !(path.contains(node)) {
                let newpath = findPath(graph, start: node, end: end, path: path)
                if nil != newpath {
                    print("new path: \(newpath)")
                    return newpath
                }
                else {
                    print("no path found for node: \(node)")
                }
            }
        }
        return nil
    }

    let start = "A"
    let end = "D"
    if let p = findPath(graph, start:start, end:end) {
        print(p)
    }
    else { print("not found") }

The debug window shows a similar result:

.. sourcecode:: bash

    find path: A -> D, input path: []
    working on node: B
    find path: B -> D, input path: ["A"]
    working on node: C
    find path: C -> D, input path: ["A", "B"]
    working on node: D
    find path: D -> D, input path: ["A", "B", "C"]
    start == end: ["A", "B", "C", "D"]
    new path: Optional(["A", "B", "C", "D"])
    new path: Optional(["A", "B", "C", "D"])
    new path: Optional(["A", "B", "C", "D"])
    ["A", "B", "C", "D"]

------------------------
All paths, shortest path
------------------------

Modifications to find all paths, or the shortest path, are trivial:

https://www.python.org/doc/essays/graphs/

First, to make things clearer, remove all the print statements.  The basic change here is addition of a list variable ``paths`` to hold all the new paths we find.

.. sourcecode:: python

    def find_all_paths(graph, start, end, path=[]):
        path = path + [start]
        if start == end:
            return [path]
        if not graph.has_key(start):
            return []
        paths = []
        for node in graph[start]:
            if node not in path:
                newpaths = find_all_paths(graph, node, end, path)
                for newpath in newpaths:
                    paths.append(newpath)
        return paths

        print find_all_paths(graph,start,end)

Rather than returning ``path``:

.. sourcecode:: python

    if start == end:
        return [path]

and 

.. sourcecode:: python

    if not graph.has_key(start):
        return []

compare with the previous code at the top of this section.

To find the shortest path, we could sort the result by length, or only retain the shortest path during running of the algorithm:

.. sourcecode:: python

    import sys
    start, end = sys.argv[1:]

    graph = {'A': ['B', 'C'],
             'B': ['C', 'D'],
             'C': ['D'],
             'D': ['C'],
             'E': ['F'],
             'F': ['C']}

    def find_shortest_path(graph, start, end, path=[]):
        path = path + [start]
        if start == end:
            return path
        if not graph.has_key(start):
            return None
        shortest = None
        for node in graph[start]:
            if node not in path:
                newpath = find_shortest_path(graph, node, end, path)
                if newpath:
                    if not shortest or len(newpath) < len(shortest):
                        shortest = newpath
        return shortest

    print find_shortest_path(graph,start,end)

And the result:

.. sourcecode:: python

    > python find.py A D
    ['A', 'B', 'D']
    >

I leave the implementation of these alternative versions in Swift to you.