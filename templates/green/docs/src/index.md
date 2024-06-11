# *It's just a template, but documentation will be here soon.*
---

# Quickstart

A standard julia [guide](https://docs.julialang.org/en/v1/manual/documentation/) that demonstrates the main cases of working with documenting a package. Here is the basic syntax for working with docstrings, style guide and tips.
A more detailed guide to working with the documenter is shown [here](https://documenter.juliadocs.org/stable/showcase/).

Below is a simple example of using docstring:

````julia
\"\"\"
    bar(x[, y])

Compute the Bar index between `x` and `y`.

If `y` is unspecified, compute the Bar index between all pairs of columns of `x`.

# Examples

```julia-repl
julia> bar([1, 2], [1, 2])
1
```
\"\"\"
function bar(x, y) ...
````

## Local documentation build

If you want to build the documentation locally, you need to run the command `julia --project docs/make.jl` in the root of the package directory.

## Documenantion file structure

Let's go through the main documentation files and folders.

### docs/make.jl

This file contains the [makedocs](https://documenter.juliadocs.org/stable/lib/public/#Documenter.makedocs) method, which builds the documentation. Let's look at a few important keywords you might need:

- `pages` can be use to specify a hierarchical page structure, and the order in which the pages appear in the navigation of the rendered output. If omitted, Documenter will automatically generate a flat list of pages based on the files present in the source directory.

```julia
pages = [
    "Overview" => "index.md",
    "tutorial.md",
    "Tutorial" => [
        "tutorial/introduction.md",
        "Advanced" => "tutorial/features.md",
    ],
    "apireference.md",
]
```

- `assets`: For the `logo`, Documenter checks for the existence of `assets/logo.{svg,png,webp,gif,jpg,jpeg}`, in this order. The first one it finds gets displayed at the top of the navigation sidebar. It will also check for `assets/logo-dark.{svg,png,webp,gif,jpg,jpeg}` and use that for dark themes. For the `favicon`, Documenter checks for the existence of `assets/favicon.ico`.

- `sidebar_sitename` determines whether the site name is shown in the sidebar or not. Setting it to `false` can be useful when the logo already contains the name of the package. Defaults to `true`.

### docs/src/index.md

If you use Documenter's default HTML output the name index.md is mandatory. This file will be the main page of the rendered HTML documentation.

### docs/src/pages/

All your markdown documentation files will be located here.

### docs/src/assets/

This is where all the resources you need for documentation are located, inlcuding `logo` and `favicon`. See also [add logo](https://documenter.juliadocs.org/stable/man/guide/#Adding-a-logo-or-icon).
