# Stars Without Number App

A CLI app to help manage information and stats for the ttrpg *Stars Without Number*.

## Running

A current installation of [Julia](https://julialang.org/) is required.

The main app is in swn.jl. To run it, clone this repository and from it run

```
julia --project=.
```

Within the Julia [REPL](https://docs.julialang.org/en/v1/stdlib/REPL/), enter Pkg mode by typing `]` then instantiate the environment:

```
(swn_app) pkg> instantiate
```

(exit the Pkg REPL by typing `Backspace`)

Once the environment is instantiated, the main app can be run from the Julia REPL with

```julia
include("swn.jl")
```

or from the command line with

```
julia --project=. ./swn.jl
```

The sector-map.jl script is for generating a map of the sector. As of now the repo contains all the data for my game, so customize the data files if you want to use this for a different game.

## Documentation

Currently the app only supports one command, `info` which provides all the information on a topic in info.txt. Currently the only three topics in this repo are test topics for “Fort Collins”, “Thomas”, “Geiger”, and “Marius”. `info Marius` for example will print out all the information on Marius.