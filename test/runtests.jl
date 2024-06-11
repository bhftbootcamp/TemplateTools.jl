# runtests

using Test
using TemplateTools
using TemplateTools: valid_package_name, http_url, ssh_url, docs_url

@testset verbose = true "Common tests" begin
    @test valid_package_name("MyPkg") == "MyPkg"
    @test valid_package_name("PrettyPkg") == "PrettyPkg"
    @test_throws ErrorException valid_package_name("MyPkg.jl")
    @test http_url("bhftbootcamp", "NumExpr") == "https://github.com/bhftbootcamp/NumExpr.jl"
    @test ssh_url("bhftbootcamp", "NumExpr") == "git@github.com:bhftbootcamp/NumExpr.jl.git"
    @test docs_url("bhftbootcamp", "NumExpr") == "https://bhftbootcamp.github.io/NumExpr.jl"
end
