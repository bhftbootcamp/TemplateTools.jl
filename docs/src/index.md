# TemplateTools.jl

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
    package_name = "NumExpr",
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
