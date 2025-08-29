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
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cfparam name="Form.Parameter" default="">
<cfparam name="Form.ParameterDatasource" default="">
<cfparam name="Form.ParameterTable" default="">
<cfparam name="Form.ParameterFieldValue" default="">
<cfparam name="Form.ParameterFieldDisplay" default="">
<cfparam name="Form.RoleTask" default="">

<cfif ParameterExists(Form.Insert)> 

<cfquery name="Verify" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM Ref_AuthorizationRole
	WHERE Role = '#Form.Role#'
</cfquery>

   <cfif Verify.recordCount is 1>
   
   <script language="JavaScript">
   
     alert("A role record with this code has been registered already!")
     
   </script>  
  
   <cfelse>
        
	<cfquery name="Insert" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Ref_AuthorizationRole
		(Role, 
		Area, 
		Description, 
		SystemModule, 
		SystemFunction, 
		OrgUnitLevel, 
		Parameter, 
		ParameterDataSource,
		ParameterTable,
		ParameterFieldValue,
		ParameterFieldDisplay,
		ParameterGroup, 
		ListingOrder, 
		RoleMemo, 
		RoleOwner, 
		RoleClass, 
		AccessLevels,
		AccessLevelLabelList,
		OfficerUserId, 
		OfficerLastName, 
		OfficerFirstName)
	VALUES (
		'#Form.Role#', 
		'#Form.Area#', 
		'#Form.Description#', 
		'#Form.SystemModule#', 
		'#Form.SystemFunction#', 
		'#Form.OrgUnitLevel#', 
		'#Form.Parameter#',
		'#ParameterDataSource#',
		'#ParameterTable#',
		'#ParameterFieldValue#',
		'#ParameterFieldDisplay#', 
		'', 
		'#Form.ListingOrder#', 
		'#Form.RoleMemo#',
		<cfif #Form.RoleOwner# neq ""> 
			'#Form.RoleOwner#', 
		<cfelse>
			null, 
		</cfif>
		'#Form.RoleClass#', 
		'#Form.AccessLevels#',
		'#Form.AccessLevelLabelList#',
		'#SESSION.acc#',
	    '#SESSION.last#',		  
		'#SESSION.first#')
	
	</cfquery>
			  
    </cfif>		
		
	<script language="JavaScript">        
    	 parent.opener.applyfilter('5','','content')
	     parent.window.close()	      
	</script>  
	           
</cfif>

<cfif ParameterExists(Form.Update)>

	<!--- check --->
	
	<cfquery name="Check" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM Ref_AuthorizationRole
	WHERE Role = '#Form.RoleOld#'
   </cfquery>
   
   <cftransaction>
   
   <cfif check.RoleClass eq "Manual">
   
	   <cfif Check.OrgUnitLevel neq "#Form.OrgUnitLevel#">
	   
		   <cfquery name="Update" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				DELETE FROM OrganizationAuthorization
				WHERE Role = '#Form.RoleOld#'		
			</cfquery>
	        
	   </cfif>
   
   </cfif>
		
   <cfquery name="Update" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_AuthorizationRole
		SET Area           		  = '#Form.Area#', 
			Description    		  = '#Form.Description#', 
			<cfif check.RoleClass eq "Manual">
			Role                  = '#Form.Role#',
			SystemModule   		  = '#Form.SystemModule#', 
			AccessLevels          = '#Form.AccessLevels#',
			OrgUnitLevel   		  = '#Form.OrgUnitLevel#', 
			Parameter             = '#Form.Parameter#',
			</cfif>
			RoleTask              = '#Form.RoleTask#',
			SystemFunction 		  = '#Form.SystemFunction#', 			
			ListingOrder   		  = '#Form.ListingOrder#', 
			RoleMemo       		  = '#Form.RoleMemo#', 			
			<cfif Parameter eq "" and form.ParameterTable neq "">
			ParameterDataSource   = '#Form.ParameterDataSource#',
			ParameterTable	      = '#Form.ParameterTable#',
			ParameterFieldValue	  = '#Form.ParameterFieldValue#',
			ParameterFieldDisplay = '#Form.ParameterFieldDisplay#',
			<cfelse>
				ParameterDataSource   = '',
				ParameterTable	      = '',
				ParameterFieldValue	  = '',
				ParameterFieldDisplay = '',
			</cfif>
			<cfif Form.RoleOwner neq ""> 
			RoleOwner             = '#Form.RoleOwner#', 
			<cfelse>
			RoleOwner             = NULL, 
			</cfif>			
			AccessLevelLabelList  = '#Form.AccessLevelLabelList#'
			
		WHERE Role = '#Form.RoleOld#'
	</cfquery>
	
	</cftransaction>
	
	<cfoutput>
	<script language="JavaScript">        
    	 parent.opener.applyfilter('1','','#Form.RoleOld#')
	     parent.window.close()	      
	</script> 
	</cfoutput>
	
</cfif>	

<cfif ParameterExists(Form.Delete)> 

    <cfquery name="CountRec" 
      datasource="AppsOrganization" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
		SELECT     *
		FROM         OrganizationAuthorization	  
      	WHERE Role  = '#Form.RoleOld#' 
    </cfquery>

    <cfif CountRec.recordCount gt 0>
		 
     <script language="JavaScript">    
	   alert("Document Type is in use. Operation aborted.")     
     </script>  
	 
    <cfelse>
			
		<cfquery name="Delete" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_AuthorizationRole
			WHERE Role = '#Form.RoleOld#'
	    </cfquery>
	
	</cfif>
	
	<cfoutput>
	<script language="JavaScript">        
    	 parent.opener.applyfilter('1','','#Form.RoleOld#')
	     parent.window.close()	      
	</script> 
	</cfoutput>
		
</cfif>	

