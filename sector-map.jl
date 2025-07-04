using Plots
using FileIO
theme(:rose_pine)
default(fontfamily="Courier Bold")

xrange=(0,6.75)
yrange=(-0.25,9.4)

bgimg = load("space.jpg")
xx = range(xrange...,size(bgimg)[1])
yy = range(yrange...,size(bgimg)[2])

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

# Forms cartesian coordinates from hex grid coordinates
function Hex(x,y) #returns a tuple of coordinates (x,y)
    hexdistance = sqrt(3) * 0.5
    θ = π/6
    xdist = hexdistance * cos(θ) * x
    ydist = hexdistance * y
    if x%2 == 1
        ydist = ydist - sin(θ) * hexdistance
    end
    return(xdist, ydist)
end

function drawhex(x,y) #returns a tuple of two vectors ([x],[y])
    hexpts = [x+1           y+0;
              x+cos(π/3)    y+sin(π/3);
              x+cos(2π/3)   y+sin(2π/3);
              x-1           y+0;
              x+cos(4π/3)   y+sin(4π/3);
              x+cos(5π/3)   y+sin(5π/3);
              x+1           y+0]
    pts = hexpts ./ 2
    return(pts[:,1] .+ x/2, pts[:,2] .+ y/2)
end

for i in eachindex(x)
    hexx = Hex(x[i],y[i])[1]
    hexy = Hex(x[i],y[i])[2]
    x[i] = hexx
    y[i] = hexy
end

p = plot(xx,yy, bgimg,
         marker=:star4,
         xlims=xrange,
         ylims=yrange,
         framestyle=:box,
         grid=false,
         aspectratio=1,
         size=(600,760),
         ticks=false,
         legend=false,
         dpi=400
        )
plot!(x,y,lt=:scatter,marker=:star5)
for i in eachindex(names)
    annotate!(p, x[i], y[i]+0.2, (names[i], 7))
end
for i in 1:8, j in 1:10
    plot!(drawhex(Hex(i,j)...)..., color=:white)
end
display(p)
savefig("sector-map.png")
