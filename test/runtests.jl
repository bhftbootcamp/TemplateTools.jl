# runtests

using Test
using TemplateTools
using TemplateTools: valid_package_name

@testset verbose = true "Common tests" begin
    @test valid_package_name("MyPkg") == "MyPkg"
    @test valid_package_name("PrettyPkg") == "PrettyPkg"
    @test_throws ErrorException valid_package_name("MyPkg.jl")
end
