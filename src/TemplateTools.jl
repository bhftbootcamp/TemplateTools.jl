module TemplateTools

export create_project

using UUIDs

const WITHOUT_RENDER = [".yml", ".ico"]
const TEMPLATES_PATH = joinpath(@__DIR__, "..", "templates")

function valid_package_name(package_name::String)
    if !occursin(r"^[A-Z].*$", package_name) || endswith(package_name, ".jl")
        error(
            "Invalid package name: '$package_name'. Name must be in CamelCase and not end with '.jl'.",
        )
    else
        package_name
    end
end

function http_url(github_username::String, package_name::String)
    return "https://github.com/$(github_username)/$(package_name).jl"
end

function ssh_url(github_username::String, package_name::String)
    return "git@github.com:$(github_username)/$(package_name).jl.git"
end

function docs_url(github_username::String, package_name::String)
    return "https://$(github_username).github.io/$(package_name).jl"
end

struct PkgTemplate
    package_name::String
    github_username::String
    template_dir::String
    http_url::String
    ssh_url::String
    docs_url::String
    project_dir::String
    uuid::UUID
    version::VersionNumber
    owners::String
    maintainers::String
    copyright_holder::String

    function PkgTemplate(
        package_name::String;
        github_username::String = "bhftbootcamp",
        template::String = "general",
        project_dir::String = joinpath(DEPOT_PATH[1], "dev", package_name),
        version::VersionNumber = VersionNumber(0, 1, 0),
        owners::Vector{<:String} = String[],
        maintainers::Vector{<:String} = String[],
        copyright_holder::String = "bhftbootcamp",
    )
        return new(
            valid_package_name(package_name),
            github_username,
            joinpath(TEMPLATES_PATH, template),
            http_url(github_username, package_name),
            ssh_url(github_username, package_name),
            docs_url(github_username, package_name),
            project_dir,
            uuid4(),
            version,
            join(owners, " "),
            join(maintainers, " "),
            copyright_holder
        )
    end
end

function create_project(
    template::PkgTemplate;
    commit::Bool = true,
    push::Bool = false,
    kw...,
)
    if !isdir(joinpath(DEPOT_PATH[1], "dev"))
        mkdir(joinpath(DEPOT_PATH[1], "dev"))
    end

    if isdir(template.project_dir) || isfile(template.project_dir)
        error("$(template.project_dir) already exists.")
    else
        mkdir(template.project_dir)
    end

    for (root, dirs, files) in walkdir(template.template_dir)
        for file in files
            source_path = joinpath(root, file)
            txt = read(source_path, String)
            source_name = relpath(source_path, template.template_dir)
            if !any(endswith.(source_path, WITHOUT_RENDER))
                for prop in propertynames(template)
                    val = getfield(template, prop)
                    txt = replace(txt, Regex("{{\\s*($prop)\\s*}}") => val)
                    source_name = replace(source_name, Regex("{{\\s*($prop)\\s*}}") => val)
                end
            end
            target_path = joinpath(template.project_dir, source_name)
            mkpath(dirname(target_path))
            write(target_path, txt)
        end
    end

    if commit
        run(Cmd(`git init -q`, dir = template.project_dir))
        run(Cmd(`git remote add origin $(template.ssh_url)`, dir = template.project_dir))
        run(Cmd(`git branch -M master`, dir = template.project_dir))
        run(Cmd(`git add .`, dir = template.project_dir))
        run(
            Cmd(
                `git commit -qm "🤖 $(template.package_name).jl project created"`,
                dir = template.project_dir,
            ),
        )
        push && run(Cmd(`git push -uf origin master`, dir = template.project_dir))
    end

    return true
end

"""
    create_project(package_name::String; kw...)

A function that generates a package named `package_name` using a given template.

## Keyword arguments
- `template::String = "general"`: The template used to create the project (Available: `"general"`, `"green"`).
- `github_username::String = "bhftbootcamp"`: The GitHub username.
- `commit::Bool = true`: A flag indicating whether to create a commit after initializing the project.
- `push::Bool = false`: A flag indicating whether to push the commit to the remote repository.
- `project_dir::String = joinpath(DEPOT_PATH[1], "dev", package_name)`: The path to the project directory.
- `version::VersionNumber = VersionNumber(0, 1, 0)`: The version of the project, used for initial setup.
- `owners::Vector{<:String} = String[]`: A list of project owners.
- `maintainers::Vector{<:String} = String[]`: A list of project maintainers.
- `copyright_holder::String = "bhftbootcamp"`: The copyright holder of the project.

## Examples

```julia-repl
julia> create_project(
           "NumExpr";
           github_username = "bhftbootcamp",
           template = "green",
           version = VersionNumber(0, 1, 0),
           owners = String[],
           maintainers = String[],
           copyright_holder = "bhftbootcamp",
           commit = true,
           push = false,
       )
```
"""
function create_project(
    package_name::String;
    commit::Bool = true,
    push::Bool = false,
    kw...,
)
    return create_project(
        PkgTemplate(package_name; kw...);
        commit = commit,
        push = push,
    )
end

end
