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
	
function ^(base::ϕField, n::Int, result=2, nullshifts=0)::ϕField
    if nullshifts>0
        # nullshifts correspond to 0's in the binary representation of n
        return ^(base, n, (result*result)> 1, nullshifts-1)
    elseif n==0
        return result
    else
        p, q, measure = 0, 0, 0
        while n >= 1<<(p+1)
            p +=1
            remainder = n%(1<<p)
            if remainder > measure
                q, measure = p, remainder
            end
        end
        return ^(base, n - 1<<p, (result*result*base)>>2, p-q)
    end
end

fibonet(n::Int)::BigInt = (ϕField(1,1)^n).root5coeff
