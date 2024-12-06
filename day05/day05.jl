function parse_infile(infile)
    rules = open(infile) do file
        a = Tuple{Int, Int}[]
        for line in eachline(file)
            if length(line)==0
                break
            end
            push!(a, Tuple(parse.(Int, split(line, "|"))))
        end
        a
    end

    pages = open(infile) do file
        a = Vector{Int}[]
        skip = true
        for line in eachline(file)
            if length(line)==0
                skip = false
                continue
            end
            if skip
                continue
            end
            push!(a, parse.(Int, split(line, ",")))
        end
        a
    end
    return rules, pages
end

function task1(file="input.txt")
    n = 0
    rules, pages = parse_infile(file)
    for page in pages
        good = true
        for (r1, r2) in rules
            if r1 ∉ page || r2 ∉ page
                continue
            end
            r2idx = findfirst(page.==r2)
            r1idx = findfirst(page.==r1)
            if r1idx > r2idx
                good = false
                break
            end
        end
        if good
            mid_idx = Int((length(page) + 1) / 2)
            n += page[mid_idx]
        end
    end
    return n
end

function task2(file="input.txt")
    n = 0
    rules, pages = parse_infile(file)
    for page in pages
        rerun = true
        good = true
        while rerun 
            rerun = false
            for (r1, r2) in rules
                if r1 ∉ page || r2 ∉ page
                    continue
                end
                r2idx = findfirst(page.==r2)
                r1idx = findfirst(page.==r1)
                if r1idx < r2idx
                    continue
                end
                good = false
                rerun = true
                page = vcat(page[1:r2idx-1], r1, page[r2idx:r1idx-1], page[r1idx+1:end])
            end
        end
        if !good
            mid_idx = Int((length(page) + 1) / 2)
            n += page[mid_idx]
        end
    end
    return n
end

if abspath(PROGRAM_FILE) == @__FILE__
    println("Task 1: $(task1())")
    println("Task 2: $(task2())")
end
