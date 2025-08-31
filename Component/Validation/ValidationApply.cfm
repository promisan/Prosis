<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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