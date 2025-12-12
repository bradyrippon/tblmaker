*** /
_____________________________________________
                                               
SAS SUMMARY TABLES           
LAST UPDATED: 12/10/2025            
                                               
_____________________ brr7014@med.cornell.edu   
                                               

/* -_-_-_-_-_-_-_-_ VERSIONS _-_-_-_-_-_-_-_- */

/  [v0.1.0]  //  11/15/2024  //  - initial release -
/  [v0.5.0]  //  12/10/2025  //  - improved syntax, "noby" functionality -




/** TABLE OF CONTENTS **

/* HELPER FUNCTIONS
%_count_obs();				/* LINE xxx		/* Count rows in dataset
%_get_contents();			/* LINE xxx		/* Count table variables and sort in [tbl.contents]
%_get_stats_numeric();		/* LINE xxx		/* Generate continuous descriptive statistics
%_get_test_numeric();		/* LINE xxx		/* Generate continuous test results
%_get_stats_categorical();	/* LINE xxx		/* Generate categorical descriptive statistics
%_get_test_categorical();	/* LINE xxx		/* Generate categorical test results

/* PUBLIC FUNCTIONS
%tblmaker();				/* LINE xxx		/* Generate final summary table


 ** TABLE OF CONTENTS **/ 





/* -_-_-_-_-_-_-_-_ %_count_obs() _-_-_-_-_-_-_-_- */

%macro _count_obs(data); %local __nobs rc;

	%let __nobs = 0;
	%let rc = %sysfunc(
		dosubl(
			%nrstr(
				proc sql noprint;
					select count(*) into :__nobs trimmed
					from &data;
				quit;
			)
		)
	);
  &__nobs

%mend _count_obs;



/* -_-_-_-_-_-_-_-_ %_get_contents() _-_-_-_-_-_-_-_- */

/* CREATES: [tbl.contents] / [tbl.byvar_out] / [tbl.byvar_labels] */


%macro _get_contents(byvar=);

	/* create PROC CONTENTS dataset */
	proc contents data=tbl.data_macro out=tbl.contents noprint; run;

	/* filter out byvar (only row variables will remain) */
	data tbl.contents;
		set tbl.contents(keep = NAME LABEL TYPE VARNUM);
		if upcase(name) ~= upcase("&byvar");
	run;

	/* change from alphabetical ordering */
	proc sort data=tbl.contents; by VARNUM; run;

	/* establish variable order, [VARNUM] will skip the [byvar] number */
	data tbl.contents;
		set tbl.contents;
		contents_order = _N_;

		length var_name_label $200;
		var_name_label = coalescec(LABEL, NAME);
		rename NAME = var_name;
	run;

	/* number of table rows to build */
	data _NULL_; set tbl.contents end=last;
		if last then call symputx("num_vars", _N_, "G");
	run;


			/* ----- no [byvar] provided ----- */
			%if &_has_byvar = NO %then %do;
				data tbl.byvar_labels;
					length byvar $200 col1 $200;
					byvar = "";
					col1  = cat('Overall^{super 1} ^{newline}(n = ', %_count_obs(tbl.data_macro), ')');
				run;

				data tbl.byvar_out;
					length byvar $200;
					byvar = "Overall"; byvar_order = 0;
					byvar_count = %_count_obs(tbl.data_macro);
					stop;
				run;
				%return; /* --- EXIT --- */
			%end;


	/* ----- [byvar] provided ----- */

	/* generate a list of levels from [byvar] */
	proc freq data=tbl.data_macro noprint; 
		tables &byvar / out=tbl.byvar_out;
	run;

	/* sort [byvar] in decending order (controls final column order) */
	proc sort data=tbl.byvar_out; by descending COUNT; run;

	/* create tags for [byvar]: [byvar_order] for order and [byvar_count] for group sizes */
	data tbl.byvar_out; 
		set tbl.byvar_out(drop = PERCENT);
		byvar_order = _N_;
		rename COUNT = byvar_count;
	run;

	/* create a macro variable for each level of [byvar] label */
	/* generate a list of levels from [byvar] */
	data tbl.byvar_labels;
		set tbl.byvar_out;
		if _N_ = 1 then do;
			&byvar 		= "x"; 
			byvar_count = %_count_obs(tbl.data_macro);
			byvar_order = 0;
			output;
		end;
	run;

	/* design labelled column headers */
	data tbl.byvar_labels;
		set tbl.byvar_labels tbl.byvar_out;
		length byvar_label $200;
		if &byvar = "x" then 
			byvar_label = cat('Overall^{super 1} ^{newline}(n = ', byvar_count, ')');
		else 
			byvar_label = cat(&byvar, '^{super 1} ^{newline}(n = ', byvar_count, ')');
		byvar = "&byvar";
	run;

	/* create transposed list of final column labels */
	proc transpose data=tbl.byvar_labels out=tbl.byvar_labels(drop=_NAME_);
		by byvar;
		var byvar_label;
	run;

	/* create a macro variable for each level of [byvar] label */
	data _null_; set tbl.byvar_labels;
		array getlabels {*} _ALL_;
		do i = 1 to dim(getlabels);
			call symputx(cat("label_", i), getlabels{i}, "G");
		end;
	run;

%mend _get_contents;





/* -_-_-_-_-_-_-_-_ %_get_stats_numeric() _-_-_-_-_-_-_-_- */

/* CREATES: [tbl.outstats_numeric] */

%macro _get_stats_numeric(byvar=);

	/* --- helper --- */
	%macro _transpose(trans_var, dataout);
		proc transpose data=tbl.outstats_temp out=&dataout(drop=_NAME_);
			by var_name;
			var &trans_var;
		run;
	%mend _transpose;

	/* generate all descriptive statistics */
	proc means data=tbl.data_macro noprint; 

		/* ----- [byvar] provided ----- */
			%if &_has_byvar = YES %then %do; class &byvar; %end;
		/* ----- */

		var &statvar;
		output out=tbl.outstats_numeric 
			n=freq nmiss=freq_miss 
			mean=stat_mean std=stat_std median=stat_median p25=q25 p75=q75;
	run;

	/* edit descriptive statistics to be in table format */
	/* stat1: [ Mean (SD)]     */
	/* stat2: [ Median (IQR)] */
	data tbl.outstats_temp;
		set tbl.outstats_numeric; 
		length var_name $200;

		/* control variable rounding */
		array stats {5} stat_mean stat_std stat_median q25 q75;
		do i = 1 to dim(stats);	
			if stats{i} >=1000 then stats{i} = round(stats{i}, 1);
			else if stats{i} >=100 then stats{i} = round(stats{i}, 0.1);
			else stats{i} = round(stats{i}, 0.01);
		end;
		stat1 = cat(stat_mean, ' (', stat_std, ')');
		stat2 = cat(stat_median, ' (', q25, ', ', q75, ')');

	/* ----- [byvar] provided ----- */
			/* find row containing stats for entire dataset */
			%if &_has_byvar = YES %then %do;
				if _TYPE_ = 0 then &byvar = "All";
			%end;
	/* ----- */

		var_name = "&statvar";
		keep &byvar stat1 stat2 var_name freq_miss _FREQ_;
	run;

	/* ----- [byvar] provided ----- */
		/* sort subgroups to intended column order */
		%if &_has_byvar = YES %then %do;
			proc sort data=tbl.outstats_temp; by descending _FREQ_; run;
		%end;
	/* ----- */
				
	/* create descriptive stats */ 
	%_transpose(stat1, tbl.outstats_numeric1); 	/* Mean (SD)    */
	%_transpose(stat2, tbl.outstats_numeric2); 	/* Median (IQR) */

	/* reformat missing data row */
	data tbl.out_miss;
	    set tbl.outstats_numeric;
	/* ----- [byvar] provided ----- */
			/* pull cumulative row only */
			%if &_has_byvar = YES %then %do; where _TYPE_ = 0; %end;
	/* ----- */
	    length var_name $200 col1 $40;
	    total_n   = %_count_obs(tbl.data_macro);
	    prop_miss = ifn(total_n>0, round((freq_miss/total_n)*100, 0.1), .);
	    col1      = cat(freq_miss, ' (', prop_miss, '%)');
	    var_name  = "Missing";
	    keep var_name col1;
	run;

	/* stack the missing row onto the bottom of the descriptive statistics */
	data tbl.outstats_numeric;
		length var_name $200 tag_stat $20 tag_type $20 isvar $8 n $20 tag_stat_order 8;
		set tbl.outstats_numeric1(in=d1) tbl.outstats_numeric2(in=d2) tbl.out_miss(in=dm);
		array chars _CHARACTER_;
		do i = 2 to dim(chars); 
			if prxmatch('/\d/', chars{i})=0 then chars{i} = '---'; 
		end; drop i;
		if d1 then do; 
			tag_stat = "Parametric";
			tag_stat_order = 1;
			isvar = "Yes"; 
		end;
		if d2 then do; 
			tag_stat = "Nonparametric";
			tag_stat_order = 2; 
			isvar = "Yes"; 
		end;
		if dm then do; 
			tag_stat = "Missing";
			tag_stat_order = 999; 
			isvar = "No"; 
		end;
		tag_type = "Numeric";
		n = put(%_count_obs(tbl.data_macro(where=(not missing(&statvar)))), 12.);
	run;

	/* save a copy to main name */
	data tbl.outstats; set tbl.outstats_numeric; run;

%mend _get_stats_numeric;





/* -_-_-_-_-_-_-_-_ %_get_test_numeric() _-_-_-_-_-_-_-_- */

/* CREATES: [tbl.outtest_numeric] */

%macro _get_test_numeric(byvar=);

			/* ----- no [byvar] provided ----- */
			%if &_has_byvar = NO %then %do;
				data tbl.outtest;
            		length
		                var_name      $200
		                tag_stat      $20
		                tag_stat_order 8
		                test          $40
		                pvalue_raw     8
		                pvalue        $8
		                isvar         $8
            		;
		            if 0; /* create test data skeleton */
		        run;
				%return; /* --- EXIT --- */
			%end;


	/* ----- [byvar] provided ----- */

	/* get two-sample test results */
	%if %_count_obs(tbl.byvar_out) = 2 %then %do;
		/* two-sample t-test */
		proc ttest data = tbl.data_macro;
			class &byvar;
			var &statvar;
			ods output ttests = tbl.outtest_numeric1 equality = tbl.out_eq;
		run;

		/* check equality of variance between samples */
		data _NULL_; set tbl.out_eq;
			if ProbF <0.05 then pooled_sig = "Unequal";
				else pooled_sig = "Equal";
			call symputx("pooled_sig", pooled_sig);
		run;

		/* only keep result which matches variance test */
		data tbl.outtest_numeric1;
			set tbl.outtest_numeric1(rename=(Variable=var_name));
			if Variances = "&pooled_sig";
			pvalue_raw = Probt;
			if pvalue_raw <0.001 then pvalue = "<0.001";
				else if pvalue_raw <0.01 then pvalue = round(pvalue_raw, 0.001);
				else pvalue = round(pvalue_raw, 0.01);
			test = "t-test";
			keep var_name pvalue_raw pvalue test;
		run;


		/* Wilcoxon rank-sum */
		proc npar1way data = tbl.data_macro wilcoxon;
			class &byvar;
			var &statvar;
			ods output WilcoxonTest = tbl.outtest_numeric2;
		run;

		/* clean test results */
		data tbl.outtest_numeric2;
			set tbl.outtest_numeric2(rename=(Variable=var_name));
			if Name1 = "PT2_WIL";
			pvalue_raw = nValue1;
			if pvalue_raw <0.001 then pvalue = "<0.001";
				else if pvalue_raw <0.01 then pvalue = round(pvalue_raw, 0.001);
				else pvalue = round(pvalue_raw, 0.01);
			test = "Wilcoxon rank-sum test";
			keep var_name pvalue_raw pvalue test;
		run;
	%end;

	/* get multi-sample (3+) test results */
	%if %_count_obs(tbl.byvar_out) >2 %then %do;
		/* ANOVA */
		proc glm data = tbl.data_macro;
			class &byvar;
			model &statvar = &byvar;
			ods output ModelANOVA = tbl.outtest_numeric1;
		run; quit;

		/* clean test results */	
		data tbl.outtest_numeric1;
			length test $40;
			set tbl.outtest_numeric1(rename=(Dependent=var_name));
			pvalue_raw = ProbF;
			if pvalue_raw <0.001 then pvalue_temp = "<0.001";
				else if pvalue_raw >0.99 then pvalue_temp = ">0.99";
				else if pvalue_raw <0.01 then pvalue_temp = round(pvalue_raw, 0.001);
				else pvalue_temp = round(pvalue_raw, 0.01);
			pvalue = put(pvalue_temp, 6.);

			test = "ANOVA";
			keep var_name pvalue_raw pvalue test;
		run;


		/* Kruskal-Wallis test */
		proc npar1way data = tbl.data_macro wilcoxon;
			class &byvar;
			var &statvar;
			ods output KruskalWallisTest = tbl.outtest_numeric2;
		run;

		/* clean test results */
		data tbl.outtest_numeric2;
			length test $40;
			set tbl.outtest_numeric2(rename=(Variable=var_name));
			if Name1 = "P_KW";

			pvalue_raw = nValue1;
			if pvalue_raw <0.001 then pvalue_temp = "<0.001";
				else if pvalue_raw >0.99 then pvalue_temp = ">0.99";
				else if pvalue_raw <0.01 then pvalue_temp = round(pvalue_raw, 0.001);
				else pvalue_temp = round(pvalue_raw, 0.01);
			pvalue = put(pvalue_temp, 6.);

			test = "Kruskal-Wallis test";
			keep var_name pvalue_raw pvalue test;
		run;
	%end;

	/* stack parametric/nonparametric results */
	data tbl.outtest_numeric;
		length tag_stat $20 tag_stat_order 8 test $40;
		set tbl.outtest_numeric1(in=dnum1) tbl.outtest_numeric2(in=dnum2);
		if dnum1 then do; tag_stat = "Parametric";    tag_stat_order = 1; end;
		if dnum2 then do; tag_stat = "Nonparametric"; tag_stat_order = 2; end;
	run;

	/* get copy of this output saved as generic name */
	data tbl.outtest; set tbl.outtest_numeric; run;

%mend _get_test_numeric;





/* -_-_-_-_-_-_-_-_ %_get_stats_categorical() _-_-_-_-_-_-_-_- */

/* CREATES: [tbl.outstats_categorical] */

%macro _get_stats_categorical(byvar=);
	
	/* calculate global values */
	%let n_total   = %_count_obs(tbl.data_macro);
	%let n_nonmiss = %_count_obs(tbl.data_macro(where=(not missing(&statvar))));

	/* write order for categorical levels (by frequency) */
	proc freq data=tbl.data_macro noprint; 
		tables &statvar / out=tbl.statvar_out;
	run;
	proc sort data=tbl.statvar_out; by descending COUNT; run;

	data tbl.statvar_out;
		set tbl.statvar_out(drop = PERCENT);
		tag_stat_order = _N_;
		rename COUNT = statvar_count;
		if missing(&statvar) then do; 
			&statvar = "Missing"; tag_stat_order = 999; 
		end;
    run;

			/* ----- no [byvar] provided ----- */
			%if &_has_byvar = NO %then %do;

				/* build one overall column */
				data tbl.outstats_categorical;
					length 
						&statvar $200 var_name $200 
						tag_stat $20 tag_type $20 tag_stat_order 8 isvar $8 n $20;
					set tbl.statvar_out end = last;

					/* create stats for each subgroup */
					prop = round((statvar_count / &n_total)*100, 0.1);
					col1 = cat(statvar_count, ' (', prop, '%)');
					var_name = &statvar;
					tag_stat = "Categorical"; tag_type = "Categorical"; isvar = "No";
					n = put(&n_nonmiss, 12.);
					output;

					/* create blank row for variable name */
					if last then do; 
						var_name = "&statvar"; 
						tag_stat_order = 0; 
						isvar = "Yes";
						col1 = ""; 
						output; 
					end;
					drop &statvar prop statvar_count;
				run;

				/* save a copy to main name */
				data tbl.outstats; set tbl.outstats_categorical; run;

				%return; /* --- EXIT --- */
			%end;


	/* ----- [byvar] provided ----- */

	/* generate all descriptive statistics */
	proc freq data = tbl.data_macro;
		tables &byvar*&statvar / 
			missprint outpct outexpect 
			out = tbl.freqs_out;
	run;

	/* sort and merge by [byvar] */
	proc sort data = tbl.freqs_out; by &byvar; run;
	proc sort data = tbl.byvar_out; by &byvar; run;

	data tbl.freqs_out;
		merge tbl.freqs_out tbl.byvar_out;
		by &byvar;
		if missing(&statvar) then &statvar = "Missing";
	run;

	/* sort and merge by [statvar] */
	proc sort data=tbl.freqs_out; by &statvar; run;
	proc sort data=tbl.statvar_out; by &statvar; run;

	/* generate tag for missing data (so it always is ordered last) */
	/* clean up freq (%) data and make template space for "All" column */
	data tbl.outstats_categorical;
		length &statvar $200;
		merge tbl.freqs_out tbl.statvar_out;
		by &statvar;

		if byvar_count >0 then prop_freq = round((COUNT/byvar_count)*100, 0.1);
			else prop_freq =.;
		stat_freq = cat(COUNT, ' (', prop_freq, '%)');
		output;
		if last.&statvar then do;
			&byvar =''; byvar_order = 0; output;
		end;
	run;
	proc sort data=tbl.outstats_categorical; by byvar_order tag_stat_order; run;

	/* clean up data for "All" column */
	data tbl.outstats_categorical;
		length &byvar $200;
		set tbl.outstats_categorical;
		if missing(&byvar) then do; 
			&byvar = "All Levels";
			prop_freq = round((statvar_count/&n_total)*100, 0.1);
			stat_freq = cat(statvar_count, ' (', prop_freq, '%)');
		end;
	run;
	proc sort data=tbl.outstats_categorical; by tag_stat_order byvar_order; run;

	/* transpose sorted data so it displays in correct final columns */
	proc transpose data=tbl.outstats_categorical out=tbl.outstats_categorical(drop = _NAME_);
		by tag_stat_order;
		var stat_freq;
	run;

	/* sort and merge by [tag_stat_order] */
	proc sort data=tbl.statvar_out; by tag_stat_order; run;
	proc sort data=tbl.outstats_categorical; by tag_stat_order; run;

	/* build final stats columns */
	data tbl.outstats_categorical;
		length 
			&statvar $200 var_name $200 
			tag_stat $20 tag_type $20 tag_stat_order 8 isvar $8 n $20;
		merge 
			tbl.statvar_out(rename=(&statvar = var_name) drop=statvar_count) 
			tbl.outstats_categorical 
			end = last;
		by tag_stat_order;

		/* treat instances of 0 cell counts */
		array vars{*} _CHARACTER_;
		do i = 1 to dim(vars);
			if missing(vars(i)) then vars(i) = "0 (0%)";
		end;
		tag_stat = "Categorical"; tag_type = "Categorical"; isvar = "No";
		n = put(&n_nonmiss, 12.); 
		output;

		/* create blank row for variable name */
		if last then do;
			var_name = "&statvar"; 
			tag_stat_order = 0;
			isvar = "Yes";
			do j = 1 to dim(vars); 
				if upcase(substr(vname(vars[j]),1,3)) = 'COL' then vars[j] = ""; 
			end;
			output;
		end;
		drop i j;
	run;

	/* save a copy to main name */
	data tbl.outstats; set tbl.outstats_categorical; run;

%mend _get_stats_categorical;





/* -_-_-_-_-_-_-_-_ %_get_test_categorical() _-_-_-_-_-_-_-_- */

/* CREATES: [tbl.outtest_categorical] */

%macro _get_test_categorical(byvar=);

			/* ----- no [byvar] provided ----- */
			%if &_has_byvar = NO %then %do;
				data tbl.outtest;
            		length
		                var_name      $200
		                tag_stat      $20
		                tag_stat_order 8
		                test          $40
		                pvalue_raw     8
		                pvalue        $8
		                isvar         $8
            		;
		            if 0; /* create test data skeleton */
		        run;
				%return; /* --- EXIT --- */
			%end;


	/* ----- [byvar] provided ----- */

	/* extract both test results (chi-squared and exact test) */
	proc freq data = tbl.data_macro;
		tables &byvar*&statvar / 
			chisq exact outexpect 
			out = tbl.out_expect;
			ods output ChiSq = tbl.chisq FishersExact = tbl.fisher;
	run;

	/* flag all cells where expected count is low */
	data tbl.out_expect;
		set tbl.out_expect(keep = EXPECTED);
		where EXPECTED ~=.;
		anchor = "Anchor"; row_number = _N_;
		if EXPECTED <5 then check_expected = 1; else check_expected = 0;
	run;

	/* create macro variable for percentage of low expected cell counts */
	data tbl.out_expect;
		set tbl.out_expect;
		by anchor;
		retain low_expected;
		if first.anchor then low_expected = check_expected*100;
			else low_expected = low_expected + (check_expected*100);
		if last.anchor then low_expected = low_expected / row_number;
		if last.anchor;
		call symputx("low_expected", low_expected);
	run;

	/* pick test based on expected cell count criteria (<20% with 5 or lower) */
	%if &low_expected >20 %then %do;
		data _NULL_;
			set tbl.fisher;
			where Name1 = "XP2_FISH";
			call symputx("pvalue_raw", nValue1);
		run;
	%end;
	%if &low_expected <=20 %then %do;
		data _NULL_;
			set tbl.chisq;
			where Statistic = "Chi-Square";
			call symputx("pvalue_raw", Prob);
		run;
	%end;

	/* create dataset for categorical results */
	data tbl.outtest_categorical;
		length var_name $200 tag_stat $20 test $40;
		var_name = "&statvar";
		pvalue_raw = &pvalue_raw;
		pvalue = "Placeholder";
		if &low_expected >20 then test = "Fisher's exact test";
			else test = "Chi-squared test";
		if &low_expected <=20 then tag_stat = "Parametric";
			else tag_stat = "Nonparametric";
		isvar = "Yes";
	run;

	/* clean p-value */
	data tbl.outtest_categorical;
		set tbl.outtest_categorical;
		if pvalue_raw <0.001 then pvalue_temp = "<0.001";
			else if pvalue_raw >0.99 then pvalue_temp = ">0.99";
			else if pvalue_raw <0.01 then pvalue_temp = round(pvalue_raw, 0.001);
			else pvalue_temp = round(pvalue_raw, 0.01);
		pvalue = put(pvalue_temp, 6.);
		drop pvalue_temp;
	run;


	/* get copy of this output saved as generic name */
	data tbl.outtest; set tbl.outtest_categorical; run;

%mend _get_test_categorical;










/* -_-_-_-_-_-_-_-_ %tblmaker() _-_-_-_-_-_-_-_- */

/* CREATES: [WORK.tbl] -- final product for summary table */

%macro tblmaker(
	data, 						/* specify dataset for table */
	byvar, 						/* specify stratification variable */
	missing_row = YES, 			/* [ YES | NO ];    toggle missing data rows */
	ncol = NO, 		        	/* [ YES | NO ];    toggle data frequency column */
	stat_continuous = MEAN, 	/* [ MEAN MEDIAN ]; list for continuous variables */
	add_p = NO,            		/* [ YES | NO ];    toggle p-value */
	add_testflag = NO			/* [ YES | NO ];    toggle statistical test */
);
	
	ods exclude all;
	ods escapechar='^';

	/* sanitize user inputs (remove stray quotes/spaces and fix caps) */
	%macro _validate(val); %local _cleaned_val;
		%let _cleaned_val = &val;
		%let _cleaned_val = %sysfunc(strip(%superq(_cleaned_val)));
		%let _cleaned_val = %upcase(%superq(_cleaned_val));
		%let _cleaned_val = %sysfunc(compress(&_cleaned_val, %str(%")));
		%let _cleaned_val = %sysfunc(compress(&_cleaned_val, %str(%')));
		&_cleaned_val
	%mend _validate;

	%local _byvar _missing_row _ncol _stat_continuous _add_p _add_testflag;
	%let _byvar  	  	  = %_validate(&byvar);
	%let _missing_row  	  = %_validate(&missing_row);
	%let _ncol 		      = %_validate(&ncol);
	%let _stat_continuous = %_validate(&stat_continuous);
	%let _add_p           = %_validate(&add_p);
	%let _add_testflag    = %_validate(&add_testflag);

	/* check request for continuous statistics */
	%local _need_mean _need_median;
	%let _need_mean   = %eval(%sysfunc(indexw(&_stat_continuous, MEAN)) >0);
	%let _need_median = %eval(%sysfunc(indexw(&_stat_continuous, MEDIAN)) >0);

	/* default for bad user input */
    %if (&_need_mean = 0 and &_need_median = 0) %then %do;
        %let _need_mean = 1;
    %end;

	/* create internal flag to check if [byvar] is present */
	%local _has_byvar;
	%if %sysevalf(%superq(_byvar)=, boolean) or &_byvar = BYVAR_TEMP %then
		%let _has_byvar = NO;
	%else %let _has_byvar = YES;

	/* create a folder [TBL] for temporary datasets */
	%if %sysfunc(libref(tbl)) = 0 %then %do;
		proc datasets lib=tbl nolist kill; quit;
	%end;

	%let outdir = %sysfunc(getoption(work));
	options dlcreatedir;
	libname tbl "&outdir./tbl";

	/* create copy of input data */
	data tbl.data_macro; set &data; run;
	

	/* --- DEFINED ON LINE 40 --- */
	%_get_contents(byvar = &_byvar);


	/* loops actions through all content variables */
	%if %sysevalf(%superq(num_vars)=,boolean) %then %let num_vars=0;
	%if &num_vars >0 %then %do iGlobal = 1 %to &num_vars; 

		/* find name and type of present variable */
		data _NULL_; set tbl.contents;
			if contents_order = &iGlobal;
			call symputx("statvar", var_name);
			call symputx("statvar_type", TYPE);
		run;

		/* check of variable is numeric */
		%if &statvar_type = 1 %then %do; 

			/* --- DEFINED ON LINE XXX --- */
			%_get_stats_numeric(byvar = &_byvar);
			/* --- DEFINED ON LINE XXX --- */
			%_get_test_numeric(byvar = &_byvar);

			/* sort variable summaries before merging */
			proc sort data = tbl.outstats; by var_name tag_stat_order; run;
			proc sort data = tbl.outtest;  by var_name tag_stat_order; run;

			/* create variable info that will go in final table */
			data tbl.outtable_temp_num;
				merge tbl.outstats tbl.outtest;
				by var_name tag_stat_order;
				tbl_order = &iGlobal;
			run;
			data tbl.outtable_temp; set tbl.outtable_temp_num; run;

		%end;

		/* check of variable is numeric */
		%if &statvar_type = 2 %then %do; 

			/* --- DEFINED ON LINE XXX --- */
			%_get_stats_categorical(byvar = &_byvar);
			/* --- DEFINED ON LINE XXX --- */
			%_get_test_categorical(byvar = &_byvar);

			/* sort variable summaries before merging */
			proc sort data = tbl.outstats; by var_name; run;
		
			/* create variable info that will go in final table */
			data tbl.outtable_temp_cat;
				merge tbl.outstats tbl.outtest;
				by var_name;
				tbl_order = &iGlobal;
			run;
			data tbl.outtable_temp; set tbl.outtable_temp_cat; run;

		%end;

		/* combine info for all table variables */
		%if &iGlobal = 1 %then %do;
			data tbl.outtable; set tbl.outtable_temp; run;
		%end;

		%if &iGlobal >1 %then %do;
			data tbl.outtable; 
				length var_name $200;
				set tbl.outtable tbl.outtable_temp; 
			run;
		%end;

	/* end global loop */
	%end;

	/* create copy for diagnostics */
	proc sort data = tbl.outtable out = tbl.outtable_check1;
		by tbl_order tag_stat_order;
	run;

	/* --- TABLE DESIGN --- */


	/* control input parameters for table design */
	/* choose continuous stats, missing data input */
	data tbl.outtable;
		set tbl.outtable;
		if tag_type = "Numeric" then do;
			if tag_stat = "Parametric" and (&_need_mean = 0) then delete;
			if tag_stat = "Nonparametric" then do;
				if (&_need_median = 0) then delete;
				if (&_need_mean = 1 and &_need_median = 1) then var_name = "";
			end;
			if var_name = "Missing" and col1 = "0 (0%)" then delete;
        end;
		if (var_name = "Missing" and &_missing_row = NO) then delete;
	run;

	/* create copy for diagnostics */
	proc sort data = tbl.outtable out = tbl.outtable_check2;
		by tbl_order tag_stat_order;
	run;

	/* sort datasets to merge labels together */
	proc sort data = tbl.outtable; by var_name; run;
	proc sort data = tbl.contents; by var_name; run;

	/* add in row labels */
	data tbl.outtable;
		merge tbl.outtable tbl.contents;
		by var_name;
		label var_name = "^{newline}Characteristic"
			  pvalue   = "^{newline}p-value^{super 2}"
			  test 	   = "^{newline}Test"
			  n 	   = "^{newline}n";
		if not missing(LABEL) then var_name = LABEL;
		drop LABEL TYPE VARNUM contents_order;
	run;

	/* hide test/pvalue columns and suppress footnote if requested */
	%if (&_add_p = NO and &_add_testflag = NO) or &_has_byvar = NO %then %do;
		data tbl.outtable; set tbl.outtable; drop test pvalue; run;
		%let test_list =;  
	%end;
	%else %do;
		/* create a list of all tests performed for the footnote */
		proc sql noprint;
			select distinct strip(test)
			into :test_list separated by '; '
			from tbl.outtable
			where not missing(test);
		quit;
	%end;

	/* add labels onto final table columns */
	%macro _label; %local _label_count;

		%if &_has_byvar = YES %then
			%let _label_count = %eval(%_count_obs(tbl.byvar_out) +1);
		%else %let _label_count = 1;

		%do iLabel = 1 %to &_label_count;
			data _NULL_;
				set tbl.byvar_labels(obs=1);
				call symputx("label", col&iLabel);
			run;

			data tbl.outtable;
				set tbl.outtable;
				label col&iLabel = "&label";
			run;
		%end;

	%mend _label;
	%_label;

	/* create column list from [byvar] */
	%macro _col_list; %local i k list;
		%if &_has_byvar = YES %then %let k = %eval(%_count_obs(tbl.byvar_out) + 1); 
			%else %let k = 1; /* limit loop span to 1:1 */
		%let list=;
		%do i=1 %to &k; %let list=&list col&i; %end;
		&list
	%mend _col_list;

	/* reorder rows for final table */
	proc sort data = tbl.outtable;
		by tbl_order tag_stat_order;
	run;
	
	/* drop variables only used for table aesthetics */
	data tbl.outtable;
		retain var_name n;
		set tbl.outtable;
		if missing(tag_type) then delete;
		if isvar^="Yes" then n="";
		drop tag_stat tag_type var_name_label tag_stat_order tbl_order pvalue_raw;
	run;	

	/* control columns for user inputs */
	%if &_ncol = NO %then %do;
		data tbl.outtable; set tbl.outtable; drop n; run;
	%end;

	%if &_add_p = NO %then %do;
		data tbl.outtable; set tbl.outtable; drop pvalue; run;
	%end;

	%if &_add_testflag = NO %then %do;
		data tbl.outtable; set tbl.outtable; drop test; run;
	%end;

	/* drop extra columns if no byvar is selected */
	%if &_has_byvar = NO %then %do;
		data tbl.outtable;
			set tbl.outtable;
			%if &_add_p = NO %then %do; drop pvalue; %end;
			%if &_add_testflag = NO %then %do; drop test; %end;
		run;
	%end;

	/* make a copy of the output table in work directory */
	data tbl; set tbl.outtable; run;

	/* create a list of all variable names */
	proc sql noprint;
	    select distinct var_name_label
	    into :var_list separated by ' '
	    from tbl.contents;
	quit;

	ods exclude none;
	
	/* print final table */
	proc report data = tbl nowd;

		columns 
			isvar
			var_name 
			%if &_ncol ~= NO %then n;
			%_col_list
			%if &_add_testflag = YES %then test;
			%if &_add_p = YES %then pvalue;
		;

		define isvar 	/ noprint;
		define var_name / display "^{newline}Characteristic" style(column)=[just=l];
		%if &_add_testflag = YES %then %do; define test / display "^{newline}Test"; %end;
		%if &_add_p = YES %then %do; define pvalue / display '^{newline}p-value^{super 2}'; %end;
		%if &_ncol = YES %then %do; define n / display '^{newline}n'; %end;

		compute var_name;
		if isvar = "Yes" then 
			call define(_col_, "style", "style=[font_weight=bold indent=0]");
		else if var_name = "Missing" then
			call define(_col_, "style", "style=[font_style=italic indent=1%]");
		else 
			call define(_col_, "style", "style=[indent=1%]");
		endcomp;

		compute after;
			%if (&_need_mean = 1 and &_need_median = 0) %then %do;
				line @1 "^{super 1}n (%); Mean (SD)";
			%end;
			%else %if (&_need_mean = 0 and &_need_median = 1) %then %do;
				line @1 "^{super 1}n (%); Median (IQR)";
			%end;
			%else %do;
				line @1 "^{super 1}n (%); Mean (SD) and Median (IQR)";
			%end;
			%if %length(%superq(test_list)) %then %do;
				line @1 "^{super 2}&test_list";
			%end;
		endcomp;
	run;

%mend tblmaker;




data baseball;
	set SASHELP.baseball;
	keep League division crruns crrbi natbat nAssts;
run;

/*
%tblmaker(
	data = baseball,
	byvar = League,
	add_p = yes,
	add_testflag = yes
);
*/

%tblmaker(
	data = baseball
);


