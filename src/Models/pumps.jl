
struct ConstSpeedPump <: Link
    name::String
    connectionpoints::@NT(from::Junction, to::Junction)
    status::Bool
    pumpcurve::Union{Function,Array{Tuple{Float64,Float64}}}
    driveefficiency::Union{Nothing,Float64}
    energyprice::TimeSeries.TimeArray
end

# function pump curves
ConstSpeedPump(
    name::String,
    connectionpoints::@NT(from::Junction, to::Junction),
    status::Bool,
    pumpcurve::Function,
    driveefficiency::Union{Nothing,Float64},
    energyprice::TimeSeries.TimeArray
    ) = ConstSpeedPump(name, connectionpoints, status, pumpcurve, driveefficiency, energyprice)

# PWL pump curves
ConstSpeedPump(
    name::String,
    connectionpoints::@NT(from::Junction, to::Junction),
    status::Bool,
    pumpcurve::Array{Tuple{Float64,Float64}},
    driveefficiency::Union{Nothing,Float64},
    energyprice::TimeSeries.TimeArray
    )= ConstSpeedPump(name, connectionpoints, status, pumpcurve, driveefficiency, energyprice)

ConstSpeedPump(;
                name="init",
                connectionpoints=(from::Junction(), to::Junction()),
                status=false,
                pumpcurve=[(0.0,0.0)],
                driveefficiency=1.0,
                energyprice=TimeSeries.TimeArray(today(), [0.0])
                ) = ConstSpeedPump(name, connectionpoints, status, pumpcurve, driveefficiency, energyprice)
