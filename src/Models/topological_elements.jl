export Junction
export PressureZone


struct Junction
    number::Int
    name::String
    elevation::Real
    head::Union{Nothing,Float64}
    demand::Any 
    minimum_pressure::Float64
    coordinates::Union{NamedTuple{(:lat,:lon), Tuple{Float64,Float64}},Nothing}
end

Junction(;  number = 0,
            name="init",
            elevation=0,
            head = nothing,
            demand = nothing,
            minimum_pressure = 0,
            coordinates = nothing
            ) = Junction(number,name,elevation,head,demand,minimum_pressure,coordinates)

struct PressureZone
    name::String
    junctions::Array{Junction}
end
