The overall aim of the MyDas project was to develop and test a range of assessment models and methods to establish Maximum Sustainable Yield (MSY), or proxy MSY reference points across the spectrum of data-limited stocks.   

The methods are written using **R** and making use of the [FLR suite of packages](http://www.flr-project.org/)

## INSTALL

```{r}
library(devtools)

install.packages(c("FLCore","FLFishery","FLasher","FLBRP","mpb","FLife"), repos="http://flr-project.org/R")
devtools::install_github(c("flr/FLCore", "flr/FLFishery", "flr/mpb", "flr/kobe", "flr/diags"))
devtools::install_github("laurieKell/mydas", subdir="pkgs/mydas")
```

# Quick Start

## Load Libraries
```{r}
library(plyr)
library(reshape)
library(ggplot2)

library(FLCore)
library(FLasher)
library(FLBRP)

library(FLife)
library(mydas)
```

## Operating Model Conditioning
Load fishbase database
```{r}
load(url("https://github.com//fishnets//fishnets//blob//master//data//fishbase-web//fishbase-web.RData?raw=True"))
```

Get data for turbot
```{r}
lh=subset(fb,species=="Psetta maxima")

names(lh)[c(14,17)] = c("l50","a50")
lh=lh[,c("linf","k","t0","a","b","a50","l50")]

head(lh)
```

The life history parameters are used to derive the parameters for natural mortality-at-age, based on Gislason et
al. (2008), and default parameters and relationships for selection pattern and stock recruitment.

First create an FLPar object
```{r}
lh=as(lh,"FLPar")

par
```
and then fill in missing values
```
par=lhPar(lh)

par
```

The parameters are then used by lhEql to simulate the equilibrium dynamics by combining the spawner/yield
per recruit relationships with a stock recruitment relationship.
```{r}
eq = lhEql(par)
plot(eq)
```

Dynamics, i.e. a forward projection.
To go from equilibrium to time series dynamics the FLBRP object created by lhEql can be coerced to an
FLStock object.
First change the F time series so that it represents a time series where the stock was origionally lightly
exploited, F increased until the stock was overfished and then fishing pressure was reduced to ensure spawning
stock biomass was greater than BMSY.
```{r}
library(FLasher)

eq@fbar = refpts(eq)["msy","harvest"]%*%FLQuant(c(rep(.1,19),
                                              seq(.1,2,length.out = 30),
                                              seq(2,1.0,length.out = 10),
                                              rep(1.0,61)))[,1:105]

om = as(eq,"FLStock")

om = fwd(om,fbar = fbar(om)[,-1], sr = eq)
```

```{r}
plot(om)
```

## Model Based MP
In this example the MP is based on an Virtual Population Analysis (VPA). First the control settings are checked by running FLXSA on data simulated by the OM without error and feedback. Ideally there should be no bias in the estimates from the stock assessment.
```{r}
library(FLXSA)
library(mydas)
xsa = function(om,pg = 10,ctrl = xsaControl){
  stk = setPlusGroup(om,pg)
  idx = FLIndex(index=stock.n(stk))
  range(idx)[c("plusgroup","startf","endf")] = c(pg,0.1,.2)
  stk + FLXSA(stk, idx, control = ctrl, diag.flag = FALSE)
}
```
Calculate fbar on mature part of stock.
```{r}
range(om)[c("minfbar","maxfbar")] = ceiling(mean(lh["a50"]))
range(eq)[c("minfbar","maxfbar")] = ceiling(mean(lh["a50"]))
```
### OM
```{r}
om = window(om, start = 25)
om = iter(om,1:1)
eq = iter(eq,1:1)
```

Before running the MSE, i.e. using XSA as part of a feedback control procedure, the current reference points
need to be estimated. XSA control object (below)
```{r}
xsaControl = FLXSA.control(tol    =1e-09, maxit   =150, 
                         min.nse=0.3,   fse     =1.0, 
                         rage   =1,     qage    =3, 
                         shk.n  =TRUE,  shk.f   =TRUE, 
                         shk.yrs=1,     shk.ages=4, 
                         window =10,    tsrange =10, 
                         tspower= 0,
                         vpa    =FALSE)


mp = xsa(window(om,start = 25, end = 75), ctrl = xsaControl,pg = 10)

plot(FLStocks(list("xsa"= mp,"om" = om)))
```
```{r}
nits = dim(mp)[6]
set.seed(4321)
```
To simulation random variation in the time series, deviations around the stock recruitment relationship was
modelled as a random variable.
```{r}
srDev = FLife:::rlnoise(nits,rec(    om)[,,,,,1] %=% 0, 0.3, b = 0.0)
```
While to generate data for use in the MP, random measurement error was added to the simulated catch per
unit effort (CPUE).
```{r}
uDev = FLife:::rlnoise(nits,stock.n(om)[,,,,,1] %=% 0, 0.2, b = 0.0)
```
Then the MSE can be run using the mseXSA function.
```{r}
mseXSA=mydas:::mseXSA

mse1=mseXSA(om,
            eq,
            mp,control = xsaControl,
            ftar = 1.0,
            interval = 1,start = 54,end = 80,
            srDev = srDev, uDev = uDev)
```
## Model-free MP
A derivative control rule is derived from adjusting the trends in the signal. i.e to the derivative of the error. Where
k1 = decrease level when stock declines, k2 = sets stock increase level when stock increases. Gamma = additional decrease control.

```{r}
### Stochasticity
library(popbio)
nits = 100
set.seed(1234)
srDev = FLife:::rlnoise(nits,FLQuant(0, dimnames = list(year = 1:100)), 0.2, b = 0.0)

### OEM
uDev = FLife:::rlnoise(nits, FLQuant(0, dimnames = list(year = 1:100)), 0.3, b  = 0.0)

## MSE for Derivative empirical MP

om=iter(om,1)
eq=iter(eq,1)
  
res=mydas:::mseSBTD(om,eq, 
                    control=FLPar(c(k1=0.5,k2=0.5,gamma=1)),
              start=60, end=100, srDev=srDev, uDev=uDev)

empD = rbind(empD, 
 cbind(scen=i,stock=scen[i,"stock"],
 k1 = scen[i,"k1"], k2 = scen[i,"k2"], 
 gamma = scen[i,"gamma"], 
 mydas:::omSmry(res, eq, lh)))
}
```
## MPB MP
In mpb there is a biomass dynamic stock assessment, designed to be used as an MP.
First the control object has to be set, i.e. setting best guess, bounds and any priors for parameters.
```{r}
om=window(om,start=20,end=90)
setMP=mpb:::setMP

growth = vonB

prior = FLife:::priors(lh,eq)
```
Biodyn implements a Pella-Tomlinson production function using ADMB. Starting values for the parameters are required. The defaults assume that r is 0.5, the production function is symmetric (i.e. p=1) and the b0 ratio of the initial biomass to k is 1. MSY should be the same order of magnitude as the catch and so carry capacity (k) can be calculated if a guess for r is provided. 
```{r}
mp=setMP(as(window(om,end=54),"biodyn"),
         r =median(prior["r"],na.rm=T),
         k =median(prior["v"],na.rm=T),
         b0=0.8,
         p =median(mpb:::p(prior["bmsy"]/prior["v"]),na.rm=TRUE))

nits=dims(mp)$iter
set.seed(1234)

 srDev=FLife:::rlnoise(nits,FLQuant(0,dimnames=list(year=1:100)),0.3,b=0.0)
 uDev=FLife:::rlnoise(nits,FLQuant(0,dimnames=list(year=1:100)),0.2,b=0.0)


eq=FLCore:::iter(eq,seq(nits))

mse=mydas:::mseMPB(om,eq,mp,start=54,ftar=0.5,srDev=srDev,uDev=uDev)
```


# Supplementary Material

[equations](https://github.com/flr/equations/blob/master/tex/mp.pdf)

# References 

# Acknowledgements