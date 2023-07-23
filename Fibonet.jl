import Base: convert, promote_rule, *, ^, >>>

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

function >>>(num::ϕField, shift::Int)
    # "Field" right bitshift for numbers of the form A + B√5
    return ϕField(num.natural>>>shift, num.root5coeff>>>shift)
end

function ^(base::ϕField, n::Int, result=2, bitwiser=2^63)::ϕField
    if bitwiser==0
        # done.
        return result
    elseif n & bitwiser == 0
        # this binary digit of n is zero, meaning no power of 2 at that bit
        # so just square the current result, and bitshift down by 1
        return ^(base, n, (result*result)>>>1, bitwiser>>>1)
    else
        # this binary digit of n is one, meaning a power of 2 exists at that bit
        # square the current result, multiply by the base and bitshift down by 2 this time
        return ^(base, n, (result*result*base)>>>2, bitwiser>>>1)
    end
end

fibonet(n::Int)::BigInt = (ϕField(1,1)^n).root5coeff
