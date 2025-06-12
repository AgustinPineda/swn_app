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

