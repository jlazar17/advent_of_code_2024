function parse_match(match::RegexMatch)
    acommab = match.match[5:end-1]

    a, b = parse.(Int, split(acommab, ","))
    return a, b
end

function task1(file="input.txt")
    n = 0
    for line in eachline(open(file))
        for match in eachmatch(r"mul\([0-9]+,[0-9]+\)", line)
            a, b = parse_match(match)
            n += a * b
        end
    end
    return n
end

function task2(file="input.txt")
    n = 0
    do_it = true
    for line in eachline(open(file))
        for match in eachmatch(r"(mul\([0-9]+,[0-9]+\))|(don't\(\))|(do\(\))", line)
            if match.match=="don't()"
                do_it = false
                continue
            elseif match.match=="do()"
                do_it = true
                continue
            end
            if !do_it
                continue
            end
            a, b = parse_match(match)
            n += a * b
        end
    end
    return n
end

if abspath(PROGRAM_FILE) == @__FILE__
    println("Task 1: $(task1())")
    println("Task 2: $(task2())")
end

