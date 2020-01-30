
<cfsilent>
	<cfparam name="attributes.tpe"      default="integer">
	<cfparam name="attributes.val"      default="">
	<cfparam name="attributes.base"     default="1">
	<cfparam name="attributes.size"     default="">
	<cfparam name="attributes.fontsize" default="">
	<cfset val  = "#Attributes.val#">
	<cfset bas  = "#Attributes.base#">
	
	<cfoutput>
	<cfif attributes.tpe eq "Integer">
		<cfset out = "#numberFormat(val,"___")#">
	<cfelseif attributes.tpe eq "Amount0">
		<cfset out = "#numberFormat(val,"_,__")#">
	<cfelseif attributes.tpe eq "Amount1">
		<cfset out = "#numberFormat(val,"_,_")#">	
	<cfelseif attributes.tpe eq "Amount2">
		<cfset out = "#numberFormat(val,"_,_.__")#">
	<cfelseif attributes.tpe eq "Currency">
		<cfset out = "$#numberFormat(val,"_,_.__")#">
	<cfelseif attributes.tpe eq "Percentage">
		    <cfif val neq "">
				<cfset out = "#numberFormat((val/bas)*100,"._")#%">	
			</cfif>	
	<cfelse>
		<cfset out = "#val#">
	</cfif>
	</cfoutput>
</cfsilent>

<cfset content = replaceNoCase(out," ","")>

<cfoutput>
<cfif attributes.size neq "">
   <cf_space spaces="#attributes.size#" align="right" label="#content#" font="#attributes.fontsize#">
<cfelse>
	#content#
</cfif>
</cfoutput>
