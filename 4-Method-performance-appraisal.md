Develop a set of diagnostics that can be applied across a range of models, assess the stability of the model, sensitivity to assumptions and bias in the advised catch.     

The diagnostics will be based on simulation, where an Operating Model (OM) is used to represent a range of hypotheses reflecting uncertainty about the resource dynamics and an Observation Error Model (OEM) to simulate different types and quality of data and knowledge. Two main procedures will be used Management Strategy Evaluation (MSE) where an assessment method is evaluated as part of a Management Procedure (MP) i.e. a feedback control rule,  and cross testing where the assessment method is not run in feedback mode. In the later case estimates of stock status relative to reference points alone are compared.    
  
# Management Strategy Evaluation

There are a variety of ways of evaluating the performance of stock assessment methods and the robustness of management advice based upon them. As well as using a MSE with an OM to simulation test MPs with feedback control the OM and OEM can be used without feedback in the form of a cross-test. In a cross-test a stock assessment model is first fitted to data and then used to simulate data for use by a second model and the results compared.

Although the most rigorous way to evaluate stock assessment methods is to conduct MSE, this is time consuming and so cross-testing will be used to screen potential methods first. 

Conducting a MSE requires six steps; namely i) identification of management objectives; ii) selection of hypotheses for the OM; iii) conditioning the OM based on data and knowledge, and possible weighting and rejection of hypotheses; iv) identifying candidate management strategies; v) running the Management Procedure (MP) as a feedback control in order to simulate the long-term impact of management; and then vi) identifying the MPs that robustly meet management objectives. 

## Operating Model

There are many alternative ways to condition OMs which are used to represent the resource dynamics.

One way is to use a stock assessment. 
- This implies that the assessment is able to describe nature almost perfectly
- If this is true why bother with MSE? 

Basing an OM on the current assessment model has arguably the lowest demands for knowledge and data and allows  a phased transition to be made from a stock assessment paradigm to a risk based approach. Also if a management procedure can not perform well when reality is as simple as implied by an assessment model it is unlikely to perform adequately for more realistic representations of uncertainty about resource dynamics. 

### Life History

Life history relationships based on ecological theory were used to condition Operating Models using the [methods](https://github.com/flr/mydas/blob/master/tasks/task4/R/FLife-OM.pdf) in the FLife package for [Brill](https://github.com/flr/mydas/blob/master/tasks/task4/R/brill.pdf), [(source)](https://github.com/flr/mydas/blob/master/tasks/task4/R/brill.Rmd); 
[Turbot](https://github.com/flr/mydas/blob/master/tasks/task4/R/turbot.pdf), [(source)](https://github.com/flr/mydas/blob/master/tasks/task4/R/turbot.Rmd); [Rays](https://github.com/flr/mydas/blob/master/tasks/task4/R/ray.pdf), [(source)](https://github.com/flr/mydas/blob/master/tasks/task4/R/ray.Rmd); 
[Sprat](https://github.com/flr/mydas/blob/master/tasks/task4/R/sprat.pdf), [(source)](https://github.com/flr/mydas/blob/master/tasks/task4/R/sprat.Rmd); [Pollack](https://github.com/flr/mydas/blob/master/tasks/task4/R/pollack.pdf), [(source)](https://github.com/flr/mydas/blob/master/tasks/task4/R/pollack.Rmd);
[Razors clams](https://github.com/flr/mydas/blob/master/tasks/task4/R/razor.pdf), [(source)](https://github.com/flr/mydas/blob/master/tasks/task4/R/razor.Rmd); and [Lobsters](https://github.com/flr/mydas/blob/master/tasks/task4/R/lobsters.pdf), [(source)](https://github.com/flr/mydas/blob/master/tasks/task4/R/lobsters.Rmd) 


### Data Rich
Take a stock assessment of a [data rich stock](https://github.com/flr/mydas/blob/master/tasks/task2/R/task2-stock-assessments.pdf) and create an Observation Error Model (OEM) that mimics the properties of a data poor dataset.

### Alternative OMs

The OMs are generic, i.e. are for a stock that was over exploited and then recovered, We will need to change these so that they are more representative of the case studies, i.e. 

+ Use the type of data i) currently available, and ii) that may be available in the future to show the benefit of data collection and scientific study.
+ Modify the exploitation history

## Observation Error Model

### Data types
+ Total catch
+ CPUE
+ Survey
+ Size data 

## Management Procedures
### Assessment Methods

The assessment methods chosen for testing, reflect a range of data and knowledge requirements, i.e. [LBSPR](https://cran.r-project.org/web/packages/LBSPR/index.html) for length compostion data, [MLZ](https://github.com/cran/MLZ) for mean size, [mpb](http://www.flr-project.org/) a biomass dynamic model for catch and survey data and catch only and [XSA](https://github.com/flr/FLXSA) for catch-at-age data.

### Knowledge requirements

Stock assessment methods commonly require choices to be made for difficult to estimate parameters, there a set of [priors and fixed](https://github.com/flr/mydas/blob/master/tasks/task4/R/priors.pdf) parameters for the methods in the google spreadsheet were generated. These include values for

+ Growth: *L<sub>infinty<sub>*, *k*, *t<sub>0<sub>*	
+ Length-weight relationship: a, b
+ Maturity: *L<sub>MAX</sub>*, *A<sub>MAX</sub>* 
+ Selectivity: *s<sub>50<sub>*, *s<sub>95<sub>*,	

+ Production function K, *B<sub>0<sub>*, r,	

+ Natural Mortality: *M*, *M/K*	
+ Reference Points: *F<sub>msy<sub>* */M*, *B<sub>msy<sub>* */K*

+ Length based reference points: *L<sub>c<sub>*, *L<sub>opt<sub>*

+ Stock recruitment relationship: Steepness *h*, *a* of Beverton and Holt

+ Recruitment variation 
+ Depletion	
+ Fecundity at age/length,

# Simulation Tests

Before running the MSE the performance of the stock assessment methods, and the reference points derived from them, are first evaluated for each case stock by performing a cross test. In the cross test the Observation Error Model is used to generate datasets from the Operating Model (OM) which are then used in the candidate stock assessment methods, i.e. the MSE framework is run without using a Management Procedure (MP) as a feedback controller. 

This allows the performance of the candidate methods to be compared, since if there is little correlation between the estimates of reference points and status from a candidate method and the OM then there is little point in running that method in the MSE. 

When running an assessment choices have to be made about initial parameter and other values, running a cross test will help in reducing the number of simulations that have to be conducted, by identifying starting values, priors and identify the range of values for parameter tuning for example in a grid search   
 
Therefore prior to running the MSE in feedback mode the various candidate assessment methods were evaluated to identify under what conditions they perform well by running the OM without feedback. The OM and OEM are used to simulate data with a variety of levels of measurement error, and prior knowledge about input parameters. The candidate assessment method are run, and then their estimates compared to the OM values.
Once the cross tests are run the MSE can be run to evaluate the MPs. 

Tests were performed for  
[VPA](https://github.com/flr/mydas/blob/master/tasks/task4/R/simtest-vpa.pdf), [Biomass dynamic](https://github.com/flr/mydas/blob/master/tasks/task4/R/simtest-bd.pdf), [Biomass dynamic configured to use only catch data](https://github.com/flr/mydas/blob/master/tasks/task4/R/simtest-bdsra.pdf) and [LBSPR](https://github.com/flr/mydas/blob/master/tasks/task4/R/simtest-lbspr.pdf)
