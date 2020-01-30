
<cfparam name="attributes.tooltip"       default="">
<cfparam name="Attributes.content"       default="">
<cfparam name="Attributes.Layout"        default="standard">

<cfif attributes.Layout eq "standard">
	
	<cf_UIToolTip
	   tooltip="<table><tr><td>#Attributes.Tooltip#</td></tr></table>">
	   
	   <cfoutput>#attributes.content#</cfoutput>
	   
	</cf_UIToolTip>
   
</cfif>   