include("swn.jl")

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
