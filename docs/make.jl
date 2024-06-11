using TemplateTools
using Documenter

DocMeta.setdocmeta!(TemplateTools, :DocTestSetup, :(using TemplateTools); recursive = true)

makedocs(;
    modules = [TemplateTools],
    sitename = "TemplateTools.jl",
    format = Documenter.HTML(;
        repolink = "https://github.com/bhftbootcamp/TemplateTools.jl",
        canonical = "https://bhftbootcamp.github.io/TemplateTools.jl",
        edit_link = "master",
        assets = ["assets/favicon.ico"],
        sidebar_sitename = true,
    ),
    pages = [
        "Home" => "index.md",
        "API Reference" => "pages/api_reference.md",
    ],
    warnonly = [:doctest, :missing_docs],
)

deploydocs(;
    repo = "github.com/bhftbootcamp/TemplateTools.jl",
    devbranch = "master",
    push_preview = true,
)
