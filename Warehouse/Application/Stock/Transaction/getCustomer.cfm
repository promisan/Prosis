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
<!--- retrieve the item --->

<cfparam name="url.customerid"   default="">

<cfquery name="Get" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     Customer
			WHERE    CustomerId = '#url.customerid#'		
</cfquery>

<cf_verifyOperational module="WorkOrder" Warning="No">

<cfif get.recordcount eq "0" and operational eq "1">

	<cfquery name="Get" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     Customer
			WHERE    CustomerId = '#url.customerid#'		
	</cfquery>
	
</cfif>

<cfoutput>
			
	<script language="JavaScript">				   
		try { document.getElementById('customerid').value = "#url.customerid#" } catch(e) {}
	</script>		
		
	<table width="100%" cellspacing="0" cellpadding="0">
	
		<tr>
		    <td width="90%" class="labelit" style="height:20;padding-left:3px">#get.customername#</td>		
		</tr>
	
	</table>	

</cfoutput>


