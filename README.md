# _%tblmaker()_

The SAS macro **_%tblmaker()_** can currently be used to create summary tables in the form of a standard **Table 1** seen in medical journals. This macro automatically detects categorical/continuous variables, calculates appropriate descriptive statistics, reports data missingness, and performs appropriate statistical tests across column groupings. 

This macro will use all variables present in the dataset and automatically use any variable labels which have been assigned, so cleaning the input dataset is recommended before generating your table.


# Installation
You can import the **_%tblMaker()_** function into your SAS session by running the following code:
```r
filename tblMaker url "https://raw.githubusercontent.com/bradyrippon/tblMaker/refs/heads/main/tblMaker.sas";
%include tblMaker;
```
This will execute the macro directly from this GitHub page. You can alternative download the raw code file and run locally. 


# Basic Usage
**_%tblMaker(_** data = ,
 	byVar = ,
  	missingRow = ,
	statContinuous = ,
	showTest = **);**

### Required Inputs
- **data** = input dataset
- **byVar** = variable displayed in columns

### Optional Inputs
- **missingRow** = _(**"Yes"**, "No")_, toggle missing data rows on/off
- **statContinuous** = _(**"Mean"**_, "Median", "Both"), toggle mean/median for continuous data
- **showTest** = _("Yes", **"No"**)_, toggle statistical test column on/off


# Examples
Please note that the examples below were generated using the _journal_ style within **ods rtf** file exporting. You should use whichever style template you'd like to design your table. 

### SASHELP.baseball
```r
%tblMaker(
	data = SASHELP.baseball(keep = league natbat crruns division nassts),
	byVar = league
);
```
![summary table for SASHELP.baseball](https://github.com/bradyrippon/tblMaker/blob/main/figures/tbl-baseball.png)

### SASHELP.heart
```r
%tblMaker(
	data = SASHELP.heart(keep = status sex -- systolic chol_status bp_status),
	byVar = status
);
```
![summary table for SASHELP.heart](https://github.com/bradyrippon/tblMaker/blob/main/figures/tbl-heart.png)


