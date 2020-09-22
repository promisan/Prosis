
<cfquery name="SearchAction" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT *
  FROM PersonSearch
  WHERE SearchId = '#URL.ID1#'
</cfquery>

<cfquery name="Graph" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
  SELECT N.Continent, count(R.PersonNo) as Total
  FROM PersonSearchResult R, Person A, System.dbo.Ref_Nation N
  WHERE R.PersonNo = A.PersonNo
  AND R.SearchId = #URL.ID1#
  AND N.Code = A.Nationality
  GROUP BY N.Continent
    
</cfquery>

<cfif Graph.recordCount neq "0">

<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">

<tr><td align="center"><b><cf_tl id="Distribution by Continent"></b></td></tr>
<tr><td align="center" class="regular"></td></tr>
<tr><td align="center">

<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
<cfchart style = "#chartStyleFile#" format="html" 
    chartheight="300" chartwidth="600" showxgridlines="no" showygridlines="no" showborder="no" fontbold="no" 
	fontitalic="no" show3d="yes" rotated="no" sortxaxis="yes" showlegend="yes" 
	tipbgcolor="000000" 
	showmarkers="no" pieslicestyle="solid">

<cfchartseries type="pie" query="Graph" itemcolumn="Continent" valuecolumn="Total" serieslabel="Gender" seriescolor="##FFFFCC" paintstyle="raise" markerstyle="circle" colorlist="##6688aa ,##8EA4BB">
</cfchartseries>

</cfchart>
</td>
</tr>

<tr><td height="10"></td></tr>

</table>

</cfif>

