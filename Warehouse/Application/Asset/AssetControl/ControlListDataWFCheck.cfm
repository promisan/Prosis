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
<cf_compression>

<cfquery name="Org" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     TOP 1 *
	FROM         AssetItemOrganization
	WHERE     (AssetId = '#url.assetid#')
	ORDER BY DateEffective DESC
</cfquery>	


<cfquery name="Loc" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT     TOP 1 *
	FROM         AssetItemLocation
	WHERE     (AssetId = '#url.assetid#')
	ORDER BY DateEffective DESC
</cfquery>	

<!--- check pending actions for asset --->

<cfoutput>

<cfif Org.ActionStatus eq "0" or Loc.Status eq "0">
						
		<img src="#SESSION.root#/images/reminder.gif" id="#url.assetid#ref" align="absmiddle" height="10" alt="" border="0"
		onclick="ColdFusion.navigate('ControlListDataWFCheck.cfm?assetid=#url.assetid#','box#AssetId#')">
		
</cfif>		
		
<cfif Org.ActionStatus eq "0">
				
		<a href="javascript:process('#Org.MovementId#','#url.assetid#')">
		<font color="0080FF"><cf_tl id="Confirm movement">
		</a>
		
</cfif>

	
<cfif Loc.Status eq "0">
	
	    <cfif Org.ActionStatus eq "0"> <cf_tl id="and"> </cfif>
		
		<a href="javascript:process('#Loc.MovementId#','#url.AssetId#')">
			<cf_tl id="Confirm location">
		</a>
		
</cfif>

</cfoutput>