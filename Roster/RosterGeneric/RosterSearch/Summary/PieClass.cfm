
<cfquery name="SearchAction" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM RosterSearch
  WHERE SearchId = '#URL.ID1#'
</cfquery>

<cfquery name="Class" 
     datasource="AppsSelection" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
  SELECT Ref.Description, count(R.PersonNo) as Total
  FROM RosterSearchResult R, Applicant A, Ref_ApplicantClass Ref
  WHERE R.PersonNo = A.PersonNo
  AND Ref.ApplicantClassId = A.ApplicantClass
  AND R.SearchId = '#URL.ID1#'
  GROUP BY Ref.Description
</cfquery>

<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">

<tr><td>

<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">

<tr><td align="center" class="labellarge" style="color:#808080;"><cf_tl id="By Class"></td></tr>

<tr>

<td align="center">

<cfif Class.recordcount gt 0>

<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
<cfchart 
	style = "#chartStyleFile#" 
	format="png" 
	chartheight="300" 
	chartwidth="480" 
	pieslicestyle="sliced">

		<cfchartseries 
			type="pie" 
			query="Class" 
			itemcolumn="Description" 
			valuecolumn="Total" 
			seriescolor="FFFFCC" 
			paintstyle="raise" 
			markerstyle="circle" 
			colorlist="#vColorlist#">
		</cfchartseries>
		
</cfchart>
</cfif>

</td>
</tr>

</table>

</tr>

</table>

</html>
