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