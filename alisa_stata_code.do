// Stata code for paper
// Alisa Lyubina
// June 2025

version 16
clear
capture log close

log using alisa_stata_code, text replace

// Import dataset
import excel values.xlsx, firstrow clear

// Descriptive statistics
summarize oda_flows donor_gdp recipient_gdp donor_pop recipient_pop donor_poverty recipient_poverty donor_inflation recipient_inflation donor_int_rate recipient_int_rate donor_life_exp recipient_life_exp donor_mortality recipient_mortality donor_old_depend recipient_old_depend donor_young_depend recipient_young_depend donor_tuberc recipient_tuberc

// Visualize ODA flows from each donor-country by recipient-country
twoway (line oda_flows year if donor == "Canada", ///
	by(recipient, legend(off) title("ODA flows from Canada"))), ///
	 ytitle("ODA flows") xtitle("Year")
	 graph export "oda_Canada.png", replace width(1000)

twoway (line oda_flows year if donor == "France", ///
	by(recipient, legend(off) title("ODA flows from France"))), ///
	 ytitle("ODA flows") xtitle("Year")
	 graph export "oda_France.png", replace width(1000)
	 
twoway (line oda_flows year if donor == "Germany", ///
	by(recipient, legend(off) title("ODA flows from Germany"))), ///
	 ytitle("ODA flows") xtitle("Year")
	 graph export "oda_Germany.png", replace width(1000)
	 
twoway (line oda_flows year if donor == "Italy", ///
	by(recipient, legend(off) title("ODA flows from Italy"))), ///
	 ytitle("ODA flows") xtitle("Year")
	 graph export "oda_Italy.png", replace width(1000)
	 
twoway (line oda_flows year if donor == "Japan", ///
	by(recipient, legend(off) title("ODA flows from Japan"))), ///
	 ytitle("ODA flows") xtitle("Year")
	 graph export "oda_Japan.png", replace width(1000)
	 
twoway (line oda_flows year if donor == "United Kingdom", ///
	by(recipient, legend(off) title("ODA flows from United Kingdom"))), ///
	 ytitle("ODA flows") xtitle("Year")
	 graph export "oda_UK.png", replace width(1000)
	  
twoway (line oda_flows year if donor == "United States", ///
	by(recipient, legend(off) title("ODA flows from United States"))), ///
	 ytitle("ODA flows") xtitle("Year")
	 graph export "oda_USA.png", replace width(1000)
	
// Modify string variable for panel regression 
encode pair, gen(pair_num)
xtset pair_num year

// Run a panel regression with fixed effects
xtreg oda_flows donor_gdp recipient_gdp donor_pop recipient_pop donor_poverty recipient_poverty donor_inflation recipient_inflation donor_int_rate recipient_int_rate donor_life_exp recipient_life_exp donor_mortality recipient_mortality donor_old_depend recipient_old_depend donor_young_depend recipient_young_depend donor_tuberc recipient_tuberc, fe
estimates store fe
estat ic

// Run a panel regression with random effects
xtreg oda_flows donor_gdp recipient_gdp donor_pop recipient_pop donor_poverty recipient_poverty donor_inflation recipient_inflation donor_int_rate recipient_int_rate donor_life_exp recipient_life_exp donor_mortality recipient_mortality donor_old_depend recipient_old_depend donor_young_depend recipient_young_depend donor_tuberc recipient_tuberc, re
estimates store re

// Check which type of effects is better
hausman fe re
// p-value is small, reject null hypothesis, fixed effects are better

// Introduce lags for variables
xtset pair_num year
xtreg oda_flows L.donor_gdp L.recipient_gdp L.donor_pop L.recipient_pop L.donor_poverty L.recipient_poverty L.donor_inflation L.recipient_inflation L.donor_int_rate L.recipient_int_rate L.donor_life_exp L.recipient_life_exp L.donor_mortality L.recipient_mortality L.donor_old_depend L.recipient_old_depend L.donor_young_depend L.recipient_young_depend L.donor_tuberc L.recipient_tuberc, fe
estimates store fe_lags
estat ic

// AIC and BIC values have become smaller, therefore the model has become better after adding lags

// Increase the lag value to see how the coefficient estimates change
xtset pair_num year
xtreg oda_flows L5.donor_gdp L5.recipient_gdp L5.donor_pop L5.recipient_pop L5.donor_poverty L5.recipient_poverty L5.donor_inflation L5.recipient_inflation L5.donor_int_rate L5.recipient_int_rate L5.donor_life_exp L5.recipient_life_exp L5.donor_mortality L5.recipient_mortality L5.donor_old_depend L5.recipient_old_depend L5.donor_young_depend L5.recipient_young_depend L5.donor_tuberc L5.recipient_tuberc, fe
estimates store fe_fivelags
estat ic

log close



