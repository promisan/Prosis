
<cfquery name="grade" 
datasource="AppsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT   DISTINCT D.PostGrade, P.PostOrder
FROM     Document D, Employee.dbo.Ref_PostGrade P
WHERE    D.PostGrade = P.PostGrade
<cfif url.mission neq "all">
AND      D.Mission = #PreserveSingleQuotes(url.Mission)#
</cfif>
AND      D.Status != '9'
ORDER BY P.PostOrder
</cfquery>

<select name="PostGrade" class="regularxxl">
    <option value="All" selected><cf_tl id="All"></option>
    <cfoutput query="Grade">
	<option value="'#PostGrade#'">
	#PostGrade#
	</option>
	</cfoutput>
</select>