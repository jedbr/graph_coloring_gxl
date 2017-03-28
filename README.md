## generator.rb
Generates instance of graph coloring problem. In this case program creates transmitters within given radius, each transmitter is defined by its position and signal range and represented by graph vertice. Transmitters whose ranges overlap are connected by an edge. Output is a file in GXL format, XML sublanguage created as standard exchange format for graphs.
### Usage
```shell
$ ruby generator.rb A B C
A - area radius
B - number of transmitters
C - signal radius of each transmitter
```
## colorize.rb
Solves the graph coloring problem, gives the minimal number of frequencies needed for transmitters, so there is no signal disruption between adjacent transmitters.
### Usage
```shell
$ ruby colorize.rb [GXL file]
```
