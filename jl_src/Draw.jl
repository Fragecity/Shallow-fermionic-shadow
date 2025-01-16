using CSV, DataFrames

df = CSV.read("./data/data_24-12-11-13-41.csv", DataFrame)


for name in names(df)
    println(name)
end
samples = df.Samples
mean = df[:, "Theory_n=4"]