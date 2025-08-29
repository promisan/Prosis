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
<cfoutput>

<cf_tl id = "A rule with this code has been registered already!" var = "vAlready"> 

<cfif url.id1 eq ""> 

	<cfquery name="Verify" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Ref_BusinessRule
			WHERE 	Code  = '#Form.Code#' 
	</cfquery>
	
	   <cfif Verify.recordCount gt 0>
	   
		   <script language="JavaScript">
		   
		    	alert("#vAlready#");
				history.go(-1);
		     
		   </script>  
	  
	   <cfelse>
	   
			<cfquery name="Insert" 
				datasource="appsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO Ref_BusinessRule
						(
							Code,
							TriggerGroup,
							RuleClass,
							Description,
							<cfif trim(Form.MessagePerson) neq "">MessagePerson,</cfif>
							ValidationPath,
							ValidationTemplate,
							Color,
							Operational,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName
						)
					VALUES
						(
							'#Form.Code#',
							'#Form.TriggerGroup#',
							'#Form.RuleClass#',
							'#Form.Description#',
							<cfif trim(Form.MessagePerson) neq "">'#Form.MessagePerson#',</cfif>
							'#Form.ValidationPath#',
							'#Form.ValidationTemplate#',
							'#Form.Color#',
							#Form.Operational#,
							'#SESSION.acc#',
							'#SESSION.last#',
							'#SESSION.first#'
						)
			</cfquery>
			
			<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
		     action="Insert"
			 content="#form#">				
			
			<cfset url.code = form.code>
			<cfinclude template="RecordSubmitMission.cfm">
			
			<script language="JavaScript">
   
			     window.close()
				 opener.location.reload()
        
			</script> 
			  
	    </cfif>		  
           
<cfelse>


	<cfquery name="Update" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_BusinessRule
		SET 
	    	TriggerGroup    	= '#Form.TriggerGroup#',
			RuleClass			= '#Form.RuleClass#',
			Description			= '#Form.Description#',
			MessagePerson		= <cfif trim(Form.MessagePerson) eq "">null<cfelse>'#Form.MessagePerson#'</cfif>,
			ValidationPath 		= '#Form.ValidationPath#',
			ValidationTemplate	= '#Form.ValidationTemplate#',
			Color				= '#Form.Color#',
			Operational			= #Form.Operational#
		WHERE Code         		= '#Form.CodeOld#'
	</cfquery>
	
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
     action="Update"
	 content="#form#">				
	
	
	<cfset url.code = form.codeOld>
	<cfinclude template="RecordSubmitMission.cfm">
	
	<script language="JavaScript">
   
	     window.close()
		 opener.location.reload()
        
	</script>

</cfif>

</cfoutput>



