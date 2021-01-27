
*** open dataset
use data.dta, clear
** set directory for output csv
*cd DIRECTORY

*** write categorical vars between  "  "
global cat_vars =" "
*** write binary vars between  "  "
global bin_vars =" "
*** write continuous vars between  "  "
global cont_vars =" "
* exposure variable (column headings)
global exposure= " "

 
 ***

 file open table1 using "table_1 .csv", write replace
**-----

levelsof $exposure , local(levels)

foreach l of local levels {
local lbe : value label $exposure
local vlabel : label `lbe' `l'
file write table1 ",`vlabel'"
}
file write table1 ",Total"


file write table1 _n "N"
foreach l of local levels {
count if $exposure ==`l'
local n = r(N)
file write table1 ",`n'" 
}
count if $exposure !=.
local n = r(N)
file write table1 ",`n'" 

foreach var in   $cat_vars {
levelsof `var', local(level_var)
local varname : var label `var'
file write table1 _n "`varname' n (%)"
foreach l of local level_var {
local lbe : value label `var'
local vlabel : label `lbe' `l'
file write table1 _n "  `vlabel'"
foreach x of local levels {
count if $exposure ==`x' 
local N=r(N)
count if $exposure ==`x'   & `var' ==`l'
local n=r(N)
local p=string(round(`n'/`N'*100,0.1))
file write table1 ",`n' (`p'%)"
}
count if $exposure !=.
local N=r(N)
count if $exposure !=.   & `var' ==`l'
local n=r(N)
local p=string(round(`n'/`N'*100,0.1))
file write table1 ",`n' (`p'%)"
}
}


foreach var in  $bin_vars {
local varname : var label `var'
file write table1 _n "`varname' n (%)"
foreach x of local levels {
count if $exposure ==`x' 
local N=r(N)
count if $exposure ==`x'  & `var' ==1
local n=r(N)
local p=string(round(`n'/`N'*100,0.1))
file write table1 ",`n' (`p'%)"
}
count if $exposure !=. 
local N=r(N)
count if $exposure !=.  & `var' ==1
local n=r(N)
local p=string(round(`n'/`N'*100,0.1))
file write table1 ",`n' (`p'%)"
}

foreach var in  $cont_vars {
local varname : var label `var'
file write table1 _n "median `varname' (IQR)"
foreach x of local levels {
summ `var' if  $exposure ==`x' , d
local med=round(r(p50), 0.1)
local p25=round(r(p25), 0.1)
local p75=round(r(p75), 0.1)
file write table1 " ,`med' (`p25'-`p75')"
}
summ `var' if  $exposure !=. , d
local med=round(r(p50), 0.1)
local p25=round(r(p25), 0.1)
local p75=round(r(p75), 0.1)
file write table1 " ,`med' (`p25'-`p75')"
}



file close table1 








