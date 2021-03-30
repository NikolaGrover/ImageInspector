module ImageInspector

using Colors

export image

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

end
