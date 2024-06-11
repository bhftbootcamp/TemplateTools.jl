using {{ package_name }}
using Documenter

DocMeta.setdocmeta!({{ package_name }}, :DocTestSetup, :(using {{ package_name }}); recursive = true)

makedocs(;
    modules = [{{ package_name }}],
    sitename = "{{ package_name }}.jl",
    format = Documenter.HTML(;
        repolink = "{{ http_url }}",
        canonical = "{{ docs_url }}",
        edit_link = "master",
        assets = ["assets/favicon.ico"],
        sidebar_sitename = true,  # Set to 'false' if the package logo already contain its name
    ),
    pages = [
        "Home"    => "index.md",
        "Content" => "pages/content.md",
        # Add your pages here ...
    ],
    warnonly = [:doctest, :missing_docs],
)

deploydocs(;
    repo = "github.com/{{ github_username }}/{{ package_name }}.jl",
    devbranch = "master",
    push_preview = true,
)
