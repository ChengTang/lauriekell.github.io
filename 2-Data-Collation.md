The project relies on existing datasets (e.g. commercial, survey, biological, stock assessment and economic) which  need to be collated in a usable form. Most of these datasets are available from the Marine Institute, or are publicly available, but others may only exist in other European labs/agencies.    

Commercial data are the main source of landings and catch data, while surveys provide indices of trends used in the stock assessments. The commercial and survey datasets also include biological data on growth, age and fecundity. These data may be used in age and length based assessments and to estimate quantities such as population growth rate (***r***) used in productivity analyses.
 
## Database

The data are in a standard query language (SQL) relational database accessible via the web and R. This provides a flexible platform for the analyses of fisheries and biological data as well as other data variables. There are currently 7 tables including lookup tables e.g. converting ICES rectangles to ICES areas.  

The data are the most comprehensive European commercial landings and effort data available, obtained from JRC/STECF.  There is also a comprehensive table with details on surveys for stocks of interest. The commercial and survey will be updated as new data become available.

These data will be used to parameterise the assessment models, condition OMs and OEMs.

In addition the results from the MSE will be stored in the database and will be able to be queried using a shiny-app. 

### Datasets
[Commercial](      https://github.com/flr/mydas/wiki/2.1-Commercial)

[Surveys](         https://github.com/flr/mydas/wiki/2.2-Survey)

[Life history](    https://github.com/flr/mydas/wiki/2.3-Biological)

[Stock Assessment](https://github.com/flr/mydas/wiki/2.4-Assessment)

[Economic](        https://github.com/flr/mydas/wiki/2.5-Economic)

## Shiny application

shiny application, user: mydas, pwd:gmit1