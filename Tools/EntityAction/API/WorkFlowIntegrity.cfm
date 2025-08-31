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
<cfparam name="attributes.Datasource" default="appsOrganization">


<cfquery name="getEntity" 
	 datasource="#attributes.Datasource#"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT     *
		FROM       Organization.dbo.Ref_Entity AS B
		WHERE      EntityCode IN (SELECT  EntityCode
    	                          FROM    Organization.dbo.OrganizationObject
        	                      WHERE   EntityCode = B.EntityCode)
		AND        Role IN (SELECT Role 
		                    FROM   Ref_AuthorizationRole
							WHERE  SystemModule IN (SELECT SystemModule
							                        FROM   System.dbo.Ref_SystemModule
													WHERE  Operational = 1)) 						  
</cfquery>	

<cfloop query="getEntity">						  

	<!--- check table --->
	
	<cfset go = "">
	
	<cftry>		
	
		<cfquery name="Check" 
		 datasource="#attributes.Datasource#"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT TOP 1 *
	    	FROM   #EntityTableName#
		</cfquery>
			
		<cfset go = "1">
			
	<cfcatch>
	
		<cfset go = "0">
				
	</cfcatch>
	
	</cftry>
		

	<cfif EnableIntegrityCheck eq "1" and go eq "1">
							
		<cfquery name="Clean" 
		 datasource="#attributes.Datasource#"
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		
		 <cfif EntityKeyField1 neq "" 
		     and EntityKeyField2 eq "" 
			 and EntityKeyField3 eq "" 
			 and EntityKeyField4 eq "">
		 
		 	 DELETE  Organization.dbo.OrganizationObject FROM Organization.dbo.OrganizationObject OO
		     WHERE EntityCode = '#EntityCode#'
			 AND   ObjectKeyValue1 NOT IN (SELECT #EntityKeyField1#  
			                               FROM   #EntityTableName#
										   WHERE  #EntityKeyField1# = OO.ObjectKeyValue1)
			 AND   ObjectReference2 <> 'Embedded workflow'	
			 			 
		 </cfif>
		 
		 <cfif EntityKeyField2 neq "" 
			 and EntityKeyField3 eq "" 
			 and EntityKeyField4 eq "">	 
		 
		 	 DELETE  Organization.dbo.OrganizationObject FROM Organization.dbo.OrganizationObject OO
		     WHERE  EntityCode = '#EntityCode#'
			 AND    ObjectKeyValue2 NOT IN
	                          (SELECT     #EntityKeyField2#
	                            FROM      #EntityTableName#
	                            WHERE     #EntityKeyField1# = OO.ObjectKeyValue1
								AND       #EntityKeyField2# = OO.ObjectKeyValue2)
			 AND    ObjectReference2 <> 'Embedded workflow'					
							
		 </cfif>
		 
		 <cfif EntityKeyField3 neq "">
		 	 	
		 	 DELETE  Organization.dbo.OrganizationObject FROM Organization.dbo.OrganizationObject OO
		     WHERE EntityCode = '#EntityCode#'
			 AND   ObjectKeyValue3 NOT IN
	                          (SELECT     #EntityKeyField3#
	                            FROM      #EntityTableName#
	                            WHERE     #EntityKeyField1# = OO.ObjectKeyValue1
								AND       #EntityKeyField2# = OO.ObjectKeyValue2
								AND       #EntityKeyField3# = OO.ObjectKeyValue3)
			 AND   ObjectReference2 <> 'Embedded workflow'								  	
		 	 			 
		 </cfif>
		 
		 <cfif EntityKeyField4 neq "">
		 	 
		 	 DELETE  Organization.dbo.OrganizationObject FROM Organization.dbo.OrganizationObject OO
		     WHERE   EntityCode = '#EntityCode#'
			 AND     ObjectKeyValue4 NOT IN (SELECT DISTINCT  #EntityKeyField4# 
			                                 FROM  #EntityTableName#
											 WHERE #EntityKeyField4# = OO.ObjectKeyValue4)
			 AND     ObjectReference2 <> 'Embedded workflow' 					 
					 
		 </cfif>
			  
		</cfquery>					
		
	</cfif>	
	
	<!--- DISABLED on 25/11/2010 it has bad effects on the regeneration of the flow if the record was opened again for whatever
	reason
	
	<!--- ------------------------------------------------------------------------------------------------------- --->
	<!--- added option to reset the workflow if the master record is deactivated, driven by the contract workflow --->
	<!--- ------------------------------------------------------------------------------------------------------- --->
		
		
	<cftry>
	
		<cfif Entity.EntityKeyField4 neq "">
			
			<cfquery name="Clean" 
			 datasource="AppsOrganization"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
				 UPDATE OrganizationObject
				 SET    Operational = 0
				 WHERE  ObjectKeyValue4 IN (SELECT DISTINCT #Entity.EntityKeyField4# 
				                            FROM  #Entity.EntityTableName# 
											WHERE ActionStatus = '9')
			 </cfquery>
			
		</cfif>
		
		<cfcatch></cfcatch>
	
	</cftry>
	
	--->
	
</cfloop>	

