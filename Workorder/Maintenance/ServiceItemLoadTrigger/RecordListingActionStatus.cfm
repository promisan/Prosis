<cf_compression>

<cfif url.status eq "1">
	<cfset iconName = "icon_stop.gif">
	<cfset vText = "Click to enable">
<cfelseif url.status eq "0">
	<cfset iconName = "icon_confirm.gif">
	<cfset vText = "Click to disable">
</cfif>

<cfset vId = "#url.ServiceItem##url.start##url.end##url.loadscope#">
<cfset vId = replace(vId," ", "_", "ALL")>
<cfset vId = replace(vId,"/", "_", "ALL")>

<cfoutput>
<img src="#SESSION.root#/Images/#iconName#"  
	style="cursor: pointer;" title="#vText#" width="14" height="14" border="0" align="middle" 
	onClick="javascript: if (confirm('This action may incur in non desired loads or quit loading desired data. \nDo you want to continue ?')) { ColdFusion.navigate('ToggleActionStatus.cfm?serviceitem=#url.serviceItem#&start=#url.start#&end=#url.end#&status=#url.status#&loadscope=#url.loadscope#','divStatus_#vId#'); }">
</cfoutput>