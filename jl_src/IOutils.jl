using TOML, DataFrames, Dates, CSV

function save_data(data, dir::String = "./data")
    now_time = now()
    date_format = "yy-mm-dd-HH-MM"
    formatted_date = Dates.format(now_time, date_format)
    file_path = dir*"/data_$formatted_date.csv"
    CSV.write(file_path, data)

    return file_path
end

function write_data!(filename, new_row)
    df = CSV.read(filename, DataFrame)
    append!(df, new_row, promote = true)
    rm(filename)
    file = save_data(df)
    return file
end