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

<!--- Select projects for this user --->

<!--- check --->

<cfquery name="Request" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_Request
		WHERE  Code = '#url.requesttype#'
</cfquery>	

<!--- show the projects for the warehouses this person is allwed to submit --->
								
<cfif Request.ForceProgram eq "1">
	
	<cfquery name="Program" 
		datasource="AppsProgram" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   Program
			
			WHERE  Mission = '#url.mission#'
			AND    ProgramCode IN (SELECT ProgramCode 
			                       FROM   Materials.dbo.WarehouseProgram
								   WHERE  Warehouse IN (SELECT Warehouse 
								                        FROM   Materials.dbo.Warehouse W
														WHERE  1=1
														
														<!--- only the valid warehouses --->
																												
														<cfif getAdministrator(url.mission) eq "1">
	
														<!--- no filtering --->
																											
														<cfelse>
														
											            AND (
														       W. MissionOrgUnitId IN (
												                       SELECT MissionOrgUnitId
												                       FROM   Organization.dbo.Organization Org, 
																	          Organization.dbo.OrganizationAuthorization O, 
																			  Organization.dbo.Ref_EntityAction A
																	   WHERE  O.UserAccount = '#SESSION.acc#'									   
																	   AND    O.Role        = 'WhsRequester'		
																	   AND    O.OrgUnit     = Org.OrgUnit									   
																	   AND    A.ActionCode  = O.ClassParameter
																	   AND    A.ActionType  = 'Create' 
																   )
													        OR 
														
														      W.Mission  IN (
															           SELECT Mission 
												                       FROM   Organization.dbo.OrganizationAuthorization O, Organization.dbo.Ref_EntityAction A 
																	   WHERE  O.UserAccount = '#SESSION.acc#'
																	   AND    O.Role        = 'WhsRequester'		
																	   AND    O.Mission     = '#url.mission#'		
																	   AND    A.ActionCode  = O.ClassParameter
																	   AND    A.ActionType  = 'Create'		   
																	   AND    (O.OrgUnit is NULL or O.OrgUnit = 0)
			                                                          )   
			                                           )
													   													   
													 </cfif>  
													 
													) 
			
									)																			
													
			 AND    ProgramClass != 'Program'			   
			 			
	</cfquery>
	
	<cfif Program.recordcount gte "1">
	
	    <script>
			document.getElementById("projectbox").className = "regular"
		</script>
		
		
		<select name="ProgramCode" id="ProgramCode" class="regularxl" style="width:328">
			<cfoutput query="Program">
			<option value="#ProgramCode#">#ProgramName#</option>
			</cfoutput>
		</select>
		
	<cfelse>
	
		 <script>
			document.getElementById("projectbox").className = "hide"
		</script>	
	
	</cfif>
	
<cfelse>

	 <script>
		document.getElementById("projectbox").className = "hide"
	</script>	

</cfif>
