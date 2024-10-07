//********************************************************************************
**Assignment 1 - ECN 620 Applied Economic Analysis

* Name of Group Member 1: Nardeen Abdulkareem (500867209)
* Name of Group Member 2: 
* Name of Group Member 3: 
* Name of Group Member 4: 
* Name of Group Member 5: 

**Read Instructions in the PDF posted on Brightspace
** Write your code and long answers in this do file. make sure to type your long answers as comments 
//********************************************************************************

*---------------------------------------------------------------------------*
*	TYPE YOUR CODE AND ADD YOUR ANSWERS IN THE CORRESPONDING SPACE BELOW
*--------------------------------------------------------------------------*

//PRELIMINARIES
**Make sure there is nothing in stata



			clear 
			set more off 




**Set Your Global Directory here: 



			global raw_data 		= "C:\Users\nardeen.abdulkareem\Desktop\A1\1_raw_data"	
			global clean_data 	= "C:\Users\nardeen.abdulkareem\Desktop\A1\2_clean_data"
			global output 		= "C:\Users\nardeen.abdulkareem\Desktop\A1\3_output"	




**Set Your Default Directory here: 



			cd "$raw_data"



*****PART 1: BASIC DATA MANAGEMENT****

**Q1 Load the dataset A1_Data1.dta and add observations from the A1_Data2.dta dataset (Hint: use append). Export and save the combined dataset as a csv file: A1_merge_data.csv (use comma-separated format) 




		// since our data is all a .do file we can use the the use function to load both of the data sets
			use 				"A1_Data1.dta", clear

		// next we append data2 onto the fist data set so that we have one larger consolidated dataset
			append using 		"A1_Data1.dta"

		// saving the combined dataset as a csv file (comma seperated format). I perfer using the dta file
			export delimited 	"A1_Data_combined.csv", replace
			clear
	 
	 
 
 
**Q2 Load the file A1_merge_data.csv in stata and write a code to answer Q3-Q12 below: 




		// importing delimited file
			import delimited "A1_Data_combined.csv", clear 




**Q3 Clean the sample by removing observations with missing information in the variable wage. Generate a variable indicating the unique id for each worker. Name this variable worker_id and add the following label "unique worker id"




		// first we drop all the missing observations where the variable wage is missing data/information
			drop 	if missing(wage)
				// turns out that there are no missing observation in the wage variable

		// now we can add a unique worker id for wach worker in our data set
			gen 	worker_id = _n
			order 	worker_id

		// labeling the variable worker_id
			label 	variable worker_id "unique worker id"
			
		// saving as a dta
			save 	"$clean_data/clean_data_1.dta", replace




**Q4 How many observations are in the sample? What is the mean wage in the sample? What is the the minimum wage? (2 digits)




    *Sample size 	= 	1670
    *Mean wage		= 	977.0599
    *Min			= 	115




	// Code Section:
		// first we count the number of observations in the whole sample
			count						
				// we attain a value of 1670 for the number of counted observations
		
		// next we want to find the mean wage and minimum wage in our sample
			summarize wage, detail		
				// we attain a value of 977.0599 for the mean wage in our sample
			summarize wage				
				// we attain a value of 115 for the minimum wage in our sample




**Q5 Wages and earnings are often studied by first taking logarithms. Transform the wage variable by taking its logarithm and report the mean value of the log(wage) variable.




    *Mean log(wage) = 6.800854




	// Code Section:
		// instead of just transforming the wage variable I will make a new variable that will be log(wage)
			gen 		log_wage = log(wage)
				// I could have also used the replace function but I like generating new variables
			summarize 	log_wage		
				// we attain a value of 6.800854 for the minimum wage in our sample 
			mean		log_wage		
				// the mean function gives us the same results
		// here I am just organizing the data so its more managable and easy to look at
			order 		worker_id wage log_wage
		// saving the trasnformed data set
			save 		"$clean_data/clean_data_transformed.dta", replace



**Q6. How many workers have exactly a high-school degree (12 years)? How many workers have at least a college degree (16 years or more)? 




    *Number of workers with exactly 12 years of education	=	706
	*Number of workers with at least 16 years of education 	=	432




	// Code Section:
		// Workers that have exactly 12 years of education
			count if	educ == 12		
				// we attain a value of 706 for the count of workers with exactly 12 years of education (a highschool degree)

		// Workers that have at least 16 years of education
			count if	educ >= 16		
				// we attain a value of 432 for the count of workers with more than 16 years of education (a college degree)




**Q7 How many non-white workers are in the sample? What is the average wage for those workers?




	* Number of non-white workers in the sample	=	1,466
	* Average wage for non-white workers		=	1007.293 




	// Code Section: 
		// 0 is the value of the binary variable if the worker is non-white
			count if	race == 0			
				// we attain a value of 1466 for the number of observations for non-white workers
			summarize 	wage if race == 0	
				// we attain a value of 1007.293 for the mean wage of a non-white workers




**Q8 What is the highest wage in the sample? What is the race, marital status and age of the highest wage worker in the sample?




	* Highest wage in the sample				=	3088
	* Race of the highest wage worker			=	Non-white (0)
	* Marital status of the highest wage worker	=	Married (1)
	* Age of the highest wage worker			=	29




	// Code Section:
		// we already have the information regarding the maximum wage from before
			summarize	wage		
				// we attain a value of 3088 for the maximum wage in our sample
		// now we find the rest of what the question is asking for
			list		race married age if wage == 3088
				// we attain two individuals with wages of 3088, both individuals are 29 years old, non-white, and married




**Q9 Construct a scatter plot figure showing the relationship between log wage and education level. Add the following options to your graph: 




*graph title:	Relationship between wage and education 
*X-axis title:	wage 
*Y-axis title:	Years of education 




	// Code Section:
		// here's what the question wants (I would add more to this but I don't want to lose grades)
			set		scheme s1color
			scatter	log_wage educ, ///
				title("Relationship between wage and education") ///
				xtitle("Wage") ///
				ytitle("Years of Education")
		// saving the plot
			graph	export "$output/scatter_plot.png", replace




**Q10 Test the hypothesis that white and non-white workers earn the same wage on average. Interpret in one or two sentences results of your test




	*Interpretation: Here we are trying to see if the difference between two means (the white and non-white demographics) is any different that 0. The t-test states, null hypothesis, alternative hypothsis, confidence interval, and p-value for this t-test are provided by the code bellow. The average non white workers make 247.4992 more in wages than the average white workers; this difference in means is large and statistically signficant to a very high level (lower that a 1% significance level) as indicated by the low p value. 
	
	*In conclusion: We can reject the null hypothesis that the differnce in means is equal to 0, and further say with high confidence (1% significance level) that white and non-white workers do not earn the same wages on average. In fact, we can even say with a level of confidence that the non-white worker make substantially more than the white worker on average.




	// Code Section:
			ttest	wage, by(race)




*****PART 2: Randomization****

**Q11  Set the random number seed to the number that corresponds to the sample size computed in Q4 and Generate a variable "x" with random numbers distributed uniformly between zero and one (Hint: use runiform). Then, create a variable treatment equal 1 if "x" is above the mean value of "x". 




		// setting seed
			set			seed 1670
		// generating a variable "x" with a random number distributed uniformaly between zero and one
			gen 		x = runiform()
			egen		mean_x = mean(x)
				// the mean value of "x" is approximately 0.4986601 
			gen 		diff = x - mean_x
			gen			treatment = (diff > 0)
		// dropping values of these preliminary steps
			drop		mean_x diff




**Q12 Create a label for the values of the variable treatment such that: 0 represents untreated units and 1 represents treated units. Test the hypothesis that treated and untreated workers earn the same wage on average. Based on the variable Did the randomization in Q11 work? Why? (explain in one or two sentences)




	*Interpretation: The randomization did work in question 11 since the t-test bellow informs us that there is no difference in mean wages between for those assigned to the treatement and control (untreated) groups. The 95% confidence interval for diff (difference in means) includes 0 which indicates that we are able to reject the null hypothesis that the means of the treated and untreated groups are equal at the 5% significance level or with 95% confidence. We can also see that the p value is 0.7311 which is quite high and also warrants us to the reject the null hypothsis (even to the 70% signficance level or with 30% confidence)




	// Code Section:
		// labelling treatment variable
			label	define treatment_labels 0 "untreated" 1 "treated"
			label 	values treatment treatment_labels
		// Test the hypothesis that treated and untreated workers earn the same wage on average
			ttest 	wage, by(treatment)








