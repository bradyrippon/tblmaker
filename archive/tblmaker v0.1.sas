
*_______________________________________________*
*                                               *
*         CREATING SAS SUMMARY TABLES           *
*           LAST UPDATED: 11/15/2024            *
*                                               *
*_____________________ brr7014@med.cornell.edu  * 
*                                               *

/* -_-_-_-_-_-_-_-_ VERSIONS _-_-_-_-_-_-_-_- */

/  [v0.1]  //  11/15/2024  //  - initial release -





/** TABLE OF CONTENTS **


%nobs();                /* LINE 37      /* Count rows in dataset
%getContents();         /* LINE 53      /* Count table variables and sort in [tbl.contents]
%getStatsContinuous();  /* LINE 150     /* Generate continuous descriptive statistics
%getTestContinuous();   /* LINE 239     /* Generate continuous test results
%getStatsCategorical(); /* LINE 358     /* Generate categorical descriptive statistics
%getTestCategorical();  /* LINE 489     /* Generate categorical test results

%tblMaker();            /* LINE 577     /* Generate summary table (using above macros)


 ** TABLE OF CONTENTS **/ 





/* -_-_-_-_-_-_-_-_ %nobs() _-_-_-_-_-_-_-_- */


%macro nobs(data); %local dsid rc;

	%let dsid = %sysfunc(open(&data.,IN));
		%let nobs = %sysfunc(ATTRN(&dsid, NOBS));
	%let rc = %sysfunc(close(&dsid));
	&nobs

%mend;





/* -_-_-_-_-_-_-_-_ %getContents() _-_-_-_-_-_-_-_- */

/* CREATES: [tbl.contents] / [tbl.byVarOut] / [tbl.byVarLabels] */


%macro getContents;

	/* create PROC CONTENTS dataset */
	proc contents data=tbl.macroData out=tbl.contents; run;

	/* filter out byVar (only row variables will remain) */
	data tbl.contents;
		set tbl.contents(keep = NAME LABEL TYPE VARNUM);
		if upcase(name) ^= upcase("&byVar");
	run;

	/* change from alphabetical ordering */
	proc sort data=tbl.contents; by VARNUM; run;

	/* establish consecutive variable order, [VARNUM] will skip the [byVar] number */
	data tbl.contents;
		set tbl.contents;
		tblOrder = _N_;
		rename name = varName;
	run;

	/* create a new variable that combines variable name and label */
	data tbl.contents;
		set tbl.contents;
		if missing(LABEL) then varNameLabel = varName;
		else varNameLabel = LABEL;
	run;

	/* save number of variables to create table rows for as [numVars] */
	data _NULL_; set tbl.contents;
		by tblOrder;
		if last.tblOrder;
		call symput("numVars", _N_);
	run;



	/* generate a list of levels from [byVar] */
	proc freq data=tbl.macroData noprint; 
		tables &byVar / out=tbl.byVarOut;
	run;

	/* sort [byVar] in decending order (controls final column order) */
	proc sort data=tbl.byVarOut; by descending COUNT; run;

	/* create tags for [byVar]: [byVarOrder] for order and [byVarCount] for group sizes */
	data tbl.byVarOut; 
		set tbl.byVarOut(drop = PERCENT);
		byVarOrder = _N_;
		rename COUNT = byVarCount;
	run;



	/* create a macro variable for each level of [byVar] label */
	/* generate a list of levels from [byVar] */
	data tbl.byVarLabels;
		set tbl.byVarOut;
		if _N_ = 1;
		&byVar = "All"; 
		byVarCount = %nobs(tbl.macroData);
		byVarOrder = 0;
	run;

	/* design labelled column headers */
	data tbl.byVarLabels;
		set tbl.byVarLabels tbl.byVarOut;
		if &byVar = "All" then byVarLabel = cat('All^{super 1} ^{newline}(n = ', byVarCount, ')');
		else byVarLabel = cat(&byVar, '^{super 1} ^{newline}(n = ', byVarCount, ')');
		byVar = "&byVar";
	run;

	/* create transposed list of final column labels */
	proc transpose data=tbl.byVarLabels out=tbl.byVarLabels(drop=_NAME_);
		by byVar;
		var byVarLabel;
	run;

	/* create a macro variable for each level of [byVar] label */
	data _null_; set tbl.byVarLabels;
		array getLabels {*} _ALL_;
		do i = 1 to dim(getLabels);
			call symput(cat("label_", i), getLabels{i});
		end;
	run;

%mend getContents;





/* -_-_-_-_-_-_-_-_ %getStatsNumeric() _-_-_-_-_-_-_-_- */

/* CREATES: [tbl.outStatsNumeric] */

%macro getStatsNumeric;

	/* generate all descriptive statistics */
	proc means data=tbl.macroData noprint; 
		class &byVar;
		var &statVar;
		output out=tbl.outStatsNumeric 
			n=freq nmiss=freqMiss 
			mean=statMean std=statStd median=statMedian p25=q25 p75=q75;
	run;

	/* edit descriptive statistics to be in table format */
	/* [stat1: Mean (SD)] / stat2: [Median (IQR)] */
	data tbl.outStatsTemp;
		set tbl.outStatsNumeric; 
		propMiss = round((freqMiss/_FREQ_)*100, 0.1);
		statMiss = cat(freqMiss, ' (', propMiss, '%)');
		array stats {5} statMean statStd statMedian q25 q75;

		/* control variable rounding */
		do i = 1 to dim(stats);	
			if stats{i} >=1000 then stats{i} = round(stats{i}, 1);
			else if stats{i} >=100 then stats{i} = round(stats{i}, 0.1);
			else stats{i} = round(stats{i}, 0.01);
		end;
		stat1 = cat(statMean, ' (', statStd, ')');
		stat2 = cat(statMedian, ' (', q25, ', ', q75, ')');

		/* find row containing stats for entire dataset */
		if _TYPE_ = 0 then &byVar = "All";
		varName = "&statvar";
		keep &byVar statMiss stat1 stat2 varName _FREQ_;
	run;

	/* sort subgroups to intended column order */
	proc sort data=tbl.outStatsTemp; by descending _FREQ_; run;
				
	/* create descriptive stats for: Mean (SD) */
	proc transpose data=tbl.outStatsTemp out=tbl.outStatsNumeric1(drop=_NAME_);
		by varName;
		var stat1;
	run;

	/* create descriptive stats for: Median (IQR) */
	proc transpose data=tbl.outStatsTemp out=tbl.outStatsNumeric2(drop=_NAME_);
		by varName;
		var stat2;
	run;

	/* get row for missing data */
	proc transpose data=tbl.outStatsTemp out=tbl.outMiss (drop=_NAME_);
		by varName;
		var statMiss;
	run;

	/* relabel new row for missing data */
	data tbl.outMiss;
		set tbl.outMiss;
		varName = "Missing";
	run; 

	/* stack the missing row onto the bottom of the descriptive statistics */
	data tbl.outStatsNumeric;
		set tbl.outStatsNumeric1 tbl.outStatsNumeric2 tbl.outMiss;
		array vars{*} _CHARACTER_;
		do i = 2 to dim(vars);
			if prxmatch('/\d/', vars(i)) = 0 then vars(i) = "---";
		end; drop i;
		if _N_ = 1 then do; tagStat = "Parametric   "; isVar = "Yes"; end;
		if _N_ = 2 then do; tagStat = "Nonparametric"; isVar = "Yes"; end;
		tagType = "Numeric    ";
	run;

	/* get copy of this output saved as generic name */
	data tbl.outStats; 
		set tbl.outStatsNumeric; 
		varStatOrder = _N_;
	run;

%mend getStatsNumeric;





/* -_-_-_-_-_-_-_-_ %getTestNumeric() _-_-_-_-_-_-_-_- */

/* CREATES: [tbl.outTestContinuous] */

%macro getTestNumeric;

	/* get two-sample test results */
	%if %nobs(tbl.byVarOut) = 2 %then %do;
		/* two-sample t-test */
		proc ttest data = tbl.macroData;
			class &byVar;
			var &statvar;
			ods output ttests = tbl.outTestNumeric1 equality = tbl.outEq;
		run;

		/* check equality of variance between samples */
		data _NULL_; set tbl.outEq;
			if ProbF <0.05 then pooledSig = "Unequal";
				else pooledSig = "Equal";
			call symput("pooledSig", pooledSig);
		run;

		/* only keep result which matches variance test */
		data tbl.outTestNumeric1;
			set tbl.outTestNumeric1(rename=(Variable=varName));
			if Variances = "&pooledSig";
			pvalueRaw = Probt;
			if pvalueRaw <0.001 then pvalue = "<0.001";
				else if pvalueRaw <0.01 then pvalue = round(pvalueRaw, 0.001);
				else pvalue = round(pvalueRaw, 0.01);
			test = "t-test                ";
			keep varName pvalueRaw pvalue test;
		run;


		/* Wilcoxon rank-sum */
		proc npar1way data = tbl.macroData wilcoxon;
			class &byVar;
			var &statvar;
			ods output WilcoxonTest = tbl.outTestNumeric2;
		run;

		/* clean test results */
		data tbl.outTestNumeric2;
			set tbl.outTestNumeric2(rename=(Variable=varName));
			if Name1 = "PT2_WIL";
			pvalueRaw = nValue1;
			if pvalueRaw <0.001 then pvalue = "<0.001";
				else if pvalueRaw <0.01 then pvalue = round(pvalueRaw, 0.001);
				else pvalue = round(pvalueRaw, 0.01);
			test = "Wilcoxon rank-sum test";
			keep varName pvalueRaw pvalue test;
		run;
	%end;

	/* get multi-sample (3+) test results */
	%if %nobs(tbl.byVarOut) >2 %then %do;
		/* ANOVA */
		proc anova data = tbl.macroData;
			class &byVar;
			model &statvar = &byVar;
			ods output modelANOVA = tbl.outTestNumeric1;
		run; quit;

		/* clean test results */	
		data tbl.outTestNumeric1;
			set tbl.outTestNumeric1(rename=(Dependent=varName));
			pvalueRaw = ProbF;
			if pvalueRaw <0.001 then pvalueTemp = "<0.001";
				else if pvalueRaw >0.99 then pvalueTemp = ">0.99";
				else if pvalueRaw <0.01 then pvalueTemp = round(pvalueRaw, 0.001);
				else pvalueTemp = round(pvalueRaw, 0.01);
			pvalue = put(pvalueTemp, 6.);

			test = "ANOVA            ";
			keep varName pvalueRaw pvalue test;
		run;


		/* Kruskal-Wallis test */
		proc npar1way data = tbl.macroData wilcoxon;
			class &byVar;
			var &statvar;
			ods output KruskalWallisTest = tbl.outTestNumeric2;
		run;

		/* clean test results */
		data tbl.outTestNumeric2;
			set tbl.outTestNumeric2(rename=(Variable=varName));
			if Name1 = "P_KW";

			pvalueRaw = nValue1;
			if pvalueRaw <0.001 then pvalueTemp = "<0.001";
				else if pvalueRaw >0.99 then pvalueTemp = ">0.99";
				else if pvalueRaw <0.01 then pvalueTemp = round(pvalueRaw, 0.001);
				else pvalueTemp = round(pvalueRaw, 0.01);
			pvalue = put(pvalueTemp, 6.);

			test = "Kruskal-Wallis test   ";
			keep varName pvalueRaw pvalue test;
		run;
	%end;

	/* stack parametric/nonparametric results */
	data tbl.outTestNumeric;
		set tbl.outTestNumeric1 tbl.outTestNumeric2;
		if _N_ = 1 then tagStat = "Parametric   ";
		if _N_ = 2 then tagStat = "Nonparametric";
	run;

	/* get copy of this output saved as generic name */
	data tbl.outTest; set tbl.outTestNumeric; run;

%mend getTestNumeric;





/* -_-_-_-_-_-_-_-_ %getStatsCategorical() _-_-_-_-_-_-_-_- */

/* CREATES: [tbl.outStatsCategorical] */

%macro getStatsCategorical;

	/* find correct order for categorical levels (by frequency) */
	proc freq data = tbl.macroData; 
		tables &statVar / out=tbl.StatVarOut;
	run;
	proc sort data=tbl.StatVarOut; by descending COUNT; run;

	/* create marginal frequency table */
	data tbl.StatVarOut; 
		set tbl.StatVarOut(drop = PERCENT);
		statVarOrder = _N_;
		rename COUNT = statVarCount;
		if missing(&statVar) then do; 
			&statVar = "Missing";
			statVarOrder = 999;
		end;
	run;

	/* generate all descriptive statistics */
	proc freq data = tbl.macroData;
		tables &byVar*&statVar / 
			missprint outcum outpct outexpect 
			out = tbl.freqsOut;
	run;

	/* sort and merge by [byVar] */
	proc sort data = tbl.freqsOut; by &byVar; run;
	proc sort data = tbl.byVarOut; by &byVar; run;

	data tbl.freqsOut;
		merge tbl.freqsOut tbl.byVarOut;
		by &byVar;
		if missing(&statVar) then &statVar = "Missing";
	run;

	/* sort and merge by [statVar] */
	proc sort data=tbl.freqsOut; by &statVar; run;
	proc sort data=tbl.StatVarOut; by &statVar; run;

	/* generate tag for missing data (so it always is ordered last) */
	/* clean up freq (%) data and make template space for "All" column */
	data tbl.outStatsCategorical;
		length &statVar $200;
		merge tbl.freqsOut tbl.StatVarOut;
		by &statVar;

		propFreq = round((COUNT/byVarCount)*100, 0.1);
		statFreq = cat(COUNT, ' (', propFreq, '%)');
		output;
		if last.&statVar then do;
			&byVar =''; byVarOrder = 0; output;
		end;
	run;
	proc sort data=tbl.outStatsCategorical; by byVarOrder statVarOrder; run;

	/* clean up data for "All" column */
	data tbl.outStatsCategorical;
		length &byVar $200;
		set tbl.outStatsCategorical;
		if missing(&byVar) then do; 
			&byVar = "All Levels";
			propFreq = round((statVarCount/%nobs(tbl.macroData))*100, 0.1);
			statFreq = cat(statVarCount, ' (', propFreq, '%)');
		end;
	run;
	proc sort data=tbl.outStatsCategorical; by statVarOrder byVarOrder; run;

	/* transpose sorted data so it displays in correct final columns */
	proc transpose data=tbl.outStatsCategorical out=tbl.outStatsCategorical(drop = _NAME_);
		by statVarOrder;
		var statFreq;
	run;

	/* sort and merge by [statVarOrder] */
	proc sort data=tbl.statVarOut; by statVarOrder; run;
	proc sort data=tbl.outStatsCategorical; by statVarOrder; run;

	/* treat instances of 0 cell counts; create row header showing variable name */
	data tbl.outStatsCategorical;
		length &statVar $200;
		merge tbl.statVarOut(drop=statVarCount) tbl.outStatsCategorical end=ending;
		by statVarOrder;
		array vars{*} _CHARACTER_;
		do i = 1 to dim(vars);
			if missing(vars(i)) then vars(i) = "0 (0%)";
		end;

		output;
		if ending then do;
			&statVar = "&statVar"; statVarOrder = 0;
			output;
		end;

		rename &statVar = varName;
	run;
	proc sort data=tbl.outStatsCategorical; by statVarOrder; run;

	/* blank out every stat variable for the row header just created */
	/* create tag variables so this data is same format as the continuous data */
	data tbl.outStatsCategorical;
		set tbl.outStatsCategorical;
		by statVarOrder;
		array vars{*} _CHARACTER_;
		do j = 2 to dim(vars);
			if varName = "&statVar" then vars(j) ='';
		end;
		drop i j;
		tagStat = "Categorical  ";
		tagType = "Categorical";
	run;

	/* get copy of this output saved as generic name */
	data tbl.outStats; 
		set tbl.outStatsCategorical; 
		varStatOrder = _N_;
	run;

	/* get copy of this output saved as generic name */
	data tbl.outTest; set tbl.outTestCategorical; run;

%mend getStatsCategorical;





/* -_-_-_-_-_-_-_-_ %getTestCategorical() _-_-_-_-_-_-_-_- */

/* CREATES: [tbl.outTestCategorical] */

%macro getTestCategorical;

	/* extract both test results (chi-squared and exact test) */
	proc freq data = tbl.macroData;
		tables &byVar*&statVar / 
			chisq exact outexpect 
			out = tbl.outExpect;
			ods output ChiSq = tbl.chisq FishersExact = tbl.fisher;
	run;

	/* flag all cells where expected count is low */
	data tbl.outExpect;
		set tbl.outExpect(keep = EXPECTED);
		where EXPECTED ^=.;
		anchor = "Anchor"; rowNumber = _N_;
		if EXPECTED <5 then checkExpected = 1; else checkExpected = 0;
	run;

	/* create macro variable for percentage of low expected cell counts */
	data tbl.outExpect;
		set tbl.outExpect;
		by anchor;
		retain lowExpected;
		if first.anchor then lowExpected = checkExpected*100;
			else lowExpected = lowExpected + (checkExpected*100);
		if last.anchor then lowExpected = lowExpected / rowNumber;
		if last.anchor;
		call symput("lowExpected", lowExpected);
	run;

	/* pick test based on expected cell count criteria (<20% with 5 or lower) */
	%if &lowExpected >20 %then %do;
		data _NULL_;
			set tbl.fisher;
			where Name1 = "XP2_FISH";
			call symput("pvalueRaw", nValue1);
		run;
	%end;
	%if &lowExpected <=20 %then %do;
		data _NULL_;
			set tbl.chisq;
			where Statistic = "Chi-Square";
			call symput("pvalueRaw", Prob);
		run;
	%end;

	/* create dataset for categorical results */
	data tbl.outTestCategorical;
		varName = "&statVar";
		pvalueRaw = &pvalueRaw;
		pvalue = "Placeholder";
		if &lowExpected >20 then test = "Fisher's exact test   ";
			else test = "Chi-squared test      ";
		if &lowExpected <=20 then tagStat = "Parametric   ";
			else tagStat = "Nonparametric";
		isVar = "Yes";
	run;

	/* clean p-value */
	data tbl.outTestCategorical;
		set tbl.outTestCategorical;
		if pvalueRaw <0.001 then pvalueTemp = "<0.001";
			else if pvalueRaw >0.99 then pvalueTemp = ">0.99";
			else if pvalueRaw <0.01 then pvalueTemp = round(pvalueRaw, 0.001);
			else pvalueTemp = round(pvalueRaw, 0.01);
		pvalue = put(pvalueTemp, 6.);
		drop pvalueTemp;
	run;


	/* get copy of this output saved as generic name */
	data tbl.outTest; set tbl.outTestCategorical; run;

%mend getTestCategorical;










/* -_-_-_-_-_-_-_-_ %tblMaker() _-_-_-_-_-_-_-_- */

/* CREATES: [WORK.tbl] -- final product for summary table */

%macro tblMaker(
	data, 						/* specify dataset for table */
	byVar, 						/* specify stratification variable */
	missingRow = "Yes", 		/* toggle missing data rows on/off */
	statContinuous = "Mean", 	/* toggle mean/median for continuous variables */
	showTest = "No"				/* toggle statistical test on/off */
);
	
	ods exclude all;
	ods escapechar='^';

	/* create a folder [TBL] for temporary datasets */
	%let outdir = %sysfunc(getoption(work));
	options dlcreatedir;
	libname tbl "&outdir./tbl";

	/* create copy of input data */
	data tbl.macroData; set &data; run;	

	/* initialize final dataset */
	data tbl.meansOutFinal; set _NULL_; run;	
	
	/* --- DEFINED ON LINE 40 --- */
	%getContents;


	/* loops actions through all content variables */
	%do iGlobal = 1 %to &numVars; 

		/* find name and type of present variable */
		data _NULL_; set tbl.contents;
			if tblOrder = &iGlobal;
			call symput("statVar", varName);
			call symput("statVarType", TYPE);
		run;

		/* check of variable is numeric */
		%if &statVarType = 1 %then %do; 

			/* --- DEFINED ON LINE XXX --- */
			%getStatsNumeric;
			/* --- DEFINED ON LINE XXX --- */
			%getTestNumeric;

			/* sort variable summaries before merging */
			proc sort data = tbl.outStats; by varName tagStat; run;
			proc sort data = tbl.outTest; by varName tagStat; run;
		
			/* create variable info that will go in final table */
			data tbl.outTableTemp;
				merge tbl.outStats tbl.outTest;
				by varName tagStat;
				tableOrder = &iGlobal;
			run;

		%end;

		/* check of variable is numeric */
		%if &statVarType = 2 %then %do; 

			/* --- DEFINED ON LINE XXX --- */
			%getStatsCategorical;
			/* --- DEFINED ON LINE XXX --- */
			%getTestCategorical;

			/* sort variable summaries before merging */
			proc sort data = tbl.outStats; by varName; run;
		
			/* create variable info that will go in final table */
			data tbl.outTableTempCat;
				merge tbl.outStats tbl.outTest;
				by varName;
				tableOrder = &iGlobal;
			run;
			
			/* sort variable summaries back to original order */
			proc sort data = tbl.outTableTempCat out = tbl.outTableTemp(drop = statVarOrder); 
				by statVarOrder; 
			run;

		%end;

		/* combine info for all table variables */
		%if &iGlobal = 1 %then %do;
			data tbl.outTable; set tbl.outTableTemp; run;
		%end;

		%if &iGlobal >1 %then %do;
			data tbl.outTable; 
				length varName $200;
				set tbl.outTable tbl.outTableTemp; 
			run;
		%end;

	/* end global loop */
	%end;



	/* --- TABLE DESIGN --- */


	/* control input parameters for table design */
	/* choose continuous stats, missing data input */
	data tbl.outTable;
		set tbl.outTable;
			if &statContinuous = "Mean" & tagType = "Numeric" & tagStat = "Nonparametric" then delete;
			if &statContinuous = "Median" & tagType = "Numeric" & tagStat = "Parametric" then delete;
			if &statContinuous = "Both" & tagType = "Numeric" & tagStat = "Nonparametric" then varName = "";

			if varName = "Missing" & col1 = "0 (0%)" then delete;
			if varName = "Missing" & &missingRow = "No" then delete;
	run;

	/* create a list of all tests performed */
	proc sql noprint;
	    select distinct test
	    into :testList separated by '; '
	    from tbl.outTable;
	quit;
	%let testList = %substr(&testList, 3);

	%if &showTest = "No" %then %do;
		data tbl.outTable;
			set tbl.outTable;
			drop test;
		run;
	%end;


	/* sort datasets to merge labels together */
	proc sort data = tbl.outTable; by varName; run;
	proc sort data = tbl.contents; by varName; run;

	/* add in row labels */
	data tbl.outTable;
		merge tbl.outTable tbl.contents;
		by varName;
		label varName = "^{newline}Characteristic"
			  pvalue = "^{newline}p-value^{super 2}"
			  test = "^{newline}Test";
		if missing(LABEL) then varName = varName;
			else varName = LABEL;
		drop LABEL TYPE VARNUM tblOrder;
	run;

	/* add labels onto final table columns */
	%macro label;
		%do iLabel = 1 %to %nobs(tbl.byVarOut)+1;
			data _NULL_;
				set tbl.byVarLabels;
				call symput("label", col&iLabel);
			run;

		data tbl.outTable;
			set tbl.outTable;
			label col&iLabel = "&label";
		run;
		%end;
	%mend label;
	%label;


	/* reorder rows for final table */
	proc sort data = tbl.outTable;
		by tableOrder varStatOrder;
	run;
	
	/* drop variables only used for table aesthetics */
	data tbl;
		set tbl.outTable;
		if missing(tagType) then delete;
		drop tagStat tagType varNameLabel varStatOrder tableOrder pvalueRaw isVar;
	run;	

	/* create a list of all variable names */
	proc sql noprint;
	    select distinct varNameLabel
	    into :varList separated by ' '
	    from tbl.contents;
	quit;

	ods exclude none;
	
	/* print final table */
	proc report data = tbl nowd;
		compute varName;
		if index(" &varList ", strip(varName)) >0 then
			call define(_col_, "style", "style=[font_weight=bold indent=0]");
		else if varName = "Missing" then
			call define(_col_, "style", "style=[font_style=italic indent=1%]");
		else call define(_col_, "style", "style=[indent=1%]");
		endcomp;

		compute after;
			%if &statContinuous = "Mean" %then %do;
				line @1 "^{super 1}n (%); Mean (SD)";
			%end;
			%else %if &statContinuous = "Median" %then %do;
				line @1 "^{super 1}n (%); Median (IQR)";
			%end;
			%else %do;
				line @1 "^{super 1}n (%); Mean (SD) and Median (IQR)";
			%end;
			line @1 "^{super 2}&testList";
		endcomp;
	run;

%mend tblMaker;
