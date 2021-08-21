
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
  SELECT N.Name, count(R.PersonNo) as Total
  FROM PersonSearchResult R, Person A, System.dbo.Ref_Nation N
  WHERE R.PersonNo = A.PersonNo
  AND R.SearchId = #URL.ID1#
  AND N.Code = A.Nationality
  AND N.Continent = '#URL.ID2#'
  GROUP BY N.Name
</cfquery>

<cfif Graph.recordCount neq "0">

<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0">

<tr class="line" style="border-top:1px solid silver"><td align="center" style="height:30px" class="labellarge"><cf_tl id="Distribution by Country"></td></tr>
<tr><td align="center"></td></tr>
<tr><td align="center">

<cf_getChartStyle chartLocation="#GetCurrentTemplatePath()#">
<cfchart style = "#chartStyleFile#" format="html"
           chartheight="360"
           chartwidth="670"
           showygridlines="no"
           seriesplacement="default"
           labelformat="number"
           sortxaxis="yes"
           show3d="no"
           tipstyle="mouseOver"
           tipbgcolor="00000000"
           pieslicestyle="solid">

<cfchartseries
             type="pie"
             query="Graph"
             itemcolumn="Name"
             valuecolumn="Total"
             serieslabel="Country"
			 colorlist="##5DB7E8,##E8875D,##E8BC5D,##CCCA6A,##339AFA,##66AC6A,##999A9A,##FFFA9A,##996AFA"
             paintstyle="raise"
             markerstyle="circle"></cfchartseries>

</cfchart>
</td>
</tr>

<tr><td height="10"></td></tr>

</table>

</cfif>
