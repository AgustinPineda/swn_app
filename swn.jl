include("cards.jl")
using .Cards

cards = map(parsecard, read_cardfile("info.md"))
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

        print("❯❯ ")
        input = readline()
        if input=="exit"
            break
        end

        cmd = split(input, ' ')
        println()
        #printa("Jarvis: I can see you said \""*input*"\"", 0.05)

        if cmd[1]=="info"
            if length(cmd) < 2
                printa("""
                        Pixel: I can give you information on lots of different things!
                        """)
                continue
            end
            info(join(cmd[2:end], ' '))
            continue
        end

        if cmd[1]=="write"
        end

        if cmd[1]=="stats"
        end

        if cmd[1]=="status"
        end

        println()
    end
end
main()
