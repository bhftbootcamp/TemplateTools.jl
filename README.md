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
    package_name = "NumExpr",
    github_username = "bhftbootcamp",
    template = "green",
    owners = ["bootcampman"],
    commit = true,
    push = false,
)
```

## Templates

Two templates are available:

| | `"green"` | `"general"` |
|---|---|---|
| Registry | [Green](https://github.com/bhftbootcamp/Green) (private) | [General](https://github.com/JuliaRegistries/General) (public) |
| CI | Coverage.yml, Documentation.yml | CI.yml (tests + docs) |
| Release | Registry.yml, ReleaseTag.yml | TagBot.yml |
| Extras | DocPreviewCleanup.yml, CompatHelper.yml | CompatHelper.yml |

Both templates generate the following project structure:

```
PackageName.jl/
├── .github/
│   ├── CODEOWNERS
│   ├── PULL_REQUEST_TEMPLATE.md
│   ├── dependabot.yml
│   ├── ISSUE_TEMPLATE/
│   │   ├── bug_report.md
│   │   └── feature_request.md
│   └── workflows/
│       └── ...                  # see table above
├── .gitignore
├── .JuliaFormatter.toml
├── LICENSE
├── Project.toml
├── README.md
├── docs/
│   ├── Project.toml
│   ├── make.jl
│   └── src/
│       ├── assets/
│       │   └── favicon.ico
│       ├── index.md
│       └── pages/
│           └── content.md
├── src/
│   └── PackageName.jl
└── test/
    ├── Project.toml
    └── runtests.jl
```

## Bug Report

Found a bug? Please report it by [opening an issue](https://github.com/bhftbootcamp/TemplateTools.jl/issues) on our GitHub repository.
