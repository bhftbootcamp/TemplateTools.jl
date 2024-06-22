# TemplateTools.jl

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://bhftbootcamp.github.io/TemplateTools.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://bhftbootcamp.github.io/TemplateTools.jl/dev/)
[![Build Status](https://github.com/bhftbootcamp/TemplateTools.jl/actions/workflows/Coverage.yml/badge.svg?branch=master)](https://github.com/bhftbootcamp/TemplateTools.jl/actions/workflows/Coverage.yml?query=branch%3Amaster)
[![Coverage](https://codecov.io/gh/bhftbootcamp/TemplateTools.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/bhftbootcamp/TemplateTools.jl)
[![Registry](https://img.shields.io/badge/registry-Green-green)](https://github.com/bhftbootcamp/Green)

Template generator for Julia Lang packages used by the [#bhftbootcamp](https://github.com/bhftbootcamp) community, intended for registration with the [General](https://github.com/JuliaRegistries/General) and [Green](https://github.com/bhftbootcamp/Green) registries.

## Installation

If you haven't installed our [local registry](https://github.com/bhftbootcamp/Green) yet, do that first:

```
] registry add https://github.com/bhftbootcamp/Green.git
```

To install TemplateTools, simply use the Julia package manager:

```julia
] add TemplateTools
```

## Usage

A new package can be created as follows:

```julia
using TemplateTools

create_project(
    "NumExpr";
    github_username = "bhftbootcamp",
    template = "green", # "general" or "green"
    version = VersionNumber(0, 1, 0),
    owners = String["bootcampman", ],
    maintainers = String[],
    copyright_holder = "bhftbootcamp",
    commit = true,
    push = false,
)
```

## Bug Report 🐞

Found a bug? Please report it by opening an issue on our GitHub repository.
