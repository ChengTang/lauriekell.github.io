A number of data limited methods already exist and to allow them to be simulation tested to compare their performance they are implemented within a common R framework,   [FLR](http://www.flr-project.org/) with examples and documentation provided in the form of vignettes.      

# Framework

Management Strategy Evaluation (MSE) and simulation modelling are increasingly being used to evaluate the robustness of stock assessment methods and scientific advice frameworks to the main sources of uncertainty. This is because it is recognised that the robustness depends on the combination of pre-defined data, the assessment method, choice of reference points and the Harvest Control Rule (HCR) used to set management action such as a Total Allowable Catch (TAC).

When running an MSE control actions the MP are fed back into an Operating Model (OM) that represents the system being managed so that its influence on the simulated stock and hence on future fisheries data is propagated through the stock and fishery dynamics.

To simulate the types of data used by the MP requires an Observation Error Model (OEM) to generates fishery-dependent and/or fishery-independent resource monitoring data.

Examples of the MSE framework can be found in the [vignettes](https://github.com/flr/mydas/blob/master/vignettes/mse/mse.pdf) and [task5](https://github.com/flr/mydas/tree/master/tasks/task5/R)

## Assessment Methods

The majority of fish stocks worldwide are not managed quantitatively as they lack sufficient data, particularly a direct index of abundance, on which to base an assessment. Often these stocks are relatively “low value”, which renders dedicated scientific management too costly, and a generic solution is therefore desirable. A management procedure [(mp)](https://academic.oup.com/icesjms/article/72/1/251/815189) approach can be used where simple harvest control rules are simulation tested to check robustness to uncertainties. 

A number of data limited MPs already exist, for example the ICES Working Group on Category 3 and 4 stocks [WGMSYCAT34](  
http://www.ices.dk/sites/pub/Publication%20Reports/Expert%20Group%20Report/acom/2017/WKMSYCAT34/01.%20WKMSYCAT34%20REPORT%202017.pdf) has also been working on rules for survey-based assessments which indicate trends in stock status (Category 3) and for which only catch data are available (Category 4). 

In fish stock assessments the main types of data are total landings, indices of abundance, length frequency and age data. ICES classifies stock assessments into six [categories](http://www.ices.dk/sites/pub/Publication%20Reports/Advice/2015/2015/General_context_of_ICES_advice_2015.pdf) on the basis of available data, in order to identifying the advice rule to be applied i.e. 

**Category 1:** ***stocks with quantitative assessments.*** 
Full analytical assessments and forecasts as well as stocks with quantitative assessments based on production models.

**Category  2:** ***stocks  with  analytical  assessments  and  forecasts  that  are  only  treated  qualitatively.*** 
Quantitative assessments and forecasts which for a variety of reasons are considered indicative of trends in fishing mortality, recruitment, and biomass.

**Category 3:** ***stocks for which survey based assessments indicate trends.*** 
Survey or other indices are available that provide reliable indications of trends in stock metrics, such as total mortality, recruitment, and biomass.

**Category 4:** ***stocks for which only reliable catch data are available.*** 
Time series of catch can be used to approximate MSY.

**Category 5:** ***landings only stocks.*** 
Only landings data are available.

**Category 6:** ***negligible landings stocks and stocks caught in minor amounts as bycatch.*** 
Landings are negligible in comparison to discards and stocks that are  primarily caught as bycatch species in other targeted fisheries 

### Candidate Management Procedures

A [google spreadsheet](https://docs.google.com/spreadsheets/d/17_qQdzDY41ZrL0yT6QtHpUR4_ydxx_xfCh4GiDqYymU/edit?usp=sharing) has been compiled which documents available methods, their data and knowledge requirements, and parameters estimated. In this spreadsheet links can also be found to the repositories with code implementing the methods. 

A variety of [methods](http://drumfish.org/WP2) exist for different types of datasets namely

*Catch-based methods* which provide estimates of Biomass and B/Bmsy by year, e.g. Depletion-based Stock reduction analysis (DB-SRA, Dick and MacCall 2011), Catch-MSY (Martel and Froese 2013), Bayesian approaches such as COM-SIR (Vasconcellos and Cochrane 2005), State-space-Catch-Only-method (SS-COM, Thorson et al. 2013), Modified panel regression (Costello et al. 2012) and Ensemble Methods (Rosenberg et al. 2017), 

and *Length-based methods* which provide estimates of fishing mortality by year, e.g. Mean Length-Based Estimators of Mortality (MLZ), life-history and length distribution based (LBSPR, Hordyk et al. 2014), those that accounting for variable recruitment and fishing mortality in length-based stock assessments for data-limited fisheries (LIME, Rudd and Thorson, under review) and utilizing B-H invariants and catches as a function of size (Kokkalis et al. 2015).
 
Simulation has been conducted for these methods (see Pons et al., ) and the best performing ones were shown to be DBSRA, LBSPR and MLZ, therefore these were implemented in FLR. 

In addition Cat 1 methods, based on age and biomass dynamic model were also tested to evaluate the benefits of reducing uncertainty by collecting time series of catch-at-age and relative abundance. 

Such model-based strategies are attractive because they may be linked to the stock assessment results and generally have a greater capacity to “learn” about stock productivity. HCRs may also be based on empirical indicators that  follow trends in stock status (or other variables of interest such as catch rate, size composition, tag recovery rate, survey estimates of abundance and species composition). Such rules have an advantage of being more easily understood by managers and stakeholders. Also using  complex model-based MPs does not necessarily ensure a more robust management. Therefore a variety of model free MPs were also simulation tested.
