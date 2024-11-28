********************************************************************************
* name: Nardeen Abdulkareem (500867209)
* ECN 620 Applied Economic Analysis
* Assignment 3
********************************************************************************

*---------------------------------------------------------------------------*
*				 			DO FILES ASSIGNMENT 3
*--------------------------------------------------------------------------*

**Make sure there is nothing in stata
clear // Clear everything in memory 
set more off // Tired of stat prompting you to press more, use this command at the beginning of your code. It tells Stata not to pause or display a --more-- message


**Set Your Global Directory here: 


	global rawdata = "C:\Users\nardeen.abdulkareem\Desktop\Assignment 3\rawdata"		
	global predata = "C:\Users\nardeen.abdulkareem\Desktop\Assignment 3\predata"		

	
**Set Default Directory: 


	cd "$rawdata"

	
/*
*****Exercise 1: Panel Data Models ****
There is a large literature on the rentier states theory and the resource curse. The theory states that rentier capitalism can be a curse on the systemic level. States that extract rents from easily lootable resources instead of taxing their people develop institutions that become unresponsive to their citizens and provide less public goods. In this exercise you will use panel data model to test this theory. This exercise makes use of the datatset Panel_data.csv which contains a balanced panel of data from 59 countries worldwide for the years 1996 through 2010. A detailed description is given in Assignment3.pdf, available on the course website. Load the dataset on Stata and answer the following questions. 
*/

**Load the data 


	import delimited "Panel_data.csv", clear 


* Q1. Data cleaning: The variables oil, gdpcapita, aid, polity2, and mortality are coded as factor variables but they should be numeric. 
	* a) convert these variables to numeric variables.  (Hint: Note that for some variables missing values are coded as ".." or "NA" change the value of the missing into "." and use the Stata command destring) 
	
	
		**Your Answer:
		
		
	destring	oil gdpcapita aid polity2 mortality, replace ignore(".. NA")

	
	* b) Log-transform varibales gdp per capita and population size 

	
		**Your Answer:
		
		
	generate	log_gdppc = log(gdpcapita)
	generate	log_pop = log(population)


* Q2. This question has 3 parts:
 
	* a) Estimate (i) a regression of quality of institutions against oil rents and (ii) a regression of quality of institutions against oil rents, aid flow, log of gdp per capita, polity2, log of population and mortality 

	
		**Your Answer: I would cluster or make the stadard errors robust here but I noticed it asks for it later!
		

		regress		institutions oil
		regress		institutions oil aid log_gdppc polity2 log_pop mortality


	* b) Interpret the coefficient on oil rents in regression (ii). Does adding control variables in regression (ii) change the estimated effect of oil rents as measured by statistical significance?

	
		**Your Answer: Oil rents in the second regression above do not seem to be influencial is predicting the quality of institutions. Adding the control variables may give us a move accurate coefficient for oil rents which is likely due to omitted variable bias. However, although we see that the statisitical significance drops (p value increases from 0.458 to 0.583) when we add controls, it is quite unimportant since p values as high as 0.458 indicate that it is extreme unlikely that the value of the coefficient on oil is different from zero. We cannot reject the null hypothesis that beta 1 is equal to 0.
		
	
	* c) Suggest a variable that varies across countries but plausibly varies little—or not at all—over time and that could cause omitted variable bias in regression (ii). 

	
		**Your Answer: Polity, it stays the same for quite a long time in most countries but it can be radically different across countries. It can also truly influence the quality of the institutions depending on if the political institution enable an extractive or inclusive socio-political enviroment.

		
* Q3. Repeat the analysis in regression (ii) but add country fixed effects. Do this using the dummy variable approach. Do the results change when you add country fixed  effects (compare to regression (ii))? If so, which set of regression results is more credible, and why?


		**Your Answer: I chose to ommit dummy 68 which corresponds with Uganada to avoid perfect multicolinearity. I chose Uganda because they have missing data on oil rents. The results do change since the coefficient on polity2 declines with the addition of country fixed effects however it stays equally significance in predicting institutional quality. The fixed effects regression is more credible since it removes the variation and source of bias that comes from across countries (country-invariate) that, in this case, are not variable across time. It add information that tells us the effect of the indepedant variable on the dependant variable within each country. This is benefitial since it gives us a more causal interpretation of the polity coefficient but also makes it more difficult to make generalized statement across different groups. Essentially we remove OVB as a result of variables that varry across countries but plausibly varies little—or not at all—over time.


		tabulate 	country, generate(c_dummy)
		regress		institutions oil aid log_gdppc polity2 log_pop mortality c_dummy1-c_dummy67 c_dummy69-c_dummy73


* Q4. Add year fixed effects to the regression in question 3, again using the dummy variables approach [Note: Do not use robust or cluster standard errors.] Do the results change when you add time fixed effects? If so, which set of regression results is more credible, and why?

		**Your Answer: I decided to drop the year 1996 to avoid perfect multicolinearity or the dummy variable trap. This further reduces the bias, because when we add year fixed effects we are essentially also controlling for factors that are contant across countries but varry across time. This gives us more accurate coefficient for how variables like how population or mortality influence establishment quality. This is because a variable such as mortality can be heavily influence by disease and war in a region. When we take time fixed effects we are able to segregate the influence that time has on the coefficient of interest away into the dummy variables. Time ijnvariant shocks are controlled for and no longer bias our variables; therefore we can have a less biased, more credible, and accurate estimator of our variables of interest with year fixed effects. 

		
		tabulate 	year, generate(y_dummy)
		regress		institutions oil aid log_gdppc polity2 log_pop mortality c_dummy1-c_dummy67 c_dummy69-c_dummy73 y_dummy2-y_dummy12

		
* Q5. Replicate the analysis in Question 4 using Stata's xtreg command with standard errors clustered at the country level. Do the results change when using clustered standard error (compare to question 4)? Why?


		**Your Answer: When we use xtreg the value of the coefficients are unchanged since it is the same regressions as question 4 even when we add the time fixed effects. The only difference here is that we are clustering the standard errors by country. This generally increases the standard errors since they are now heteroskedastically and autocorrelatedly robust standard errors that account for the repeated nature of variables in a panel data set and heteroskedasticity. LIkewise, the differences we observe before and after introducing the year fixed effects are the same! And, again the only difference is observed in the statistical significance of our variables since the standard errors increase and the t statistic decreases across the board. 

		
		encode	country, gen(country_num)
		
		xtset	country_num
		xtreg 	institutions oil aid log_gdppc polity2 log_pop mortality, fe vce(cluster country_num)

		xtset 	country_num year
		xtreg 	institutions oil aid log_gdppc polity2 log_pop mortality i.year, fe vce(cluster country_num)
		
		
* Q6. Run a first difference regression of the change in the quality of institutions between 1996 and 2010 on the change in oil rents between 1996 and 2010 (Hint: You should first convert your data from wide to long format as we did in the empirical exercise in module 8)


		**Your Answer: This also reduces bias by controlling for the time invariant unobserved factors. The effect is negative but small in magnitude and statisitical significance. Yet, it is by far the most statistically significance estimate of establishment on oil rents that we have obtained so far. 

		
		keep 		if year == 1996 | year == 2010
		keep		country_num year oil institutions
		reshape		wide institutions oil, i(country_num) j(year)
		generate	diff_inst = institutions2010 - institutions1996
		generate	diff_oil = oil2010 - oil1996
		reg			diff_inst diff_oil
		
		
/*
*****Exercise 2: Instrumental Variables ****
In this exercise you will use IV to explore how the number of children affects the labor supply of parents. This exercise is based on Josh Angrist and Bill Evans' paper called "Children and Their Parents' Labor Supply: Evidence from Exogenous Variation in Family Size.". This exercise uses the instrumental_variable.dta which is a cross-section data from the 1980 US Census on married women aged 21–35 with two or more children. The main variables are described in the Assignment3.pdf. In this exercise, you should always use robust standard errors in your regression analysis unless otherwise specified
*/



* Q1. 
	* a) Run an OLS regression to estimate the effect of having more than two children on weeks worked by mothers, controlling for if the first and second children were boys, indicators for race/ethnicity of the mother. 

	
		**Your Answer:
		
		
		clear 	all
		use 	Instrumental_Variable, clear
		
		reg		work morekids gender1 gender2 black hispanic other, robust

		
	* b) Interpret the coefficient on having more than two children. 
		
		
		**Your Answer: Having more than two children reduces the number of working weeks of a married mother by an average of 5.6 weeks. This coefficient is large in magnitude and statsitically significant even at the 1% significance level!

		
	* c) Do you think that this analysis provides an unbiased estimate of the causal effect of having more than two children on mother's labor supply? Explain. Provide an example of omitted variables that is likely to cause bias in the results  
		
		
		**Your Answer: I do not think that this analysis provides an unbiased and causal effect of having more than two children on mother's labor supply, but it can hint us towards the right direction. There could be sample selection bias since this is data on married women only, who tend to have more support when it comes to raising their children. In addition, we could add more variables to this regression such as age, education level, health, partners income, age of children, a culture variable, government policies such as maternity leave, and distance to a city to name a few which are all sources of OVB. 
		
		
** To avoid the endogeneity issue of total number of children, Angrist and Evans instrument for whether families have three or more children using whether or not the first two children were of the same sex (instrument1). The hypothesis is that both children being of the same sex is a relevant predictor of having one or more additional children because parents are often thought to have preferences for child gender or gender mix.  If parents want a  girl and they have only had boys, they may be more likely to have an additional  child. To the extent that these preferences do exist, then having the first two children from the same sex should be a relevant predictor of having 3 or more children. The argument for exogeneity of the instrument is that birth gender itself is  already as good as random, hence having two children of the same sex should  also be as good as random.  Since birth gender is random, only a couple of  possibilities would seem to pose a potential problem to instrument exogeniety. 
* You will now use this instrument to estimate the 2SLS effect of having more children on weeks worked. 

* Q2. First, generate the 2SLS estimates manually using the multivariate specification including controls from question 2. (Hint: That is, estimate the first stage regression and generate predicted values of having more than two children. Then use the predicted values in the second stage regression to estimate the effect of having more than two children on weeks worked by mothers.)


		**Your Answer: We can now observe that a married mother works on average 6.02 fewer weeks when she has more than two children. This effect is large in magnitude and statistically significant at the 1% significance level!
		
		
		reg			morekids instrument1 gender1 gender2 black hispanic other
		predict 	X_hat
		rename		X_hat fitted_morekids
		regress		work fitted_morekids gender1 gender2 black hispanic other
		regress		work fitted_morekids gender1 gender2 black hispanic other, robust


* Q3. Generate the 2SLS estimate again but this time using the ivreg2 command. How do the estimates change between OLS and IV? And the standard errors?


		**Your Answer: Notice how we used both normal SE and Robust SE for questions 2 and 3, notably, it is likely that we do not need heteroskedastically robust SE here since the distribution of standard errors at each x variable seems homoskedastic (the change in SE when use robust is negligible). The main difference between the regressions in Q2 and Q3 is that doing 2SLS manually yields inaccurate values for the standard errors. However, the estimates remain the same between the two methods (manual and ivreg2)


		ssc 		install ivreg2
		ssc 		install ranktest

		ivreg2		work gender1 gender2 black hispanic other (morekids = instrument1)
		ivreg2		work gender1 gender2 black hispanic other (morekids = instrument1), robust
	
		
* Q4. Evaluate the instrument relevance and weakness using the ivreg2 output. Can the test of overidentifying restrictions tell us anything about the instrument exogeneity in this case? 


		**Your Answer: Firstly, since we have exact identification where the number of instruments equals the number of endogenous variables, we cannot use the overidentification test. Therefore, the test of overidentifying restrictions does not tell us anything about the instruments exogeneity. Further, we can test the instuments relevance using the F-test for the excluded instruments or first stage F-test. The first stage F test is 1270 which is significantly larger than 10, indicating that we do not have weak instrument problem and we have a relevant instrument.

