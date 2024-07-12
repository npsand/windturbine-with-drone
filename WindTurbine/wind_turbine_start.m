%% Wind Turbine
%
% This example shows how to model, parameterize, and test a wind turbine
% with a supervisory, pitch angle, MPPT (maximum power point tracking),
% and derating control. When you run the plot function,
% it generates a plot of the state transitions, normalized physical
% quantities such as the wind speed, wind turbine rotation speed, generator
% power, and pitch angle.
%

% Copyright 2021-22 The MathWorks, Inc.

%% Model
%
% The following figure shows the model of a wind turbine.The mechanical
% and electrical domains each require their own Solver Configuration block.
%

open_system('WindTurbineSystem.slx')

set_param(find_system('WindTurbineSystem','MatchFilter', @Simulink.match.allVariants, 'FindAll', 'on','type','annotation','Tag','ModelFeatures'),'Interpreter','off')

%% Supervisory Control Subsystem
%
% This subsystem demonstrates how to model the wind turbine state machine.
% The turbine state machine defines four wind turbine states.
%
% _Park brake mode_: This is the entry mode of the wind turbine operation.
% The wind turbine enters the park brake mode from the pitch brake mode when
% the turbine rotor speed is under the permissible limits for safe operation.
% During this mode, the generator is in the tripped state,  the hydraulic
% park brake is
% engaged, and the wind turbine rotor blades are pitched to the braking
% angle for the aerodynamic braking. The hydraulic brake is the secondary method
% for braking the wind turbine.
%
% _Startup mode_: The wind turbine enters the startup mode from the park
% brake mode when the wind speed is under the permissible limits for
% safe operation. The wind turbine enters this mode from the pitch brake
% mode when the wind speed and the turbine speed are under the permissible
% limits. During this mode, the generator is in the tripped state,
% the hydraulic park brake is released, and the wind turbine rotor blades
% are pitched to the minimum
% angle for achieving the maximum turbine rotor acceleration.
%
% _Generating mode_: The wind turbine enters the generating mode from
% the startup mode when the wind turbine rotor speed goes above the
% turbine cut in speed. During this mode, the generator is connected to
% the transformer, the hydraulic park brake is released, and
% the wind turbine rotor blades are pitched to achieve the
% optimal electric power generation as per the operating conditions.
%
% _Pitch brake mode_: The wind turbine enters pitch brake mode from
% generating mode when the wind speed and turbine rotation speed are
% not under the permissible limits. The wind turbine enters the pitch brake
% mode from the startup mode when the wind speed is not under the
% permissible limits. During this mode, the generator is connected to the
% transformer to consume the
% kinetic energy available in the rotor blade, the hydraulic park brake is
% released, and the wind turbine rotor blades are pitched to the braking
% angle for the aerodynamic braking. The aerodynamic braking is the primary
% method for braking the wind turbine.
%



set_param('WindTurbineSystem/Turbine State Machine/Turbine State Machine','LinkStatus','none')
open_system('WindTurbineSystem/Turbine State Machine/Turbine State Machine','force')

%% Pitch controller Subsystem
%
% This subsystem demonstrates how to model the pitch angle controller of
% the wind turbine.
%

set_param('WindTurbineSystem/Pitch Controller','LinkStatus','none')
open_system('WindTurbineSystem/Pitch Controller','force')

%%
%
% _Park brake and pitch brake mode_: The pitch angle is set to 95 degree
% for the aerodynamic braking during these modes.
%

set_param('WindTurbineSystem/Pitch Controller/Turbine State 0 : Park Brake and Turbine State 3 : Pitch Brake/Turbine State 0 an 3','LinkStatus','none')
open_system('WindTurbineSystem/Pitch Controller/Turbine State 0 : Park Brake and Turbine State 3 : Pitch Brake/Turbine State 0 an 3','force')
%%
%
% _Startup mode_: The pitch angle is set to 1 degree for achieving the maximum
% acceleration during this mode.
%

set_param('WindTurbineSystem/Pitch Controller/Turbine State 1 : Startup Condition/Turbine State 1','LinkStatus','none')
open_system('WindTurbineSystem/Pitch Controller/Turbine State 1 : Startup Condition/Turbine State 1','force')
%%
%
% _Generating mode_: The pitch angle is set to achieve the
% optimal electric power generation as per the operating conditions.
%
% 1. The pitch angle remains at the lowest setting at 1 degree up to rated
% wind speed. This control acts in synchronization with the wind turbine's
% MPPT power control.
%
% 2. The pitch angle changes when the wind speed is above the rated wind
% speed in synchronization with the wind turbine's derating power control.
%

set_param('WindTurbineSystem/Pitch Controller/Turbine State 2 : Power Generation Condition/Turbine State 2','LinkStatus','none')
open_system('WindTurbineSystem/Pitch Controller/Turbine State 2 : Power Generation Condition/Turbine State 2','force')

%% Power Controller Subsystem
%
% This subsystem demonstrates how to model the power demand and the
% generator input speed reference for the optimal torque loading on the
% wind turbine through the generator.
%

set_param('WindTurbineSystem/Power Controller','LinkStatus','none')
open_system('WindTurbineSystem/Power Controller','force')
%%
%
% _MPPT control_: This mode is active up to the rated wind speed. The power
% demand and the generator reference speed is as per the wind turbine
% characteristic power performance curve.
%

set_param('WindTurbineSystem/Power Controller/MPPT Control','LinkStatus','none')
open_system('WindTurbineSystem/Power Controller/MPPT Control','force')
%%
%
% _Derating control_: This mode is active above the rated wind speed. The
% power demand and the generator reference speed is kept constant based on
% the rating of the wind turbine.
%

set_param('WindTurbineSystem/Power Controller/Derating Control','LinkStatus','none')
open_system('WindTurbineSystem/Power Controller/Derating Control','force')
%%
%
% _Limiter Function Power Demand_: This function limits the power demand as
% per the wind turbine's mode of operation.
%

set_param('WindTurbineSystem/Power Controller/Limiter Function Power Demand','LinkStatus','none')
open_system('WindTurbineSystem/Power Controller/Limiter Function Power Demand','force')
%%
%
% _Limiter Function Reference Speed_: This function limits the speed
% reference as per the wind turbine's mode of operation.
%

set_param('WindTurbineSystem/Power Controller/Limiter Function Reference Speed','LinkStatus','none')
open_system('WindTurbineSystem/Power Controller/Limiter Function Reference Speed','force')

%% Wind Turbine Subsystem
%
% This subsystem demonstrates how to model the wind turbine.
%


set_param('WindTurbineSystem/Wind Turbine/Wind Turbine','LinkStatus','none')
open_system('WindTurbineSystem/Wind Turbine/Wind Turbine','force')
%%
%
% _Rotor Hub_: The rotor of a horizontal axis wind turbine is modeled
% using the Simscape(TM) Driveline(TM) Wind Turbine block.
% In this block, _mechanical power_
% extracted from the wind, P, is calculated as
%
% $$P = 1/2* rho * Ar * vWind^3 * cp(pitch,lambda)$$
%
% where,
%
% # _rho_ is the air density
% # _Ar_ is the area swept by the rotor blades
% # _vWind_ is the wind speed
% # _cp_ is the power coefficient as a function of lambda and pitch.
% # _lambda_ is the ratio of the rotor blade tip
% speed and the wind speed, it is also called Tip Speed Ratio (TSR)
% # _pitch_ is the rotor blade pitch angle
%
%%
%
% _Nacelle_: This subsystem demonstrates how to model the nacelle
% components of a wind turbine.
%

set_param('WindTurbineSystem/Wind Turbine/Wind Turbine/Nacelle','LinkStatus','none')
open_system('WindTurbineSystem/Wind Turbine/Wind Turbine/Nacelle','force')
%%
%
% _Brakes_: This subsystem demonstrates how to model the brakes in the
% nacelle. The hydraulics brake is a secondary braking method in the wind
% turbine. The brakes are engaged when the wind turbine speed goes below the
% parking brake speed while the wind turbine is under the park brake mode
% or during the wind turbine maintenance operation.
% If they are applied above the parking brake speed, the brake can burn out
% or the nacelle can catch fire due to the excessive frictional heat
% generation.
%

set_param('WindTurbineSystem/Wind Turbine/Wind Turbine/Nacelle/Brakes','LinkStatus','none')
open_system('WindTurbineSystem/Wind Turbine/Wind Turbine/Nacelle/Brakes','force')
%%
%
% _Gear train_: This subsystem demonstrates how to model the gear train in
% the nacelle. An epicyclic gear train represents the gear train system
% with the power losses. The gear train contributes to high power loss in
% the wind turbine operation.
%

set_param('WindTurbineSystem/Wind Turbine/Wind Turbine/Nacelle/Gear Tain','LinkStatus','none')
open_system('WindTurbineSystem/Wind Turbine/Wind Turbine/Nacelle/Gear Tain','force')
%%
%
% _Lumped generator_: This subsystem demonstrates how to model the
% generator in the nacelle. This is a simplified model of a generator to
% increase the simulation speed.
%

set_param('WindTurbineSystem/Wind Turbine/Wind Turbine/Nacelle/Lumped Generator','LinkStatus','none')
open_system('WindTurbineSystem/Wind Turbine/Wind Turbine/Nacelle/Lumped Generator','force')
%%
%
% The wind turbine has a larger time constant and slower response than a
% traditional doubly-fed induction generator (DFIG) system. To simulate
% wind turbine control, you must run the simulation longer.
%
% The closed-loop DFIG system is faster than wind turbine control systems
% such as pitch control. Therefore, a low fidelity lumped DFIG generator
% system is practical for improving simulation speed and providing
% flexibility. The lumped generator system integrates with the wind
% turbine system to simulate different aspects of the control algorithm.
%
% The lumped generator model tracks the grid voltage and phase angle at
% the point of common coupling (PCC) using the phase locked loops (PLL).
% To improve the simulation speed, fast acting PLL is modelled using
% the grid voltage zero crossing detection. Lumped generator uses the grid
% voltage and phase obtained from the PLL and implements the power flow
% equation with the generator lumped leakage inductance and resistance.
% The lumped generator model takes the real power (P), reactive power (Q),
% and reference generator shaft speed as input.
%
% In the wind turbine system, the lumped generator model gets the power
% reference and approximate speed reference input from the wind turbine
% power control system. Based on the reference input, the generator
% applies the load torque to
% the wind turbine shaft and supply the electrical power to the grid.
%
% <<../sscv_wind_turbine_grid_model.png>>
%
% $$3V_g I^*_g= P+J Q$$
%
% $$I^*_{gm}=\frac{2(P+J Q)}{3 V_{gm}}$$
%
% $$V_g=V_{gm} \angle {0} ^o$$
%
% $$V_{ig}=V_{gm}+jX_L I_{gm}+R I_{gm}=V_{igm}\angle\phi$$
%
% $$V_{iga} (t)=V_{igm} sin( \omega t+\phi )$$
%
% $$V_{igb} (t)=V_{igm} sin( \omega t+\phi-120^o )$$
%
% $$V_{igc} (t)=V_{igm} sin( \omega t+\phi-240^o )$$
%
% where,
%
% # $$V_g $$ is grid rms phase voltage at PCC
% # $$I_g $$ is grid rms phase current at PCC
% # $$V_{gm} $$ is grid peak phase voltage at PCC
% # $$I_{gm} $$ is grid peak phase current at PCC
% # $$V_{igm} $$ is electrical generator peak induced phase voltage
% # $$V_{ig} $$ is electrical generator induced phase voltage
% # $$X_L $$ is lumped leakage reactance of induction generator (wrt to stator)
% # $$R $$ is lumped resistance of induction generator (wrt to stator)
% # $$\omega t $$ is instantaneous grid voltage angle
%
% Here, $$V_{gm} $$ and $$\omega t $$ are obtained from the PLL.
%


%%
%
% The lumped generator system model block should be used only in fixed
% frequency, full sinusoidal, and balanced three phase grid connected
% systems. This model is not suitable for the transient electrical
% stimulation such as the fault ride through and the grid frequency
% variation simulation.

%% Grid and Transformer Subsystem
%
% This subsystem demonstrates how to model the grid and transformer.
% The parasitic conductance is added to increase the simulation speed.
%

set_param('WindTurbineSystem/Wind Turbine/Grid and Transformer','LinkStatus','none')
open_system('WindTurbineSystem/Wind Turbine/Grid and Transformer','force')


%% Simulation Results from Scope
%
% This figure shows the supervisory control states, turbine blade
% pitch angle, generator power, and wind speed.
%

set_param('WindTurbineSystem/Results','open','on');
sim('WindTurbineSystem');

%% Simulation Results from Simscape Logging
%
% This model generates plot of the state transitions, the normalized physical
% quantities such as the wind speed, wind turbine rotation speed, generator
% power, and pitch angle.
%

set_param('WindTurbineSystem/Results','open','off');
wind_turbine_plot_response;

run("WindTurbine/organizeData")
