## ------------------------------------------------------------------------
library(devtools)

install.packages(c("FLCore","FLFishery","FLasher","FLBRP","mpb","FLife"), repos="http://flr-project.org/R")
devtools::install_github(c("flr/FLCore", "flr/FLFishery", "flr/mpb", "flr/kobe", "flr/diags"))
devtools::install_github("flr/mydas", subdir="pkgs/mydas")

## ------------------------------------------------------------------------

library(plyr)
library(FLife)
library(FLBRP)

load(url("https://github.com//fishnets//fishnets//blob//master//data//fishbase-web//fishbase-web.RData?raw=True"))

## ------------------------------------------------------------------------
lh = subset(fb,species == "Psetta maxima")

names(lh)[c(14:17)] = c("l50","l50min","l50max","a50")
lh = lh[,c("species","linf","k","t0","a","b","a50","l50","l50min","l50max")]

lh = apply(lh[,-1],2, mean, na.rm = T)

## ------------------------------------------------------------------------
lh = FLPar(lh)

## ------------------------------------------------------------------------
eq = lhEql(par)
plot(eq)

## ------------------------------------------------------------------------
library(FLasher)
gTime = round(FLife:::genTime(FLPar(par)))

eq@fbar = refpts(eq)["msy","harvest"]%*%FLQuant(c(rep(.1,19),
                                              seq(.1,2,length.out = 30),
                                              seq(2,1.0,length.out = gTime)[-1],
                                              rep(1.0,61)))[,1:105]

om = as(eq,"FLStock")

om = fwd(om,fbar = fbar(om)[,-1], sr = eq)

## ------------------------------------------------------------------------
plot(om)

## ------------------------------------------------------------------------
library(FLXSA)
library(mydas)
xsa = function(om,pg = 10,ctrl = xsaControl){
  stk = setPlusGroup(om,pg)
  idx = FLIndex(index=stock.n(stk))
  range(idx)[c("plusgroup","startf","endf")] = c(pg,0.1,.2)
  stk + FLXSA(stk, idx, control = ctrl, diag.flag = FALSE)
}

## ------------------------------------------------------------------------
range(om)[c("minfbar","maxfbar")] = ceiling(mean(lh["a50"]))
range(eq)[c("minfbar","maxfbar")] = ceiling(mean(lh["a50"]))

## ------------------------------------------------------------------------
om = window(om, start = 25)
om = iter(om,1:1)
eq = iter(eq,1:1)

## ------------------------------------------------------------------------
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

## ------------------------------------------------------------------------
nits = dim(mp)[6]
set.seed(4321)

## ------------------------------------------------------------------------
srDev = FLife:::rlnoise(nits,rec(    om)[,,,,,1] %=% 0, 0.3, b = 0.0)

## ------------------------------------------------------------------------
uDev = FLife:::rlnoise(nits,stock.n(om)[,,,,,1] %=% 0, 0.2, b = 0.0)

## ------------------------------------------------------------------------
mseXSA=mydas:::mseXSA

mse1=mseXSA(om,
            eq,
            mp,control = xsaControl,
            ftar = 1.0,
            interval = 1,start = 54,end = 80,
            srDev = srDev, uDev = uDev)

## ------------------------------------------------------------------------
### Stochasticity
library(popbio)
nits = 1
set.seed(1234)
srDev = FLife:::rlnoise(nits,FLQuant(0, dimnames = list(year = 1:100)), 0.2, b = 0.0)

### OEM
uDev = FLife:::rlnoise(nits, FLQuant(0, dimnames = list(year = 1:100)), 0.3, b  = 0.0)

## MSE for Derivative empirical MP
scen = expand.grid(stock = c("turbot")[1],
                 k1 = seq(0.2,0.8,0.2),k2 = seq(0.2,0.8,0.2), gamma = seq(0.75,1.25,0.25),
                 stringsAsFactors = FALSE)
library(reshape)
empD=NULL
for (i in seq(dim(scen)[1])){
  
  om=iter(om,seq(nits))
  eq=iter(eq,seq(nits))
  lh=iter(lh,seq(nits))
  
res = mydas:::mseSBTD(om,eq, control = with(scen[i,],
     c(k1 = k1, k2 = k2, gamma = gamma)),
     start = 60, end = 100, srDev = srDev, uDev = uDev)

empD = rbind(empD, 
 cbind(scen=i,stock=scen[i,"stock"],
 k1r = scen[i,"k1"], k2 = scen[i,"k2"], 
 gamma = scen[i,"gamma"], 
 mydas:::omSmry(res, eq, lh)))
}

## ------------------------------------------------------------------------
om=window(om,start=20,end=90)
setMP=mpb:::setMP

growth = vonB

prior = FLife:::priors(lh,eq)

## ------------------------------------------------------------------------
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

## ---- echo=FALSE---------------------------------------------------------
options(scipen = 999)

library(DBI)
library(RPostgreSQL)
drv  = dbDriver("PostgreSQL")

con  = dbConnect(drv, host = 'postgresql-seascope.csffkpr9jjjn.eu-west-2.rds.amazonaws.com',
                 dbname='FLRout',
                 port = 5432,
                 user = 'MydasApplication',
                 password = 'gmit2017!')
mpb  = dbGetQuery(con1, paste("select* from mpb where spp = 'turbot' and year < 94"))

ss_labels = c("0.7"="Ftar=0.7", "1"="Ftar=1")
ggplot(mpb, aes(as.factor(year), ssb/msy_ssb,fill=as.factor(btrig)))+
      geom_boxplot(outlier.size=0.1, position=position_dodge(1),width=0.8, lwd=0.05, notch=TRUE)+
      stat_summary(fun.y=mean, geom="line", aes(group=1))+
      geom_hline(aes(yintercept=1), size=0.75, colour= "red", linetype="dashed")+ 
      facet_wrap(~ftar,ncol=1, labeller = labeller(ftar = ss_labels),scale="free_y") + theme_bw() +
      theme(panel.grid.major = element_blank(),
      text = element_text(size=14),
      panel.grid.minor = element_blank(),
      strip.background = element_blank(),
      panel.border = element_rect(colour = "black"),
      legend.position="bottom") + 
      scale_colour_manual(values=c("white", "#56B4E9"), labels=c("0.5","0.6"))  + 
      scale_fill_manual(name=expression(B[trig]),values=c("white", "#56B4E9"), labels=c("0.5","0.6")) + 
      scale_x_discrete(breaks = c(50,60,70,80,90))+
      scale_y_continuous(breaks = c(0:5))+
      xlab("year")+ylab(expression(B/B[MSY]))

ggplot(mpb, aes(as.factor(year), catch/msy_yield,fill=as.factor(btrig)))+
      geom_boxplot(outlier.size=0.1, position=position_dodge(1),width=0.8, lwd=0.05, notch=TRUE)+
      stat_summary(fun.y=mean, geom="line", aes(group=1))+
      geom_hline(aes(yintercept=1), size=0.75, colour= "red", linetype="dashed")+ 
      facet_wrap(~ftar,ncol=1, labeller = labeller(ftar = ss_labels),scale="free_y") + theme_bw() +
      theme(panel.grid.major = element_blank(),
      text = element_text(size=14),
      panel.grid.minor = element_blank(),
      strip.background = element_blank(),
      panel.border = element_rect(colour = "black"),
      legend.position="bottom") + 
      scale_colour_manual(values=c("white", "#56B4E9"), labels=c("0.5","0.6"))  + 
      scale_fill_manual(name=expression(B[trig]),values=c("white", "#56B4E9"), labels=c("0.5","0.6")) + 
      scale_x_discrete(breaks = c(50,60,70,80,90))+
      scale_y_continuous(breaks = c(0:5))+
      xlab("year")+ylab(expression(catch/catch[MSY]))

ggplot(mpb,aes(as.factor(year), fbar/msy_harvest,fill=as.factor(btrig)))+
      geom_boxplot(outlier.size=0.1, position=position_dodge(1),width=0.8, lwd=0.05, notch=TRUE)+
      stat_summary(fun.y=mean, geom="line", aes(group=1))+
      geom_hline(aes(yintercept=1), size=0.75, colour= "red", linetype="dashed")+ 
      facet_wrap(~ftar,ncol=1, labeller = labeller(ftar = ss_labels),scale="free_y") + theme_bw() +
      theme(panel.grid.major = element_blank(),
      text = element_text(size=14),
      panel.grid.minor = element_blank(),
      strip.background = element_blank(),
      panel.border = element_rect(colour = "black"),
      legend.position="bottom") + 
      scale_colour_manual(values=c("white", "#56B4E9"), labels=c("0.5","0.6"))  + 
      scale_fill_manual(name=expression(B[trig]),values=c("white", "#56B4E9"), labels=c("0.5","0.6")) + 
      scale_x_discrete(breaks = c(50,60,70,80,90))+
      scale_y_continuous(breaks = c(0:5))+
      xlab("year")+ylab(expression(f/f[MSY]))



## ------------------------------------------------------------------------
library(FLCore)
library(FLasher)
library(FLBRP)
library(mydas)

library(doParallel)
library(foreach)

library(googledrive)

fls=drive_find()
drive_download("ray.RData",path="ray.RData")
load("ray.RData")

### Stochasticity
nits=dim(om)[6]
set.seed(1234)
srDev=FLife:::rlnoise(nits,FLQuant(0,dimnames=list(year=1:100)),0.2,b=0.0)

### OEM
uDev =FLife:::rlnoise(nits,FLQuant(0,dimnames=list(year=1:100)),0.3,b=0.0)

## MSE for Derivate empirical MP
scen=expand.grid(k1=seq(0.2,1.0,0.8),k2=seq(0.2,1.0,0.8),gamma=seq(1,2),
                 stringsAsFactors=FALSE)

registerDoParallel(4)
mseSBTD=mydas:::mseSBTD
empD<-foreach(i=(seq(dim(scen)[1])), 
              .combine=rbind,
              .multicombine=TRUE,
              .packages=c("FLCore","FLasher","FLBRP","FLife","plyr","reshape")) %dopar%{
                
               omRes=mseSBTD(om,eq,control=with(scen[i,],c(k1=k1,k2=k2,gamma=gamma)),start=60,end=100,
                             srDev=srDev,uDev=uDev)

               res  =cbind(scen=i,k1=scen[i,"k1"],k2=scen[i,"k2"],gamma=scen[i,"gamma"],
                            omSmry(omRes,eq,lh))
                
               res}

dbWriteTable(con1, "empd", empD, append=!TRUE, overwrite=TRUE)

