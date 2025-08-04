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
<cfparam name="url.html"   default="No">
<cfparam name="url.closeAction" default="">

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cf_systemscript>

<cfif ParameterExists(Form.Update)> 
	
	<cfif Len(Form.Remarks) gt 100>
	  <cfset remarks = left(Form.Remarks,100)>
	<cfelse>
	  <cfset remarks = Form.Remarks>
	</cfif>
	
	<cfparam name="form.Operational" default="0">
		  
	<!---
	
	<cfset dateValue = "">
	<CF_DateConvert Value="#Form.DateEffective#">
	<cfset STR = #dateValue#>
	
	<cfset dateValue = "">
	<cfif #Form.DateExpiration# neq ''>
	    <CF_DateConvert Value="#Form.DateExpiration#">
	    <cfset END = #dateValue#>
	<cfelse>
	    <cfset END = 'NULL'>
	</cfif>	
	
	--->
	
 	<cftransaction>
	
	 <cfquery name="Update" 
	   datasource="AppsOrganization" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   UPDATE OrganizationAddress 
	   SET   AddressType         = '#Form.Addresstype#',
			 TelephoneNo         = '#Form.TelephoneNo#',
			 MarkerIcon          = '#Form.MarkerIcon#',
			 MarkerColor         = '#Form.MarkerColor#',
 			 MobileNo         	 = '#Form.MobileNo#',
			 FaxNo               = '#Form.FaxNo#',
			 eFaxNo              = '#Form.eFaxNo#',			 
			 WebURL              = '#Form.WebURL#',
			 PersonNo            = '#Form.PersonNo#',
			 Contact             = '#Form.Contact#',
			 FiscalNo            = '#Form.FiscalNo#',
			 Operational         = '#Form.Operational#'
	   WHERE AddressId           = '#Form.AddressId#'
	   </cfquery>
	   
 		<cf_address datasource="AppsOrganization"  addressid="#Form.AddressId#" mode="save" addressscope="Organization">   
		
	 </cftransaction>	
	   
</cfif>

<cfif ParameterExists(Form.Delete)>

 <cfquery name="Update" 
	   datasource="AppsOrganization" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
	   DELETE OrganizationAddress 
	   WHERE AddressId  = '#Form.AddressId#' 
	   </cfquery> 

</cfif>	   
	   	  
<cfoutput>
	
 <script>
	
	  ptoken.location("UnitAddress.cfm?ID=#Form.OrgUnit#&html=#url.html#&closeAction=#url.closeAction#&systemfunctionid=#url.systemfunctionid#")
    
</script>	

</cfoutput>	   

