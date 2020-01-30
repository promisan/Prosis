
<cfquery name="Program" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT     Pe.reference, P.*
		FROM       ProgramPeriod Pe, Program P
		WHERE      Pe.ProgramCode = P.ProgramCode
		AND        Pe.Period   = '#url.period#'
		
		AND        Pe.OrgUnit  = '#url.orgunit#'
		
		AND        Pe.Status       != '9'
		AND        Pe.RecordStatus != '9'
		<!---
		AND        P.ProgramCode IN (SELECT  ProgramCode 
		                              FROM   ProgramAllotment
									   WHERE ProgramCode = P.ProgramCode 
									   AND   Period    = '#url.period#' 
									   AND   EditionId = '#url.editionid#')
									   --->
		ORDER By reference
		
</cfquery>

<cfoutput>		
			   
	<select name="programcode" id="programcode" class="regularxl"
	   onchange="ColdFusion.navigate('../Request/RequestSummary.cfm?history=no&summarymode=program&editionid=#url.editionid#&period=#url.period#&programcode='+this.value,'programtarget')">
	   <cfloop query="Program">
	   <option value="#ProgramCode#" <cfif url.programcode eq programcode>selected</cfif>>#Reference# #ProgramName# [#ProgramCode#]</option>
	   </cfloop>				   
	</select>	

</cfoutput>
