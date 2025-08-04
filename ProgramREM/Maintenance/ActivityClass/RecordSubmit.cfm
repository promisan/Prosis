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

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 


<cf_preventCache>

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
FROM Ref_ActivityClass
WHERE 
Code  = '#Form.Code#' 
</cfquery>

   <cfif #Verify.recordCount# is 1>
   
   <script language="JavaScript">
   
     alert("a record with this code has been registered already!")
     
   </script>  
  
   <cfelse>
   
		<CF_RegisterAction 
			SystemFunctionId="0999" 
			ActionClass="Code" 
			ActionType="Enter" 
			ActionReference="#Form.code#" 
			ActionScript="">   
		
		<cfquery name="Insert" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO Ref_ActivityClass
			         (code,
					 Description,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			  VALUES ('#Form.Code#',
			          '#Form.Description#', 
					  '#SESSION.acc#',
			    	  '#SESSION.last#',		  
				  	  '#SESSION.first#')
		</cfquery>
		
		<cfquery name="GetMissions" 
			datasource="AppsProgram" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT 	*
				FROM 	Ref_ParameterMission
		</cfquery>
		
		<cfloop query="GetMissions">
			<cfset missionId = replace(mission, " ", "", "ALL")>
			<cfset missionId = replace(missionId, "-", "", "ALL")>
			<cfif isDefined("Form.mission_#missionId#")>
				<cfquery name="InsertMission" 
					datasource="AppsProgram" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						INSERT INTO Ref_ActivityClassMission
							(
								Code,
								Mission,
								OfficerUserId,
								OfficerLastName,
								OfficerFirstName
							)
						VALUES
							(
								'#Form.Code#',
								'#mission#',
								'#SESSION.acc#',
						    	'#SESSION.last#',		  
							  	'#SESSION.first#'
							)
				</cfquery>
			</cfif>
		</cfloop>
				  	
	</cfif>		  
           
</cfif>

<cfif ParameterExists(Form.Update)>

	<CF_RegisterAction 
		SystemFunctionId="0999" 
		ActionClass="Code" 
		ActionType="Update" 
		ActionReference="#Form.Code#" 
		ActionScript="">   
	
	<cfquery name="Update" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			UPDATE Ref_ActivityClass
			SET 
			    Code           = '#Form.code#',
			    Description    = '#Form.Description#'
			WHERE code         = '#Form.CodeOld#'
	</cfquery>
	
	<cfquery name="ClearMissions" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE
			FROM 	Ref_ActivityClassMission
			WHERE	Code = '#Form.Code#'
	</cfquery>
	
	<cfquery name="GetMissions" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	*
			FROM 	Ref_ParameterMission
	</cfquery>
	
	<cfloop query="GetMissions">
		<cfset missionId = replace(mission, " ", "", "ALL")>
		<cfset missionId = replace(missionId, "-", "", "ALL")>
		<cfif isDefined("Form.mission_#missionId#")>
			<cfquery name="InsertMission" 
				datasource="AppsProgram" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					INSERT INTO Ref_ActivityClassMission
						(
							Code,
							Mission,
							OfficerUserId,
							OfficerLastName,
							OfficerFirstName
						)
					VALUES
						(
							'#Form.Code#',
							'#mission#',
							'#SESSION.acc#',
					    	'#SESSION.last#',		  
						  	'#SESSION.first#'
						)
			</cfquery>
		</cfif>
	</cfloop>

</cfif>	

<cfif ParameterExists(Form.Delete)> 

<cfquery name="CountRec" 
      datasource="AppsProgram" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT ActivityClass
      FROM ProgramActivityClass
      WHERE ActivityClass  = '#Form.codeOld#' 
    </cfquery>

    <cfif #CountRec.recordCount# gt 0>
		 
     <script language="JavaScript">
    
	   alert("Activity Class is in use. Operation aborted.")
	        
     </script>  
	 
    <cfelse>
	
	<CF_RegisterAction 
SystemFunctionId="0999" 
ActionClass="code" 
ActionType="Remove" 
ActionReference="#Form.codeOld#" 
ActionScript="">   
		
	<cfquery name="Delete" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
DELETE FROM Ref_ActivityClass
WHERE code = '#FORM.codeOld#'
    </cfquery>
	
	</cfif>
	
	
</cfif>	

<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  
