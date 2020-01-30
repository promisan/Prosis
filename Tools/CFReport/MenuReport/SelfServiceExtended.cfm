
<!--- container --->

<cfoutput>

<cfparam name="url.owner"         default="">
<cfparam name="url.functionclass" default="">
<cfparam name="url.module"        default="">

<table width="100%" height="100%">

	<tr><td width="100%" height="100%">
	
	<iframe 
	    src="#SESSION.root#/Tools/CFreport/MenuReport/SelfServiceExtendedContent.cfm?systemfunctionid=#url.systemfunctionid#&portal=1&owner=#url.owner#&functionclass=#url.functionclass#&module=#url.module#" 
		width="100%" 
		height="100%" 
		frameborder="0">
	</iframe>
	
	</td></tr>
	
</table>

</cfoutput>