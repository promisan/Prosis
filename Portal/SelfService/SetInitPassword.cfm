<cf_param name="URL.PortalId" default="" type="string">

<cfoutput>
<table width="100%" height="100%">
<tr><td style="height:100%;width:100%">
	<iframe src="#session.root#/System/UserPassword.cfm?portalid=#URL.portalid#" width="100%" height="100%" frameborder="0"></iframe>
</td></tr>
</table>
</cfoutput>

<script>
	Prosis.busy('no');	
</script>
