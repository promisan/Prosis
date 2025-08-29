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
<cfform action="ContractEditSubmit.cfm?action=#url.action#" method="POST" name="ContractEntry" onSubmit="#onsub#" style="width:100%">
		
	<table width="100%" align="center" class="formpadding">
	
	<cfif url.action eq "0">
			
		<tr class="fixrow">
			<td height="10" style="padding-left:7px">	
			  <cfset ctr      = "0">		
			  <cfset openmode = "close"> 
			  <cfinclude template="../PersonViewHeaderToggle.cfm">		  
			</td>
		</tr>	

	</cfif>
	
	<tr class="hide"><td id="process"></td></tr>
			
	<tr><td valign="top">
		
		<table width="100%" border="0" align="center">
				  
		  <!--- embedded form ---> 		 
		  
		  <cfinclude template="ContractEditForm.cfm">
		  
		  <cfoutput>
		  
		  <cfparam name="selact" default="">
		  
		  <script>
		  
			  function getreason() {					      
					_cf_loadingtexthtml='';		
					if (document.getElementById('groupfield')) {					
					ptoken.navigate('getReason.cfm?scope=edit&mission=#contractsel.mission#&actioncode=#selact#','groupfield') 
					}
			  }
					
		  </script>
		  </cfoutput>
		  
		  <cfif contractsel.mission neq "">
			
				<cfquery name="Check" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT *
					FROM   OrganizationObject
					WHERE  ObjectId   = '#url.id1#'
					AND    EntityCode = 'VacCandidate'  					
				</cfquery>
				
				<cfif check.recordcount eq "1">
												
				<!--- ---------------------------------------------------- --->
				<!--- ------workflow comes from A recruitment track ------ --->
				<!--- ----------THIS IS NOT RELEVANT ANYMORE-------------- --->
				
																		
					<cf_actionListingScript>
					<cf_FileLibraryScript>
					
					<cfquery name="getCandidate" 
					datasource="AppsVacancy" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM  DocumentCandidate
						WHERE DocumentNo = '#check.objectkeyvalue1#'
						AND   PersonNo   = '#check.objectkeyvalue2#'
					</cfquery>
					
					<cfoutput>
					
					<input type="hidden" 
						   name="workflowlink_mybox#getcandidate.Personno#" 
						   id="workflowlink_mybox#getcandidate.Personno#" 						   
						   value="#SESSION.root#/Vactrack/Application/Candidate/CandidateWorkflow.cfm">	
			
					<input type="hidden" 
						   name="workflowcondition_mybox#getcandidate.Personno#" 
						   value="?id=#check.objectkeyvalue1#&id1=#check.objectkeyvalue2#&ajaxid=mybox#getcandidate.Personno#">				   
							   
					</cfoutput>	   
							  	   	
					<tr><td colspan="12" align="center">
					
						<cf_securediv id="mybox#getcandidate.Personno#" 
						    bind="url:#SESSION.root#/Vactrack/Application/Candidate/CandidateWorkflow.cfm?id=#check.objectkeyvalue1#&id1=#check.objectkeyvalue2#&ajaxid=mybox#getcandidate.Personno#"/>   
								
					</td></tr> 
							
					<cfoutput>					
									
					<script>
					
					function arrival() {		   						
						ProsisUI.createWindow('myarrival', 'On boarding', '',{x:100,y:100,height:document.body.clientHeight-40,width:document.body.clientWidth-40,modal:false,resizable:false,center:true})    					
						ptoken.navigate('#SESSION.root#/Staffing/Application/Position/Lookup/PositionTrack.cfm?Source=vac&mission=#check.Mission#&mandateno=0000&applicantno=#check.objectkeyvalue2#&personno=#url.id#&recordid=#check.objectkeyvalue1#&documentno=#check.objectkeyvalue1#','myarrival') 	
					}
										
					function arrivalrefresh() {	
					    ptoken.navigate('#SESSION.root#/Vactrack/Application/Candidate/CandidateWorkflow.cfm?id=#check.objectkeyvalue1#&id1=#check.objectkeyvalue2#&ajaxid=mybox#getcandidate.Personno#','mybox#getcandidate.Personno#') 	
					}								
									
					</script>
					
					</cfoutput>
						
								   	
			   <cfelseif check.recordcount eq "0">
			   	   
			   	    <!--- verify if regular workflow is enabled --->
					
					<cfquery name="EntityClass" 
					   datasource="AppsEmployee" 
					   username="#SESSION.login#" 
					   password="#SESSION.dbpw#">
					      SELECT * 
						  FROM   Ref_ContractType
						  WHERE  ContractType =  '#ContractSel.ContractType#'		    			
						  AND    EntityClass IN (SELECT EntityClass
												 FROM   Organization.dbo.Ref_EntityClass
											 	 WHERE  EntityCode = 'PersonContract')
						</cfquery>
													  
					 <cfquery name="CheckMission" 
						 datasource="AppsOrganization"
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
								 SELECT   *
								 FROM     Ref_EntityMission 
								 WHERE    EntityCode     = 'PersonContract'  
								 AND      Mission        = '#ContractSel.Mission#' 
					  </cfquery>
						
					  <cfif CheckMission.WorkflowEnabled eq "0" or CheckMission.recordcount eq "0" 
					      or EntityClass.Recordcount eq "0">
			        				  
							  	<cfquery name="Deactivate" 
									datasource="AppsOrganization" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
										UPDATE OrganizationObject
										SET    Operational = '0'
										WHERE  ObjectkeyValue4 = '#contractsel.Contractid#'
								</cfquery>
								
								<cfquery name="Update" 
								   datasource="AppsEmployee" 
								   username="#SESSION.login#" 
								   password="#SESSION.dbpw#">
								   	  UPDATE PersonContract
									  SET    ActionStatus = '1'
									  WHERE  PersonNo    = '#url.id#' 
								        AND  ContractId = '#contractsel.Contractid#' 	 
								</cfquery>		
								
					  
					      <!--- workflow is disabled for this mission and as such will not be shown --->
					  
					  <cfelse>
					  					  
					   <!--- no a loaded contract and 
						             then only for pending contract the workflow is shown / triggered --->									 
												
				        <cfif ContractSel.HistoricContract eq "0" and 
						    (ContractSel.actionStatus eq "0" or 
							url.mycl eq "1" or 
							wfStatus eq "Open" or 
							(url.action eq "1" and wfExist eq "1"))>		
														  
					  	  <!--- show workflow --->
							 														
								<cfquery name="Person" 
								datasource="AppsEmployee" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									SELECT *
									FROM   Person
									WHERE  PersonNo = '#PersonNo#' 
								</cfquery>
								
								<!--- show workflow only if this a pending transaction --->
																										
								<cf_actionListingScript>
								<cf_FileLibraryScript>
								
								<cfoutput>	
								
									<cfset pk = contractsel.Contractid>																
									<input type="hidden" 
									   name="workflowlink_#pk#" 
									   id="workflowlink_#pk#" 									   
									   value="EmployeeContractWorkflow.cfm">	
										
									<tr>
									
										<td colspan="1" style="padding-left:16px;padding-right:35px">																				
											<cf_securediv id="#pk#"  bind="url:EmployeeContractWorkflow.cfm?ajaxid=#pk#"/>																						
										</td>
									
									</tr>	
														
								</cfoutput>							
														
						</cfif>	
						
					</cfif>	
				
				</cfif>	
				
		 </cfif>	
		
	</TABLE>

</td></tr>

</table>
	
</CFFORM>