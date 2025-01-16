using Yao
using Serialization: deserialize
struct KCdata
	depth::Number
	samples::Int
	data::Vector
end
struct CSdata
	Sname::String
	S::Vector
	depth::Number
	samples::Int
	data::Vector
end

path = "./improve_src/data/"



FCSdata = open(path * "FCSdata.dat", "r") do io
	deserialize(io)
end

ADFCSdata5 = open(path * "ADFCSdata5.dat", "r") do io
	deserialize(io)
end

ADFCSdata9 = open(path * "ADFCSdata9.dat", "r") do io
	deserialize(io)
end

ADFCSdata13 = open(path * "ADFCSdata13.dat", "r") do io
	deserialize(io)
end

ADFCSdata17 = open(path * "ADFCSdata17.dat", "r") do io
	deserialize(io)
end

ADFCSdata21 = open(path * "ADFCSdata21.dat", "r") do io
	deserialize(io)
end

KCFCSdata = open(path * "KCFCSdata.dat", "r") do io
	deserialize(io)
end

KCADFCSdata3 = open(path * "KCADFCSdata3.dat", "r") do io
	deserialize(io)
end

KCADFCSdata5 = open(path * "KCADFCSdata5.dat", "r") do io
	deserialize(io)
end

KCADFCSdata7 = open(path * "KCADFCSdata7.dat", "r") do io
	deserialize(io)
end

KCADFCSdata9 = open(path * "KCADFCSdata9.dat", "r") do io
	deserialize(io)
end

KCADFCSdata11 = open(path * "KCADFCSdata11.dat", "r") do io
	deserialize(io)
end

function checkdata(data, Sname)
	filted = filter(d -> d.Sname == Sname, data)
	return length(filted)
end

function checkdata(data)
	S_names = ["k2d3", "k2d9", "k4d6", "k4d15", "k6d4", "k6d13"]
	for name in S_names
		if checkdata(data, name) < 24
			println(name)
		end
	end
end

function checKCdata(data, s)
	filted = filter(d -> d.samples == s, data)
	return length(filted)
end

function checKCdata(data)
	samples = [1024, 2048, 4096, 6648, 10088, 14256, 20168, 26608, 35112]
	for s in samples
		if checKCdata(data, s) < 4
			println(s)
		end
	end
end


# %%
checkdata(FCSdata)
checkdata(ADFCSdata5)
checkdata(ADFCSdata9)
checkdata(ADFCSdata13)
checkdata(ADFCSdata17)
checkdata(ADFCSdata21)

checKCdata(KCFCSdata)
checKCdata(KCADFCSdata3)
checKCdata(KCADFCSdata5)
checKCdata(KCADFCSdata7)
checKCdata(KCADFCSdata9)
checKCdata(KCADFCSdata11)