# Peer Review Papers  

A main outputs are peer review pap  ers demonstrating the use of the R packages and documenting the case studies. 


## FLife, [Application Paper](http://besjournals.onlinelibrary.wiley.com/hub/journal/10.1111/(ISSN)2041-210X/features/applicationpapers.html) for Methods in Ecology and Evolution

+ An understanding of population dynamics is important for fisheries management, since life history invariants can help to provide priors for difficult to estimate population parameters and to parameterise ecological models used to help develop an ecosystem based approach to fisheries management. 

+ A main goal of fish stock assessment is to provide robust advice, therefore Management Strategy Evaluation (MSE) is increasingly being use to to simulation test alternative management strategies prior to implementation. To ensure a control system is robust requires simulation models to be conditioned on expert beliefs and other a priori information about system processes that may affect the behaviour of management systems in the future. This requires hypothesis to be developed and system processes.

+ While in data poor situations life history parameters, such as maximum size and size at first maturity have been used as proxies for productivity since species displaying late age-at-maturity, large size, slow growth and low rate of potential population increase, appeared more vulnerable to exploitation and declined more in abundance than others. 

### Workplan

Provide examples of the methods in **FLife** to

+ Describe the relationships between life history parameters
+ Show how to derive processes such as natural mortality and fecundity
+ Compare estimation of productivity based on
   + Leslie matrices
   + Spawner per recruit equilibrium analyses and reference points
+ Show how to estimate limit reference points
+ Condition Operating Models
 
## Life History Imputation

+ Biological reference points have become central to management following the adoption, by many fisheries organisations, of the precautionary approach. These are used as targets to maximise surplus production and  limits to minimise the risk of depleting a resource to a level where productivity is compromised. They must integrate dynamic processes such as growth, recruitment, mortality and connectivity into indices of spawning reproductive potential and exploitation level.  

+ Indicators are increasingly being required for by-caught, threatened, endangered, and protected species where data and knowledge are limited. In such situations life history parameters, such as maximum size and size at first maturity have been used as proxies for productivity. For example in Ecological Risk Assessment (ERA) and Productivity and Susceptibility Analysis (PSA), where the risk of a stock to becoming overfished is evaluated using indices of productivity. In a PSA life history attributes are combined and used to rank stocks, populations or species in order of productivity. 

+ Ranking using a mixture of attributes, however. is sensitive to the choice of attributes, the weights applied when combining them and the methods used in their derivation. Random errors may lead to a switch in rankings, and can influence outcomes considerably. Robust rankings, where ranking order is stable, are normally considered to be reliable and trustworthy, and conversely non-robust rankings as unreliable and unstable. The robustness of ranking in a composite index, however, may be due to a redundancy of attributes. If so it may make little sense to combine correlated indices. Robustness can therefore be both desirable and undesirable simultaneously. 

+ For data poor stocks, where attributes may not be available for all species, a variety of ad-hoc approaches have been used to handle missing data, which may introduce noise and bias. An important objective when providing advice is robustness. Where in statistics, a test is robust if it provides insight despite its assumptions being violated. While in engineering, a robust control system is one that still functions correctly in the presence of uncertainty or stressful environmental conditions. 

### Workplan

+ Use FLife and data rich data sets to estimate productivity, then using these data simulate data poor datasets. 

+ Use Bayesian imputation to estimate indicces of productivity for the data poor dataset and compare to the data rich estimates

## Black-grey-white box.

+ In fisheries there is a trend towards develop advice based on increasingly complex stock assessment models fitted to historical data. These are then projected forward to determine what the catch should be to achieve management objectives, such as low risk of stock collapse and maximum sustainable yield. Then a few years later the results are reviewed and the process repeated. In engineering terms this is equivalent to using a white box model. 

+ An example of a grey-box model, i.e. a simple model with only a few parameters, is a logistic production function, while a black box where the control is based on data alone as in an empirical harvest control rule.

+ An alternative to using white box models is the use of MSE to develop simpler models and management advice based upon them. One reason for the use of MSE is as a response to recent technological advances in computational power and modelling sophistication that have allowed fisheries scientists to develop complex models. This trend has led to two problems (i) a lack of transparency because of many internal, inexplicit and often poorly documented assumptions (especially for data-limited stocks), (ii) a lack of access, as only a few highly skilled modellers can run such complex models. An alternative to the development of such increasingly complex models, accessible only to a limited few, is the development of management decisions based on simple rules that are more data-based than model-based.

### Workplan

+ Set up an [OMs](https://github.com/flr/mydas/tree/master/papers/black-box/R/om.pdf) with biological processes based on **FLife** 
+ Create an [Observation Error Model](https://github.com/flr/mydas/tree/master/papers/black-box/R/oem.pdf) to mimic different types of data collecting regimes
+ Implement a variety of [MP](https://github.com/flr/mydas/tree/master/papers/black-box/R/mse-run.pdf), i.e. age, biomass and indicator based
+ Agree [scenarios](https://github.com/flr/mydas/tree/master/papers/black-box/R/scenarios.pdf).
+ Compare the [performance](https://github.com/flr/mydas/tree/master/papers/black-box/R/smmry.pdf) of MPs

## Comparison of data rich and data poor indicators

+ Use a data rich assessment to simulate different data poor indicators and compare their ability to identify overfishing. 

+ A main objective of reference points is to prevent overfishing, e.g. growth, recruitment, economic and target overfishing. Growth and recruitment overfishing are generally associated with limit reference points, while economic overfishing may be expressed in terms of either targets or limits. 

+ The difference between targets and limits is that indicators may fluctuate around targets but in general limits should not be crossed. Target overfishing occurs when a target is overshot, although variations around a target is not necessarily considered serious unless a consistent bias becomes apparent. In contrast even a single violation of a limit reference point may indicate the need for immediate action. Therefore to achieve MSY requires limit as well as target reference points.

### Workplan

+ Select a variety of data rich assessments
+ Set up and run a number of assessment scenario
+ Create an Observation Error Model to simulate different datasets
+ Implement a variety of different data poor assessment methods
+ Compare the different indicators of overfishing

## Bayesian Hierarchical Stock assessment  

### Workplan

## PSA with economics, for Marine Policy

### Workplan

## Case Studies

### Workplan

