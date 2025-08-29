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
<cfparam name="Form.AddressType" default = "">

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<!--- verify if record exist --->

<cfquery name="Address" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT A.*
FROM vwPersonAddress A
WHERE PersonNo = '#Form.PersonNo#' AND AddressId  = '#Form.AddressId#'
</cfquery>

<cfif Address.recordCount eq 1> 

  <!----
 <cfquery name="UpdateContract" 
   datasource="AppsEmployee" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   DELETE FROM  PersonAddress 
   WHERE PersonNo = '#Form.PersonNo#' AND AddressId  = '#Form.AddressId#' 
   </cfquery>
  ---->

 
 <cftransaction>

	 <cfquery name="UpdateContract" 
	   datasource="AppsEmployee" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		   UPDATE PersonAddress 
		   SET   <cfif Form.AddressType neq "">
			    	 AddressType         = '#Form.Addresstype#',
				 </cfif> 
				 Address             = '#Form.Address#',
				 Address2            = '#Form.Address2#',
				 AddressCity         = '#Form.AddressCity#',
		 		 AddressRoom         = '#Form.AddressRoom#', 
				 <cfif Form.AddressZone	neq "">
				 	 AddressZone         = '#Form.AddressZone#',
				 </cfif>	 
				 Country             = '#Form.Country#',
				 State               = '#Form.State#'
		   WHERE PersonNo = '#Form.PersonNo#' AND AddressId  = '#Form.AddressId#' 
    </cfquery>
	
	
   
	   
	   <!--- provision for contacts --->
	   
   
   </cftransaction>
  
   
</cfif>   
	