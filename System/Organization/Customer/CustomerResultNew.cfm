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
<cfif len(url.customerid) gte "20">  
  
	<cfquery name="Get" 
		datasource="#url.dsn#"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM  Customer
			WHERE CustomerId  = '#URL.CustomerId#' 		
	</cfquery>
	
	<cfoutput>
	
	<table cellspacing="0" cellpadding="0" width="100%" class="navigation_table">
	
	<tr class="navigation_row">		
	
		<td id="box#url.customerid#" width="100%">	
				
			<table width="100%" border="0" cellspacing="0" cellpadding="0" onclick="ColdFusion.navigate('CustomerEdit.cfm?systemfunctionid=#url.systemfunctionid#&customerid=#CustomerId#&dsn=#url.dsn#','detail')">
			
					<tr>
					
						<td height="18" rowspan="2" width="20"><img src="#SESSION.root#/images/pointer.gif" height="9" alt="" border="0"></td>			
						<td class="labelit" oncontextmenu="viewOrgUnit('#get.orgunit#')">
							<font size="2" color="gray"><b>#Get.CustomerName# <cfif Get.OrgUnit neq "">[#Get.OrgUnit#]</cfif></td>
						</td>
					
					</tr>
										
			</table>		
		</td>		
		
	</tr>
	
	<tr><td colspan="2" class="linedotted"></td></tr>
	
	</table>
	
	</cfoutput>
	
</cfif>		

<cfset AjaxOnLoad("doHighlight")>	