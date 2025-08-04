<!--
    Copyright © 2025 Promisan

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
		
<!--- register fields --->

		<cfquery name="Fields" 
		datasource="AppsSystem">		
			SELECT * 
			FROM   UserReportOutput
			WHERE  UserAccount   = '#SESSION.acc#'
			AND    OutputId      IN (SELECT OutputId FROM UserPivot WHERE ControlId = '#id#')
			AND    OutputClass   = 'Detail' 
			AND    OutputEnabled = 1
			ORDER BY FieldNameOrder 
		</cfquery>
		
		<cfif Fields.recordcount eq "0">
		
			<!--- disabled the warning
			
			<cf_waitEnd>
			<cf_message 
			    message="No fields have been selected. Please select the [Fields] tab" 
				return="No">
			<cfexit method="EXITTEMPLATE">		
			
			--->
		
		<cfelse>
		
			<cfloop query="Fields">
			
				<cfif currentRow eq "1">
				
			       <cfset value = FieldName>
				   
				   <cfif OutputHeader eq "">
				       <cfset header  = "#FieldName#">
				   <cfelse>
				       <cfset header  = "#OutputHeader#">
				   </cfif>
	
				   <cfset order   = "#FieldNameOrder#">
				   
				   <cfif OutputWidth lte "5">
				   	<cfset width   = "30">
				   <cfelse>
				    <cfset width   = "#OutputWidth#">
				   </cfif>
				   
				   <cfif OutputFormat eq "">
				      <cfset format  = "varchar">
				   <cfelse>
				      <cfset format  = OutputFormat>
				   </cfif>
				   
				   <cfset color   = "#OutputColor#">
				    
			   <cfelse>
			   
			       <cfset value   = "#value#|#FieldName#">
			       
				   <cfif OutputHeader eq "">
				       <cfset header  = "#header#|#FieldName#">
				   <cfelse>
				       <cfset header  = "#header#|#OutputHeader#">
				   </cfif>
				   
				   <cfset order   = "#order#|#FieldNameOrder#">
				   
				   <cfif OutputWidth lte "5">
				       <cfset width   = "#width#|30">
				   <cfelse>
					   <cfset width   = "#width#|#OutputWidth#">
				   </cfif>	
				   
				   <cfif OutputFormat eq "">
				      <cfset format  = "#format#|varchar">
				   <cfelse>
				      <cfset format  = "#format#|#OutputFormat#">
				   </cfif>
				   
				   <cfset color   = "#color#|#OutputColor#"> 
				   
			   </cfif>	
			   
			</cfloop>   
			
		</cfif>	
							  
		<cfinvoke component="Service.Analysis.CrossTab"  
			  method="Dimension"
			  ControlId            = "#id#"
			  Presentation         = "Details"
			  FieldName            = "Details"
			  ListingOrder         = "#order#"
			  FieldWidth           = "#width#"
			  FieldValue           = "#value#"
			  FieldDataType        = "#format#"
			  FieldHeader          = "#header#"
			  FieldColor           = "#color#"
			  FieldTooltip         = "#header#"/>	    