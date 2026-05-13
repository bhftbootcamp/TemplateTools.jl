module TemplateTools

export create_project, default_templates

using UUIDs
using Dates
using Jinja2Cpp

const SKIP_RENDER_EXTENSIONS = [".yml", ".ico"]
const INTERNAL_FIELDS = (:template_dir, :project_dir)

function valid_package_name(package_name::String)
    if !occursin(r"^[A-Z].*$", package_name) || endswith(package_name, ".jl")
        error(
            "Invalid package name: '$package_name'. Name must be in CamelCase and not end with '.jl'.",
        )
    else
        return package_name
    end
end

default_templates() = joinpath(@__DIR__, "..", "templates")

struct PkgTemplate
    package_name::String
    github_username::String
    template_dir::String
    project_dir::String
    uuid::UUID
    version::VersionNumber
    owners::String
    maintainers::String
    copyright_holder::String

    function PkgTemplate(
        package_name::String;
        github_username::String,
        template::String,
        templates_dir::String = default_templates(),
        project_dir::String = joinpath(DEPOT_PATH[1], "dev", package_name),
        version::VersionNumber = VersionNumber(0, 1, 0),
        owners::Vector{<:String} = String[],
        maintainers::Vector{<:String} = String[],
        copyright_holder::String = "bhftbootcamp",
    )
        return new(
            valid_package_name(package_name),
            github_username,
            joinpath(templates_dir, template),
            project_dir,
            uuid4(),
            version,
            join("@" .* owners, " "),
            join("@" .* maintainers, " "),
            copyright_holder,
        )
    end
end

function _template_values(template::PkgTemplate)
    values = Dict{String,Any}()
    for name in propertynames(template)
        name in INTERNAL_FIELDS && continue
        values[string(name)] = string(getproperty(template, name))
    end
    values["year"] = string(year(today()))
    return values
end

function _render(source::String, values::Dict{String,Any}; name::String = "")
    tmpl = Jinja2Template(source; name)
    try
        return jinja2_render(tmpl, values)
    finally
        close(tmpl)
    end
end

_should_render(path::AbstractString) = !any(ext -> endswith(path, ext), SKIP_RENDER_EXTENSIONS)

function create_project(
    template::PkgTemplate;
    branch::String,
    repository_ssh_url::String,
    commit::Bool,
    push::Bool,
)
    if !isdir(template.template_dir)
        error("The template directory $(template.template_dir) does not exist.")
    end

    if isdir(template.project_dir) || isfile(template.project_dir)
        error("The directory or file $(template.project_dir) already exists.")
    end

    mkpath(template.project_dir)
    values = _template_values(template)

    for (root, dirs, files) in walkdir(template.template_dir)
        for file in files
            source_path = joinpath(root, file)
            source_name = relpath(source_path, template.template_dir)
            if _should_render(source_path)
                txt = _render(read(source_path, String), values; name = source_name)
                source_name = _render(source_name, values; name = "path")
            else
                txt = read(source_path)
            end
            target_path = joinpath(template.project_dir, source_name)
            mkpath(dirname(target_path))
            write(target_path, txt)
        end
    end

    if commit
        dir = template.project_dir
        run(Cmd(`git init -q`; dir))
        run(Cmd(`git remote add origin $(repository_ssh_url)`; dir))
        run(Cmd(`git branch -M $(branch)`; dir))
        run(Cmd(`git add .`; dir))
        run(Cmd(`git commit -qm "Create project $(template.package_name) 🤖"`; dir))
        push && run(Cmd(`git push -uf origin $(branch)`; dir))
    end

    return true
end

"""
    create_project(; package_name, template, github_username, kw...)

A function that generates a package named `package_name` using a given template.

## Required keyword arguments
- `package_name::String`: The name of the package to be created, used as the directory name. Use names like `Foo`; do not use extensions like `Foo.jl`.
- `template::String`: Template used to create the project (Available: `"general"`, `"green"`).
- `github_username::String`: GitHub username (for example `bhftbootcamp`).

## Optional keyword arguments
- `commit::Bool = true`: Create a commit after initializing the project.
- `push::Bool = false`: Push the commit to the remote repository.
- `branch::String = "master"`: Branch name to use when setting up the repository. Defaults to "master".
- `project_dir::String = joinpath(DEPOT_PATH[1], "dev", package_name)`: Path to the project directory.
- `version::VersionNumber = VersionNumber(0, 1, 0)`: Version of the project, used for initial setup.
- `owners::Vector{<:String} = String[]`: List of project owners.
- `maintainers::Vector{<:String} = String[]`: List of project maintainers.
- `copyright_holder::String = "bhftbootcamp"`: Copyright holder of the project.

## Examples

```julia-repl
julia> create_project(
           package_name = "NumExpr",
           github_username = "bhftbootcamp",
           template = "green",
           version = VersionNumber(0, 1, 0),
           owners = String["bootcampman", ],
           maintainers = String[],
           copyright_holder = "bhftbootcamp",
           branch = "master",
           commit = true,
           push = false,
       )
```
"""
function create_project(;
    package_name::String,
    github_username::String,
    branch::String = "master",
    repository_ssh_url::String = "git@github.com:$(github_username)/$(package_name).jl.git",
    commit::Bool = true,
    push::Bool = false,
    kw...,
)
    return create_project(
        PkgTemplate(
            package_name;
            github_username = github_username,
            kw...,
        );
        repository_ssh_url = repository_ssh_url,
        commit = commit,
        push = push,
        branch = branch,
    )
end

end
