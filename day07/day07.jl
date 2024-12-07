function parse_infile(infile)
    eqns = open(infile) do file
        a = Tuple{Int, Vector{Int}}[]
        for line in eachline(file)
            splitline = split(line)
            lhs = parse(Int, splitline[1][1:end-1])
            rhs = parse.(Int, splitline[2:end])
            push!(a, (lhs, rhs))
        end
        a
    end
    return eqns
end

function task1(file="input.txt")
    eqns = parse_infile(file)
    n = 0
    for (lhs, rhs) in eqns
        for idx in 1:Int(2^(length(rhs))-1)
            ops = [d==0 ? Base.:+ : Base.:* for d in digits(idx; base=2, pad=length(rhs)-1)]
            tot = rhs[1]
            for (op, v) in zip(ops, rhs[2:end])
                tot = op(tot, v)
            end
            if tot==lhs
                n += tot
                break
            end
        end
    end
    return n
end

function concat(a::Int, b::Int)::Int
    return a * 10^floor(log(10, b) + 1) + b
end

function task2(file="input.txt")
    ops_map = [Base.:+, Base.:*, concat]
    eqns = parse_infile(file)
    n = 0
    ops = Function[rand(ops_map) for _ in 1:30]
    tot = [0]
    for (lhs, rhs) in eqns
        for idx in 0:Int(3^(length(rhs)-1) - 1)
            for (idx, d) in enumerate(digits(idx; base=3, pad=length(rhs)-1))
                ops[idx] = ops_map[d+1]
            end
            tot[1] = rhs[1]
            for (op, v) in zip(ops, rhs[2:end])
                tot[1] = op(tot[1], v)
                if tot[1] > lhs
                    break
                end
            end
            if tot[1]==lhs
                n += tot[1]
                break
            end
        end
    end
    return n
end

if abspath(PROGRAM_FILE) == @__FILE__
    println("Task 1: $(task1())")
    println("Task 2: $(task2())")
end
