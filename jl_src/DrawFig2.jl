using Serialization: deserialize
using Pkg
Pkg.activate("venv")
using Plots
using StatsPlots: errorline!

struct CSdata
    Sname::String
    depth::Number
    samples::Int
    mean::Number
    var::Number
end

ADFCS_data = open("./data/ADFCSdata.dat", "r") do io
    deserialize(io)
end

FCS_data = open("./data/FCSdata.dat", "r") do io
    deserialize(io)
end

theoretical_data = open("./data/theoretical_data.dat", "r") do io
    deserialize(io)
end

# %%
p = plot(title ="S = {1, 20}",
    size = (800,320),  
    ylims=(-0.07,0),  
    xticks=2 .^ (10:15), 
    xscale = :log2, 
    legend_column = -1
    )

samples = [1024, 2048, 4096,8192, 16384, 32768]


depths = [5, 9, 15, 19, 23]

    fcs = [data.mean for data in filter(x -> x.Sname == "ends",  FCS_data)]
fcs_var = [data.var for data in filter(x -> x.Sname == "ends",  FCS_data)]
plot!(p, samples, fcs[1:6],  
    ribbon = fcs_var[1:6], fillalpha = 0.25, 
    color = RGB(126/255,153/255,244/255),lw = 2.7, label="FCS")


adfcs_lines = []
adfcs_vars = []
for depth in depths
    adfcs = [data.mean 
                for data in filter(
                    x -> x.Sname == "ends" && x.depth == depth,  
                    ADFCS_data
                    )
            ]
    vars = [data.var 
    for data in filter(
        x -> x.Sname == "ends" && x.depth == depth,  
        ADFCS_data
        )
]
    push!(adfcs_lines, adfcs[1:6])
    push!(adfcs_vars, vars[1:6])
end

# plot!(p, samples, adfcs_lines[1], color = RGB(126/255,153/255,244/255),lw = 2, label="ADFCS")
for (depth, lines) in zip(depths, adfcs_lines)
    if depth == 19
        plot!(p, samples, lines, 
        ribbon = adfcs_vars[4], fillalpha = 0.25,
        color = RGB(204/255,124/255,113/255), 
        ls =:dashdot, lw = 2.7, label="d=$depth")
    else
    plot!(p, samples, lines, ls=:dash, lw = 1.8, alpha=0.9, label="d=$depth")
    end
end

hline!(p, [theoretical_data[1]], linestyle=:dot, lw = 2, linecolor=:black, label=false)

display(p)


# %% S = {10, 20}
p = plot(title ="S = {10, 11}",
    size = (800,320),  
    ylims=(0.02, 0.08),  
    xticks=2 .^ (10:15), 
    xscale = :log2, 
    legend_column = -1,
    legend = :bottomright
    )

fcs = [data.mean for data in filter(x -> x.Sname == "close",  FCS_data)]
fcs_var = [data.var for data in filter(x -> x.Sname == "close",  FCS_data)]
plot!(p, samples, fcs[1:6],  
    ribbon = fcs_var[1:6], fillalpha = 0.25, 
    color = RGB(126/255,153/255,244/255),lw = 2.7, label="FCS")





adfcs_lines = []
adfcs_vars = []
for depth in depths
    adfcs = [data.mean 
                for data in filter(
                    x -> x.Sname == "close" && x.depth == depth,  
                    ADFCS_data
                    )
            ]
    vars = [data.var 
    for data in filter(
        x -> x.Sname == "close" && x.depth == depth,  
        ADFCS_data
        )
]
    push!(adfcs_lines, adfcs[1:6])
    push!(adfcs_vars, vars[1:6])
end

# plot!(p, samples, adfcs_lines[1], color = RGB(126/255,153/255,244/255),lw = 2, label="ADFCS")
for (depth, lines) in zip(depths, adfcs_lines)
    if depth == 5
        plot!(p, samples, lines, 
        ribbon = adfcs_vars[1], fillalpha = 0.25,
        color = RGB(204/255,124/255,113/255), 
        ls =:dashdot, lw = 2.7 , label="d=$depth")
    else
    plot!(p, samples, lines, lw = 1.8, ls = :dash, alpha=0.8, label="d=$depth")
    end
end


hline!(p, [theoretical_data[2]], linestyle=:dot, lw = 2, linecolor=:black, label=false)
display(p)


# %% "S = [20]"
p = plot(title ="S = [20]",
    size = (800,320),  
    ylims=(-0.05,-0.036),  
    xticks=2 .^ (10:15), 
    xscale = :log2, 
    legend_column = -1,
    legend = :bottomright
    )

fcs = [data.mean for data in filter(x -> x.Sname == "all",  FCS_data)]
fcs_var = [data.var for data in filter(x -> x.Sname == "all",  FCS_data)]
plot!(p, samples, fcs[1:6],  
    ribbon = fcs_var[1:6], fillalpha = 0.25, 
    color = RGB(126/255,153/255,244/255),lw = 2.7, label="FCS")





adfcs_lines = []
adfcs_vars = []
for depth in depths
    adfcs = [data.mean 
                for data in filter(
                    x -> x.Sname == "all" && x.depth == depth,  
                    ADFCS_data
                    )
            ]
    vars = [data.var 
    for data in filter(
        x -> x.Sname == "all" && x.depth == depth,  
        ADFCS_data
        )
]
    push!(adfcs_lines, adfcs[1:6])
    push!(adfcs_vars, vars[1:6])
end

# plot!(p, samples, adfcs_lines[1], color = RGB(126/255,153/255,244/255),lw = 2, label="ADFCS")
for (depth, lines) in zip(depths, adfcs_lines)
    if depth == 5
        plot!(p, samples, lines, 
        ribbon = adfcs_vars[1], fillalpha = 0.25,
        color = RGB(204/255,124/255,113/255), 
        ls =:dashdot, lw = 2.7, label="d=$depth")
    else
    plot!(p, samples, lines, ls =:dash, lw = 1.8, alpha=0.8, label="d=$depth")
    end
end
# errorline!(p, fcs[1:6], fcs_var[1:6], errorstyle=:ribbon, label=false)


hline!(p, [theoretical_data[3]], linestyle=:dot, lw = 2, linecolor=:black, label=false)

display(p)


# %% "S = {1, 5, 10, 15, 20}"
p = plot(title ="S = {1, 5, 10, 15, 20}",
    size = (800,320),  
    ylims=(-0.15, 0.08),  
    xticks=2 .^ (10:15), 
    xscale = :log2, 
    legend_column = -1,
    legend = :topright
    )

fcs = [data.mean for data in filter(x -> x.Sname == "sep5",  FCS_data)]
fcs_var = [data.var for data in filter(x -> x.Sname == "sep5",  FCS_data)]
plot!(p, samples, fcs[1:6],  
    ribbon = fcs_var[1:6], fillalpha = 0.25, 
    color = RGB(126/255,153/255,244/255),lw = 2.7, label="FCS")





adfcs_lines = []
adfcs_vars = []
for depth in depths
    adfcs = [data.mean 
                for data in filter(
                    x -> x.Sname == "sep5" && x.depth == depth,  
                    ADFCS_data
                    )
            ]
    vars = [data.var 
    for data in filter(
        x -> x.Sname == "sep5" && x.depth == depth,  
        ADFCS_data
        )
]
    push!(adfcs_lines, adfcs[1:6])
    push!(adfcs_vars, vars[1:6])
end

# plot!(p, samples, adfcs_lines[1], color = RGB(126/255,153/255,244/255),lw = 2, label="ADFCS")
for (depth, lines) in zip(depths, adfcs_lines)
    if depth == 9
        plot!(p, samples, lines, 
        ribbon = adfcs_vars[2], fillalpha = 0.25,
        color = RGB(204/255,124/255,113/255), 
        ls =:dashdot, lw = 2.7, label="d=$depth")
    else
    plot!(p, samples, lines, ls =:dash, lw = 1.8, alpha=0.8, label="d=$depth")
    end
end
# errorline!(p, fcs[1:6], fcs_var[1:6], errorstyle=:ribbon, label=false)


hline!(p, [-theoretical_data[4]], linestyle=:dot, lw = 2,  linecolor=:black, label=false)

display(p)


# %% "S = {9, 11,12,20}"
p = plot(title ="random k = 2, S = {9, 11,12,20}",
    size = (800,320),  
    ylims=(-0.15, 0.08),  
    xticks=2 .^ (10:15), 
    xscale = :log2, 
    legend_column = -1,
    legend = :bottomright
    )

fcs = [data.mean for data in filter(x -> x.Sname == "rand2",  FCS_data)]
fcs_var = [data.var for data in filter(x -> x.Sname == "rand2",  FCS_data)]
plot!(p, samples, fcs[1:6],  
    ribbon = fcs_var[1:6], fillalpha = 0.25, 
    color = RGB(126/255,153/255,244/255),lw = 2.7, label="FCS")





adfcs_lines = []
adfcs_vars = []
for depth in depths
    adfcs = [data.mean 
                for data in filter(
                    x -> x.Sname == "rand2" && x.depth == depth,  
                    ADFCS_data
                    )
            ]
    vars = [data.var 
    for data in filter(
        x -> x.Sname == "rand2" && x.depth == depth,  
        ADFCS_data
        )
]
    push!(adfcs_lines, adfcs[1:6])
    push!(adfcs_vars, vars[1:6])
end

# plot!(p, samples, adfcs_lines[1], color = RGB(126/255,153/255,244/255),lw = 2, label="ADFCS")
for (depth, lines) in zip(depths, adfcs_lines)
    if depth == 19
        plot!(p, samples, lines, 
        ribbon = adfcs_vars[4], fillalpha = 0.25,
        color = RGB(204/255,124/255,113/255), 
        ls =:dashdot, lw = 2.7, label="d=$depth")
    else
    plot!(p, samples, lines, ls =:dash, lw = 1.8, alpha=0.8, label="d=$depth")
    end
end
# errorline!(p, fcs[1:6], fcs_var[1:6], errorstyle=:ribbon, label=false)


hline!(p, [theoretical_data[5]], linestyle=:dot, lw = 2, linecolor=:black, label=false)

display(p)


# %% "S = {2,6,9,10,11,12,15,16}"
p = plot(title ="random k = 4, S = {2,6,9,10,11,12,15,16}",
    size = (800,320),  
    ylims=(-0.22, 0.22),  
    xticks=2 .^ (10:15), 
    xscale = :log2, 
    legend_column = -1,
    legend = :topright
    )  

fcs = [data.mean for data in filter(x -> x.Sname == "rand4",  FCS_data)]
fcs_var = [data.var for data in filter(x -> x.Sname == "rand4",  FCS_data)]
plot!(p, samples, fcs[1:6],  
    ribbon = fcs_var[1:6], fillalpha = 0.25, 
    color = RGB(126/255,153/255,244/255),lw = 3.2, label="FCS")





adfcs_lines = []
adfcs_vars = []
for depth in depths
    adfcs = [data.mean 
                for data in filter(
                    x -> x.Sname == "rand4" && x.depth == depth,  
                    ADFCS_data
                    )
            ]
    vars = [data.var 
    for data in filter(
        x -> x.Sname == "rand4" && x.depth == depth,  
        ADFCS_data
        )
]
    push!(adfcs_lines, adfcs[1:6])
    push!(adfcs_vars, vars[1:6])
end

# plot!(p, samples, adfcs_lines[1], color = RGB(126/255,153/255,244/255),lw = 2, label="ADFCS")
for (depth, lines) in zip(depths, adfcs_lines)
    if depth == 5
        plot!(p, samples, lines, 
        ribbon = adfcs_vars[1], fillalpha = 0.25,
        color = RGB(204/255,124/255,113/255), 
        ls =:dashdot, lw = 3.4, label="d=$depth")
    else
    plot!(p, samples, lines, ls =:dash, lw = 1.8, alpha=0.8, label="d=$depth")
    end
end
# errorline!(p, fcs[1:6], fcs_var[1:6], errorstyle=:ribbon, label=false)


hline!(p, [theoretical_data[6]], linestyle=:dot, lw = 2, linecolor=:black, label=false)

display(p)

