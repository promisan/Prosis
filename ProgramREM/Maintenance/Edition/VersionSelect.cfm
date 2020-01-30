
<cfquery name="Version"
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_AllotmentVersion
	WHERE Mission = '#URL.Mission#' or Mission is NULL
	ORDER BY ListingOrder
</cfquery>

<select name="version" onchange="selected(period.value,mission.value,this.value)" class="regularxl">
   <option value="">--- select ---</option>
   <cfoutput query="Version">
     	<option value="#Code#">#Description#</option>
  	</cfoutput>
</select>