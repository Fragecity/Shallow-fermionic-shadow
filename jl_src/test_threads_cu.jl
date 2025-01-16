using Yao, CUDA, Base.Threads

function f_cu()
    cureg = rand_state(9; nbatch=1000) |> cu;   # or `curand_state(9; nbatch=1000)`.
    cureg |> put(9, 2=>Z);
    measure!(cureg)
    return cureg |> cpu;
end

function f()
    reg = rand_state(9; nbatch=1000) ;   # or `curand_state(9; nbatch=1000)`.
    reg |> put(9, 2=>Z);
    measure!(reg)
    return reg
end

function test1()
    for _ = 1:1000
        f()
    end
end

function test2()
    for _ = 1:1000
        f_cu()
    end
end

function test3()
    @threads for _ = 1:1000
        f()
    end
end

function test4()
    @threads for _ = 1:1000
        f_cu()
    end
end

using BenchmarkTools
@benchmark test3()