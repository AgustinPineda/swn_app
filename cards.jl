module Cards

@enum CardType person location faction object rule
#TODO: Potentially try to handle KeyError for CardTypes::Dict
CardTypes = Dict(
                 "person" => person,
                 "location" => location,
                 "faction" => faction,
                 "object" => object,
                 "rule" => rule
                )

mutable struct Stat
    const name::AbstractString
    value::Int64
end

mutable struct Card
    const name::AbstractString
    read::Bool
    const type::CardType
    const tags::Array{String}
    stats::Array{Stat}
    const summary::AbstractString
end

function parsecard(str::AbstractString)::Card
    #TODO: There may be a better way to do this (i.e. using a local variable)
    # Also I may want to initialize these values, or handle if they're not present
    data = split(str, '\n')
    local cardname
    local cardread
    local cardtype
    cardtags = String[]
    cardstats = Stat[]
    cardsummary = ""
    for line in data

        if length(line) < 2
            continue

        elseif line[1:2] == "# "
            cardname = line[3:end]
            continue

        elseif line[1] == '?'
            if occursin("unread", line)
                cardread = false
                continue
            else
                cardread = true
                continue
            end

        elseif line[1] == '&'
            cardtype = CardTypes[line[2:end]]
            continue

        elseif line[1:2] == "--"
            push!(cardtags, line[3:end])
            continue

        elseif line[1] == '+'
            tmp = split(line[2:end], ": ")
            push!(cardstats, Stat(tmp[1], parse(Int64, tmp[2])))
            continue

        elseif isempty(cardsummary)
            cardsummary *= line
        else
            cardsummary = join([cardsummary, line], '\n')
        end
    end
    return Card(
                cardname,
                cardread,
                cardtype,
                cardtags,
                cardstats,
                cardsummary
               )
end

function isblank(str::AbstractString)::Bool
    blankchars = [' ', '\t']
    if str == "" return true end
    for c in str
        if !(c in blankchars); return false; end
    end
    return true
end

function read_cardfile(filename::AbstractString)
    file = open(filename)
    lines = readlines(file)
    cards = String[]
    cardstring = ""
    for line in lines
        if !isblank(line) && line!=last(lines)
            cardstring *= line
        elseif isblank(line)
            push!(cards, cardstring)
            cardstring = ""
        else
            cardstring = join([cardstring, line], '\n')
            push!(cards, cardstring)
        end
    end
    close(file)
    return cards
end

function fitstring(str::AbstractString)
    local width = displaysize(stdout)[2]
    local newlines = [0]
    local i = length(str)
    while length(str)-last(newlines) > width
        if i-last(newlines)<width && str[i]==' '
            str = str[1:i-1]*'\n'*str[i+1:end]
            push!(newlines, i)
            i = length(str)
        end
        i = i-1
    end
    return str
end

function printa(str::AbstractString, sleep_time::Float64=0.05) #print animate
    str = fitstring(str)
    for c in str
        print(c)
        flush(stdout)
        sleep(sleep_time)
    end
    println() #I may want to remove this line from this function
end

function printcard(card::Card)
    local delay = 0.05
    if card.read == true; delay = 0.01; end
    printa(card.name, delay)
    for t in card.tags
        printa(t, delay)
    end
    for s in card.stats
        printa(s.name * ": " * string(s.value), delay)
    end
    printa(card.summary, delay)
    if card.read == false; card.read = true; end
end

export Card
export parsecard
export read_cardfile
export printa
export printcard
export fitstring
#TODO: Make layout of printing better, including colors from Crayons
#TODO: updatecard(::Card) for things like damage
#TODO: writecard(::Card) or card_to_str(::Card) and writecards(::Array{Card})

end
