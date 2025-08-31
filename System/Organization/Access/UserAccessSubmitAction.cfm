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

	
<!--- save query for reuse --->

<cfsavecontent variable="condition">

	 (
	 	(OrgUnit = '#orgunit#') 	
		 <cfif role.MissionAsParameter eq "0"> 
		 OR (OrgUnit is NULL AND Mission = '#url.mission#')
		 <cfelse>
		 OR (OrgUnit is NULL)
		 </cfif>
		 OR (OrgUnit is NULL AND Mission is NULL)
	 ) 
	 AND  UserAccount = '#URL.ACC#'
	 AND  Role        = '#URL.ID#'
	 AND  ClassParameter = '#ClassParameter#'	 
	 <cfif GroupParameter neq "">
	 AND  GroupParameter = '#GroupParameter#' 
	 </cfif>
	 
</cfsavecontent>


<!--- it was detemrined that access was revoked --->
		
<cfif AccessLevel eq ""> 
	
	    <!--- check if also group access was granted for the revoked access record 
		this action should overrule the group access and be put in OrganizationAuthorizationDeny
		in order to prevent access is inherited	from the group at a later stage again
		--->
		
		<cfinvoke component="Service.Access.AccessLog"  
		  method               = "DeleteAccess"
		  ActionId             = "#rowguid#"
		  ActionStep           = "Delete Access Individual"
		  ActionStatus         = "9"
		  UserAccount          = "#URL.ACC#"
		  Condition            = "#condition#"
		  DeleteCondition      = ""
		  AddDeny              = "1"
		  AddDenyCondition     = "Source != 'Manual'">	 
				
<cfelse> 

	
        <!--- some access is granted but so check if group record exist in database 
		on a >>>HIGHER<<< level which should then be revoke --->
		
		<cfquery name="GroupEntry" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT  *
			FROM    OrganizationAuthorization 
			WHERE   #PreserveSingleQuotes(condition)#
			  AND   AccessLevel > '#AccessLevel#'
			  AND   Source != 'Manual' 
		</cfquery>		
							
		<cfif GroupEntry.recordCount gt "0">
				
			<!--- add record for group to denied and remove group entries --->
			
			<cfinvoke component="Service.Access.AccessLog"  
			  method               = "DeleteAccess"
			  ActionId             = "#rowguid#"
			  ActionStep           = "Change Access"
			  ActionStatus         = "9"
			  UserAccount          = "#URL.ACC#"
			  Condition            = "#condition#"
			  DeleteCondition      = "Source != 'Manual'"
			  AddDeny              = "1"
			  AddDenyCondition     = "Source != 'Manual'">	 			  
						
		</cfif> 	
				
		<!--- --------------------- --->		
		<!--- remove manual entries --->		
		<!--- --------------------- --->	
						
		<cfif orgunit neq "">
				
			<cfinvoke component  = "Service.Access.AccessLog"  
				  method               = "DeleteAccess"
				  ActionId             = "#rowguid#"
				  ActionStep           = "Change Access"
				  ActionStatus         = "9"
				  UserAccount          = "#URL.ACC#"
				  Condition            = "#condition#"
				  DeleteCondition      = "Source = 'Manual' AND OrgUnit is not NULL">		
				   
			  			  
		<cfelse>
		
			<cfinvoke component  = "Service.Access.AccessLog"  
				  method               = "DeleteAccess"
				  ActionId             = "#rowguid#"
				  ActionStep           = "Change Access"
				  ActionStatus         = "9"
				  UserAccount          = "#URL.ACC#"
				  Condition            = "#condition#"
				  DeleteCondition      = "Source = 'Manual'">	
				  				  	 
		</cfif>	 
																	
		<!--- check for remaining entries = group that MATCH the manual entry --->
		
		<cfquery name="Check" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   OrganizationAuthorization 
			WHERE  #PreserveSingleQuotes(condition)# 
			AND    Source = 'Manual'
			<!--- removed on 26/1/2011 for the requestid processing of a global role --->
			<cfif Role.OrgUnitLevel eq "Global">
			<cfelse>
			AND   AccessLevel = '#AccessLevel#'
			</cfif>			
		</cfquery>
												
		<!--- make an insert if needed --->					

		<cfif Check.recordcount eq "0"> <!--- and CheckManual.recordcount eq "0"> --->
		
		   <!--- first we check if we have group record for this combination
					which might have been denied before --->							
			 
		   <cfif accessmission neq "">					   					   
				 <cfset mis = "#accessmission#">
		   <cfelseif URL.Mission eq "undefined" or URL.Mission eq "">					   
				 <cfset mis = ""> 
		   <cfelse>
				 <cfset mis = "#URL.Mission#">
		   </cfif>			  
		 						
			<cfquery name="getDenied" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT * 
				FROM  OrganizationAuthorizationDeny
				WHERE UserAccount  = '#URL.ACC#'
				<cfif Role.OrgUnitLevel neq "Global" or Role.MissionasParameter eq "1">
				
				    AND  Mission =  <cfif mis neq "">'#mis#'<cfelse>NULL</cfif>	
					<cfif orgunit neq "">
					AND  OrgUnit = '#orgunit#'
					</cfif>
					
			    </cfif>
					
				AND GroupParameter = '#GroupParameter#'
				AND Role           = '#URL.ID#'
				AND ClassParameter = '#ClassParameter#'
				AND AccessLevel    = '#AccessLevel#' 
			</cfquery>
			
			<cfif getDenied.recordcount gte "1">		
			
				<cfquery name="clear" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				DELETE FROM OrganizationAuthorizationDeny
				WHERE UserAccount  = '#URL.ACC#'
				<cfif Role.OrgUnitLevel neq "Global" or Role.MissionasParameter eq "1">
				
				    AND  Mission =  <cfif mis neq "">'#mis#'<cfelse>NULL</cfif>	
					<cfif orgunit neq "">
					AND  OrgUnit = '#orgunit#'
					</cfif>
					
			    </cfif>
					
				AND GroupParameter = '#GroupParameter#'
				AND Role           = '#URL.ID#'
				AND ClassParameter = '#ClassParameter#'
				AND AccessLevel    = '#AccessLevel#' 
			    </cfquery>
				
			</cfif>	
										
			<cfquery name="Insert" 
				datasource="AppsOrganization" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					
					INSERT INTO OrganizationAuthorization  
					         (<cfif Role.OrgUnitLevel neq "Global" or Role.MissionasParameter eq "1">
								  Mission,
								  <cfif orgunit neq "">OrgUnit,</cfif>
							  </cfif>
							  UserAccount, 
							  Role,
							  ClassParameter,
							  GroupParameter, 
							  ClassIsAction,
							  AccessLevel,
							  Source,
							  RecordStatus,
							  OfficerUserId,
							  OfficerLastName,
							  OfficerFirstName,
							  Created)
					  VALUES (<cfif Role.OrgUnitLevel neq "Global" or Role.MissionAsParameter eq "1">		 
		
					          <cfif mis neq "">'#mis#'<cfelse>NULL</cfif>,						  
						      <cfif orgunit neq "">#orgunit#,</cfif>
							  
						   </cfif>
								   				  
				          '#URL.ACC#',
				          '#URL.ID#',  
						  '#ClassParameter#',
						  '#GroupParameter#', 
				          '#Form.ClassIsAction#', 
						  '#AccessLevel#',
						  <cfif getDenied.recordcount gte "1">
						  '#getDenied.source#',   <!--- we just restore the source --->
						  <cfelse>
						  'Manual',
						  </cfif>
						  '#RecordStatus#',
						  '#SESSION.acc#',
						  '#SESSION.last#', 
						  '#SESSION.first#', 
						  getDate()) 				  
						  
			</cfquery>		
											
		</cfif>		
										
		<cfif orgunit eq "">
			
			   <!--- ----------------------------------------------------------------------------------------------------- --->
			   <!--- since access was now granted on a tree level, we can remove safely any entries on the unit level here --->
			   <!--- ----------------------------------------------------------------------------------------------------- --->
				 			
				<cfsavecontent variable="qry">
				  (OrgUnit is not NULL and OrgUnit != '') 
					 AND   Mission = '#URL.Mission#'
					 AND   UserAccount = '#URL.ACC#'
					 AND   Role        = '#URL.ID#'
					 AND   ClassParameter = '#ClassParameter#'
					 <cfif GroupParameter neq "">
					   AND GroupParameter = '#GroupParameter#' 
				     </cfif>				 
		        </cfsavecontent>
				
				<cfinvoke component    = "Service.Access.AccessLog"  
				  method               = "DeleteAccess"
				  ActionId             = "#rowguid#"
				  ActionStep           = "2"
				  ActionStatus         = "9"
				  UserAccount          = "#URL.ACC#"
				  Condition            = "#qry#"
				  DeleteCondition      = ""
				  AddDeny              = "1"
				  AddDenyCondition     = "Source != 'Manual'">	 					
										
		</cfif>
							
</cfif>

<cfif Form.Rolldown eq "1"> <!--- only in case of unit or mandate access --->
	
		
	    <cfif url.id2 eq "" and url.id4 neq "">
		
			<!--- full list of the mandate excluding the root unit --->
			
			<cfquery name="orgunitlist"
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#"> 
				SELECT   OrgUnit,
				         OrgUnitCode,
						 Mission,
						 MandateNo 			
				FROM     Organization 
				WHERE    Mission    = '#url.Mission#'
				AND      MandateNo  = '#url.id4#' 
				AND      OrgUnit != '#orgunit#'
				ORDER BY HierarchyCode 
				
			</cfquery>	
					
		<cfelse>
	
			<cfquery name="Org"
			datasource="AppsOrganization" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#"> 
				SELECT   *
				FROM     Organization 				
				WHERE    OrgUnit = '#URL.ID2#' 				
			</cfquery>
																				
			<cfquery name="orgunitlist"
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#"> 
				SELECT   OrgUnit,OrgUnitCode,Mission,MandateNo 			
				FROM     Organization 
				WHERE    HierarchyCode LIKE '#Org.HierarchyCode#.%'
				AND      Mission    = '#Org.Mission#'
				AND      MandateNo  = '#Org.MandateNo#' 
				ORDER BY HierarchyCode
			</cfquery>		
			
		</cfif>			

	    <cfif orgunitlist.recordcount neq 0>

		<cfset units = quotedValueList(orgunitlist.orgunit)>													
		
		<cfsavecontent variable="condition">
			  OrgUnit IN (#preservesingleQuotes(units)#)			
			  AND UserAccount = '#URL.ACC#'
			  AND Role        = '#URL.ID#'
			  AND ClassParameter = '#ClassParameter#'
			  <cfif GroupParameter neq "">
			  AND GroupParameter = '#GroupParameter#' 
			  </cfif>
		</cfsavecontent>
			
		 <cfset cnt = 0>
		 						
		 <!--- incorrect 						
		 <cfloop index="item" from="1" to="#Form.Row#">
		 --->
		 
		 <cfloop index="item" from="1" to="1">
		 
		 		<cfif cnt gt 15>
					<cfset cnt = 0>
				</cfif>
			 				
				<cfset cnt = cnt+1>
														
				<cfif AccessLevel eq ""> <!--- revoke access --->
		
				    <!--- check if group access has been granted --->
					
					<cfinvoke component  = "Service.Access.AccessLog"  
					  method               = "DeleteAccess"
					  ActionId             = "#rowguid#"
					  ActionStep           = "5"
					  ActionStatus         = "9"
					  UserAccount          = "#URL.ACC#"
					  Condition            = "#condition#"
					  DeleteCondition      = ""
					  AddDeny              = "1"
					  AddDenyCondition     = "Source != 'Manual'">					 
					 																					
				<cfelse> 
				
				<!--- should have access, so check if higher group record exist in database --->
				
					<cfquery name="GroupEntry" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM   OrganizationAuthorization 
						WHERE  #PreserveSingleQuotes(condition)#
						  AND  AccessLevel > '#AccessLevel#'
						  AND  Source != 'Manual'
					</cfquery>									
																		
					<cfif GroupEntry.recordCount gt "0">
	
						<!--- add to denied for the source is a group --->
						
						<cfinvoke component="Service.Access.AccessLog"  
						  method               = "DeleteAccess"
						  ActionId             = "#rowguid#"
						  ActionStep           = "6"
						  ActionStatus         = "9"
						  UserAccount          = "#URL.ACC#"
						  Condition            = "#condition#"
						  DeleteCondition      = "Source != 'Manual'"
						  AddDeny              = "1"
						  AddDenyCondition     = "Source != 'Manual'">	 										 	
													
					</cfif>							
										
					<!--- check for any remaining (group) entries that match --->		
					
										
					<cfquery name="RemoveInheritedEntry" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						DELETE FROM OrganizationAuthorization 
						WHERE #PreserveSingleQuotes(condition)#												
					</cfquery>																		
						
					<!--- added 4/8/2008 Dev --->
					
					<!--- unknown
					
					<cfquery name="Clear" 
					datasource="AppsOrganization" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT *
						FROM   OrganizationAuthorization 
						WHERE  #PreserveSingleQuotes(condition)#
						  AND  AccessLevel = '#AccessLevel#'
						  AND  Source = 'Manual'
					</cfquery>		
					
					--->
																	
					<cfif Check.recordcount eq "0">
										
						<cfquery name="Insert" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							INSERT INTO OrganizationAuthorization  
						         (OrgUnit,  
								  OrgUnitInherit,
								  Mission,
								  UserAccount,
								  Role,
								  ClassParameter,
								  GroupParameter,
								  ClassIsAction,
								  AccessLevel,
								  Source,
								  RecordStatus,
								  OfficerUserId,
								  OfficerLastName,
								  OfficerFirstName)
							 SELECT OrgUnit,
							        '#OrgUnit#',
									'#URL.Mission#',
							        '#URL.ACC#',
							        '#URL.ID#',  
									'#ClassParameter#',
									'#GroupParameter#', 
									'#Form.ClassIsAction#',
									'#AccessLevel#',
									'Manual',
									'#RecordStatus#',
									'#SESSION.acc#',
									'#SESSION.last#',
									'#SESSION.first#' 
							FROM   Organization
							WHERE  OrgUnit IN (#preservesingleQuotes(units)#)			
									
						</cfquery>							
												
					</cfif>
					
				</cfif>
	    </cfloop>

	</cfif>		
		
</cfif>


</cfoutput>

