import Base: convert, promote_rule, one, *, ^, >>

struct ϕField <: Number
    # represents numbers of the form A + B√5 in Big Integer form
    natural::BigInt
    root5coeff::BigInt
end

convert(::Type{ϕField}, x::Int) = ϕField(BigInt(x), 0)

promote_rule(::Type{ϕField}, ::Type{<:Number}) = ϕField

one(::Type{ϕField}) = ϕField(1,0) 

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
	
function ^(base::ϕField, n::Int, result=one(base), shift=0)::ϕField
    s = 0
    if n==0
        return result
    elseif n==1
        return ^(base, n>>1, (result*base)>>shift)
        # this penultimate level, don't square the base and don't bitshift the result
    elseif n%2==1
        return ^((base*base)>>1, n>>1, (result*base)>>shift, 1)
    else
        return ^((base*base)>>1, n>>1, result, shift)
    end
end

fibonet(n::Int)::BigInt = (ϕField(1,1)^n).root5coeff