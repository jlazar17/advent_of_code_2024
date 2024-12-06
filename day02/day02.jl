function parse_line(linestring)
    return parse.(Int, split(linestring, " "))
end

function is_monotonic(readings)
    d = diff(readings)
    return !any(d.==0) && all(sign(d[1]) .== sign.(d))
end

function is_slow(readings)
    absd = abs.(diff(readings))
    return maximum(absd) <= 3
end

function is_safe(readings)
    if !is_monotonic(readings)
        return false
    end
    if !is_slow(readings)
        return false
    end
    return true
end

function task1(file="input.txt")
    n = 0
    for line in eachline(open(file))
        readings = parse_line(line)
        if !is_safe(readings)
            continue
        end
        n += 1
    end
    return n
end

function task2(file="input.txt")
    n = 0
    for line in eachline(open(file))
        readings = parse_line(line)
        for idx in 1:length(readings)
            new_readings = deleteat!(copy(readings), idx)
            if is_safe(new_readings)
                n += 1
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
