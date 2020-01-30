<!--- Refreshes the parent window --->

<cfparam     name= "Object.ObjectKeyValue4"        default="">

<cfoutput>
<script>
	opener.window.location = '#SESSION.root#/System/AccessRequest/DocumentEntry.cfm?drillid=#Object.ObjectKeyValue4#'
</script>
</cfoutput>