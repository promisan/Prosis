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

<cfquery name="Log" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 
			SELECT Max(LogSerialNo) as Last
			FROM   ParameterLog 		
		
</cfquery>
	
<cfif Log.Last eq "">
	  <cfset No = "1">
<cfelse>
	  <cfset No = Log.Last+1>
</cfif>

<cfinvoke component = "Service.Process.System.Database"  
	   method           = "getTableFields" 
	   datasource	    = "AppsEmployee"	  
	   tableName        = "Parameter"
	   ignoreFields		= "'LogSerialNo','LogStamp','OfficerUserId','OfficerLastName','OfficerFirstName'"
	   returnvariable   = "fields">	

<cftransaction>
	   
	<cfquery name="Log" 
			 datasource="AppsEmployee" 		 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 
				INSERT INTO ParameterLog ( 
					  LogSerialNo,
					  LogStamp,
					  OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName,
					  #fields# )
					  
				SELECT '#No#' AS LogSerialNo,
					    getDate() AS LogStamp,
						'#SESSION.acc#' AS OfficerUserId,
						'#SESSION.last#' AS OfficerLastName,
						'#SESSION.first#' AS OfficerFirstName,
						#fields#	
				FROM   Parameter
	</cfquery>
		   
	
	<cfquery name="Update" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Parameter
		SET    DependentEntitlement  = '#Form.DependentEntitlement#', 
	    	   ActionMode            = '#Form.ActionMode#',
			   PictureWidth          = '#Form.PictureWidth#',
			   PictureHeight         = '#Form.PictureHeight#',
			   AddressType           = '#Form.AddressType#',
			   IndexNoName           = '#Form.IndexnoName#',
			   <cfif form.Indexno eq "">
			   IndexNo               = NULL,
			   <cfelse>
			   IndexNo               = '#Form.IndexNo#', 
			   </cfif>
			   LeaveFieldsEnforce    = '#LeaveFieldsEnforce#',
			   EnablePersonGroup     = '#Form.EnablePersonGroup#',
			   GenerateApplicant     = '#Form.GenerateApplicant#'
	</cfquery>

</cftransaction>

<cfoutput>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   

<script>
	#ajaxLink('ParameterEditMiscellaneous.cfm?mid=#mid#')#	
</script>

</cfoutput>
