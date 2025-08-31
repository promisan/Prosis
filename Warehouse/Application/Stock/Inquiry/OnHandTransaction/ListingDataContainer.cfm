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
<cfparam name="url.filterwarehouse"   default="1">	
<cfparam name="url.location"          default="">	

<cfquery name="Param" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT 	  *
	FROM   	  Ref_ParameterMission
	WHERE  	  Mission = '#url.Mission#'							
</cfquery>	

<table width="100%" style="height:100%;" align="center"> 

    <!---
		
	<cfif param.LotManagement eq "1" and url.location eq "">    
		<tr>
			<td height="20">
				<cfdiv id="divListingFilter" bind="url:#session.root#/Warehouse/Application/Stock/Inquiry/Onhand/ListingFilter.cfm?filterwarehouse=#url.filterwarehouse#&warehouse=#url.warehouse#&mission=#url.mission#&SystemFunctionId=#url.SystemFunctionId#">        	
			</td>
		</tr>
	<cfelse>
		<tr>
			<td id="mainlisting" valign="top" style="height:95%;">
				<cfdiv id="divListing" style="height:100%;" bind="url:#session.root#/Warehouse/Application/Stock/Inquiry/Onhand/ListingDataGet.cfm?location=#url.location#&filterwarehouse=#url.filterwarehouse#&warehouse=#url.warehouse#&mission=#url.mission#&SystemFunctionId=#url.SystemFunctionId#">        	
			</td>
		</tr>
	</cfif>	
	
	<cfif param.LotManagement eq "1" and url.location eq "">
	<tr>
		<td id="mainlisting" valign="top" style="height:95%;">
			<cfdiv id="divListing" style="height:100%;" bind="url:#session.root#/Warehouse/Application/Stock/Inquiry/Onhand/ListingDataGet.cfm?location=#url.location#&filterwarehouse=#url.filterwarehouse#&warehouse=#url.warehouse#&mission=#url.mission#&SystemFunctionId=#url.SystemFunctionId#"> 
		</td>
	</tr>
	</cfif>
	
	--->
	
	<tr>
			<td id="mainlisting" valign="top" style="height:95%;">			
				<cfdiv id="divListing" style="height:100%;" bind="url:#session.root#/Warehouse/Application/Stock/Inquiry/OnhandTransaction/ListingDataGet.cfm?location=#url.location#&filterwarehouse=#url.filterwarehouse#&warehouse=#url.warehouse#&mission=#url.mission#&SystemFunctionId=#url.SystemFunctionId#">        	
			</td>
		</tr>
	
</table>				     
	