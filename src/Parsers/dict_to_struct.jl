function dict_to_struct(data::Dict{String,Any})
    haskey(data, "Junction") ? junctions = junction_to_struct(data["Junction"]) : warn("Key Error : key 'Junction' not found in WaterSystems dictionary, this will result in an empty Junction array")
    haskey(data, "Node") ? nodes = node_to_struct(data["Node"]) : warn("Key Error : key 'Node' not found in WaterSystems dictionary, this will result in an empty Node array")
    haskey(data, "Tank") ? tanks = tank_to_struct(data["Tank"]) : warn("Key Error : key 'Tank' not found in WaterSystems dictionary, this will result in an empty Tank array")
    haskey(data, "Reservoir") ? res = res_to_struct(data["Reservoir"]) : warn("Key Error : key 'Reservoir' not found in WaterSystems dictionary, this will result in an empty Reservoir array")
    haskey(data, "Pipe") ? pipes = pipe_to_struct(data["Pipe"]) : warn("Key Error : key 'Pipe' not found in WaterSystems dictionary, this will result in an empty Pipe array")
    haskey(data, "Valve") ? valves = valve_to_struct(data["Valve"]) : warn("Key Error : key 'Valve' not found in WaterSystems dictionary, this will result in an empty Valve array")
    haskey(data, "Pump") ? pumps = pump_to_struct(data["Pump"]) : warn("Key Error : key 'Pump' not found in WaterSystems dictionary, this will result in an empty Pump array")
    haskey(data, "demand") ? demands = demand_to_struct(data["demand"]) : warn("Key Error : key 'demand' not found in WaterSystems dictionary, this will result in an empty demand array")
    d = data["wntr"]
    simulations = Simulation(d["duration"], d["timeperiods"], d["num_timeperiods"], d["start"], d["end"])
    links = vcat(pipes, valves, pumps)
    return nodes, junctions, tanks, res, links, pipes, valves, pumps, demands, simulations
end

function junction_to_struct(data::Dict{Int64,Any})
    junctions = [Junction(j["number"], j["name"], j["elevation"], j["head"], j["minimum_pressure"], j["coordinates"]) for (key,j) in data]
    return junctions
end
function node_to_struct(data::Dict{String, Any})
    nodes = [Junction(j["number"], j["name"], j["elevation"], j["head"], j["minimum_pressure"], j["coordinates"]) for (key,j) in data]
    return nodes
end

function tank_to_struct(data::Dict{Int64,Any})
    tanks = Array{RoundTank}(length(data))
    for (key, t) in data
        node = t["node"]
        junction = Junction(node["number"], node["name"], node["elevation"], node["head"], node["minimum_pressure"], node["coordinates"])
        push!(tanks, RoundTank(t["name"], junction, t["volumelimits"], t["diameter"], t["volume"], t["area"], t["level"], t["levellimits"]))
    end
    return tanks
end

function res_to_struct(data::Dict{Int64, Any})
    res = Array{Reservoir}(0)
    for (key, r) in data
        node = r["node"]
        junction = Junction(node["number"], node["name"], node["elevation"], node["head"], node["minimum_pressure"], node["coordinates"])
        push!(res, Reservoir(r["name"], junction, r["elevation"]))
    end
    return res
end

function pipe_to_struct(data::Dict{Int64,Any})
    pipes = Array{RegularPipe}(0)
    for (key, p) in data
        j_from = p["connectionpoints"].from
        j_to = p["connectionpoints"].to
        junction_from = Junction(j_from["number"], j_from["name"], j_from["elevation"], j_from["head"], j_from["minimum_pressure"], j_from["coordinates"])
        junction_to = Junction(j_to["number"], j_to["name"], j_to["elevation"], j_to["head"], j_to["minimum_pressure"], j_to["coordinates"])
        push!(pipes,RegularPipe(p["number"], p["name"], @NT(from = junction_from, to = junction_to) ,p["diameter"], p["length"], p["roughness"], p["headloss"], p["flow"], p["initial_status"]))
    end
    return pipes
end
 function valve_to_struct(data::Dict{Int64, Any})
     valves = Array{PressureReducingValve}(0)
     for (key, v) in data
         j_from = v["connectionpoints"].from
         j_to = v["connectionpoints"].to
         junction_from = Junction(j_from["number"], j_from["name"], j_from["elevation"], j_from["head"], j_from["minimum_pressure"], j_from["coordinates"])
         junction_to = Junction(j_to["number"], j_to["name"], j_to["elevation"], j_to["head"], j_to["minimum_pressure"], j_to["coordinates"])
         push!(valves,PressureReducingValve(v["number"], v["name"], @NT(from = junction_from, to = junction_to) ,v["status"], v["diameter"], v["pressure_drop"]))
     end
     return valves
 end

function pump_to_struct(data::Dict{Int64,Any})
    pumps = Array{ConstSpeedPump}(length(data))
    for (key, p) in data
        j_from = p["connectionpoints"].from
        j_to = p["connectionpoints"].to
        junction_from = Junction(j_from["number"], j_from["name"], j_from["elevation"], j_from["head"], j_from["minimum_pressure"], j_from["coordinates"])
        junction_to = Junction(j_to["number"], j_to["name"], j_to["elevation"], j_to["head"], j_to["minimum_pressure"], j_to["coordinates"])
        push!(pumps, ConstSpeedPump(p["number"], p["name"], @NT(from = junction_from, to = junction_to) ,p["status"], p["pumpcurve"], p["efficiency"], p["energyprice"], p["intercept"], p["slope"]))
    end
    return pumps
end
function demand_to_struct(data::Dict{Int64,Any})
    demands = Array{WaterDemand}(length(data),1)
    for (key, d) in data
        node_data = d["node"]
        number = node_data["number"]
        node = Junction(number, node_data["name"], node_data["elevation"], node_data["head"], node_data["minimum_pressure"], node_data["coordinates"])
        demands[number, 1] = WaterDemand(d["name"], number, node , d["status"], d["max_demand"], d["demand"], d["demandforecast"])
    end
    return demands
end