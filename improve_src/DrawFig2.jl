# using Plots
using StatsPlots, Statistics, LaTeXStrings
using Serialization: deserialize

 
struct CSdata
	Sname::String
	S::Vector
	depth::Number
	samples::Int
	data::Vector
end

Snames = ["k2d3", "k2d9", "k4d6", "k4d15", "k6d4", "k6d13"]
SnamesTex = [L"k=2, d_\mathrm{int}(S)=3", 
	L"k=2, d_\mathrm{int}(S)=9", 
	L"k=4, d_\mathrm{int}(S)=6", 
	L"k=4, d_\mathrm{int}(S)=15", 
	L"k=6, d_\mathrm{int}(S)=4", 
	L"k=2, d_\mathrm{int}(S)=13"]
Slst = [[9, 12], [5, 14], [1, 7, 13, 19], [3, 18, 19, 20], [1, 5, 9, 13, 17, 20], [3, 16, 17, 18, 19, 20]]
samples = [1024, 2048, 4096, 8192, 16384, 32768]
path = "./improve_src/data/"

theorydata = open(path * "theory.dat", "r") do io
	deserialize(io)
end
# 0.007054127777895658
# 0.03303946820722126
# -0.026530915869530887
# 0.0231482382053107
# -0.044508251737327476
# 0.017416153453355895




function loadFCSdata(Sname, shots)
	FCSdata = open(path * "FCSdata.dat", "r") do io
		deserialize(io)
	end
	data = filter(d -> d.Sname == Sname && d.samples == shots, FCSdata)

	# return [d.data for d in data]
	return std(vcat([d.data for d in data]...))
	# return [d.data for d in data]
end

function loaddata(depth, Sname, shots)
	ADFCSdata = open(path * "ADFCSdata$depth.dat", "r") do io
		deserialize(io)
	end
	data = filter(d -> d.Sname == Sname && d.samples == shots, ADFCSdata)

	return std(vcat([d.data for d in data]...))
end


# together version
# function plot_Sname()
# 	datas = []
# 	for i in 1:6
#         fcs = []
# 		for s in samples[1:6]
#             # println(i,"\t", s)
#             # println(abs(mean(vcat(loadFCSdata(Snames[i], s)...)) - theorydata[i]))
# 			# push!(fcs, abs(mean(vcat(loadFCSdata(Snames[i], s)...)) - theorydata[i]))
# 			push!(fcs, loadFCSdata(Snames[i], s))
# 		end
#         push!(datas, fcs)
# 	end
	
# 	for depth in [5, 9, 13, 17, 21]
#         # adfcs = []
# 		for i in 1:6
# 			ls = []
# 			for s in samples
# 				push!(ls, loaddata(depth, Snames[i], s))
# 			end
# 			# push!(adfcs, ls)
# 			push!(datas, ls)
# 		end
#         # push!(datas, adfcs)
# 	end
# 	return datas

# end


function plot_Sname(i)
	datas = []
	# for i in 1:6
		fcs = []
		for s in samples[1:6]
			# println(i,"\t", s)
			# println(abs(mean(vcat(loadFCSdata(Snames[i], s)...)) - theorydata[i]))
			# push!(fcs, abs(mean(vcat(loadFCSdata(Snames[i], s)...)) - theorydata[i]))
			push!(fcs, loadFCSdata(Snames[i], s))
		end
		push!(datas, fcs)
	# end
	
	for depth in [5, 9, 13, 17, 21]
		# adfcs = []
		# for i in 1:6
			ls = []
			for s in samples
				push!(ls, loaddata(depth, Snames[i], s))
			end
			# push!(adfcs, ls)
			push!(datas, ls)
		# end
		# push!(datas, adfcs)
	end
	return datas

end




# plotsdata = plot_Sname()
function pp(i)
	
	plotsdata = plot_Sname(i)
	palette(:acton)
	groupedbar(hcat(plotsdata...),
		bar_position = :dodge,
		bar_width = 0.7,
		xticks = (1:6, samples),
		title = SnamesTex[i],
		size = (450, 210),
		label = false,
		# layout = (2, 3),
	)
end
pp(1)
pp(2)
pp(3)
pp(4)
pp(5)
pp(6)