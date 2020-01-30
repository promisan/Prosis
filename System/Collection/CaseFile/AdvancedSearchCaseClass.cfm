																	
<cfquery name = "CaseFileClass"  
	  datasource="AppsCaseFile" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	    SELECT   DISTINCT CL.Code, CL.Description
	    FROM     Claim C INNER JOIN
	             Ref_ClaimTypeClass CL ON C.ClaimTypeClass = CL.Code INNER JOIN
	             Ref_ClaimType R ON C.ClaimType = R.Code AND C.ClaimType = R.Code
	    WHERE    C.Mission   = '#url.mission#'
		<cfif url.casetype neq "Any">
		AND      C.ClaimType = '#url.casetype#'
		</cfif>
	    ORDER BY CL.Code
</cfquery>	

	
<select name="CaseClass" style="font:12px" id="CaseClass">

          <option value="Any"><cf_tl id="Any"></option>
		<cfoutput query="CaseFileClass">
		  <option value="#Code#">#Description#</option>
		</cfoutput>
		
</select>					