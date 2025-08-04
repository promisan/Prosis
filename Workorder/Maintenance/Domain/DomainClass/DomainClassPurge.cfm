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
<cfquery name="CountRec" 
      datasource="AppsWorkOrder" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      	SELECT	RequestId as id
		FROM	Request
		WHERE	ServiceDomain = '#url.id1#'
		AND 	ServiceDomainClass = '#url.id2#'
		UNION
		SELECT	WorkorderId as id
		FROM	Workorderline
		WHERE	ServiceDomain = '#url.id1#'
		AND 	ServiceDomainClass = '#url.id2#'
</cfquery>

<cfif CountRec.recordCount gt 0>
		 
     <script language="JavaScript">
    
	   alert("Domain Class is in use. Operation aborted.")
     
     </script>  
 
<cfelse>
		
	<cfquery name="Delete" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM Ref_ServiceitemDomainClass
		WHERE	ServiceDomain = '#url.id1#'
		AND 	Code = '#url.id2#'
	</cfquery>

</cfif>

<cfoutput>
	<script language="JavaScript">
    	ptoken.navigate('#SESSION.root#/Workorder/Maintenance/Domain/DomainClass/DomainClassListing.cfm?ID1=#url.id1#','domainClassListing')   
	</script> 
</cfoutput>