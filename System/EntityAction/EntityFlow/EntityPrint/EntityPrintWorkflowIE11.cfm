<cfset url.showPrintButton = 0>
<cfhtmltopdf
	overwrite="yes"
	unit="in" 
	pagetype="A4"
	orientation="portrait"
	destination="#SESSION.rootPath#\CFRStage\User\#SESSION.acc#\Print_#URL.EntityCode#_#URL.EntityClass#_#URL.PublishNo#.pdf">
		<cfinclude template="EntityPrintWorkflow.cfm"> 	
</cfhtmltopdf>

<cfoutput>
	<script>
		parent.window.location = '#SESSION.root#/CFRStage/User/#SESSION.acc#/Print_#URL.EntityCode#_#URL.EntityClass#_#URL.PublishNo#.pdf';
	</script>
</cfoutput>