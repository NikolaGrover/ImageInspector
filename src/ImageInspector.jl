module ImageInspector

using Colors

export image, gridsize, imagegrid

function image(x::AbstractMatrix{T}; flip = true) where {T <: Real}
    xx = flip ? PermutedDimsArray(x, (2, 1)) : x
    return Gray.(xx)
end

function image(x::AbstractArray{T,3}; flip = true) where {T <: Real}
    s = size(x, 3)
    if s == 1
        return image(dropdims(x; dims = 3); flip)
    elseif s == 3
        xx = flip ? PermutedDimsArray(x, (2, 1, 3)) : x
        r, g, b = eachslice(xx; dims=3)
        return RGB.(r, g, b)
    else
        throw(ArgumentError("unsupported size of the third dimension $(s) ∉ [1,3]."))
    end
end

image(x::AbstractArray{T,3}, inds; flip = true) where {T <: Real} = [image(x[:,:,i]; flip) for i in inds]
image(x::AbstractArray{T,4}, inds; flip = true) where {T <: Real} = [image(x[:,:,:,i]; flip) for i in inds]
image(x::AbstractArray{T,3}, ind::Int; flip = true) where {T <: Real} = image(x, [ind]; flip)[1]
image(x::AbstractArray{T,4}, ind::Int; flip = true) where {T <: Real} = image(x, [ind]; flip)[1]

function gridsize(n::Int; nrows::Int = -1, ncols::Int = - 1)
    if nrows < 1
        if ncols < 1
            nrows = round(Int, sqrt(n))
            ncols = ceil(Int, n / nrows)
        else
            nrows = ceil(Int, n / ncols)
        end
    else
        ncols = ceil(Int, n / nrows)
    end
    return nrows, ncols
end

imagegrid(x, ind::Int; flip = true, kwargs...) = image(x, ind; flip)

function imagegrid(x, inds; flip = true, sep = 1, kwargs...)
    imgs = image(x, inds; flip)
    n = length(imgs)
    nrows, ncols = gridsize(n; kwargs...)

    h, w = size(imgs[1])
    A = fill(
        eltype(imgs[1])(1), # white color in proper color type
        nrows*h + (nrows + 1)*sep, # height of the reculting image
        ncols*w + (ncols + 1)*sep, # width of the reculting image
    )

    for i in 1:nrows, j in 1:ncols
        k = j + (i - 1) * ncols
        k > n && break

        rows = (1:h) .+ (i - 1)*h .+ i*sep
        cols = (1:w) .+ (j - 1)*w .+ j*sep
        A[rows, cols] = imgs[k]
    end
    return A
end

using Requires

function __init__()
    @require Plots="91a5bcdd-55d7-5caf-9e0b-520d859cae80" include("imageplot.jl")
end

end
