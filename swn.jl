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

function main()

    print("\033c")

    while true

        print("❯ ")
        input = readline()
        if input=="exit"
            break
        end

        cmd, args... = split(input, ' ')
        println()
        #printa("Jarvis: I can see you said \""*input*"\"", 0.05)

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
