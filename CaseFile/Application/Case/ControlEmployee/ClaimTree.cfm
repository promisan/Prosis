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
<table width="100%" class="formpadding">

<cfinvoke component = "Service.Access"  
   method           = "CaseFileManager" 	   
   returnvariable   = "accessLevel"
   Mission          = "#url.mission#">	   

<tr><td height="3"></td></tr>

<cfoutput>

<cfif accesslevel eq "ALL" or accessLevel eq "EDIT">			  
				
	<tr class="labelmedium line"><td style="height:22;padding-left:10px">	
	<a href="javascript:showclaim('','#URL.mission#')"><cf_tl id="Record New Case"></a>
	</td></tr>
				  
</cfif>		  

<tr class="labelmedium line"><td style="height:10;padding-left:10px">
<a href="javascript:printme("><cf_tl id="Print"></a>
</td></tr>

</cfoutput>

<tr><td valign="top" width="100%" height="100%"  style="padding-top:8px;padding-left:8px;">

    <cf_UItree id="root" expand="Yes" Root="No">	

			<cfset Mission = URL.mission>
						
			<cfinclude template="ClaimTreeOrganization.cfm">
			
			<!--- check if we have workflow status --->
									
			<cfquery name="Status" 
			  datasource="AppsCaseFile" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			    SELECT   E.EntityCode,
				         E.EntityStatus, 
				         E.StatusDescription						 
			    FROM     Organization.dbo.Ref_EntityStatus E
			    WHERE    E.EntityCode IN (SELECT 'Clm'+Code 
				                          FROM   Ref_ClaimTypeTab 
										  WHERE  Mission = '#mission#')
				ORDER BY EntityCode, EntityStatus						  
			</cfquery>		
			
			<cfif Status.recordcount gte "1">
			
				<cfoutput query="Status" group="EntityCode">		
				
						<cf_tl id="File status" var="1">		
						
						 <cf_UItreeitem value="#EntityCode#"
					        display = "<span style='font-size:16px;font-weight:bold;padding-top:3px;padding-bottom:3px' class='labelit'>#lt_text#</span>"
							parent  = "root"														
							target  = "right"
					        expand  = "Yes">							
												
					<cfoutput>	
					
						<cf_UItreeitem value="#EntityCode#_#EntityStatus#"
					        display = "<span style='font-size:14px' class='labelit'>#StatusDescription#</span>"
							parent  = "#EntityCode#"														
							target  = "right"
							href="javascript:list('status','#EntityStatus#','#mission#')"
					        expand  = "No">									
						
					</cfoutput>
					
			    </cfoutput>		
			
			<cfelse>	
								
				<cfquery name="Step" 
					datasource="AppsCaseFile"
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT *
					FROM     Ref_Status
					WHERE    StatusClass = 'clm'
					AND      Status IN (SELECT ActionStatus FROM Claim WHERE Mission = '#mission#')
				    ORDER BY ListingOrder
				</cfquery>	 	
					
				<cfoutput query="Step" group="StatusClass">					
				
					 <cf_UItreeitem value="#statusclass#"
					        display = "<span style='font-size:16px;font-weight:bold;padding-top:3px;padding-bottom:3px' class='labelit'>Case File Status</span>"
							parent  = "root"														
							target  = "right"
					        expand  = "Yes">	
												
					<cfoutput>	
					
						<cf_UItreeitem value="#statusclass#_#status#"
					        display = "<span style='font-size:14px' class='labelit'>#Description#</span>"
							parent  = "#StatusClass#"														
							target  = "right"
							href="javascript:list('status','#status#','#mission#')"
					        expand  = "No">								
						
					</cfoutput>
					
			    </cfoutput>		
				
			</cfif>	
				
				
			<cfquery name="Loc" 
				datasource="AppsCaseFile"
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT DISTINCT C.Location, C.Casualty, R.Name
					FROM   ClaimIncident C INNER JOIN System.dbo.Ref_Nation R ON C.Location = R.Code
					WHERE  Location <> '-'
					AND    ClaimId IN (SELECT ClaimId FROM Claim WHERE Mission = '#mission#')
					<cfif accessLevel eq "NONE">
					<!--- check if person has been granted access on-the-fly to the workflow on the claim level --->
					
					AND    ClaimId IN (SELECT DISTINCT O.ObjectKeyValue4
									   FROM   Organization.dbo.OrganizationObject AS O INNER JOIN
						                      Organization.dbo.OrganizationObjectActionAccess AS A ON O.ObjectId = A.ObjectId
									   WHERE  O.EntityCode = 'ClmNoticas' 									 
									   AND    A.UserAccount = '#SESSION.acc#'
									   )
									   
					</cfif>				 
				
			</cfquery>	 
			
			<cfif Loc.recordcount gt "0">
			
				 <cf_UItreeitem value="Loc"
					        display = "<span style='font-size:16px;font-weight:bold;padding-top:3px;padding-bottom:3px' class='labelit'>Location</span>"
							parent  = "root"														
							target  = "right"
					        expand  = "No">										
					
				<cfoutput query="Loc" group="Location">		
				
				    <cfif name neq "">	
					
						<cf_UItreeitem value="#location#"
					        display = "<span style='font-size:14px' class='labelit'>#Name#</span>"
							parent  = "Loc"														
							target  = "right"
							href    = "javascript:list('nation','#location#')"
					        expand  = "No">								
													
						<cfoutput>	
						
							<cf_UItreeitem value="#location#_#casualty#"
					        display = "<span style='font-size:14px' class='labelit'>#Casualty#</span>"
							parent  = "#location#"														
							target  = "right"
							href    = "javascript:list('nation','#location#','#casualty#')"
					        expand  = "No">																	
							
						 </cfoutput>
					 
					</cfif>	 
					
			    </cfoutput>	
			
			</cfif>	
			
	</cf_UItree>
			

</td></tr></table>


