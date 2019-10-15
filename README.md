# 2019-ACS1year
R scripts for pulling ACS 1year data using tidycensus package

## Scripts:
ACS1yr_income: Median household income for all households, plus each racial/ethnic groups, and one-person and four-person households; Median earnings for workers age 16 and older broken down for all workers, male workers and female workers. Geographies: all states; Minnesota counties; US and all metros

ACS1yr_diversity: This gets data for various geographies from the B03002 table, race by hispanic ethnicity. It also gets data from a table that breaks down race/ethnicity by age (a series of tables that start with B01001). 

ACS1yr_employ: Table B23001 - Sex by age by employment status. This retrieves all the variables from that table, for all states and the US. The analysis looks at employment among various age groups, particularly the over 65 and the people (especially women) who are in prime parenthood years.

ACS1yr_inequality: Pulls gini index numbers for all states and the US and spits out a csv file. Didn't have time to build tables or charts.

ACS1yr_mobility: Geographical mobility in the past year. Indicates how many people moved, either within the same county, from another county in the same state, from another state or from abroad within the previous year. Data for state of MN and all metro areas.

ACS1yr_housing: Homeownership rates for all and for racial groups in the Twin Cities (I've collapsed the 7 metro counties into one); Also includes the average percent of income spent on rental housing costs. (FYI: I tried to use formattable's percent() function in this page and could only get it to work on one of the tables)
