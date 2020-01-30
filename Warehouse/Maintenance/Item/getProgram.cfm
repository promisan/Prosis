<cfparam name="URL.Mission" default="">
<cfparam name="URL.ItemNo" default="">
<cfparam name="URL.Mode" default="Entry">
<cfparam name="URL.FieldName" default="">
<cfparam name="client.ProgramCode" default="">


<cfif URL.Mode eq "Entry"> 
	<cfquery name="qItem" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
   	SELECT * 
   	FROM   Item
   	WHERE  ItemNo = '#URL.ItemNo#'
	</cfquery>

	<cfquery name="qProgram" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
   	SELECT * 
   	FROM   Program
   	WHERE  ProgramClass = 'Project'
   	AND    Mission = '#url.mission#'
   	ORDER BY Created DESC	   
	</cfquery>	
	
	<select name="programcode" id="programcode" class="regularxl">	
	    <option value=""><cf_tl id="Not applicable"></option>	
		<cfoutput query="qProgram">
			<option value="#ProgramCode#" <cfif ProgramCode eq qItem.ProgramCode>selected</cfif>>#ProgramName#</option>
		</cfoutput>
	</select>
<cfelse>

	<cfif URL.FieldName neq "">
		
		<cfif url.mission neq "">
			<cfquery name="qProgram" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
   			SELECT DISTINCT P.ProgramCode,P.ProgramName,P.Created  
   			FROM   Program P INNER JOIN Materials.dbo.Item I 
   			ON P.ProgramCode = I.ProgramCode 
   			AND P.ProgramClass = 'Project'
   			AND P.Mission = I.Mission 
 			AND P.Mission = '#url.mission#'
   			ORDER BY P.Created DESC	   
			</cfquery>		
			
			<cfoutput>
			<select name="#url.fieldName#" id="#url.fieldName#" class="regularxl">	
		    	<option value="">--<cf_tl id="Any">--</option>	
				<cfloop query="qProgram">
					<option value="#ProgramCode#" <cfif ProgramCode eq client.ProgramCode>selected</cfif>>#ProgramName#</option>
				</cfloop>
			</select>
			</cfoutput>
	 	<cfelse>
	 		<INPUT type="hidden" name="#url.fieldName#" id="#url.fieldName#" value="">
	 	
	  	</cfif>	
	</cfif>

</cfif>	
