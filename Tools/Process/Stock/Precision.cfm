
<cfparam name="Attributes.number"    default="0">

<cfswitch expression="#Attributes.number#">

<cfcase value="0">
   <cfset val = "___,__">
</cfcase>

<cfcase value="1">
   <cfset val = "___,__._">
</cfcase>

<cfcase value="2">
   <cfset val = "___,__.__)">
</cfcase>

<cfcase value="3">
   <cfset val = "___,__.___">
</cfcase>

<cfdefaultcase>
    <cfset val = "___,__">
</cfdefaultcase>

</cfswitch>

<cfset caller.pformat = val>