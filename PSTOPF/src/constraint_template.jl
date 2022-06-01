###############################################
# Constraint templates
function constraint_ohms_y_from_pst(pm::_PM.AbstractPowerModel, i::Int; nw::Int=_PM.nw_id_default)
    pst = _PM.ref(pm, nw, :pst, i)
    f_bus = pst["f_bus"]
    t_bus = pst["t_bus"]
    f_idx = (i, f_bus, t_bus)
    t_idx = (i, t_bus, f_bus)

    g, b = _PM.calc_branch_y(pst)
    g_fr = pst["g_fr"]
    b_fr = pst["b_fr"]

    constraint_ohms_y_from_pst(pm, nw, i, f_bus, t_bus, f_idx, t_idx, g, b, g_fr, b_fr)
end

function constraint_ohms_y_to_pst(pm::_PM.AbstractPowerModel, i::Int; nw::Int=_PM.nw_id_default)
    pst = _PM.ref(pm, nw, :pst, i)
    f_bus = pst["f_bus"]
    t_bus = pst["t_bus"]
    f_idx = (i, f_bus, t_bus)
    t_idx = (i, t_bus, f_bus)

    g, b = _PM.calc_branch_y(pst)
    g_to = pst["g_to"]
    b_to = pst["b_to"]

    constraint_ohms_y_to_pst(pm, nw, i, f_bus, t_bus, f_idx, t_idx, g, b, g_to, b_to)
end

function constraint_power_balance(pm::_PM.AbstractPowerModel, i::Int; nw::Int=_PM.nw_id_default)
    bus = _PM.ref(pm, nw, :bus, i)
    bus_arcs = _PM.ref(pm, nw, :bus_arcs, i)
    bus_arcs_pst = _PM.ref(pm, nw, :bus_arcs_pst, i)
    bus_gens = _PM.ref(pm, nw, :bus_gens, i)
    bus_loads = _PM.ref(pm, nw, :bus_loads, i)
    bus_shunts = _PM.ref(pm, nw, :bus_shunts, i)


    bus_pd = Dict(k => _PM.ref(pm, nw, :load, k, "pd") for k in bus_loads)
    bus_qd = Dict(k => _PM.ref(pm, nw, :load, k, "qd") for k in bus_loads)

    bus_gs = Dict(k => _PM.ref(pm, nw, :shunt, k, "gs") for k in bus_shunts)
    bus_bs = Dict(k => _PM.ref(pm, nw, :shunt, k, "bs") for k in bus_shunts)

    constraint_power_balance(pm, nw, i, bus_arcs, bus_arcs_pst, bus_gens, bus_loads, bus_gs, bus_bs)
end