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
    # I may want to initialize these values, or handle if they're not present
    data = split(str, '\n')
    local cardname
    local cardread
    local cardtype
    cardtags = String[]
    cardstats = Stat[]
    cardsummary = ""
    for line in data

        if length(line) <= 1

        elseif line[1:2] == "# "
            cardname = line[3:end]

        elseif line[1] == '?'
            if occursin("unread", line)
                cardread = false
            else
                cardread = true
            end

        elseif line[1] == '&'
            cardtype = CardTypes[line[2:end]]

        elseif line[1:2] == "--"
            push!(cardtags, line[3:end])

        elseif line[1] == '+'
            tmp = split(line[2:end], ": ")
            push!(cardstats, Stat(tmp[1], parse(Int64, tmp[2])))

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
            cardstring *= line * '\n'
        elseif isblank(line)
            push!(cards, cardstring)
            cardstring = ""
        else
            cardstring *= line
            push!(cards, cardstring)
        end
    end
    close(file)
    return cards
end

function writecards(cards::Array{Card}, filename::AbstractString)
    local content
    for card in cards
        string = join([
                       "# " * card.name,
                       "?" * string(card.read),
                       "&" * string(card.type),
                       "--" .* card.tags...
                      ],
                      '\n'
                     )
        for stat in card.stats
            string = join([string, "+" * stat.name * ": " * stat.value], 'n')
        end
        string = join([string, card.summary], '\n')
        if !isempty(content)
            content = join([content, string], "\n\n")
        else
            content = string
        end
    end
    write(filename, content)
end

function fitstring(str::AbstractString)
    str = split(str, '\n')
    for s in str
        local width = displaysize(stdout)[2]
        local newlines = [0]
        local i = length(s)
        while length(s)-last(newlines) > width
            if i-last(newlines)<width && s[i]==' '
                s = s[1:i-1]*'\n'*s[i+1:end]
                push!(newlines, i)
                i = length(s)
            end
            i = i-1
        end
    end
    return join(str, '\n')
end

function printa(str::AbstractString, sleep_time::Float64=0.05) #print animate
    str = fitstring(str)
    for c in str
        print(c)
        flush(stdout)
        sleep(sleep_time)
    end
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
export writecards
export fitstring
export printa
export printcard
#TODO: Make layout of printing better, including colors from Crayons
#TODO: updatecard(::Card) for things like damage
#TODO: writecard(::Card) or card_to_str(::Card) (do i really want this??)

end
