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
<cf_systemscript>

<cfif Len(Form.Remarks) gt 100>
  <cfset remarks = left(Form.Remarks,100)>
<cfelse>
  <cfset remarks = Form.Remarks>
</cfif>  

<cfparam name="Form.eFaxNo" default="">

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

<!--- verify if record exist --->

<cfquery name="Address" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM vwOrganizationAddress
	WHERE OrgUnit = '#Form.OrgUnit#' 
		  AND AddressType  = '#Form.AddressType#' 
		  AND PostalCode = '#Form.AddressPostalCode#'
		  AND Address1 = '#Form.Address#'
</cfquery>

<cfparam name="Address.RecordCount" default="0">

<cfif Address.recordCount gte 1> 

   <cf_message message = "Your enter an existing address record. Operation not allowed."
  return = "back">

<CFELSE>

    <cftransaction>

	<cf_AssignId>
	
	<cfset AddressId = rowguid>

      <cfquery name="InsertAddress" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     INSERT INTO OrganizationAddress
	         (OrgUnit,
			 AddressId,
			 AddressType,
			 MarkerIcon,
			 MarkerColor,
			 TelephoneNo,
			 MobileNo,
			 FaxNo,
			 eFaxNo,		 
			 WebURL,
			 PersonNo,
			 Contact,
			 FiscalNo,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
      VALUES ('#Form.OrgUnit#',
	  	  '#AddressId#',
     	  '#Form.AddressType#',
		  '#Form.MarkerIcon#',
		  '#Form.MarkerColor#',
		  '#Form.TelephoneNo#',
		  '#Form.MobileNo#',
		  '#Form.Faxno#',
		  '#Form.eFaxno#',		  
		  '#Form.WebURL#',
		  '#Form.PersonNo#',
		  '#Form.Contact#',
		  '#Form.FiscalNo#',
		  '#SESSION.acc#',
    	  '#SESSION.last#',		  
	  	  '#SESSION.first#')
	  </cfquery>
	    
 	  <cf_address datasource="appsOrganization"   addressid="#addressid#" mode="save" addressscope="Organization">			
		 
    <cftransaction>
		 
     <cfoutput>
	
    	 <script LANGUAGE = "JavaScript">		
		   ptoken.location("UnitAddress.cfm?ID=#Form.OrgUnit#&html=#url.html#&closeAction=#url.closeAction#&systemfunctionid=#url.systemfunctionid#");    
    	 </script>	
	 
	</cfoutput>	   
	
</cfif>	

