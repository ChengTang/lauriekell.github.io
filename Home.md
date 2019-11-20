![](emff-logo.jpg)

The **MyDas** project simulation tested a range of assessment models and methods in order to establish Maximum Sustainable Yield (MSY), or proxy MSY reference points across the spectrum of data-limited stocks. A main output of the project was the development of two R packages `mydas` and `FLife`, both are implemented as [FLR](http://www.flr-project.org/) packages with example [vignettes](https://3o2y9wugzp1kfxr5hvzgzq-on.drv.tw/MyDas/doc/html/mydas_data.html) are available. 

**MyDas** was funded by the Irish exchequer and [EMFF 2014-2020](https://ec.europa.eu/fisheries/cfp/emff_en) 

**Contact:** [Laurence Kell](<laurie@kell.es>) and [Coilin Minto](<coilin.minto@gmit.ie>) 

------------------------------

## FLR

The `mydas` package is part of [FLR](http://www.flr-project.org) family of R packages, a collection of tools for quantitative fisheries science, developed in the R language, that facilitates the construction of bio-economic simulation models of fisheries systems. 

These can be [installed](http://www.flr-project.org/#install) from the website 

```{r}
install.packages(c("FLCore","FLFishery","FLasher","FLBRP","FLife","mydas"), 
             repos="http://flr-project.org/R")
```

A range of [tutorials](https://www.flr-project.org/doc/) are also available.

The `mydas` package can be installed from this repository using `devtools` 

```{r}
install.packages("devtools",dependencies=TRUE)
```

```{r}
library(devtools)

devtools::install_github("lauriekell/mydas-pkg")
```

## Libraries

```{r}
library(plyr)
library(reshape)
library(ggplot2)
```

### FLR libraries
```{r}
library(FLCore)
library(FLasher)
library(FLBRP)
library(FLife)
library(mydas)
```

# Plotting

```{r}
library(ggplotFL)
```

Plotting is done using `ggplot2` which provides a powerful alternative paradigm for creating both simple and complex plots in R using the ideas the [Grammar of Graphics](http://dx.doi.org/10.1007/978-3-642-21551-3_13). The idea of the grammar is to specify the individual building blocks of a plot and then to combine them to create the desired [graphic](http://tutorials.iq.harvard.edu/R/Rgraphics/Rgraphics.html).

`ggplotFL` implements a number of plots for the main `FLR` objects.

The `ggplot` functions expects a `data.frame` for its first argument, `data`; then a geometric object `geom` that specifies the actual marks put on to a plot and an aesthetic that is "something you can see" have to be provided. Examples of geometic Objects (geom) include points (geom_point, for scatter plots, dot plots, etc), lines (geom_line, for time series, trend lines, etc) and boxplot (geom_boxplot, for, well, boxplots!). Aesthetic mappings are set with the aes() function and, examples include, position (i.e., on the x and y axes), color ("outside" color), fill ("inside" color), shape (of points), linetype and size. 


# Operating Model Conditioning 

### Life history parameters

Life history parameters can be loaded from the [fishnets](https:/github.com/fishnets) github repository, a library of multivariate priors for fish population dynamics parameters 
 
```{r}
load(url("https://github.com//fishnets//fishnets//blob//master//data//fishbase-web//fishbase-web.RData?raw=True"))
```

Select turbot as a case study
```{r}
lh=subset(fb,species=="Psetta maxima")

names(lh)[c(14,17)] = c("l50","a50")
lh=lh[,c("linf","k","t0","a","b","a50","l50")]

head(lh)
```

Get the means and create an `FLPar` object
```{r}
lh=apply(lh,2,mean,na.rm=T)
lh=FLPar(lh)
```

Values can be replace with any [better estimates](https://www.researchgate.net/publication/236650425_Ecological_and_economic_trade-offs_in_the_management_of_mixed_fisheries_A_case_study_of_spawning_closures_in_flatfish_fisheries) available.

Then `lhPar` fills in missing values using life history theory, while quantities like selection-at-age are set using defaults, in this case set to be the same as maturity-at-age.  


```{r}
?lhPar
```

```{r}
par=lhPar(lh)
par
```

The parameters can then be used by `lhEql` to simulate equilibrium dynamics by combining the spawner/yield per recruit relationships with a stock recruitment relationship, by creating an [`FLBRP` object](https://www.flr-project.org/doc/Reference_points_for_fisheries_management_with_FLBRP.html)

```{r}
eq=lhEql(par)

plot(eq)
```

To model time series the FLBRP object created by lhEql is coerced to an FLStock object and then [projected forward](https://www.flr-project.org/doc/Forecasting_on_the_Medium_Term_for_advice_using_FLasher.html)

For example a fishing time series is simulated that represents a stock that was originally lightly exploited, then effort is increased until the stock is overfished and then fishing pressure was reduced to recover the stock biomass to $B_{MSY}$.

```{r}
fbar(eq)=refpts(eq)["msy","harvest"]%*%FLQuant(c(rep(.1,19),
                                              seq(.1,2,length.out = 30),
                                              seq(2,1.0,length.out = 10),
                                              rep(1.0,61)))[,1:105]
plot(fbar(eq))
```
Coercing the FLBRP object into an FLStock

```{r}
om=as(eq,"FLStock")
```
We can simply plot the forward F projection catch, recruitment and biomass estimates etc..
We call fwd() with the stock, the control object (fbar) and the stock recruitment relationship, and look at the results

```{r}
om=fwd(om,fbar=fbar(om)[,-1], sr=eq)
```

can add units 
```{r}
units(catch(om)) = units(discards(om)) = units(landings(om)) = units(stock(om)) = 'tonnes'
units(catch.n(om)) = units(discards.n(om)) = units(landings.n(om)) = units(stock.n(om)) = '1000'
units(catch.wt(om)) = units(discards.wt(om)) = units(landings.wt(om)) = units(stock.wt(om)) = 'kg'

plot(om)
```

### Stochasticity 
To add recruitment variability into add the residuals argument, e.g. for 100 Monte Carlo simulations with a CV of 0.3  
```{r}
nits=100
srDev=rlnoise(nits, rec(om) %=% 0, 0.3)

om=propagate(om,nits)

om=fwd(om,fbar=fbar(om)[,-1], sr=eq, residuals=srDev)
```

```{r}
plot(om)
```


------------------------------