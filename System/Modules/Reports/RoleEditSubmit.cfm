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
<cfquery name="MissionList" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT 	R.*
	    FROM  	Ref_Mission R 	
		WHERE 	R.Operational = 1	
</cfquery>

<cfquery name="Class" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT * 
	 FROM   Ref_AuthorizationRole
	 WHERE  Role = '#Form.Role#'	  
</cfquery>

<cftransaction>

	<cfquery name="check" 
		    datasource="AppsSystem" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			SELECT * FROM Ref_ReportControlRole				
			WHERE ControlId 	= '#url.id#'
			AND Role 			= '#url.role#' 
		 </cfquery>

	<cfif url.role eq "" and check.recordcount eq "0">
	
		<cfquery name="Insert" 
		     datasource="AppsSystem" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO Ref_ReportControlRole 
		         (ControlId,
				 Role,
				 ClassParameter,			 
				 Delegation,
				 Operational,
				 OfficerUserId,
				 OfficerLastName,
				 OfficerFirstName)
		      VALUES ('#URL.ID#',
		      	  '#form.Role#',
				  <cfif Class.Parameter eq "Owner">'#form.classparameter#'<cfelse>NULL</cfif>,
				  <cfif isDefined("form.roledelegation")>1<cfelse>0</cfif>,
				  <cfif isDefined("form.roleoperational")>1<cfelse>0</cfif>,
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
		</cfquery>
		
	<cfelse>
	
		<cfquery name="Update" 
		    datasource="AppsSystem" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
			    UPDATE Ref_ReportControlRole
				  SET Operational = <cfif isDefined("form.roleoperational")>1<cfelse>0</cfif>,
				      <cfif Class.Parameter eq "Owner">
				      ClassParameter = '#form.classparameter#',
					  </cfif>
				      Delegation = <cfif isDefined("form.roledelegation")>1<cfelse>0</cfif>
				 WHERE ControlId 	= '#url.id#'
				 AND Role 			= '#url.role#' 
		 </cfquery>
				
		<cfquery name="clear" 
		    datasource="AppsSystem" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">
		    DELETE FROM Ref_ReportControlRoleMission		
		    WHERE ControlId = '#url.id#'
			AND   Role 		= '#url.role#' 
		</cfquery>
	
	</cfif>
	
	<cfloop query="MissionList">
		<cfset vMission = replace(mission, "-", "_", "ALL")>
		<cfif isDefined("form.mission_#vMission#")>
			<cfquery name="Insert" 
			    datasource="AppsSystem" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			    INSERT INTO Ref_ReportControlRoleMission		
					(ControlId,Role,Mission) 
				VALUES 
					('#URL.ID#','#form.role#','#mission#')
			</cfquery>
		</cfif>
	</cfloop>

</cftransaction>

<cfoutput>
	<script>
	    parent.parent.rolerefresh('#url.status#','#url.id#')
		parent.parent.ProsisUI.closeWindow('myrole',true)	
	</script>
</cfoutput>