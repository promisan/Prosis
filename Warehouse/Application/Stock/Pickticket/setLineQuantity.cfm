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

<cfquery name="Item" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT ItemNo 
	FROM   Request
	WHERE  RequestId = '#URL.ID#'
</cfquery>

<cfquery name="Update" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    UPDATE Request
	SET    RequestedQuantity = '#quantity#' 
	WHERE  RequestId = '#URL.ID#'
</cfquery>

<cfquery name="Line" 
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   Request	
	WHERE  RequestId = '#URL.ID#'
</cfquery>

<cfquery name="Total" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

		SELECT sum(RequestedAmount) as Standard, sum(ItemAmount) as ItemPrice		      
		FROM  Materials.dbo.Request L
			  
			  <!---	  
			<cfif getAdministrator(url.mission) eq "1">
			<!--- no filtering --->
			<cfelse>
			   ,OrganizationAuthorization O 
			</cfif>
				--->
				
		WHERE L.Status   = '#line.Status#' 
		AND   L.Reference  = '#Line.Reference#' 
				
		
</cfquery>

<cfoutput>

	#NumberFormat(Line.RequestedAmount,'__,____.__')#	

	<script>
	    document.getElementById('sale_#URL.ID#').innerHTML = "#NumberFormat(Line.ItemAmount,',.__')#"
		document.getElementById('boxstd_#line.reference#').innerHTML = "#NumberFormat(Total.Standard,',.__')#"
		document.getElementById('boxprc_#line.reference#').innerHTML = "#NumberFormat(Total.ItemPrice,',.__')#"
	</script>

</cfoutput>



