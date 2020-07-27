<cfparam name="attributes.left"         default="">
<cfparam name="attributes.right"        default="">
<cfparam name="attributes.collate"      default="Cyrillic_General_CI_AI">
<cfparam name="attributes.language"     default="">

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

<cfoutput> 
( (CONVERT(varchar(max), #vLeft#) COLLATE #attributes.collate#) 
   LIKE (CONVERT(varchar(max),'%#vRight#%') COLLATE #attributes.collate#) )
</cfoutput>
