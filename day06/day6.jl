function parse_infile(infile::String)
    nrow = open(infile) do file 
        countlines(file)
    end
    m = open(infile) do file
        m = nothing
        for (idx, line) in enumerate(eachline(file))
            if idx==1
                m = Matrix{String}(undef, nrow, length(line))
            end
            m[idx, :] = split(line, "")
        end
        m
    end
    return m
end

function find_initial_state(m::Matrix)
    dx = Vector{Int}(undef, 2)
    x = Vector{Int}(undef, 2)
    nrow, ncol = size(m)
    for idx in 1:nrow
        for jdx in 1:ncol
            v = m[idx, jdx]
            if v=="." || v=="#"
                continue
            end
            @assert v ∈ ["^", ">", "<", "v"]
            x[:] = [idx, jdx]
            if v=="^"
                dx[:] = [-1, 0]
            elseif v==">"
                dx[:] = [0, 1]
            elseif v=="v"
                dx[:] = [1, 0]
            else
                dx[:] = [0, -1]
            end
        end
    end
    return x, dx
end

function increment_dx!(dx)
    if dx==[-1, 0]
        dx[:] = [0, 1]
    elseif dx==[0, 1]
        dx[:] = [1, 0]
    elseif dx==[1, 0]
        dx[:] = [0, -1]
    else
        dx[:] = [-1, 0]
    end
end

function escape_condition(x::Vector{Int}, m::Matrix)
    nrow, ncol = size(m)
    if any(x.==1) || x[1]==nrow || x[2]==ncol
        return true
    end
    return false
end

function task1(file="input.txt")
    m = parse_infile(file)
    x, dx = find_initial_state(m)
    while true
        m[x[1], x[2]] = "X"
        if escape_condition(x, m)
            break
        end
        new_x = x .+ dx
        if m[new_x[1], new_x[2]]=="#"
            increment_dx!(dx)
            continue
        end
        x = new_x
    end
    return sum(m.=="X")
end

function task2(file="input.txt")
    m = parse_infile(file)
    nrow, ncol = size(m)
    x0, dx0 = find_initial_state(m)

    n = 0
    for idx in 1:nrow
        for jdx in 1:ncol
            v = m[idx, jdx]
            m = parse_infile(file)
            x, dx = find_initial_state(m)
            if v=="#" || (all([idx, jdx].==x0))
                continue
            end
            states = UInt64[]
            m[idx, jdx] = "#"
            while true
                state_hash = hash(vcat(x, dx))
                if escape_condition(x, m)
                    break
                end

                if state_hash in states
                    n += 1
                    break
                end

                push!(states, state_hash)

                new_x = x .+ dx
                if m[new_x[1], new_x[2]]=="#"
                    increment_dx!(dx)
                    continue
                end
                x = new_x
            end
        end
    end
    return n
end

if abspath(PROGRAM_FILE) == @__FILE__
    println("Task 1: $(task1())")
    println("Task 2: $(task2())")
end
