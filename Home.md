![](emff-logo.jpg)

The **MyDas** project simulation tested a range of assessment models and methods in order to establish Maximum Sustainable Yield (MSY), or proxy MSY reference points across the spectrum of data-limited stocks.  

Models are implemented as [FLR](http://www.flr-project.org/) packages and there are a variety of [vignettes](https://github.com/flr/mydas/wiki/mydas_vignettes) with examples, and datasets can be downloaded from [google drive](https://drive.google.com/open?id=1WfthxhdBgZfPg_lrUkpKzwRQHe61RBgK)

**MyDas** was funded by the Irish exchequer and [EMFF 2014-2020](https://ec.europa.eu/fisheries/cfp/emff_en) 

**Contact:** [Laurence Kell](<laurie@kell.es>) and [Coilin Minto](<coilin.minto@gmit.ie>) 

------------------------------

To use `mydas` you will have to install a number of packages, either from CRAN or from [FLR](http://www.flr-project.org) where variety of packages and [tutorials](https://www.flr-project.org/doc/) are available.

Install FLR 
```{r}
install.packages(c("FLCore","FLFishery","FLasher","FLBRP","mpb","FLife"), 
             repos="http://flr-project.org/R")
```

If you want to install the development code then `devtools` needs to be installed and then loaded so that the `mydas` package can be installed from this GitHub repository.

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

------------------------------