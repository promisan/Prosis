<cfparam name="attributes.left"         default="">
<cfparam name="attributes.right"        default="">
<cfparam name="attributes.collate"      default="Cyrillic_General_CI_AI">
<cfparam name="attributes.language"     default="">
<cfparam name="url.var"                 default  = "0">
<cfparam name="Attributes.var"          default  = "#url.var#">

<cfset sanitized = "">

<cf_softLikeSanitize 
    field="#attributes.left#" 
    type="db" 
    language="#attributes.language#">
	
<cfset vLeft = sanitized>

<cfset sanitized = "">

<cf_softLikeSanitize 
    field="#attributes.right#" 
    type="text" 
    language="#attributes.language#">
	
<cfset vRight = sanitized>

<cfif attributes.var eq "1">

	<cfset caller.softstring = "( (CONVERT(varchar(max), #vLeft#) COLLATE #attributes.collate#) LIKE (CONVERT(varchar(max),'%#vRight#%') COLLATE #attributes.collate#) )">

<cfelse>
	
	<cfoutput> 
	( (CONVERT(varchar(max), #vLeft#) COLLATE #attributes.collate#) 
	   LIKE (CONVERT(varchar(max),'%#vRight#%') COLLATE #attributes.collate#) )
	</cfoutput>

</cfif>
