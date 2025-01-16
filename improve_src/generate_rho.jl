using Yao
using Serialization: serialize, deserialize

path = "./improve_src/data/"

rho = rand_state(10)
open(path*"reg_n10.dat", "w") do io
    serialize(io, rho)
end

FCS_data = []
open(path*"FCSdata.dat", "w") do io
    serialize(io, FCS_data)
end

ADFCSdata5 = []
open(path*"ADFCSdata5.dat", "w") do io
    serialize(io, ADFCSdata5)
end

ADFCSdata9 = []
open(path*"ADFCSdata9.dat", "w") do io
    serialize(io, ADFCSdata9)
end

ADFCSdata13 = []
open(path*"ADFCSdata13.dat", "w") do io
    serialize(io, ADFCSdata13)
end

ADFCSdata17 = []
open(path*"ADFCSdata17.dat", "w") do io
    serialize(io, ADFCSdata17)
end

ADFCSdata21 = []
open(path*"ADFCSdata21.dat", "w") do io
    serialize(io, ADFCSdata21)
end

KCFCSdata = []
open(path*"KCFCSdata.dat", "w") do io
    serialize(io, KCFCSdata)
end

KCADFCSdata3 = []
open(path*"KCADFCSdata3.dat", "w") do io
    serialize(io, KCADFCSdata3)
end

KCADFCSdata5 = []
open(path*"KCADFCSdata5.dat", "w") do io
    serialize(io, KCADFCSdata5)
end

KCADFCSdata7 = []
open(path*"KCADFCSdata7.dat", "w") do io
    serialize(io, KCADFCSdata7)
end

KCADFCSdata9 = []
open(path*"KCADFCSdata9.dat", "w") do io
    serialize(io, KCADFCSdata9)
end

KCADFCSdata11 = []
open(path*"KCADFCSdata11.dat", "w") do io
    serialize(io, KCADFCSdata11)
end

theoretical_data = let hamil_yao_lst = get_hamil_Yao.(hamil_lst, n)
    [expect(ham, reg) for ham in hamil_yao_lst  ]
end