<html>
<head>
<title>Untitled Document</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 
</head>

<cfquery name="SearchAction" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   RosterSearch
    WHERE  SearchId = '#URL.ID1#'
</cfquery>

<cfquery name="Graph" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	  SELECT N.Continent, count(R.PersonNo) as Total
	  FROM   RosterSearchResult R, Applicant A, System.dbo.Ref_Nation N
	  WHERE  R.PersonNo = A.PersonNo
	  AND    R.SearchId = #URL.ID1#
	  AND    N.Code = A.Nationality
	  GROUP BY N.Continent    
</cfquery>

<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">

<tr><td>

<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">


<tr><td align="center" class="labellarge" style="color:#808080;"><cf_tl id="By Continent"></td></tr>
<tr>

<td align="center">

<cf_uichart name="Continent" format="png" 
	 chartheight="300" 
	 chartwidth="600">
	
	<cf_uichartseries type="pie" 
	  query="#Graph#" 
	  itemcolumn="Continent" 
	  valuecolumn="Total" 
	  seriescolor="##FFFFCC" 
	  paintstyle="raise" 
	  markerstyle="circle"
	  colorlist="#vColorlist#">
	</cf_uichartseries>

</cf_uichart>
</td>

</tr>

</table>

</tr>

</table>

</html>
