# runtests

using Test
using TemplateTools
using TemplateTools: valid_package_name, _template_values, _render, _should_render, PkgTemplate

@testset verbose = true "TemplateTools" begin

    @testset "valid_package_name" begin
        @test valid_package_name("MyPkg") == "MyPkg"
        @test valid_package_name("PrettyPkg") == "PrettyPkg"
        @test_throws ErrorException valid_package_name("MyPkg.jl")
        @test_throws ErrorException valid_package_name("mypkg")
    end

    @testset "Jinja2 rendering" begin
        @test _render("Hello, {{ name }}!", Dict{String,Any}("name" => "World")) ==
              "Hello, World!"
        @test _render("No placeholders", Dict{String,Any}()) == "No placeholders"
        @test _render("{{ a }} and {{ b }}", Dict{String,Any}("a" => "X", "b" => "Y")) ==
              "X and Y"
    end

    @testset "template values" begin
        tmpl = PkgTemplate(
            "TestPkg";
            github_username = "testuser",
            template = "general",
        )
        vals = _template_values(tmpl)
        @test vals["package_name"] == "TestPkg"
        @test vals["github_username"] == "testuser"
        @test vals["version"] == "0.1.0"
        @test vals["copyright_holder"] == "bhftbootcamp"
        @test haskey(vals, "uuid")
        @test haskey(vals, "year")
        @test match(r"^\d{4}$", vals["year"]) !== nothing
        @test !haskey(vals, "template_dir")
        @test !haskey(vals, "project_dir")
    end

    @testset "should render" begin
        @test _should_render("README.md") == true
        @test _should_render("src/Foo.jl") == true
        @test _should_render("LICENSE") == true
        @test _should_render(".github/workflows/CI.yml") == false
        @test _should_render("docs/src/assets/favicon.ico") == false
    end

    @testset "create_project general" begin
        mktempdir() do dir
            project_dir = joinpath(dir, "TestPkg")
            create_project(
                package_name = "TestPkg",
                github_username = "testuser",
                template = "general",
                project_dir = project_dir,
                commit = false,
                push = false,
            )

            @test isfile(joinpath(project_dir, "Project.toml"))
            @test isfile(joinpath(project_dir, "src", "TestPkg.jl"))
            @test isfile(joinpath(project_dir, "README.md"))
            @test isfile(joinpath(project_dir, "LICENSE"))
            @test isfile(joinpath(project_dir, ".gitignore"))
            @test isfile(joinpath(project_dir, ".JuliaFormatter.toml"))
            @test isdir(joinpath(project_dir, "docs"))
            @test isdir(joinpath(project_dir, ".github"))

            project_toml = read(joinpath(project_dir, "Project.toml"), String)
            @test occursin("name = \"TestPkg\"", project_toml)
            @test !occursin("{{ package_name }}", project_toml)
            @test !occursin("{{ uuid }}", project_toml)
            @test !occursin("{{ version }}", project_toml)

            readme = read(joinpath(project_dir, "README.md"), String)
            @test occursin("TestPkg", readme)
            @test occursin("testuser", readme)
            @test !occursin("{{ package_name }}", readme)
            @test !occursin("{{ github_username }}", readme)

            src = read(joinpath(project_dir, "src", "TestPkg.jl"), String)
            @test occursin("module TestPkg", src)

            license = read(joinpath(project_dir, "LICENSE"), String)
            @test occursin("bhftbootcamp", license)
            @test !occursin("{{ copyright_holder }}", license)
            @test !occursin("{{ year }}", license)

            # YAML files are copied without rendering
            ci_yml = read(joinpath(project_dir, ".github", "workflows", "CI.yml"), String)
            @test occursin("\${{ matrix.version }}", ci_yml)
        end
    end

    @testset "create_project green" begin
        mktempdir() do dir
            project_dir = joinpath(dir, "GreenPkg")
            create_project(
                package_name = "GreenPkg",
                github_username = "bhftbootcamp",
                template = "green",
                project_dir = project_dir,
                version = VersionNumber(0, 2, 0),
                owners = ["user1"],
                commit = false,
                push = false,
            )

            @test isfile(joinpath(project_dir, "Project.toml"))
            @test isfile(joinpath(project_dir, "src", "GreenPkg.jl"))
            @test isfile(joinpath(project_dir, ".JuliaFormatter.toml"))

            project_toml = read(joinpath(project_dir, "Project.toml"), String)
            @test occursin("name = \"GreenPkg\"", project_toml)
            @test occursin("version = \"0.2.0\"", project_toml)

            @test isfile(joinpath(project_dir, ".github", "workflows", "Coverage.yml"))
            @test isfile(joinpath(project_dir, ".github", "workflows", "Registry.yml"))
            @test isfile(joinpath(project_dir, ".github", "workflows", "Documentation.yml"))
            @test isfile(joinpath(project_dir, ".github", "workflows", "ReleaseTag.yml"))

            codeowners = read(joinpath(project_dir, ".github", "CODEOWNERS"), String)
            @test occursin("@user1", codeowners)
        end
    end

    @testset "duplicate project error" begin
        mktempdir() do dir
            project_dir = joinpath(dir, "DupPkg")
            create_project(
                package_name = "DupPkg",
                github_username = "testuser",
                template = "general",
                project_dir = project_dir,
                commit = false,
                push = false,
            )
            @test_throws ErrorException create_project(
                package_name = "DupPkg",
                github_username = "testuser",
                template = "general",
                project_dir = project_dir,
                commit = false,
                push = false,
            )
        end
    end

    @testset "invalid template error" begin
        mktempdir() do dir
            @test_throws ErrorException create_project(
                package_name = "BadPkg",
                github_username = "testuser",
                template = "nonexistent",
                project_dir = joinpath(dir, "BadPkg"),
                commit = false,
                push = false,
            )
        end
    end

end
