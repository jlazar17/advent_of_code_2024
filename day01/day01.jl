function parse_infile(infile)
    nrow = open(infile) do file
        countlines(file)
    end
    m = Matrix{Int}(undef, nrow, 2)
    open(infile) do file
        for (idx, line) in enumerate(readlines(file))
            m[idx, :] = parse.(Int, split(line)) 
        end
    end
    return m
end

function task1(file="input.txt")
    m = parse_infile(file)
    sort!(m, dims=1)
    return sum(abs.(m[:, 1] - m[:, 2]))
end

function task2(file="input.txt")
    m = parse_infile(file)
    n = 0
    for v in m[:, 1]
        n += sum(m[:, 2].==v) * v
    end
    return n
end

if abspath(PROGRAM_FILE) == @__FILE__
    println("Task 1: $(task1())")
    println("Task 2: $(task2())")
end
