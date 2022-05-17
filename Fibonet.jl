import Base: convert, promote_rule, *, ^, >>

struct ϕField <: Number
    # represents numbers of the form A + B√5 in Big Integer form
    natural::BigInt
    root5coeff::BigInt
end

convert(::Type{ϕField}, x::Int) = ϕField(BigInt(x), 0)

promote_rule(::Type{ϕField}, ::Type{<:Number}) = ϕField

function *(num1::ϕField, num2::ϕField)
    # "Field" multiplication for numbers of the form A + B√5
    natty = num1.natural * num2.natural + 5 * num1.root5coeff * num2.root5coeff
    rooty = num1.natural * num2.root5coeff + num1.root5coeff * num2.natural
    return ϕField(natty, rooty)
end

function >>(num::ϕField, shift::Int)
    # "Field" right bitshift for numbers of the form A + B√5
    return ϕField(num.natural>>shift, num.root5coeff>>shift)
end
	
function ^(base::ϕField, n::Array{Int}, result=2)::ϕField
    if n==[]
        return result
    elseif pop!(n) == 1
        return ^(base, n, (result*result*base) >> 2)
    else
        return ^(base, n, (result*result) >> 1)
    end
end

function ^(base::ϕField, n::Int)::ϕField
    binary_rep = Int[]
    while n > 0
        binary_rep = push!(binary_rep, n%2)
        n >>= 1
    end
    return ^(base, binary_rep)
end

fibonet(n::Int)::BigInt = (ϕField(1,1)^n).root5coeff
