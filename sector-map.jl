using Plots
using FileIO
theme(:rose_pine)

bgimg = load("space.png")
xx = range(0,9,size(bgimg)[1])
yy = range(0,11,size(bgimg)[2])

file = readlines("sector-coords.txt")

x = []
y = []
names = []
for line in file
    if occursin("xCoord", line)
        push!(x, parse(Float64, split(line,' ')[2]))
    elseif occursin("yCoord", line)
        push!(y, parse(Float64, split(line,' ')[2]))
    elseif occursin("Name", line)
        push!(names, split(line,' ')[2])
    end
end

for i in eachindex(x)
    if isodd(x[i])
        y[i] = y[i] - 0.5
    end
end

p = plot(xx,yy, bgimg,
         marker=:star4,
         xlims=(0,9),
         ylims=(0,11),
         framestyle=:box,
         grid=false,
         aspectratio=1,
         size=(600,760),
         ticks=false,
         legend=false,
        )
plot!(x,y,lt=:scatter,marker=:star5)
for i in eachindex(names)
    annotate!(p, x[i], y[i]+0.3, names[i])
end
display(p)
