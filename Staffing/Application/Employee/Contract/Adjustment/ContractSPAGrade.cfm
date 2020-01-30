<cfquery name="qGrade" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT DISTINCT ServiceStep
  		FROM SalaryScaleLine
	    WHERE ServiceLevel = '#URL.Grade#' 
	    ORDER BY ServiceStep ASC
</cfquery>

<select name="contractstep" id="contractstep" class="regularxl">

	<cfoutput query="qGrade">
	 	<option value="#ServiceStep#" <cfif url.select eq servicestep>selected</cfif>>#ServiceStep#
	</cfoutput>		
	
</select>
