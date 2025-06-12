include("cards.jl")
using .Cards

#TODO: change this to fetch data from repository
# cards = parsecard.(read_cardfile("cards.dat")) # array of Cards
cards = map(parsecard, read_cardfile("cards.dat"))
names = getfield.(cards, :name)
C = Dict(zip(lowercase.(names), cards))

function info(topic::AbstractString)
    topic = lowercase(topic)
    try
        printcard(C[topic])
    catch
        printa("No information found on that topic\n")
    end
end

function dmg!(damage::Int64, person::AbstractString)
    try
        person = C[lowercase(person)]
    catch
        printa("No entry found for " * person * '\n')
    end
    if "health" in getfield.(person.stats, :name)
        i = findfirst(x -> x=="health", getfield.(person.stats, :name))
        person.stats[i].value -= damage
    else
        push!(person.stats, Stat("health", -damage))
    end
end

function dmg!(damage::Int64, people::Vector{String})
    for p in people
        dmg!(damage, p)
    end
end

function main()

    print("\033c")

    while true

        print("❯ ")
        input = readline()
        if input=="exit"
            break
        end

        cmd, args... = string.(split(input, ' '))
        println()

        if cmd=="info"
            if length(args) == 0
                printa("""
                        Pixel: I can give you information on lots of different things!
                        """)
                continue
            end
            info(join(args, ' '))
            continue
        end

        if cmd=="dmg"
            try
                if length(args) < 2 error() end
                damage = parse(Int64, args[1])
                dmg!(damage, args[2:end])
                println(string(damage) * " damage done to " * join(args[2:end], ", "))
            catch
                printa("""
                       Error. Cmd format is:
                        dmg <damage> <person1> <person2> ...
                       """)
                continue
            end
        end

        if cmd=="write"
        end

        if cmd=="stats"
        end

        if cmd=="status"
        end

        println()
    end
end
main()
