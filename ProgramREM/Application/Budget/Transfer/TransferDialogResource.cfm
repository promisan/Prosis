
<cfquery name="Edition" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_AllotmentEdition E, Ref_AllotmentVersion V
	WHERE  EditionId = '#URL.EditionId#'	
	AND    E.Version = V.Code	
</cfquery>	

<cfquery name="Param" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_ParameterMission	
	WHERE  Mission = '#Edition.Mission#'	 
</cfquery>

<cfquery name="Resource" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Ref_Resource
	WHERE  Code IN (SELECT Resource 
	                FROM   Ref_Object 
					WHERE  ObjectUsage = '#Edition.ObjectUsage#'
					<!---
					AND    Code IN (SELECT ObjectCode 
	                                FROM ProgramAllotmentDetail
									WHERE ProgramCode IN (SELECT ProgramCode
									                      FROM   Program 
														  WHERE  Mission = '#URL.Mission#') 
			       	) --->
			 ) 	
	ORDER BY ListingOrder		 
</cfquery>

<cfoutput>

<select name="resource" class="regularxl" id="resource" onchange="resetfrom();resetto()">
    <option value="">--- <cf_tl id="select"> ---</option>
	<cfif param.BudgetTransferMode eq "2">
	  <option value="any">[<cf_tl id="Between classes">]</option>
	</cfif>
	<cfloop query="resource">
		<option value="#code#">#Description#</option>
	</cfloop>
</select>	

</cfoutput>

