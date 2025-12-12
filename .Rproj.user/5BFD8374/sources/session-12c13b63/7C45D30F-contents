# _%tblmaker()_

The SAS macro **_%tblmaker()_** can currently be used to create summary tables in the form of a standard **Table 1** seen in medical journals. This macro automatically detects categorical/continuous variables, calculates appropriate descriptive statistics, reports data missingness, and performs appropriate statistical tests across column groupings. 

This macro will use all variables present in the dataset and automatically use any variable labels which have been assigned, so cleaning the input dataset is recommended before generating your table.


# Installation
You can import the **_%tblmaker()_** function into your SAS session by running the following code:
```r
filename tblmaker url "https://raw.githubusercontent.com/bradyrippon/tblMaker/refs/heads/main/tblmaker.sas";
%include tblmaker;
```
This will execute the macro directly from this GitHub page. You can alternative download the raw code file and run locally. 


# Basic Usage
**_%tblmaker(_** data =, . . .  **);**

### Required Inputs
- **data** = input dataset

### Optional Inputs
- **byvar** = stratifying variable displayed in columns
- **missing_row** = [ **YES** | NO ], toggle missing data rows
- **ncol** = [ YES | **NO** ], toggle data frequency column
- **stat_continuous** = [ **MEAN** | MEDIAN | BOTH ], toggle mean/median for continuous data reporting
- **add_p** = [ YES | **NO** ], toggle p-value column
- **add_test** = [ YES | **NO** ], toggle statistical test column


# Examples
Please note that the examples below were generated using the _journal_ style within **ods rtf** file exporting. You should use whichever style template you'd like to design your table. 

### SASHELP.baseball
```r
%tblmaker(
	data = SASHELP.baseball(keep = league natbat crruns division nassts),
	byVar = league
);
```
![summary table for SASHELP.baseball](https://github.com/bradyrippon/tblmaker/blob/main/figures/tbl-baseball.png)

### SASHELP.heart
```r
%tblmaker(
	data = SASHELP.heart(keep = status sex -- systolic chol_status bp_status),
	byvar = status
);
```
![summary table for SASHELP.heart](https://github.com/bradyrippon/tblmaker/blob/main/figures/tbl-heart.png)
