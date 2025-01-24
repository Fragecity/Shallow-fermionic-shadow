using Plots
using Pkg
Pkg.activate("venv")
using StatsPlots, Statistics, LaTeXStrings
using Serialization: deserialize

struct KCdata
	depth::Number
	samples::Int
	data::Vector
end

samples = [1024, 2048, 4096, 6648, 10088, 14256, 20168, 26608, 35112]
path = "./improve_src/data/"

function loadFCSdata(shots)
	FCSdata = open(path * "KCFCSdata.dat", "r") do io
		deserialize(io)
	end
	data = filter(d -> d.samples == shots, FCSdata)

	return [d.data for d in data]
end

function loaddata(depth, shots)
	ADFCSdata = open(path * "KCADFCSdata$depth.dat", "r") do io
		deserialize(io)
	end
	data = filter(d -> d.samples == shots, ADFCSdata)

	return [d.data for d in data]
end

theorydata = open(path * "KCtheory.dat", "r") do io
	deserialize(io)
end # -0.19660900392697234

FCSdata = let datas = []
	for s in samples
		push!(datas, mean(vcat(loadFCSdata(s)...)))
	end
	datas
end

FCSerr = let datas = []
	for s in samples
		# push!(datas, var(vcat(loadFCSdata(s)...)))
		push!(datas, std(vcat(loadFCSdata(s)...)))
	end
	datas
end

ADdata3 = let datas = []
	for s in samples
		push!(datas, mean(vcat(loaddata(3, s)...)))
	end
	datas
end
ADdata5 = let datas = []
	for s in samples
		push!(datas, mean(vcat(loaddata(5, s)...)))
	end
	datas
end
ADdata7 = let datas = []
	for s in samples
		push!(datas, mean(vcat(loaddata(7, s)...)))
	end
	datas
end
ADdata9 = let datas = []
	for s in samples
		push!(datas, mean(vcat(loaddata(9, s)...)))
	end
	datas
end
ADdata11 = let datas = []
	for s in samples
		push!(datas, mean(vcat(loaddata(11, s)...)))
	end
	datas
end
ADdata3err = let datas = []
	for s in samples
		# push!(datas, var(vcat(loaddata(3, s)...)))
		push!(datas, std(vcat(loaddata(3, s)...)))
	end
	datas
end
ADdata5err = let datas = []
	for s in samples
		push!(datas, std(vcat(loaddata(5, s)...)))
	end
	datas
end
ADdata7err = let datas = []
	for s in samples
		push!(datas, std(vcat(loaddata(7, s)...)))
	end
	datas
end
ADdata9err = let datas = []
	for s in samples
		push!(datas, std(vcat(loaddata(9, s)...)))
	end
	datas
end
ADdata11err = let datas = []
	for s in samples
		push!(datas, std(vcat(loaddata(11, s)...)))
	end
	datas
end
Plots.palette(:acton)
color1 = RGB(68 / 255, 133 / 255, 199 / 255)
color2 = RGB(212 / 255, 86 / 255, 46 / 255)
#%%
p1f = -log2.(-FCSdata)
fillfup = -log2.(-(FCSdata - FCSerr))

# symlog2(x) = x>0 ? log2(x) : -log2(-x)

fillfdown = -log2.(-min.(FCSdata + FCSerr, -1e-10))

p1d = -log2.(-ADdata3)
fillaup = -log2.(-(ADdata3 - ADdata3err))
filladown = -log2.(-min.(ADdata3 + ADdata3err, -1e-10))
# p1 = Plots.plot(samples, fillfup, fillrange = fillfdown,
# 	fillcolor = color1,
# 	linealpha = 0,
# 	fillalpha = 0.3,
# 	label = false)

# hline!(p1, 


# Plots.plot!(p1, samples,
# 	fillaup, fillrange = filladown,
# 	fillcolor = color2,
# 	linealpha = 0,
# 	fillalpha = 0.3,
# 	label = false)

p1 = Plots.plot( samples,
# Plots.plot( samples,
	# [FCSdata ADdata3],
	[p1f p1d],
	# ribbon = [FCSerr/1.12 ADdata3err/1.12],
	label = ["FCS data" "d = 3"],
	xlabel = "samples",
	ylabel = "Estimation value",
	linestyle = [:solid :dashdot],
	linewidth = 3,
	xscale = :log2,
	# fillalpha = 0.2,
	legend = :bottomright,
	# yscale=:log2,
	xticks = 2 .^ (10:15),
	yticks = (1.4:0.4:4, [L"-2^{%$s}" for s in 1.4:0.4:4]),
	# yticks = 1.4:0.3:4,
	# yticks = (2.0 .^(-5:-1), ["1" "2" "3" "4" "5"]),
	# yticks = 2.0 .^(-5:-1),
	marker = [:circle :diamond],
	markersize = 6.5,
	guidefontsize = 14,
	color = [color1 color2],
	ylims = (1.4, 3),
    # subplot = 1
    size = (900,600)
)


Plots.plot!(p1, samples,
	[-log2.(-ADdata5), -log2.(-ADdata7), -log2.(-ADdata9), -log2.(-ADdata11)],
	label = ["d = 5" "d = 7" "d = 9" "d = 11"],
	linewidth = 1.5,
	linestyle = :dot,
	linealpha = 0.5,
    # subplot = 1
)

hline!(p1,
    [-log2(-theorydata)],  # 水平线的 y 值
	label = "Theoretical Value",  # 图例
	linewidth = 2,  # 线宽
	color = :black,  # 颜色
	linestyle = :dash,  # 线型（虚线）
	xscale = :log2,
	yscale = :log2,
    # subplot = 1
)


p2 = Plots.plot(samples, 
# Plots.plot!(samples, 
# [abs.(FCSdata .- theorydata) abs.(ADdata3 .- theorydata)],
[FCSerr, ADdata3err],
	# ribbon = [FCSerr ADdata3err],
	#  ribbon=(y_lower_error, y_upper_error), 
	label = ["FCS data" "d = 3"],
	# label = false,
	xlabel = "samples",
	ylabel = "Estimation error",
	linestyle = [:solid :dashdot],
	#  title="Line Plot with Asymmetric Error Shading", 
	linewidth = 3,
	fillalpha = 0.2,
	# legend = :bottomright,
	legend = :topright,
	xscale = :log2,
    xticks = 2 .^ (10:15),
	# yscale = :log2,
	marker = [:circle :diamond],
	markersize = 6.5,
	# ylims = ,
    # subplot = 2,
    size = (800,600)
)

Plots.plot!(p2, samples,
# Plots.plot!(samples,
	# [abs.(ADdata5 .- theorydata), abs.(ADdata7 .- theorydata), abs.(ADdata9 .- theorydata), abs.(ADdata11 .- theorydata)],
	[ADdata5err, ADdata7err, ADdata9err, ADdata11err],
	label = ["d = 5" "d = 7" "d = 9" "d = 11"],
	linewidth = 1.5,
	linestyle = :dot,
	linealpha = 0.5,
    xscale = :log2,
    # label = false
	# yscale = :log2,
    # subplot = 2,
)


# Plots.plot(p1,p2, size = (1600, 600), layout=(1,2))
# Plots.plot(size = (1800, 600), layout=(1,2))
# Plots.pdf("figure4_origin.pdf")