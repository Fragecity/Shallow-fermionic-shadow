#%%
using Serialization: deserialize
using Pkg
Pkg.activate("venv")
using Plots
using StatsPlots

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

#%%
samples = [1024, 2048, 4096,8192, 16384, 32768]
depths = [5, 9, 15, 19, 23]
legends = append!(["FCS"], ["d = $depth" for depth in depths])
Sname_table = Dict(zip(["ends", "close", "all", "sep5", "rand2", "rand4"], 1:6))
Sname_title = Dict(zip(["ends", "close", "all", "sep5", "rand2", "rand4"], 
                       ["S = {1, 20}", "S = {10, 11}", "S = [20]",
                        "S = {1, 5, 10, 15, 20}", "random k = 2, S = {9, 11,12,20}", "random k = 4, S = {2,6,9,10,11,12,15,16}"]))




function getmean(CSdatas, Sname, depth, theory_num)
    fcs = [abs(data.mean-theoretical_data[theory_num]) for data in filter(
        x -> x.Sname == Sname && x.depth == depth,  CSdatas)]
    fcs_var = [data.var for data in filter(
        x -> x.Sname == Sname && x.depth == depth,  CSdatas)]
    return fcs[1:6], fcs_var[1:6]
end


function plot_Sname(Sname, ylims)
fcs_data, fcs_var = getmean(FCS_data, Sname, Inf, Sname_table[Sname])
plots_data, plots_var = [fcs_data], [fcs_var]
for depth in depths
    adfcs_mean, adfcs_var = getmean(ADFCS_data, Sname, depth, Sname_table[Sname])
    push!(plots_data, adfcs_mean)
    push!(plots_var, adfcs_var)
end


palette(:acton)
groupedbar(hcat(plots_data...), 
           bar_position = :dodge, 
           bar_width=0.7, 
           xticks=(1:6, samples),
           title = Sname_title[Sname],
           size = (450,190),
        #    label = hcat(legends...),
           label = false,
           ylims=ylims,
           )
# groupedbar(hcat(plots_data...))

end

#%%
plot_Sname("ends", (0,0.08))
plot_Sname("close", :auto)
plot_Sname("all", :auto)
plot_Sname("sep5", :auto)
plot_Sname("rand2", :auto)
plot_Sname("rand4", :auto)


