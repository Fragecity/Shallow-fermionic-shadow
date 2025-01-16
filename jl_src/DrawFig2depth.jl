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
p = plot(title = "S = {1, 20}",
	size = (800, 200),
	ylims = (-0.06, -0.005),
	legend_column = -1,
)

samples = [4096, 8192, 16384, 32768]

depths = [5, 9, 15, 19, 23]


adfcs_lines = []
adfcs_vars = []
for sample in samples
	adfcs = [data.mean
			 for data in filter(
		x -> x.Sname == "ends" && x.samples == sample,
		ADFCS_data,
	)
	]

	push!(adfcs_lines, adfcs[1:5])
end

# plot!(p, samples, adfcs_lines[1], color = RGB(126/255,153/255,244/255),lw = 2, label="ADFCS")
for (sample, lines) in zip(samples, adfcs_lines)

	# plot!(p, depths, lines, lw = 2.2, label = "samples=$sample")
	plot!(p, depths, lines, lw = 2.2, label = false)

end

hline!(p, [theoretical_data[1]], linestyle = :dash, linecolor = :black, label = false)

display(p)


# %% S = [10, 11]
p = plot(title = "S = {10, 11}",
	size = (800, 200),
	ylims = (0.03, 0.06),
	legend = :top,
)


adfcs_lines = []
adfcs_vars = []
for sample in samples
	adfcs = [data.mean
			 for data in filter(
		x -> x.Sname == "close" && x.samples == sample,
		ADFCS_data,
	)
	]

	push!(adfcs_lines, adfcs[1:5])
end

# plot!(p, samples, adfcs_lines[1], color = RGB(126/255,153/255,244/255),lw = 2, label="ADFCS")
for (sample, lines) in zip(samples, adfcs_lines)
	plot!(p, depths, lines, lw = 2.2, label = false)
end

hline!(p, [theoretical_data[2]], linestyle = :dash, linecolor = :black, label = false)
display(p)


# %% "S = [20]"
p = plot(title = "S = [20]",
	size = (800, 200),
	ylims = (-0.047, -0.038),
)
adfcs_lines = []
adfcs_vars = []
for sample in samples
	adfcs = [data.mean
			 for data in filter(
		x -> x.Sname == "all" && x.samples == sample,
		ADFCS_data,
	)
	]

	push!(adfcs_lines, adfcs[1:5])
end

# plot!(p, samples, adfcs_lines[1], color = RGB(126/255,153/255,244/255),lw = 2, label="ADFCS")
for (sample, lines) in zip(samples, adfcs_lines)
	plot!(p, depths, lines, lw = 2.2, label = false)
end

hline!(p, [theoretical_data[3]], linestyle = :dash, linecolor = :black, label = false)
display(p)


# %% "S = {1, 5, 10, 15, 20}"
p = plot(title = "S = {1, 5, 10, 15, 20}",
	size = (800, 200),
	ylims = (-0.09, -0.03),
)

adfcs_lines = []
adfcs_vars = []
for sample in samples
	adfcs = [data.mean
			 for data in filter(
		x -> x.Sname == "sep5" && x.samples == sample,
		ADFCS_data,
	)
	]

	push!(adfcs_lines, adfcs[1:5])
end

# plot!(p, samples, adfcs_lines[1], color = RGB(126/255,153/255,244/255),lw = 2, label="ADFCS")
for (sample, lines) in zip(samples, adfcs_lines)
	plot!(p, depths, lines, lw = 2.2, label = false)
end

hline!(p, [-theoretical_data[4]], linestyle = :dash, linecolor = :black, label = false)
display(p)


# %% "S = {9, 11,12,20}"
p = plot(title = "random k = 2, S = {9, 11,12,20}",
	size = (800, 200),
	ylims = (-0.06, -0.01),
)
adfcs_lines = []
adfcs_vars = []
for sample in samples
	adfcs = [data.mean
			 for data in filter(
		x -> x.Sname == "rand2" && x.samples == sample,
		ADFCS_data,
	)
	]

	push!(adfcs_lines, adfcs[1:5])
end

# plot!(p, samples, adfcs_lines[1], color = RGB(126/255,153/255,244/255),lw = 2, label="ADFCS")
for (sample, lines) in zip(samples, adfcs_lines)
	plot!(p, depths, lines, lw = 2.2, label = false)
end

hline!(p, [theoretical_data[5]], linestyle = :dash, linecolor = :black, label = false)
display(p)


# %% "S = {2,6,9,10,11,12,15,16}"
p = plot(title = "random k = 4, S = {2,6,9,10,11,12,15,16}",
	size = (800, 200),
	ylims = (-0.1, 0.05),
)
adfcs_lines = []
adfcs_vars = []
for sample in samples
	adfcs = [data.mean
			 for data in filter(
		x -> x.Sname == "rand4" && x.samples == sample,
		ADFCS_data,
	)
	]

	push!(adfcs_lines, adfcs[1:5])
end

# plot!(p, samples, adfcs_lines[1], color = RGB(126/255,153/255,244/255),lw = 2, label="ADFCS")
for (sample, lines) in zip(samples, adfcs_lines)
	plot!(p, depths, lines, lw = 2.2, label = false)
end

hline!(p, [theoretical_data[6]], linestyle = :dash, linecolor = :black, label = false)
display(p)

