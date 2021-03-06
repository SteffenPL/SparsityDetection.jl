### Rules
using Test
using Cassette
import Cassette: tag, untag, Tagged, metadata, hasmetadata, istagged
using SparseArrays
using SparsityDetection
import SparsityDetection: abstract_run, HessianSparsityContext,
                          JacobianSparsityContext, TermCombination, HessInput
using Test

Term(i...) = TermCombination(Set([Dict(j=>1 for j in i)]))

function jactester(f, Y, X, args...)
    ctx, val = jacobian_sparsity(f, Y, X, args...; raw=true)
end

jactestmeta(args...) = jactester(args...)[1].metadata
jactestval(args...) = jactester(args...) |> ((ctx,val),) -> untag(val, ctx)
jactesttag(args...) = jactester(args...) |> ((ctx,val),) -> metadata(val, ctx)

function hesstester(f, X, args...)
    ctx, terms, val = hessian_sparsity(f, X, args...; raw=true)
end

hesstestmeta(args...) = hesstester(args...)[1].metadata
hesstestval(args...)  = hesstester(args...) |> ((ctx,terms,val),) -> untag(val, ctx)
hesstesttag(args...)  = hesstester(args...) |> ((ctx,terms,val),) -> metadata(val, ctx)
hesstestterms(args...)  = hesstester(args...) |> ((ctx,terms,val),) -> terms


Base.show(io::IO, ::Type{<:Cassette.Context}) = print(io, "ctx")
Base.show(io::IO, ::Type{<:Tagged{<:Any, A}}) where {A} = print(io, "tagged{", A, "}")

