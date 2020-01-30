<cf_param name="url.target" default="" type="string">
<cf_param name="url.validationactionid" default="" type="string">

<cfif url.validationactionid eq "">

	<cfset color = "81EA53">	
	<table width="97%" height="65" align="center" bgcolor="#color#">	
		<tr><td valign="top" height="100%" class="labelit" style="padding-top:4px;padding-left:4px"><cf_tl id="No exceptions found"></td></tr>	
	</table>

<cfelse>
	
	<cfquery name="get" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   ValidationAction VA INNER JOIN
	               Ref_Validation R ON VA.ValidationCode = R.ValidationCode
			WHERE  ValidationActionId = '#url.validationactionid#'
	</cfquery>					  
	
	<cfinvoke component = "Service.Validation.#get.SystemModule#"  
		   method                = "#get.ValidationMethod#" 		
		   validationActionId    = "#url.validationactionid#"				      
		   ValidationCode   	 = "#get.ValidationCode#"
		   mission               = "#get.Mission#" 
		   Owner                 = "#get.Owner#" 
		   Object                = "#get.Object#"
		   ObjectKeyvalue1       = "#get.ObjectKeyValue1#"
		   ObjectKeyvalue2       = "#get.ObjectKeyValue2#"
		   ObjectKeyvalue3       = "#get.ObjectKeyValue3#"
		   ObjectKeyvalue4       = "#get.ObjectKeyValue4#"
		   Target			     = "#URL.target#"
		   returnvariable        = "validationResult">		
		   
	<cfparam name="ValidationResult.Pass"     default="OK">	  
	
	<!--- this contains a list of items to be process by the user  --->
	
	<cfparam name="ValidationResult.PassMemo" default="">	   
	
	<cfoutput>
	<cfif ValidationResult.Pass eq "No">
	 	<cfset color = "ffffcf">
	<cfelse>
		<cfset color = "81EA53">	 
	</cfif>
	
	<cfif NOT structKeyExists(ValidationResult, "height")>
		<cfset vHeight = "auto">
	<cfelse>
		<cfif ValidationResult.height eq "">
			<cfset vHeight = "auto">
		<cfelse>
			<cfset vHeight = ValidationResult.height>	
		</cfif>
	</cfif>	
				
	<table width="96%" height="#vHeight#" align="center">	
		<tr><td valign="top" height="100%" class="labelit" style="padding-top:5px;padding-left:5px;padding-bottom:15px;">#ValidationResult.Passmemo#</td></tr>	
	</table>
	
	</cfoutput>

</cfif>	