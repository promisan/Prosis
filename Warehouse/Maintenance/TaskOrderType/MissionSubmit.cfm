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

<cfquery name="Exist" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT    	*
	FROM     	Ref_TaskTypeMission
	WHERE    	Code = '#Form.Code#'
    AND    		Mission  = '#Form.Mission#'
</cfquery>

<!--- <cfif ParameterExists(Form.Save)> 
	
	<cfif Exist.recordCount eq "0">
		
		<cfquery name="Insert" 
		     datasource="AppsMaterials" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			     INSERT INTO Ref_TaskTypeMission
			         	(Code,
						Mission,
						<cfif trim(Form.TaskOrderTemplate) neq "">TaskOrderTemplate,</cfif>
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName)
			      VALUES ('#Form.Code#',
				  		'#Form.Mission#',
						<cfif trim(Form.TaskOrderTemplate) neq "">'#Form.TaskOrderTemplate#',</cfif>
						'#SESSION.acc#',
						'#SESSION.last#',
						'#SESSION.first#')
		</cfquery>
		
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Insert" 
						 content="#Form#">
		
		<cfoutput>
			<script language="JavaScript">   
	     		ColdFusion.navigate('MissionListing.cfm?idmenu=#url.idmenu#&ID1=#Form.Code#', 'divMissions');
				ColdFusion.Window.hide('mydialog');
			</script>
		</cfoutput>
			
	<cfelse>
			
		<script>
			<cfoutput>
				alert("Sorry, but this entity already exists.")
			</cfoutput>
		</script>
				
	</cfif>	

</cfif> --->

<cfif ParameterExists(Form.Update)>	
	
	<cfif Exist.recordCount gt 0 and Form.Mission neq Form.MissionOld>
		
		<script>
			<cfoutput>
				alert("Sorry, this entity already exists.")
			</cfoutput>
		</script>				
			
	<cfelse>
					
		<cfquery name="Update" 
		     datasource="AppsMaterials" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		   	  	 UPDATE Ref_TaskTypeMission
				 SET	Mission           = '#Form.Mission#',
			 		TaskOrderTemplate = <cfif trim(Form.TaskOrderTemplate) neq "">'#Form.TaskOrderTemplate#'<cfelse>null</cfif>
			 	 WHERE 	Code   		      = '#Form.Code#'
			 	 AND	Mission           = '#Form.MissionOld#'
		</cfquery>
		
		<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Update" 
						 content="#Form#">
		
		<cfoutput>
			<script language="JavaScript">   
	     		ptoken.navigate('MissionListing.cfm?idmenu=#url.idmenu#&ID1=#Form.Code#', 'divMissions');
				ProsisUI.closeWindow('mydialog');
			</script>
		</cfoutput>
				
	</cfif>	

</cfif>

<!--- <cfif ParameterExists(Form.Delete)> 

    <cfquery name="Delete" 
	     datasource="AppsMaterials" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     DELETE FROM Ref_TaskTypeMission
		 WHERE 	Code       = '#Form.Code#'
		 AND	Mission    = '#Form.MissionOld#'
	</cfquery>	
	
	<cf_ModuleControlLog systemfunctionid="#url.idmenu#" 
	                     action="Delete" 
						 content="#Form#">
	
	<cfoutput>
		<script language="JavaScript">   
     		ColdFusion.navigate('MissionListing.cfm?idmenu=#url.idmenu#&ID1=#Form.Code#', 'divMissions');
			ColdFusion.Window.hide('mydialog');
		</script>
	</cfoutput>
	
</cfif> --->	
	  
	
