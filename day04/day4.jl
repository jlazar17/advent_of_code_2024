const target = ["X", "M", "A", "S"]

function read_file_to_matrix(file)
    m = nothing
    nlines = countlines(open(file))
    for (idx, line) in enumerate(eachline(open(file)))
        if idx==1
            m = Matrix{String}(undef, nlines, length(line))
        end
        m[idx, :] = split(line, "")
    end
    return m
end

function base_search(m::Matrix, target::Vector, idx::Int, jdx::Int, isign::Int, jsign::Int)
    proposal = [m[idx+isign * o, jdx+jsign * o] for o in 0:3]
    return all(proposal.==target)
end

function search_x(m::Matrix, target::Vector, idx::Int, jdx::Int)
    proposal_1 = [m[idx+o, jdx+o] for o in -1:1]
    proposal_2 = [m[idx-o, jdx+o] for o in -1:1]
    check_1 = all(proposal_1.==target) || all(reverse(proposal_1).==target)
    check_2 = all(proposal_2.==target) || all(reverse(proposal_2).==target)
    return check_1 && check_2
end

function task1(file="input.txt")
    t = ["X", "M", "A", "S"]
    m = read_file_to_matrix(file)
    ncols, nrows = size(m)

    n = 0
    for idx in 1:ncols
        for jdx in 1:nrows
            can_south = idx <= nrows - 3
            can_north = idx >= 4
            can_east = jdx <= ncols - 3
            can_west = jdx >= 4
            if can_south
                n += Int(base_search(m, t, idx, jdx, 1, 0))
            end
            if can_north
                n += Int(base_search(m, t, idx, jdx, -1, 0))
            end
            if can_east
                n += Int(base_search(m, t, idx, jdx, 0, 1))
            end
            if can_west
                n += Int(base_search(m, t, idx, jdx, 0, -1))
            end
            if can_south && can_east
                n += Int(base_search(m, t, idx, jdx, 1, 1))
            end
            if can_north && can_east
                n += Int(base_search(m, t, idx, jdx, -1, 1))
            end
            if can_south && can_west
                n += Int(base_search(m, t, idx, jdx, 1, -1))
            end
            if can_north && can_west
                n += Int(base_search(m, t, idx, jdx, -1, -1))
            end
        end
    end
    return n
end

function task2(file="input.txt")

    t = ["M", "A", "S"]
    m = read_file_to_matrix(file)
    ncols, nrows = size(m)

    n = 0
    for idx in 1:ncols
        for jdx in 1:nrows
            can_south = idx <= nrows - 1
            can_north = idx >= 2
            can_east = jdx <= ncols - 1
            can_west = jdx >= 2
            if !all([can_south, can_north, can_east, can_west])
                continue
            end
            n += Int(search_x(m, t, idx, jdx))
        end
    end
    return n
end

if abspath(PROGRAM_FILE) == @__FILE__
    println("Task 1: $(task1())")
    println("Task 2: $(task2())")
end
