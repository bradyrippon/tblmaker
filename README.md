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

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<meta name="Generator" content="SAS Software Version 9.4, see www.sas.com">
<meta http-equiv="Content-type" content="text/html; charset=windows-1252">
<title>SAS Output</title>
<style type="text/css">
<!--
.aftercaption
{
  background-color: #FAFBFE;
  border-spacing: 0px;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
  padding-top: 4pt;
}
.batch
{
  background-color: #FAFBFE;
  border: 1px solid #C1C1C1;
  border-collapse: separate;
  border-spacing: 1px;
  color: #000000;
  font-family: 'SAS Monospace', 'Courier New', Courier, monospace;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  padding: 7px;
}
.beforecaption
{
  background-color: #FAFBFE;
  border-spacing: 0px;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.body
{
  background-color: #FAFBFE;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  margin-left: 8px;
  margin-right: 8px;
}
.bodydate
{
  background-color: #FAFBFE;
  border-spacing: 0px;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  text-align: right;
  vertical-align: top;
  width: 100%;
}
.bycontentfolder
{
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  list-style-type: none;
  margin-left: 6pt;
}
.byline
{
  background-color: #FAFBFE;
  border-spacing: 0px;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.bylinecontainer
{
  background-color: #FAFBFE;
  border: 0px solid #000000;
  border-spacing: 1px;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  width: 100%;
}
.caption
{
  background-color: #FAFBFE;
  border-spacing: 0px;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.cell
{
  background-color: #FAFBFE;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.container
{
  background-color: #FAFBFE;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.contentfolder
{
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  list-style-type: none;
  margin-left: 6pt;
}
.contentitem
{
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  list-style-type: none;
  margin-left: 6pt;
}
.contentproclabel
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.contentprocname
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.contents
{
  background-color: #FAFBFE;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  list-style-type: decimal;
  margin-left: 8px;
  margin-right: 8px;
}
.contentsdate
{
  background-color: #FAFBFE;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  width: 100%;
}
.contenttitle
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: italic;
  font-weight: bold;
}
.continued
{
  background-color: #FAFBFE;
  border-spacing: 0px;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
  width: 100%;
}
.data
{
  background-color: #FFFFFF;
  border-bottom-width: 1px;
  border-color: #C1C1C1;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.dataemphasis
{
  background-color: #FFFFFF;
  border-bottom-width: 1px;
  border-color: #C1C1C1;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.dataemphasisfixed
{
  background-color: #FFFFFF;
  border-bottom-width: 1px;
  border-color: #C1C1C1;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  font-family: 'Courier New', Courier, monospace;
  font-size: x-small;
  font-style: italic;
  font-weight: normal;
}
.dataempty
{
  background-color: #FFFFFF;
  border-bottom-width: 1px;
  border-color: #C1C1C1;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.datafixed
{
  background-color: #FFFFFF;
  border-bottom-width: 1px;
  border-color: #C1C1C1;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  font-family: 'Courier New', Courier;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.datastrong
{
  background-color: #FFFFFF;
  border-bottom-width: 1px;
  border-color: #C1C1C1;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.datastrongfixed
{
  background-color: #FFFFFF;
  border-bottom-width: 1px;
  border-color: #C1C1C1;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  color: #000000;
  font-family: 'Courier New', Courier, monospace;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.date
{
  background-color: #FAFBFE;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  width: 100%;
}
.document
{
  background-color: #FAFBFE;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
a:link {
color:#0000FF
}
a:visited {
color:#800080
}
a:active {
color:#800080
}
.errorbanner
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.errorcontent
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.errorcontentfixed
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: 'Courier New', Courier;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.extendedpage
{
  background-color: #FAFBFE;
  border: 1pt solid #000000;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: italic;
  font-weight: normal;
  text-align: center;
}
.fatalbanner
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.fatalcontent
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.fatalcontentfixed
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: 'Courier New', Courier;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.folderaction
{
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  list-style-type: none;
  margin-left: 6pt;
}
.footer
{
  background-color: #EDF2F9;
  border-bottom-width: 1px;
  border-color: #B0B7BB;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.footeremphasis
{
  background-color: #EDF2F9;
  border-bottom-width: 1px;
  border-color: #B0B7BB;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: italic;
  font-weight: normal;
}
.footeremphasisfixed
{
  background-color: #EDF2F9;
  border-bottom-width: 1px;
  border-color: #B0B7BB;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  color: #112277;
  font-family: 'Courier New', Courier, monospace;
  font-size: x-small;
  font-style: italic;
  font-weight: normal;
}
.footerempty
{
  background-color: #EDF2F9;
  border-bottom-width: 1px;
  border-color: #B0B7BB;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.footerfixed
{
  background-color: #EDF2F9;
  border-bottom-width: 1px;
  border-color: #B0B7BB;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  color: #112277;
  font-family: 'Courier New', Courier;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.footerstrong
{
  background-color: #EDF2F9;
  border-bottom-width: 1px;
  border-color: #B0B7BB;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.footerstrongfixed
{
  background-color: #EDF2F9;
  border-bottom-width: 1px;
  border-color: #B0B7BB;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  color: #112277;
  font-family: 'Courier New', Courier, monospace;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.frame
{
  background-color: #FAFBFE;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.graph
{
  background-color: #FAFBFE;
  border: 1px solid #C1C1C1;
  border-collapse: separate;
  border-spacing: 1px;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.header
{
  background-color: #EDF2F9;
  border-bottom-width: 1px;
  border-color: #B0B7BB;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.headeremphasis
{
  background-color: #D8DBD3;
  border-bottom-width: 1px;
  border-color: #B0B7BB;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: italic;
  font-weight: normal;
}
.headeremphasisfixed
{
  background-color: #D8DBD3;
  border-bottom-width: 1px;
  border-color: #B0B7BB;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  color: #000000;
  font-family: 'Courier New', Courier, monospace;
  font-size: x-small;
  font-style: italic;
  font-weight: normal;
}
.headerempty
{
  background-color: #EDF2F9;
  border-bottom-width: 1px;
  border-color: #B0B7BB;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.headerfixed
{
  background-color: #EDF2F9;
  border-bottom-width: 1px;
  border-color: #B0B7BB;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  color: #112277;
  font-family: 'Courier New', Courier;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.headersandfooters
{
  background-color: #EDF2F9;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.headerstrong
{
  background-color: #D8DBD3;
  border-bottom-width: 1px;
  border-color: #B0B7BB;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.headerstrongfixed
{
  background-color: #D8DBD3;
  border-bottom-width: 1px;
  border-color: #B0B7BB;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  color: #000000;
  font-family: 'Courier New', Courier, monospace;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.heading1
{
  font-family: Arial, Helvetica, sans-serif;
}
.heading2
{
  font-family: Arial, Helvetica, sans-serif;
}
.heading3
{
  font-family: Arial, Helvetica, sans-serif;
}
.heading4
{
  font-family: Arial, Helvetica, sans-serif;
}
.heading5
{
  font-family: Arial, Helvetica, sans-serif;
}
.heading6
{
  font-family: Arial, Helvetica, sans-serif;
}
.index
{
  background-color: #FAFBFE;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.indexaction
{
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  list-style-type: none;
  margin-left: 6pt;
}
.indexitem
{
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  list-style-type: none;
  margin-left: 6pt;
}
.indexprocname
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.indextitle
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: italic;
  font-weight: bold;
}
.layoutcontainer
{
  border: 0px solid #000000;
  border-spacing: 30px;
}
.layoutregion
{
  border: 0px solid #000000;
  border-spacing: 30px;
}
.linecontent
{
  background-color: #FAFBFE;
  border-bottom-width: 1px;
  border-color: #C1C1C1;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.list
{
  background-color: #FAFBFE;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  list-style-type: disc;
}
.list10
{
  background-color: #FAFBFE;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  list-style-type: square;
}
.list2
{
  background-color: #FAFBFE;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  list-style-type: circle;
}
.list3
{
  background-color: #FAFBFE;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  list-style-type: square;
}
.list4
{
  background-color: #FAFBFE;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  list-style-type: square;
}
.list5
{
  background-color: #FAFBFE;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  list-style-type: square;
}
.list6
{
  background-color: #FAFBFE;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  list-style-type: square;
}
.list7
{
  background-color: #FAFBFE;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  list-style-type: square;
}
.list8
{
  background-color: #FAFBFE;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  list-style-type: square;
}
.list9
{
  background-color: #FAFBFE;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  list-style-type: square;
}
.listitem
{
  background-color: #FAFBFE;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  list-style-type: disc;
}
.listitem10
{
  background-color: #FAFBFE;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  list-style-type: square;
}
.listitem2
{
  background-color: #FAFBFE;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  list-style-type: circle;
}
.listitem3
{
  background-color: #FAFBFE;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  list-style-type: square;
}
.listitem4
{
  background-color: #FAFBFE;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  list-style-type: square;
}
.listitem5
{
  background-color: #FAFBFE;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  list-style-type: square;
}
.listitem6
{
  background-color: #FAFBFE;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  list-style-type: square;
}
.listitem7
{
  background-color: #FAFBFE;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  list-style-type: square;
}
.listitem8
{
  background-color: #FAFBFE;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  list-style-type: square;
}
.listitem9
{
  background-color: #FAFBFE;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  list-style-type: square;
}
.note
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.notebanner
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.notecontent
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.notecontentfixed
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: 'Courier New', Courier;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.output
{
  background-color: #FAFBFE;
  border: 1px solid #C1C1C1;
  border-collapse: separate;
  border-spacing: 1px;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.pageno
{
  background-color: #FAFBFE;
  border-spacing: 0px;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
  text-align: right;
  vertical-align: top;
}
.pages
{
  background-color: #FAFBFE;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  list-style-type: decimal;
  margin-left: 8px;
  margin-right: 8px;
}
.pagesdate
{
  background-color: #FAFBFE;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  width: 100%;
}
.pagesitem
{
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  list-style-type: none;
  margin-left: 6pt;
}
.pagesproclabel
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.pagesprocname
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.pagestitle
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: italic;
  font-weight: bold;
}
.paragraph
{
  background-color: #FAFBFE;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.parskip
{
  border: 0px solid #000000;
  border-spacing: 0px;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.prepage
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  text-align: left;
}
.proctitle
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.proctitlefixed
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: 'Courier New', Courier, monospace;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.rowfooter
{
  background-color: #EDF2F9;
  border-bottom-width: 1px;
  border-color: #B0B7BB;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.rowfooteremphasis
{
  background-color: #EDF2F9;
  border-bottom-width: 1px;
  border-color: #B0B7BB;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: italic;
  font-weight: normal;
}
.rowfooteremphasisfixed
{
  background-color: #EDF2F9;
  border-bottom-width: 1px;
  border-color: #B0B7BB;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  color: #112277;
  font-family: 'Courier New', Courier, monospace;
  font-size: x-small;
  font-style: italic;
  font-weight: normal;
}
.rowfooterempty
{
  background-color: #EDF2F9;
  border-bottom-width: 1px;
  border-color: #B0B7BB;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.rowfooterfixed
{
  background-color: #EDF2F9;
  border-bottom-width: 1px;
  border-color: #B0B7BB;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  color: #112277;
  font-family: 'Courier New', Courier;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.rowfooterstrong
{
  background-color: #EDF2F9;
  border-bottom-width: 1px;
  border-color: #B0B7BB;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.rowfooterstrongfixed
{
  background-color: #EDF2F9;
  border-bottom-width: 1px;
  border-color: #B0B7BB;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  color: #112277;
  font-family: 'Courier New', Courier, monospace;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.rowheader
{
  background-color: #EDF2F9;
  border-bottom-width: 1px;
  border-color: #B0B7BB;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.rowheaderemphasis
{
  background-color: #EDF2F9;
  border-bottom-width: 1px;
  border-color: #B0B7BB;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: italic;
  font-weight: normal;
}
.rowheaderemphasisfixed
{
  background-color: #EDF2F9;
  border-bottom-width: 1px;
  border-color: #B0B7BB;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  color: #112277;
  font-family: 'Courier New', Courier, monospace;
  font-size: x-small;
  font-style: italic;
  font-weight: normal;
}
.rowheaderempty
{
  background-color: #EDF2F9;
  border-bottom-width: 1px;
  border-color: #B0B7BB;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.rowheaderfixed
{
  background-color: #EDF2F9;
  border-bottom-width: 1px;
  border-color: #B0B7BB;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  color: #112277;
  font-family: 'Courier New', Courier;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.rowheaderstrong
{
  background-color: #EDF2F9;
  border-bottom-width: 1px;
  border-color: #B0B7BB;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.rowheaderstrongfixed
{
  background-color: #EDF2F9;
  border-bottom-width: 1px;
  border-color: #B0B7BB;
  border-left-width: 0px;
  border-right-width: 1px;
  border-style: solid;
  border-top-width: 0px;
  color: #112277;
  font-family: 'Courier New', Courier, monospace;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.systemfooter
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.systemfooter10
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.systemfooter2
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.systemfooter3
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.systemfooter4
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.systemfooter5
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.systemfooter6
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.systemfooter7
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.systemfooter8
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.systemfooter9
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.systemtitle
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: small;
  font-style: normal;
  font-weight: bold;
}
.systemtitle10
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: small;
  font-style: normal;
  font-weight: bold;
}
.systemtitle2
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: small;
  font-style: normal;
  font-weight: bold;
}
.systemtitle3
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: small;
  font-style: normal;
  font-weight: bold;
}
.systemtitle4
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: small;
  font-style: normal;
  font-weight: bold;
}
.systemtitle5
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: small;
  font-style: normal;
  font-weight: bold;
}
.systemtitle6
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: small;
  font-style: normal;
  font-weight: bold;
}
.systemtitle7
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: small;
  font-style: normal;
  font-weight: bold;
}
.systemtitle8
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: small;
  font-style: normal;
  font-weight: bold;
}
.systemtitle9
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: small;
  font-style: normal;
  font-weight: bold;
}
.systitleandfootercontainer
{
  background-color: #FAFBFE;
  border: 0px solid #000000;
  border-spacing: 1px;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  width: 100%;
}
.table
{
  border-bottom-width: 0px;
  border-collapse: collapse;
  border-color: #C1C1C1;
  border-left-width: 1px;
  border-right-width: 0px;
  border-spacing: 0px;
  border-style: solid;
  border-top-width: 1px;
}
.top_stacked_value
{
  padding-bottom: 1px;
  border: 0;
}
.middle_stacked_value
{
  padding-top: 1px;
  padding-bottom: 1px;
  border: 0;
}
.bottom_stacked_value
{
  padding-top: 1px;
  border: 0;
}
.titleandnotecontainer
{
  background-color: #FAFBFE;
  border: 0px solid #000000;
  border-spacing: 1px;
  color: #000000;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
  width: 100%;
}
.titlesandfooters
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.usertext
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.warnbanner
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: bold;
}
.warncontent
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: Arial, 'Albany AMT', Helvetica, Helv;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.warncontentfixed
{
  background-color: #FAFBFE;
  color: #112277;
  font-family: 'Courier New', Courier;
  font-size: x-small;
  font-style: normal;
  font-weight: normal;
}
.l {text-align: left }
.c {text-align: center }
.r {text-align: right }
.d {text-align: right }
.j {text-align: justify }
.t {vertical-align: top }
.m {vertical-align: middle }
.b {vertical-align: bottom }
TD, TH {vertical-align: top }
.stacked_cell{padding: 0 }
-->
</style>
<script language="javascript" type="text/javascript">
<!-- 
function startup(){

}
function shutdown(){

}

//-->
</script>

</head>
<body onload="startup()" onunload="shutdown()" class="body">

<script language="javascript" type="text/javascript">
<!-- 
var _info = navigator.userAgent
var _ie = (_info.indexOf("MSIE") > 0
          && _info.indexOf("Win") > 0
          && _info.indexOf("Windows 3.1") < 0);
var _ie64 = _info.indexOf("x64") > 0

//-->
</script>

<div class="branch">
</div>
<div class="branch">
</div>
<div class="branch">
</div>
<div class="branch">
</div>
<div class="branch">
</div>
<div class="branch">
</div>
<div class="branch">
</div>
<div class="branch">
</div>
<div class="branch">
</div>
<div class="branch">
</div>
<div class="branch">
</div>
<div class="branch">
</div>
<div class="branch">
<a name="IDX"></a>
<table class="systitleandfootercontainer" width="100%" cellspacing="1" cellpadding="1" rules="none" frame="void" border="0" summary="Page Layout">
<tr>
<td class="c systemtitle">The SAS System</td>
</tr>
</table><br>
<div>
<div align="center">
<table class="table" cellspacing="0" cellpadding="5" rules="all" frame="box" bordercolor="#C1C1C1" summary="Procedure Report: Detailed and/or summarized report">
<colgroup>
<col>
<col>
<col>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="c header" scope="col"><br/>
Characteristic</th>
<th class="c header" scope="col">All<sup>1</sup> <br/>
(n = 322)</th>
<th class="c header" scope="col">American<sup>1</sup> <br/>
(n = 175)</th>
<th class="c header" scope="col">National<sup>1</sup> <br/>
(n = 147)</th>
<th class="c header" scope="col"><br/>
p-value<sup>2</sup></th>
</tr>
</thead>
<tbody>
<tr>
<td class="l data" style=" font-weight: bold; text-indent: 0px;">Times at Bat in 1986</td>
<td class="l data">390.1 (143.6)</td>
<td class="l data">405.1 (145)</td>
<td class="l data">372.2 (140.3)</td>
<td class="l data">  0.04</td>
</tr>
<tr>
<td class="l data" style=" font-weight: bold; text-indent: 0px;">Career Runs</td>
<td class="l data">374.3 (336.4)</td>
<td class="l data">393.7 (325.6)</td>
<td class="l data">351.2 (348.6)</td>
<td class="l data">  0.26</td>
</tr>
<tr>
<td class="l data" style=" font-weight: bold; text-indent: 0px;">Career RBIs</td>
<td class="l data">347.6 (338.8)</td>
<td class="l data">367.1 (333)</td>
<td class="l data">324.4 (345.2)</td>
<td class="l data">  0.26</td>
</tr>
<tr>
<td class="l data" style=" font-weight: bold; text-indent: 0px;">Division at the End of 1986</td>
<td class="c data">&nbsp;</td>
<td class="c data">&nbsp;</td>
<td class="c data">&nbsp;</td>
<td class="l data">  0.94</td>
</tr>
<tr>
<td class="l data" style=" text-indent: 1%;">West</td>
<td class="l data">165 (51.2%)</td>
<td class="l data">90 (51.4%)</td>
<td class="l data">75 (51%)</td>
<td class="c data">&nbsp;</td>
</tr>
<tr>
<td class="l data" style=" text-indent: 1%;">East</td>
<td class="l data">157 (48.8%)</td>
<td class="l data">85 (48.6%)</td>
<td class="l data">72 (49%)</td>
<td class="c data">&nbsp;</td>
</tr>
<tr>
<td class="l data" style=" font-weight: bold; text-indent: 0px;">Assists in 1986</td>
<td class="l data">106.9 (136.9)</td>
<td class="l data">101.2 (134.4)</td>
<td class="l data">113.7 (139.9)</td>
<td class="l data">  0.42</td>
</tr>
<tr>
<td class="l linecontent" colspan="5"><sup>1</sup>n&nbsp;(%);&nbsp;Mean&nbsp;(SD)<br><sup>2</sup>Chi-squared&nbsp;test;&nbsp;t-test</td>
</tr>
</tbody>
</table>
</div>
</div>
<br>
</div>
<div class="branch">
</div>
<div class="branch">
</div>
<div class="branch">
</div>
<div class="branch">
</div>
<div class="branch">
</div>
<div class="branch">
</div>
<div class="branch">
</div>
<div class="branch">
<p style="page-break-after: always;"><br/></p><hr size="3"/>
<a name="IDX1"></a>
<table class="systitleandfootercontainer" width="100%" cellspacing="1" cellpadding="1" rules="none" frame="void" border="0" summary="Page Layout">
<tr>
<td class="c systemtitle">The SAS System</td>
</tr>
</table><br>
<div>
<div align="center">
<table class="table" cellspacing="0" cellpadding="5" rules="all" frame="box" bordercolor="#C1C1C1" summary="Procedure Report: Detailed and/or summarized report">
<colgroup>
<col>
<col>
</colgroup>
<thead>
<tr>
<th class="c header" scope="col"><br/>
Characteristic</th>
<th class="c header" scope="col">All<sup>1</sup> <br/>
(n = 322)</th>
</tr>
</thead>
<tbody>
<tr>
<td class="l data" style=" font-weight: bold; text-indent: 0px;">Times at Bat in 1986</td>
<td class="l data">390.1 (143.6)</td>
</tr>
<tr>
<td class="l data" style=" font-weight: bold; text-indent: 0px;">Career Runs</td>
<td class="l data">374.3 (336.4)</td>
</tr>
<tr>
<td class="l data" style=" font-weight: bold; text-indent: 0px;">Career RBIs</td>
<td class="l data">347.6 (338.8)</td>
</tr>
<tr>
<td class="l data" style=" font-weight: bold; text-indent: 0px;">League at the End of 1986</td>
<td class="c data">&nbsp;</td>
</tr>
<tr>
<td class="l data" style=" text-indent: 1%;">American</td>
<td class="l data">175 (54.3%)</td>
</tr>
<tr>
<td class="l data" style=" text-indent: 1%;">National</td>
<td class="l data">147 (45.7%)</td>
</tr>
<tr>
<td class="l data" style=" font-weight: bold; text-indent: 0px;">Division at the End of 1986</td>
<td class="c data">&nbsp;</td>
</tr>
<tr>
<td class="l data" style=" text-indent: 1%;">West</td>
<td class="l data">165 (51.2%)</td>
</tr>
<tr>
<td class="l data" style=" text-indent: 1%;">East</td>
<td class="l data">157 (48.8%)</td>
</tr>
<tr>
<td class="l data" style=" font-weight: bold; text-indent: 0px;">Assists in 1986</td>
<td class="l data">106.9 (136.9)</td>
</tr>
<tr>
<td class="l linecontent" colspan="2"><sup>1</sup>n&nbsp;(%);&nbsp;Mean&nbsp;(SD)</td>
</tr>
</tbody>
</table>
</div>
</div>
<br>
</div>


![summary table for SASHELP.baseball](https://github.com/bradyrippon/tblMaker/blob/main/figures/tbl-baseball.png)

### SASHELP.heart
```r
%tblmaker(
	data = SASHELP.heart(keep = status sex -- systolic chol_status bp_status),
	byvar = status
);
```
![summary table for SASHELP.heart](https://github.com/bradyrippon/tblMaker/blob/main/figures/tbl-heart.png)


