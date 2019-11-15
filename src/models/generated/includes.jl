include("Junction.jl")
include("Arc.jl")
include("PumpParams.jl")
include("Pump.jl")
include("OpenPipe.jl")
include("GatePipe.jl")
include("CVPipe.jl")
include("StaticDemand.jl")
include("Tank.jl")
include("Reservoir.jl")

export get__forecasts
export get_arc
export get_available
export get_coordinates
export get_diameter
export get_effncyBEP
export get_elevation
export get_epnt_efficiency
export get_epnt_head
export get_epnt_power
export get_epnt_type
export get_flow
export get_flowBEP
export get_flowlimits
export get_from
export get_head
export get_head0
export get_headBEP
export get_headgain
export get_headloss
export get_internal
export get_junction
export get_length
export get_level
export get_level_limits
export get_maxdemand
export get_minimum_pressure
export get_name
export get_open_status
export get_operating
export get_powerintcpt
export get_powerslope
export get_pumpparams
export get_roughness
export get_to
