---
title: saccharina
layout: home
---

# The saccharina model

*Niels Holst & Teis Boderskov, Aarhus University, 21 February 2023.*

## Mathematical notation
The bracketing functions
$$
\lceil x \rceil^a \\\
\lfloor x \rfloor_b
$$
imposes either an upper bound of $$a$$ or a lower bound of $$b$$ on $$x$$.

Full brackets denote a concentration:
$$
[X]
$$
Sharp parentheses around a *rate variable* denote the value it would attain under ideal circumstances, i.e. it refers to a certain demand:
$$
\left< \Delta X \right>
$$
The same *rate variable* without the sharp parentheses denotes the realised rate, i.e. the supply rate attained; it cannot exceed the demand:
$$
\Delta X \le \left< \Delta X \right>
$$
A *state variable* in sharp parentheses denotes the value it would attain at the end of this time step under ideal circumstances, whereas the same state variable without the sharp parentheses refers to its value at the beginning of the time step:
$$
\left < X \right> = X + \left< \Delta X \right>
$$
At the end of the time step, all state variables are updated according to the realised rates (supplies):
$$
X \leftarrow X + \Delta X
$$
Superscripts are used to denote the units of variables:
$$
\begin{split}
&X^{dw} \;\;&&{\;\text{g dw/m}}\\\
&X^C \;\;&&{\;\text{g C/m}}\\\
&X^N \;\;&&{\;\text{g N/m}}\\\
&X^P \;\;&&{\;\text{g P/m}}\\\
\end{split}
$$

## Model structure

### Space and time

The spatial unit considered is one meter of line. Hence, state and rate variables are per m. Rates are per day as the model operates with a time step of $$\Delta t=1$$ d.

In every time step, the model is updated in the following steps:

1. Compute demands.
2. Compute supplies.
3. Allocate supplies.

### Biomass

The biomass is split into four plant compartments (structure, carbon store, nitrogen store and phosphorus store).  For each compartment, the model keeps track of the weight of carbon, nitrogen, phosphorus and total biomass:

| Biomass   | Carbon (g C/m) | Nitrogen (g N/m) | Phosphorus (g P/m) | Total (g dw/m) |
| -------------- | --------------------- | ----------------------- | ------------------------- | ------------------------- |
| Structure      | $${\mathcal{S}^{C}}$$                 | $${\mathcal{S}^{N}}$$                  | *n.a.*      | $${\mathcal{S}^{dw}}$$                   |
| Carbon store   | $${\mathcal{C}^{C}}$$                 | *n.a.*            | *n.a.*      | $${\mathcal{C}^{dw}}$$                   |
| Nitrogen store | *n.a.*           | $${\mathcal{N}^{N}}$$                  | *n.a.*            | $${\mathcal{N}^{dw}}$$                   |
| Phosphorus store | *n.a.* | *n.a.* | $${\mathcal{P}^{P}}$$ | $${\mathcal{P}^{dw}}$$ |
| Whole plant    | $${\mathcal{W}^{C}}$$ | $${\mathcal{W}^{N}}$$  | $${\mathcal{W}^{P}}$$ | $${\mathcal{W}^{dw}}$$ |

Since the concentrations of carbon, nitrogen and phosphorus in the four compartments are assumed fixed (see below), the model needs only four primary state variables:

* Structural biomass $$({\mathcal{S}^{dw}})$$
* Carbon store biomass $$({\mathcal{C}^{dw}})$$
* Nitrogen store biomass $$({\mathcal{N}^{dw}})$$
* Phosphorus store biomass $$({\mathcal{P}^{dw}})$$

The whole-plant sums are 
$$
\begin{split}
{\mathcal{W}^{C}}&={\mathcal{S}^{C}}+{\mathcal{C}^{C}}\\[6pt]
{\mathcal{W}^{N}}&={\mathcal{S}^{N}}+{\mathcal{N}^{N}}\\[6pt]
{\mathcal{W}^{P}}&={\mathcal{P}^{P}}\\[6pt]
{\mathcal{W}^{dw}}&={\mathcal{S}^{dw}}+{\mathcal{C}^{dw}}+{\mathcal{N}^{dw}}+{\mathcal{P}^{dw}}
\end{split}
$$

### Concentrations

| Concentrations | Carbon (g C/g dw) | Nitrogen (g N/g dw) | Phosphorus (g P/g dw) |
| -------------- | ------------------------------- | ---------------------------------- | ---------------------------------- |
| Structure      | $${[\mathcal{S}^{C}]}={\mathcal{S}^{C}}/{\mathcal{S}^{dw}}=0.21$$          | $${[\mathcal{S}^{N}]}={\mathcal{S}^{N}}/{\mathcal{S}^{dw}}=0.02$$             | *n.a.* |
| Carbon store   | $${[\mathcal{C}^{C}]}={\mathcal{C}^{C}}/{\mathcal{C}^{dw}}=0.47$$          | *n.a.*          | *n.a.* |
| Nitrogen store | *n.a.*  | $${[\mathcal{N}^{N}]}={\mathcal{N}^{N}}/{\mathcal{N}^{dw}}=0.37$$             | *n.a.*       |
| Phosphorus store | *n.a.* | *n.a.* | $${[\mathcal{P}^{P}]}={\mathcal{P}^{P}}/{\mathcal{P}^{dw}}=0.33$$ |
| Whole plant    | $${[\mathcal{W}^{C}]}={\mathcal{W}^{C}}/{\mathcal{W}^{dw}}$$               | $${[\mathcal{W}^{N}]}={\mathcal{W}^{N}}/{\mathcal{W}^{dw}}$$                  | $${[\mathcal{W}^{P}]}={\mathcal{W}^{P}}/{\mathcal{W}^{dw}}$$ |
| Whole plant max. | $${[\mathcal{W}^{C}]_{max}}=0.35$$ | $${[\mathcal{W}^{N}]_{max}}=0.05$$ | $${[\mathcal{W}^{P}]_{max}}=0.009$$ |

Note: For consistency we should define $${[\mathcal{S}^{P}]}>0$$. This will not change the outputs of the current model.

Under non-limiting growing conditions, the plant will attain its maximum concentration of all three elements. We can infer the distribution of biomass among the three compartments that will then be attained. From the above we have
$$
\begin{equation}\begin{split}
{[\mathcal{W}^{C}]_{max}} &= \frac{\mathcal{S}^{dw}}{X} \\[6pt]
{[\mathcal{W}^{N}]_{max}} &= \frac{\mathcal{S}^{dw}}{X} \\[6pt]
{[\mathcal{W}^{P}]_{max}} &= \frac{\mathcal{P}^{dw}}{X} \\[6pt]
1 &= {\mathcal{S}^{dw}}+{\mathcal{C}^{dw}}+{\mathcal{N}^{dw}}+{\mathcal{P}^{dw}}
\end{split}\end{equation}
$$
Solving these four equations for the unknown biomasses, we get
$$
\begin{equation}\begin{split}
{\mathcal{S}^{dw}} &= {w_\mathcal{S}}
{\mathcal{C}^{dw}} &= {w_\mathcal{C}}
{\mathcal{N}^{dw}} &= {w_\mathcal{N}}
{\mathcal{P}^{dw}} &= {w_\mathcal{P}}
{w_\mathcal{S}} &= \frac{{w_\mathcal{S}}'}{k}=0.1861,\quad {w_\mathcal{C}} = \frac{{w_\mathcal{C}}'}{k}=0.6615,
         \quad {w_\mathcal{N}} = \frac{{w_\mathcal{N}}'}{k}=0.1251, \quad {w_\mathcal{P}} = \frac{{[\mathcal{W}^{P}]_{max}}}{{[\mathcal{P}^{P}]}}=0.02727\\[6pt]
{w_\mathcal{S}}' &= ({[\mathcal{C}^{C}]}
{w_\mathcal{C}}' &= ({[\mathcal{S}^{C}]}
{w_\mathcal{N}}' &= ({[\mathcal{S}^{C}]}
k      &= {[\mathcal{S}^{C}]}
\end{split}\label{eq_ideal_proportions}\end{equation}
$$

So, under non-limiting conditions the plant biomass will constitute roughly one fifth structure $$({w_\mathcal{S}})$$ , two-thirds  carbon store $$({w_\mathcal{C}})$$, one eighth nitrogen store $$({w_\mathcal{N}})$$, and 3% phosphorus store $$({w_\mathcal{P}})$$.  

### Growth: demands and supplies

In every time step, the plant's demand for growth, i.e. its biomass increment $${\left<\Delta\mathcal{W}^{dw}\right>}$$ under non-limiting conditions,  is calculated. The specific demands per compartment are formulated further down.

| Growth demands | Carbon (g C/m) | Nitrogen (g N/m) | Phosphorus (g P/m) | Total (g dw/m) |
| -------------- | ---------------------   | ----------------------- | ------------------------- | ------------------------- |
| Structure      | $${\left<\Delta\mathcal{S}^{C} \right>}$$                  | $${\left<\Delta\mathcal{S}^{N} \right>}$$                  | *n.a.* | $${\left<\Delta\mathcal{S}^{dw}\right>}$$                   |
| Carbon store   | $${\left<\Delta\mathcal{C}^{C} \right>}$$                  | *n.a.*            | *n.a.*            | $${\left<\Delta\mathcal{C}^{dw}\right>}$$                   |
| Nitrogen store | *n.a.*            | $${\left<\Delta\mathcal{N}^{N} \right>}$$                  | *n.a.*            | $${\left<\Delta\mathcal{N}^{dw}\right>}$$                   |
| Phosphorus store | *n.a.* | *n.a.* | $${\left<\Delta\mathcal{P}^{P} \right>}$$ | $${\left<\Delta\mathcal{P}^{dw}\right>}$$ |
| Whole plant    | $${\left<\Delta\mathcal{W}^{C} \right>}$$ | $${\left<\Delta\mathcal{W}^{N} \right>}$$ | $${\left<\Delta\mathcal{W}^{P} \right>}$$ | $${\left<\Delta\mathcal{W}^{dw}\right>}$$ |

The whole-plant sums of demands are
$$
\begin{split}
{\left<\Delta\mathcal{W}^{C} \right>}&={\left<\Delta\mathcal{S}^{C} \right>}+{\left<\Delta\mathcal{C}^{C} \right>} \\[6pt]
{\left<\Delta\mathcal{W}^{N} \right>}&={\left<\Delta\mathcal{S}^{N} \right>}+{\left<\Delta\mathcal{N}^{N} \right>} \\[6pt]
{\left<\Delta\mathcal{W}^{P} \right>}&={\left<\Delta\mathcal{P}^{P} \right>} \\[6pt]
{\left<\Delta\mathcal{W}^{dw}\right>}&={\left<\Delta\mathcal{S}^{dw}\right>}+{\left<\Delta\mathcal{C}^{dw}\right>}+{\left<\Delta\mathcal{N}^{dw}\right>}+{\left<\Delta\mathcal{P}^{dw}\right>}
\end{split}
$$
The resources acquired by photosynthesis and nutrient uptake result in supplies, which are equal to or less than the demands:

| Growth supplies | Carbon (g C/m) | Nitrogen (g N/m) | Phosphorus (g P/m) | Total (g dw/m) |
| -------------- | ---------------------   | ----------------------- | ------------------------- | ------------------------- |
| Structure      | $${\Delta\mathcal{S}^{C}}$$                  | $${\Delta\mathcal{S}^{N}}$$                  | *n.a.* | $${\Delta\mathcal{S}^{dw}}$$             |
| Carbon store   | $${\Delta\mathcal{C}^{C}}$$                  | *n.a.*   | *n.a.*            | $${\Delta\mathcal{C}^{dw}}$$                   |
| Nitrogen store | *n.a.*            | $${\Delta\mathcal{N}^{N}}$$                  | *n.a.*            | $${\Delta\mathcal{N}^{dw}}$$                   |
| Phosphorus store | *n.a.* | *n.a.* | $${\Delta\mathcal{P}^{P}}$$ | $${\Delta\mathcal{P}^{dw}}$$ |
| Whole plant    | $${\Delta\mathcal{W}^{C}}$$ | $${\Delta\mathcal{W}^{N}}$$ | $${\Delta\mathcal{W}^{P}}$$ | $${\Delta\mathcal{W}^{dw}}$$ |

The whole-plant sums of supplies are
$$
\begin{split}
{\Delta\mathcal{W}^{C}}&={\Delta\mathcal{S}^{C}}+{\Delta\mathcal{C}^{C}} \\[6pt]
{\Delta\mathcal{W}^{N}}&={\Delta\mathcal{S}^{N}}+{\Delta\mathcal{N}^{N}} \\[6pt]
{\Delta\mathcal{W}^{P}}&={\Delta\mathcal{P}^{P}} \\[6pt]
{\Delta\mathcal{W}^{dw}}&={\Delta\mathcal{S}^{dw}}+{\Delta\mathcal{C}^{dw}}+{\Delta\mathcal{N}^{dw}}+{\Delta\mathcal{P}^{dw}}
\end{split}
$$

### Expenditures: demands and supplies

Resources are needed not only for growth but also for basic metabolism, exudation and tissue building costs:

| Expenditures         | Demand         | Supply         |
| -------------------- | -------------- | -------------- |
| Basic metabolism     | $${\left<\Delta\mathcal{M}^{C}\right>}$$ (g C/m) | $${\Delta\mathcal{M}^{C}}$$ (g C/m) |
| Carbon exudation     | $${\left<\Delta\mathcal{E}^{C}\right>}$$ (g C/m) | $${\Delta\mathcal{E}^{C}}$$ (g C/m) |
| Nitrogen exudation   | $${\left<\Delta\mathcal{E}^{N}\right>}$$ (g N/m) | $${\Delta\mathcal{E}^{N}}$$ (g N/m) |
| Phosphorus exudation | $${\left<\Delta\mathcal{E}^{P}\right>}$$ (g P/m) | $${\Delta\mathcal{E}^{P}}$$ (g P/m) |
| Building costs       | $${\left<\Delta\mathcal{B}^{C}\right>}$$ (g C/m) | $${\Delta\mathcal{B}^{C}}$$ (g C/m) |

### Resource acquisition

The summed demands for growth and expenditures define the total daily demands for the uptake of carbon $${\left<\Delta\mathcal{U}^{C}\right>}$$ (g C/m), nitrogen $${\left<\Delta\mathcal{U}^{N}\right>}$$ (g N/m) and phosphorus $${\left<\Delta\mathcal{U}^{P}\right>}$$ (g P/m). They follow from the definitions above  as
$$
\begin{equation}
\begin{split}
{\left<\Delta\mathcal{U}^{C}\right>} &= {\left<\Delta\mathcal{S}^{C} \right>} &&+ {\left<\Delta\mathcal{C}^{C} \right>} &&+{\left<\Delta\mathcal{E}^{C}\right>}+{\left<\Delta\mathcal{M}^{C}\right>} +{\left<\Delta\mathcal{B}^{C}\right>}  \\[6pt]
{\left<\Delta\mathcal{U}^{N}\right>} &= {\left<\Delta\mathcal{S}^{N} \right>} &&+ {\left<\Delta\mathcal{N}^{N} \right>} &&+{\left<\Delta\mathcal{E}^{N}\right>}\\[6pt]
{\left<\Delta\mathcal{U}^{P}\right>} &= {\left<\Delta\mathcal{P}^{P} \right>} &&+{\left<\Delta\mathcal{E}^{P}\right>}
\end{split}
\label{totaldemands}
\end{equation}
$$

Resources are acquired from the water surrounding the plant canopy. This is modelled as three separate processes, one for each element, in the form of the Baumgärtner-Gutierrez functional response,
$$
\begin{equation}
{\Delta\mathcal{U}} = {\left<\Delta\mathcal{U}\right>}
\left\{ 1-\text{exp}\left(-\frac{aXY \Delta t}{{\left<\Delta\mathcal{U}\right>}} \right) \right\}
\label{eq_b_g_response}
\end{equation}
$$
where $${\Delta\mathcal{U}}$$ is the realised daily supply with respect to the demand $${\left<\Delta\mathcal{U}\right>}$$. The acquisition efficiency $$a$$ is  applied to the product of resource density $$X$$ and plant density $$Y$$. The units of the parameters and variables differ whether eq. $$\ref{eq_b_g_response}$$ is applied to the uptake of carbon, nitrogen or phosphorus. The relation has the shape of a saturation curve, which is linear under meagre conditions (small $$XY$$) with a slope of $$aY\Delta t$$; it approaches the demand $${\left<\Delta\mathcal{U}\right>}$$ when conditions are rich (large $$XY$$):

<img src="..\media

The resource variable $$X$$ is sunlight intensity for carbon acquisition and water concentrations of dissolved nitrogen and phosphorus for the other two elements. The uptake efficiency $$a$$ takes care of converting the units of $$X$$ into $${\Delta\mathcal{U}}$$. 

Equations for demands and supplies are formulated in the following. Since supplies cannot be expected to fulfill the demands, supplies must subsequently be allocated to meet specific demands according to a priority scheme.

## Demands

Empirically, plant growth is measured as an increase in biomass. This is due to an increase in one or more of the four plant compartments. If the plant is growing under unlimiting conditions then the plant compartments will maintain their optimum proportions (eq. $$\ref{eq_ideal_proportions}$$) during growth, and they will thus all grow at the same maximum growth rate ($$g$$; g dw/g dw/d). The growth demand is calculated first for structural growth. Afterwards the growth demand of the stores are calculated, so that the optimum proportions will be achieved if resources are plentiful.

### Structural growth

The biomass demand for structural growth is
$$
\begin{equation}
{\left<\Delta\mathcal{S}^{dw}\right>} =\varphi_T\,\varphi_{sal}\,g\,{\mathcal{S}^{dw}}
\label{eq_dSdw}
\end{equation}
$$
where $$g$$ (g dw/g dw/d) is the maximum growth rate with the scaling factors ($$\varphi_T,\,\varphi_{sal}\in[0;1]$$) taking sub-optimal conditions into account. The corresponding  elementary demands (used in eq. $$\ref{totaldemands}$$) are
$$
\begin{split}
{\left<\Delta\mathcal{S}^{C} \right>} &= {[\mathcal{S}^{C}]} {\left<\Delta\mathcal{S}^{dw}\right>} \\[6pt]
{\left<\Delta\mathcal{S}^{N} \right>} &= {[\mathcal{S}^{N}]} {\left<\Delta\mathcal{S}^{dw}\right>} 
\end{split}
$$

The temperature response ($$\varphi_T$$) is piece-wise linear with two breakpoints:

<img src="..\media

The salinity response ($$\varphi_{sal}$$) is likewise piece-wise linear with two breakpoints, the first one at 50% response:

<img src="..\media

### Stores

The demands for the storage of carbon $${\left<\Delta\mathcal{C}^{C} \right>}$$, nitrogen $${\left<\Delta\mathcal{N}^{N} \right>}$$ and phosphorus $${\left<\Delta\mathcal{P}^{P} \right>}$$ are linked to the current whole-plant biomass $${\mathcal{W}^{dw}}$$ by the ideal plant proportions achieved under non-limiting conditions (eq. $$\ref{eq_ideal_proportions}$$). We have
$$
\begin{equation}
\begin{split}
{\left<\Delta\mathcal{C}^{C} \right>} &= {[\mathcal{C}^{C}]}\,\left
{\left<\Delta\mathcal{N}^{N} \right>} &= {[\mathcal{N}^{N}]}\,\left
{\left<\Delta\mathcal{P}^{P} \right>} &= {[\mathcal{P}^{P}]}\,\left
\end{split}
\label{eq_store_demands_dw}
\end{equation}
$$
For each demand, the first term represents the ideal dry weight of the store in proportion to $${\mathcal{W}^{dw}}$$, while the second term is the current dry weight of the store. A floor value of zero is imposed in case of superflous stores. The demands are used in eq. $$\ref{totaldemands}$$.

### Maintenance respiration

The maintenance (i.e., dark) respiration was measured at 20℃ in the laboratory by Davison et al. (1991) and Nepper-Davidsen et al. (2019) who found, respectively, values of 1.0 and 1.5 μmol O~2~ /g fw/h. We can convert these into g glucose/g dw by the conversion ratio,
$$
1 \frac{\mu
\frac{1\text{ g fw}}{0.09\text{ g dw}} \times
\frac{180\text{ g dw/mol glucose}}{6 \text{ mol O}_2 \text{/mol glucose}} \times
\frac{24\text{ h}}{1 \text{ d}} =0.00800 \frac{\text{g glucose}}{\text{g dw}\times
$$
The above estimates at 1.0 and 1.5 μmol O~2~ /g fw/h give us a respiration rate at 20℃ ($$r_{20}$$) in the range,
$$
r_{20} \in [8;12] \frac{\text{mg glucose}}{\text{g dw }\times
$$
which matches the range of 7-13 mg glucose/g dw/d typical of crop leaves (de Wit 1978, p. 51). We adjust this respiration rate by temperature assuming $$Q_{10}$$ = 1.05 (Davison et al. 1991), which gives us the temperature-dependent respitation rate ($$r_T$$; g glucose/g dw/d ),
$$
r_T=r_{20}Q_{10}^{(T-20)/10}
$$
The daily carbon demand for maintenance respiration $${\left<\Delta\mathcal{M}^{C}\right>}$$ (g C/m) then becomes
$$
{\left<\Delta\mathcal{M}^{C}\right>} = \frac{72\text{ g C}}{180\text{ g glucose}}\times
r_T\, {\mathcal{W}^{dw}}
$$

### Exudation cost

The mechanisms of exudation in kelp are not well understood. Abdullah and Fredriksen (2004) estimated the exudation rate of *Laminaria* *hyperborea* and found some correlation with the growth rate (r=0.73) with an annual average of 26% exudation of the fixed carbon. Earlier on, Newell et al. (1980) found that the dry matter contents of the exudate in two other kelp species were 10% carbohydrate, 3% protein and 0.3% lipids (the remaining, presumably, consisted of salts).

We assume that the exudation rates of carbon, nitrogen and phosphorus (at rates of $$\epsilon^C$$, $$\epsilon^N$$ and $$\epsilon^P$$, respectively, all per day)  all pertain to the total biomass,
$$
\begin{equation}
\begin{split}
{\left<\Delta\mathcal{E}^{C}\right>} &= \epsilon^C{\mathcal{W}^{dw}}
{\left<\Delta\mathcal{E}^{N}\right>} &= \epsilon^N{\mathcal{W}^{dw}}
{\left<\Delta\mathcal{E}^{P}\right>} &= \epsilon^P{\mathcal{W}^{dw}}
\end{split}
\label{eq_exudation}
\end{equation}
$$
In effect, exudation is a daily tax on the standing biomass, just like maintenance respiration.

### Building costs

The building costs (also known as growth respiration) for different plant organs depend on their chemical composition (Penning de Vries et al. 1974). We will use the general costs tabulated by de Wit (1978): 0.30 g glucose/g dw for structural biomass , 0.14 g glucose/g dw for carbon reserves and 0.41 g glucose/g dw for nitrogen reserves, the latter being the average value for nitrogen uptaken as ammonia or nitrate. De Wit mentions (1978, p.50) that the cost of mineral uptake is minimal. 

We get the following conversions costs,
$$
\begin{equation}
\begin{split}
{\lambda_\mathcal{S}} &= 0.30\frac{\text{ g glucose}}{\text{g dw}}\times
\frac{72\text{ g C}}{180\text{ g glucose}}=0.120\frac{\text{g C}}{\text{g dw}} \\[6pt]
{\lambda_\mathcal{C}} &= 0.14\frac{\text{ g glucose}}{\text{g dw}}\times
\frac{72\text{ g C}}{180\text{ g glucose}}=0.0560\frac{\text{g C}}{\text{g dw}} \\[6pt]
{\lambda_\mathcal{N}} &= 0.41\frac{\text{ g glucose}}{\text{g dw}}\times
\frac{72\text{ g C}}{180\text{ g glucose}}=0.164\frac{\text{g C}}{\text{g dw}} \\[6pt]
{\lambda_\mathcal{P}} &= 0\,\frac{\text{g C}}{\text{g dw}}
\end{split}
\label{conversion_costs}
\end{equation}
$$
The total daily carbon demand to cover building costs $${\left<\Delta\mathcal{B}^{C}\right>}$$ (g C/m) is then
$$
\begin{equation}
{\left<\Delta\mathcal{B}^{C}\right>} = {\lambda_\mathcal{S}}
\label{eq_building_cost}
\end{equation}
$$

## Supplies

### Carbon supply

A part of the incoming sunlight irradiation ($$I_0$$; mol PAR/m^2^/d) is reflected at the water surface, for which we assume a fixed reflectivity ($$\rho$$ = 0.05; see Kirk 2010, section 2.5). Light is absorbed as it passes down the water column. We assume an exponential decay characterised by the extinction coefficient $$k_d$$, which varies with the clarity of the water.  Thus the light available at depth $$d$$ ($$I_d$$; mol PAR/m^2^/d) becomes
$$
I_d=(1-\rho) exp(-k_dd)I_0
$$

The canopy will span over a time-varying range of water depths. It is anchored at the depth of the line but is otherwise free-floating with changing currents. To keep the model at a level of detail reflecting our knowledge, we assume that the canopy is exposed to $$I_d$$ at a fixed depth $$d$$.

To model the photosynthetic rate of a single plant, Benjamin and Park (2007) defined two allometric relations depending on plant biomass ($$M$$), one for leaf area,
$$
A_l = c_1 M^{c_2}
$$
the other for the crown zone area, i.e. the horizontal area covered by the plant crown,
$$
A_z = c_3M^{c_4}
$$
They fixed two of the parameters $$c_2=1$$ and $$c_4=2/3$$ but acknowledged that all four parameters ought to be estimated experimentally according to plant species and growing conditions.

Consider these calibration data:

```
      Date Wtotal     A    L Cconc  Nconc
22-01-2020   7.21  0.58 0.08 0.250 0.0495
27-02-2020  50.99  3.26 0.23 0.252 0.0522
26-03-2020 160.79  4.88 0.38 0.296 0.0335
28-04-2020 587.63 11.37 0.72 0.364 0.0136
03-06-2020 834.03 12.63 0.76 0.351 0.0111
```

The columns `Wtotal`, `Cconc` and `Nconc` correspond to the variables $${\mathcal{W}^{dw}}$$, $${[\mathcal{W}^{C}]}$$ and $${[\mathcal{W}^{N}]}$$. For the columns `A` and `L` we define the variables: leaf area $$A_l$$ (m^2^/m) and leaf length $$L$$ (m).  We will assume that the status of the stores do not affect leaf area or length. Thus in our model, $$A_l$$ and $$L$$  depend on the structural biomass $${\mathcal{S}^{dw}}$$ not the total biomass $${\mathcal{W}^{dw}}$$. Structural biomass is not directly observable but we can derive it, knowing the carbon and nitrogen concentrations. We've got 
$$
\begin{split}
{[\mathcal{W}^{C}]} &= \frac{{[\mathcal{S}^{C}]}
{[\mathcal{W}^{N}]} = \frac{{[\mathcal{S}^{N}]}
{\mathcal{W}^{dw}} = {\mathcal{S}^{dw}}+{\mathcal{C}^{dw}}+{\mathcal{N}^{dw}}
\quad
{\mathcal{S}^{dw}} &= {\mathcal{W}^{dw}}
\end{split}
$$
from which we can add another column `Wstruct` as an estimate of $${\mathcal{S}^{dw}}$$:

```
      Date Wtotal     A    L Cconc  Nconc Wstruct
22-01-2020   7.21  0.58 0.08 0.250 0.0495    4.83
27-02-2020  50.99  3.26 0.23 0.252 0.0522   32.87
26-03-2020 160.79  4.88 0.38 0.296 0.0335   89.94
28-04-2020 587.63 11.37 0.72 0.364 0.0136  221.41
03-06-2020 834.03 12.63 0.76 0.351 0.0111  371.66
```

Linear regression on log-transformed data let us predict both $$A_l$$ and $$L$$ from $${\mathcal{S}^{dw}}$$,
$$
\begin{equation}
\begin{split}
A_l &= c_A({\mathcal{S}^{dw}})^{e_A} &&= 0.211({\mathcal{S}^{dw}})^{0.716} \\[6pt]
L &= c_L({\mathcal{S}^{dw}})^{e_L}   &&= 0.0358({\mathcal{S}^{dw}})^{0.531} \\[6pt]
\end{split}
\label{eq_leaf}
\end{equation}
$$
A cross section of the canopy is roughly wedge-shaped (i.e. pizza slice-shaped) with its point fastened at the line suspending the canopy. Its maximum horizontal extent will be $$2L$$ and its minimum $$1L$$. Sunlight will hit the canopy surface from all sides except from the bottom (in Danish waters, upwards scattering of light is neglible and the bottom is either far down or of low albedo). Thus we arrive at the crown zone area $$A_z$$ (m^2^/m) ,
$$
\begin{equation}
A_z = c_ZL
\label{eq_crown_zone}
\end{equation}
$$
with $$c_Z\in[1;2]$$ m/m.

We compute the leaf area index $$A_i$$ (m^2^ leaf/m^2^ crown zone) following Benjamin and Park (2007),
$$
A_i=\frac{A_l}{A_z}
$$
It follows that the canopy is exposed to a light intensity of $$A_zI_d$$ (mol PAR/m/d). The units are derived as
$$
\frac{{\text{m}^2} \text{ crown zone}}{\text{m}}\cdot
\frac{\text{mol PAR}}{\text{m}\cdot \text{d}}
$$
The two measures of area may seem incommensurable at first glance. That they are the same is most easily seen if one considers the crown zone area in its maximum extent. This occurs when it is spread out horizontally and reaches its maximum width of $$2L$$. Thus, with $$L=0.8$$ m the crown zone would cover $$1.6$$ m^2^ sea surface per m line. This would be the area exposed to the incoming sunlight $$I_d$$. With $$c_Z<2$$ (eq. $$\ref{eq_crown_zone}$$) the exposed area would be less, and at the minimum $$s_Z=1$$ it would be only $$0.8$$ m^2^/m.

The incoming light $$A_zI_d$$ is intercepted by the plant canopy according to $$A_i$$ and the leaf light extinction coefficient $$k_l$$. The fraction of light intercepted is $$1-exp(-k_lA_i)$$, and the amount of light absorbed $$I_a$$ (mol PAR/m/d) becomes
$$
I_a = A_zI_d\{1-exp(-k_lA_i)\}
$$
The relations all ultimately depend on $${\mathcal{S}^{dw}}$$ as illustrated here with $$c_Z=2$$ m and $$k_l=0.7$$:

![carbon-supply](..\media

The leaf area index is always high and the fraction of light intercepted (`fabs` in the figure) close to 100%. This means that the extent of the crown zone $$A_z$$ is more decisive for light absorption than the leaf area $$A_l$$, and that $$c_Z$$ is more influential than $$k_l$$, which we can safely leave at $$k_l=0.7$$. According to this reasoning, line-grown plants are expected to be morphologically distinguishable from solitary plants, due to the dense foliage, with narrower and maybe thinner leaves (showing etiolated growth).

$$I_a$$ corresponds to the resource density $$X$$ in eq. $$\ref{eq_b_g_response}$$, where we plug it in:
$$
\begin{equation}
{\Delta\mathcal{U}^{C}}={\left<\Delta\mathcal{U}^{C}\right>}
  -\frac{\alpha\,\psi^N I_a\Delta t}
  {{\left<\Delta\mathcal{U}^{C}\right>}}
\right) \right\}
\label{eq_sUC}
\end{equation}
$$
The photosynthetic efficiency $$\alpha$$ (g C/mol PAR) converts the absorbed light into fixed carbon. It is modulated by $$\psi ^N\in [0;1]$$, which takes into account sub-optimal concentrations of plant nitrogen $${[\mathcal{W}^{N}]}$$. 

The value of $$\alpha$$ can be estimated from Sogn Andersen et al. (2013, Fig. 3):
$$
\begin{split}
\alpha &= 0.23\frac{\mu
&=0.23\cdot421.5\frac{\mu
&=0.969\cdot10^{-5}\frac{\text{g C}}{\text{dm}^2\cdot
&=0.969\cdot10^{-5}\frac{100}{3600}\frac{\text{g C}}{\mu
&=2.69\frac{\text{g C}}{\text{mol PAR}}
\end{split}
$$
The response ($$\psi^N$$) to plant nitrogen forms a piece-wise linear response with two breakpoints, 

<img src="..\media

### Nitrogen and phosphorus supply

We apply the acquistion function (eq. $$\ref{eq_b_g_response}$$) to the uptake of nitrogen ($${\Delta\mathcal{U}^{N}}$$; g N/m) and phosphorus ($${\Delta\mathcal{U}^{P}}$$; g P/m) from the surrounding sea water, where it occurs at concentrations  $$[N_{water}]$$ and $$[P_{water}]$$ (both $$\mu$$M);
$$
\begin{equation}
\begin{split}
{\Delta\mathcal{U}^{N}} &= {\left<\Delta\mathcal{U}^{N}\right>}
\left\{ 1-\text{exp}\left(-\frac{\beta\, [N_{water}]A_l\Delta t }{{\left<\Delta\mathcal{U}^{N}\right>}} \right) \right\} \\[6pt]
{\Delta\mathcal{U}^{P}} &= {\left<\Delta\mathcal{U}^{P}\right>}
\left\{ 1-\text{exp}\left(-\frac{\gamma\,[P_{water}]A_l\Delta t }{{\left<\Delta\mathcal{U}^{P}\right>}} \right) \right\} \\[6pt]
\end{split}
\label{eq_NP_supply}
\end{equation}
$$

with nitrogen acquisition efficiency $$\beta$$ in units,
$$
\frac{\text{g N}}{\text{m}^2\text{/m}\cdot \mu
$$
and phosphorus acquisition efficiency $$\gamma$$ in units,
$$
\frac{\text{g P}}{\text{m}^2\text{/m}\cdot \mu
$$
These acquisition functions (eq. $$\ref{eq_NP_supply}$$) are simpler than the one for carbon (eq. $$\ref{eq_sUC}$$). This is because we assume that the concentration of dissolved nitrogen and phosphorus, unlike light, is not attenuated as water passes through the canopy. Hence, for these nutrients we base uptake on leaf area $$A_l$$ rather than leaf area index $$A_i$$. There will, locally, be a slight drop in nutrient concentrations as they are taken up by the plants but we assume that water currents will quickly reinstate the ambient concentrations.

## Allocation

The acquired carbon, nitrogen and phosphorus is allocated in a sequence of steps, according to demands, while stores are being mobilised as needed. The allocation procedure follows a prioritised sequence of the demands (*cf.* Gutierrez 1996): 

1. Maintenance respiration
2. Exudation
3. Plant structure
4. Nitrogen store
5. Carbon store 
6. Phosphorus store

The first two steps allocate ressources to obligatory expenditures. The costs for building tissue of plant structure and stores are taken into account during allocation in proportion to the actual supplies. We assume that nitrogen stores take priority over carbon stores; this will only have a consequence if carbon to cover store building costs are limiting. The phosphorus store is built at no cost ($${\lambda_\mathcal{P}}=0$$, eq. $$\ref{conversion_costs}$$).

During each allocation step, priority is given to the resources just acquired: $${\left<\Delta\mathcal{U}^{C}\right>}$$, $${\left<\Delta\mathcal{U}^{N}\right>}$$ and $${\left<\Delta\mathcal{U}^{P}\right>}$$. Only when these have been exhausted are stores ($${\mathcal{C}^{C}}$$, $${\mathcal{N}^{N}}$$ and $${\mathcal{P}^{P}}$$) being mobilised to meet demands.

The `allocation.R` script demonstrates the logic applied during allocation by the function `take`. In step 1, for example, when carbon for maintenance respiration is allocated, it is written like this
$$
{\text{take}\;}
$$
This corresponds to a call of the `take` function with `demand` equal to $${\left<\Delta\mathcal{M}^{C}\right>}$$, `sources` equal to the vector $$({\Delta\mathcal{U}^{C}},{\mathcal{C}^{C}})$$, and with the function result (local variable `supply`) assigned to $${\Delta\mathcal{M}^{C}}$$.

Note that the function has side effects (recognised by operator `<<-` in the R script) as it reduces the resources from which the supply has been taken. 

```R
take = function(demand, sources) {
  supply = 0
  lacking = demand
  # Go through sources in order of priority
  for (source in sources) {
    lacking = demand - supply
    taken = if (lacking > R[source]) R[source] else lacking
    supply = supply + taken
    R[source] <<- R[source] - taken
    # Stop if supply meets demand
    if (abs(supply - demand) < 1e-6) break
  }
  supply
}
```

In the following, `ask for` has the same functionality as `take`, except that it calculates the supply without any side effects. It is used to ask what the supply *would be*, in case it were taken from the given sources.

### Step 1. Maintenance respiration

First, carbon needed for respiration is taken,
$$
{\text{take}\;}
$$

If the uptaken carbon $${\Delta\mathcal{U}^{C}}$$ was not sufficient to meet the demand $${\left<\Delta\mathcal{M}^{C}\right>}$$ then the deficit was drawn from the carbon store $${\mathcal{C}^{C}}$$ by the `take` function. We must keep track of the carbon store before and after allocation to calculate any loss to the store ($${\Delta\mathcal{C}^{dw}}_1$$; g dw/m) in this step,
$$
{\Delta\mathcal{C}^{dw}}_1 = \frac{{\mathcal{C}^{C}}_{after} - {\mathcal{C}^{C}}_{before}}{{[\mathcal{C}^{C}]}} \le 0
$$
If the carbon store was exhausted without the demand being fulfilled, we need to recycle structural biomass $${\Delta\mathcal{S}^{dw}}_1$$ (g dw/m) to cover the deficit:
$$
\begin{equation}
{\Delta\mathcal{S}^{dw}}_1= \left
\label{eq_maintenance_deficit}
\end{equation}
$$
If $${\Delta\mathcal{S}^{dw}}

On exit from step 1:

* The demand for maintenance respiration has been met.
* Resources $${\Delta\mathcal{U}^{C}}$$ and $${\mathcal{C}^{C}}$$ may have decreased.
* If $${\mathcal{C}^{C}}$$ decreased then carbon store dry matter was lost, $${\Delta\mathcal{C}^{dw}}_1 \lt 0$$.
* Structural mass may have been lost and carbon resources emptied, $${\Delta\mathcal{S}^{dw}}_1<0 \and {\Delta\mathcal{U}^{C}}=0 \and {\mathcal{C}^{C}}=0$$. 

### Step 2. Exudation

We take carbon, nitrogen and phosphorus exudates from the following sources,
$$
\begin{split}
{\text{take}\;}
{\text{take}\;}
{\text{take}\;}
\end{split}
$$
If any resource is limiting, i.e if $${\Delta\mathcal{E}^{C}}<{\left<\Delta\mathcal{E}^{C}\right>}$$ or $${\Delta\mathcal{E}^{N}}<{\left<\Delta\mathcal{E}^{N}\right>}$$ or $${\Delta\mathcal{E}^{P}}<{\left<\Delta\mathcal{E}^{P}\right>}$$, then structural biomass will not be recycled to make up for the lack. This is in contrast to basic metabolism in step 1, which was strictly obligatory. Thus stressed plants might exude less than demanded. We define the supply/demand ratios for exudation (which are useful descriptors of this aspect of plant performance) by
$$
\begin{split}
{\phi^C_\mathcal{E}}&=\frac{{\Delta\mathcal{E}^{C}}}{{\left<\Delta\mathcal{E}^{C}\right>}} \in [0;1] \\[6pt]
{\phi^N_\mathcal{E}}&=\frac{{\Delta\mathcal{E}^{N}}}{{\left<\Delta\mathcal{E}^{N}\right>}} \in [0;1] \\[6pt]
{\phi^P_\mathcal{E}}&=\frac{{\Delta\mathcal{E}^{P}}}{{\left<\Delta\mathcal{E}^{P}\right>}} \in [0;1] 
\end{split}
$$
Any losses to stores in step 2 are recorded (in g dw/m) as
$$
\begin{split}
{\Delta\mathcal{C}^{dw}}_2 &= \frac{{\mathcal{C}^{C}}_{after} - {\mathcal{C}^{C}}_{before}}{{[\mathcal{C}^{C}]}}\le 0\\[6pt]
{\Delta\mathcal{N}^{dw}}_2 &= \frac{{\mathcal{N}^{N}}_{after} - {\mathcal{N}^{N}}_{before}}{{[\mathcal{N}^{N}]}}\le 0\\[6pt]
{\Delta\mathcal{P}^{dw}}_2 &= \frac{{\mathcal{P}^{P}}_{after} - {\mathcal{P}^{P}}_{before}}{{[\mathcal{P}^{P}]}}\le 0
\end{split}
$$
On exit from step 2:

* The demands for exudation may not have been met: $${\phi^C_\mathcal{E}}
* Resources $${\Delta\mathcal{U}^{C}},{\mathcal{C}^{C}},{\Delta\mathcal{U}^{N}},{\mathcal{N}^{N}},{\Delta\mathcal{U}^{P}}$$ and $${\mathcal{W}^{P}}$$  may have decreased.
* For any store $${\mathcal{C}^{C}}$$, $${\mathcal{N}^{N}}$$ or $${\mathcal{P}^{P}}$$ that decreased, store dry matter was lost, respectively, $${\Delta\mathcal{C}^{dw}}_2 \lt 0$$, $${\Delta\mathcal{N}^{dw}}_2 \lt 0$$ or $${\Delta\mathcal{P}^{dw}}_2 \lt 0$$.

### Step 3. Plant structure

Structural growth uses carbon and nitrogen for structural tissue plus carbon to cover the building costs. To find out which resource is more limiting for structural growth, carbon or nitrogen, we tentatively ask for the allocation of both. For the carbon demand, we add the building costs,
$$
\begin{split}
&{\text{ask for}\;}
&{\text{ask for}\;}
\end{split}
$$
We  convert the tentative supplies $${\Delta\mathcal{S}^{C}}_0$$ and $${\Delta\mathcal{S}^{N}}_0$$ to the corresponding biomass decrement. The supply that gives the smaller increment governs the outcome:
$$
\begin{split}
&{\text{if}\quad}
&\quad
&\quad
&{\text{else}\quad}\\[6pt]
&\quad
&\quad
\end{split}
$$

In the first case, carbon is the more limiting and carbon is allocated first. Afterwards, the nitrogen needed to follow with the carbon to build structural tissue is allocated. In the alternative case, the order of allocation is the opposite.

The allocation to structural growth (g dw/m) in step 3 is
$$
{\Delta\mathcal{S}^{dw}}_3=\frac{{\Delta\mathcal{S}^{C}}}{{[\mathcal{S}^{C}]}}=\frac{{\Delta\mathcal{S}^{N}}}{{[\mathcal{S}^{N}]}} \ge 0
$$

resulting in the supply/demand ratio for structural growth,
$$
{\phi_\mathcal{S}}=\frac{{\Delta\mathcal{S}^{dw}}_3}{{\left<\Delta\mathcal{S}^{dw}\right>}} \in [0;1]
$$
Any losses to stores (g dw/m) in step 3 are
$$
\begin{split}
{\Delta\mathcal{C}^{dw}}_3 &= \frac{{\mathcal{C}^{C}}_{after} - {\mathcal{C}^{C}}_{before}}{{[\mathcal{C}^{C}]}} \le 0\\[6pt]
{\Delta\mathcal{N}^{dw}}_3 &= \frac{{\mathcal{N}^{N}}_{after} - {\mathcal{N}^{N}}_{before}}{{[\mathcal{N}^{N}]}} \le 0
\end{split}
$$
On exit from step 3:

* The demand for structural growth may not have been met, $${\phi_\mathcal{S}}
* Resources $${\Delta\mathcal{U}^{C}},{\mathcal{C}^{C}},{\Delta\mathcal{U}^{N}}$$ and $${\mathcal{N}^{N}}$$ may have decreased.
* For any store $${\mathcal{C}^{C}}$$ or $${\mathcal{N}^{N}}$$ that decreased, store dry matter was lost, respectively, $${\Delta\mathcal{C}^{dw}}_3 \lt 0$$ or $${\Delta\mathcal{N}^{dw}}_3 \lt 0$$.

### Step 4. Nitrogen store

We need nitrogen for the store itself plus carbon to cover the building costs. This means that both nitrogen and carbon could be limiting. As in step 3, we tentatively ask for the allocation of both,
$$
\begin{split}
&{\text{ask for}\;}
&{\text{ask for}\;}
\end{split}
$$
First, we ask for the demanded nitrogen $${\left<\Delta\mathcal{N}^{N} \right>}$$ to be covered by the nitrogen that was just uptaken. As a result we get the nitrogen-limited supply $${\Delta\mathcal{N}^{N}}_N \le {\left<\Delta\mathcal{N}^{N} \right>}$$.

Second, we ask for the carbon needed to build the tissue demanded by the nitrogen store. We find the building cost by converting the nitrogen demand $${\left<\Delta\mathcal{N}^{N} \right>}$$ (g N/m) to a biomass demand (g dw/m), using the nitrogen concentration in the store $${[\mathcal{N}^{N}]}$$ (g N/g dw), and then convert that to a carbon demand using the building cost $${\lambda_\mathcal{N}}$$ (g C/g dw). The demanded carbon may be sourced from the just fixated carbon $${\Delta\mathcal{U}^{C}}$$, as well as from the carbon store $${\mathcal{C}^{C}}$$. As a result we get the carbon-limited supply $${\Delta\mathcal{N}^{N}}_C \le {\left<\Delta\mathcal{N}^{N} \right>}$$.

We pick the source that is more limiting and take the appropriate amounts of both nitrogen and carbon:
$$
\begin{split}
&{\text{if}\quad} {\Delta\mathcal{N}^{N}}_N < {\Delta\mathcal{N}^{N}}_C &&{\quad\text{then}\quad} \\[6pt]

&\quad
&\quad

&{\text{else}\quad}\\[6pt]

&\quad
&\quad
\end{split}
$$

In the first case, nitrogen is the more limiting. Consequently, we take the available nitrogen first to get the supply $${\Delta\mathcal{N}^{N}}$$. Next we calculate the carbon expenditure needed to build $${\Delta\mathcal{N}^{N}}$$ and take that from the available carbon. The second case operates in the same way, just the other way around.

Allocation to to the nitrogen store (g dw/m) in step 4 is
$$
{\Delta\mathcal{N}^{dw}}_4 = \frac{{\Delta\mathcal{N}^{N}}}{{[\mathcal{N}^{N}]}} \ge 0
$$

resulting in the supply/demand ratio for stored nitrogen,
$$
{\phi_\mathcal{N}}=\frac{{\Delta\mathcal{N}^{dw}}_4}{{\left<\Delta\mathcal{N}^{dw}\right>}} \in [0;1]
$$
Any loss to the carbon store (g dw/m) in step 4 is
$$
{\Delta\mathcal{C}^{dw}}_4 = \frac{{\mathcal{C}^{C}}_{after} - {\mathcal{C}^{C}}_{before}}{{[\mathcal{C}^{C}]}} \le 0
$$


On exit from step 4:

* The demand of the nitrogen store may not have been met, $${\phi_\mathcal{N}} \le1$$.
* resources $${\Delta\mathcal{U}^{C}},{\mathcal{C}^{C}}$$ and $${\Delta\mathcal{U}^{N}}$$ may have decreased.
* If  $${\mathcal{C}^{C}}$$ decreased, carbon store dry matter was lost, $${\Delta\mathcal{C}^{dw}}_4 \lt 0$$.

### Step 5. Carbon store

The supply to the carbon store and the associated building cost can only be taken from the just fixated carbon,
$$
{\text{take}\;}
$$

Allocation to the carbon store (g dw/m) in step 5 is then
$$
{\Delta\mathcal{C}^{dw}}_5 = \frac{{\Delta\mathcal{C}^{C}}}{{[\mathcal{C}^{C}]}}
$$
resulting in the supply/demand ratio for stored carbon,
$$
{\phi_\mathcal{C}}=\frac{{\Delta\mathcal{C}^{dw}}_5}{{\left<\Delta\mathcal{C}^{dw}\right>}} \in [0;1]
$$
On exit from step 5:

* The demand of the carbon store may not have been met, $${\phi_\mathcal{C}} \le1$$
* $${\Delta\mathcal{U}^{C}}$$ may have decreased.

### Step 6. Phosphorus store

There is only one source to supply the phosphorus store and there is no building cost,
$$
{\text{take}\;}
$$
Allocation to the phosphorus store (g dw/m) in step 6 is then
$$
{\Delta\mathcal{P}^{dw}}_6 = \frac{{\Delta\mathcal{P}^{P}}}{{[\mathcal{P}^{P}]}}
$$
resulting in the supply/demand ratio for stored phosphorus,
$$
{\phi_\mathcal{P}}=\frac{{\Delta\mathcal{P}^{dw}}_6}{{\left<\Delta\mathcal{P}^{dw}\right>}} \in [0;1]
$$
On exit from step 6:

* The demand of the phosphorus store may not have been met, $${\phi_\mathcal{P}}
* $${\Delta\mathcal{U}^{P}}$$ may have decreased.

### Roundup

The allocation in steps 1 to 6 served to compute the supplies and losses pertaining to the four compartments ($${\mathcal{S}^{dw}},{\mathcal{C}^{dw}},{\mathcal{N}^{dw}},{\mathcal{P}^{dw}}$$). We now apply these changes to update the model state variables:
$$
\begin{split}
{\mathcal{S}^{dw}} &\leftarrow {\mathcal{S}^{dw}}+{\Delta\mathcal{S}^{dw}}_1+{\Delta\mathcal{S}^{dw}}_3 \\[6pt]
{\mathcal{C}^{dw}} &\leftarrow {\mathcal{C}^{dw}}+{\Delta\mathcal{C}^{dw}}_1+{\Delta\mathcal{C}^{dw}}_2+{\Delta\mathcal{C}^{dw}}_3+{\Delta\mathcal{C}^{dw}}_4+{\Delta\mathcal{C}^{dw}}_5 \\[6pt]
{\mathcal{N}^{dw}} &\leftarrow {\mathcal{N}^{dw}}+{\Delta\mathcal{N}^{dw}}_2+{\Delta\mathcal{N}^{dw}}_3+{\Delta\mathcal{N}^{dw}}_4 \\[6pt]
{\mathcal{P}^{dw}} &\leftarrow {\mathcal{P}^{dw}}+{\Delta\mathcal{P}^{dw}}_2+{\Delta\mathcal{P}^{dw}}_6
\end{split}
$$
Note that any $$\Delta$$ is either $$\le0$$ or $$\ge 0$$; no $$\Delta$$ can attain both positive and negative values.

The total  building costs (eq. $$\ref{eq_building_cost}$$) are 
$$
{\Delta\mathcal{B}^{C}} = {\lambda_\mathcal{S}}
$$


## Calibration

While most model parameters can be estimated from biological principles or from empirical data, other parameters can only be estimated by comparison of simulation outputs with expected data This method of parameter estimation is known as 'calibration'. Calibration was carried out by trial-and-error and visual inspection of plots showing simulation outputs together with observations.

For the exudation costs (eq. $$\ref{eq_exudation}$$) we found

* $$\lambda^C=0.02$$ 
* $$\lambda^N=0.02$$  
* $$\lambda^P=0.001$$ 

For carbon supply, we set the scaling of leaf length to crown zone area (eq. $$\ref{eq_crown_zone}$$) to its maximum,

* $$c_Z=2$$

The uptake rates for nitrogen and phosphorus  (eq. $$\ref{eq_NP_supply}$$)  interacted much with the corresponding exudation rates. We arrived at

* $$\beta=0.27$$ 
* $$\gamma=0.30$$

This figure shows the driving variables  on the left $$\big(I_d, [N_{water}], [P_{water}]\big)$$, and simulated and observed plant concentrations on the right $$\big({[\mathcal{W}^{C}]},{[\mathcal{W}^{N}]},{[\mathcal{W}^{P}]}

![](D:\Documents

The upper brown lines show the upper limits on the respective concentrations. The model overshoots a bit because of the roughness of the time step (1 day). The two lower brown lines for $${[\mathcal{W}^{N}]}$$ show the critical limits for its influence on plant photosynthesis. 

The  model is very sensitive to plant nitrogen $${[\mathcal{W}^{N}]}$$ as seen in the simulated biomass $${\mathcal{W}^{dw}}$$ and leaf area $$A_l$$:

![calibration-biomass-area](..\media

The dip in biomass at the of April is due to low plant nitrogen $${[\mathcal{W}^{N}]}$$ concomitant with low light $$I_d$$.

## Verification

In model verification, we expose the model to different scenarios to check its robustness and to see if its outputs make sense.

### Darkness

In this scenario there was no sunlight, $$I_d=0$$. We expect the plant to exhaust itself by maintenance respiration and exudation. First, we check the biomass and leaf area:

![verification-darkness](..\media

We see the expected exponential decline of the biomass, while the initial increase in leaf area is due to mobilisation of stores to build structural tissue. Yet, the initial, tiny increase looks suspicious. Let's study the details of the biomass compartments in the first few time steps:

```
      date structure.dw storeC.dw storeN.dw storeP.dw whole.dw    concC     concN      concP
2019/12/16        1.035     0.375     0.075     0.015      1.5   0.2624    0.0323     0.0033
2019/12/17      1.08675  0.223569  0.187547 0.0407837  1.53865 0.216615 0.0592255 0.00874703
2019/12/18      1.14109  0.105931  0.192444 0.0419632  1.48143 0.195363   0.06347 0.00934765
2019/12/19       1.1853       0.0  0.192444 0.0419632  1.41971 0.175327  0.066852 0.00975401
2019/12/20      1.15991       0.0  0.192444 0.0419632  1.39432 0.174696 0.0677051 0.00993162
```

That tiny increment turns out to be nitrogen! The nitrogen store was initialised at a value $${\mathcal{S}^{dw}}=0.075$$ g dw/m that turned out to be out of balance with the nitrogen concentration in the water. As there are no upper limits to the rate of nutrient uptake, besides those set by the demands, the plant quickly made up for that imbalance and took up a large quantity of nitrogen in just one day. The needed building costs were taken from the carbon store.

Another issue ia that, in the longer run,  plant concentrations of nitrogen and phosphorus, drift out of control:![verification-darkness-conc](..\media

This happens because the model respires carbon from the structural tissue to meet the demand of basic metabolism (eq. $$\ref{eq_maintenance_deficit}$$), while leaving the stores alone. This needs to be fixed, even though it is not known exactly how the plant would react to extreme light limitation. A simple measure would be to carry out all steps of the allocation procedure, even when step 1 (maintenance respiration) leads to a carbon deficit. The model will also benefit from this by making it simpler: a carbon deficit is no longer considered an exceptional case.
