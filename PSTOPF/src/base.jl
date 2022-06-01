function ref_add_pst!(ref::Dict{Symbol,<:Any}, data::Dict{String,<:Any})
    for (nw, nw_ref) in ref[:it][:pm][:nw]
        if !haskey(nw_ref, :pst)
            error(_LOGGER, "required pst data not found")
        end

        nw_ref[:pst] = Dict(x for x in nw_ref[:pst] if (x.second["br_status"] == 1 && x.second["f_bus"] in keys(nw_ref[:bus]) && x.second["t_bus"] in keys(nw_ref[:bus])))

        nw_ref[:arcs_from_pst] = [(i,pst["f_bus"],pst["t_bus"]) for (i,pst) in nw_ref[:pst]]
        nw_ref[:arcs_to_pst]   = [(i,pst["t_bus"],pst["f_bus"]) for (i,pst) in nw_ref[:pst]]
        nw_ref[:arcs_pst] = [nw_ref[:arcs_from_pst]; nw_ref[:arcs_to_pst]]

        bus_arcs_pst = Dict((i, []) for (i,bus) in nw_ref[:bus])
        for (l,i,j) in nw_ref[:arcs_pst]
            push!(bus_arcs_pst[i], (l,i,j))
        end
        nw_ref[:bus_arcs_pst] = bus_arcs_pst
    end
end