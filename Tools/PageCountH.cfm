

<cfparam name="URL.Page" default="1">
<cfparam name="Attributes.recordCount" default="1">
<cfparam name="Attributes.records" default="#CLIENT.PageRecords#">

<cfset firstrow   = ((#URL.Page#-1)*#Attributes.records#)+1>
<cfset first      = ((#URL.Page#-1)*#Attributes.records#)+1>
<cfset pages     = Ceiling(#Attributes.recordCount#/#Attributes.records#)>
<cfif pages lt '1'>
   <cfset pages = '1'>
</cfif>

<cfset caller.pages = #pages#>
<cfset caller.no = #Attributes.records#>
<cfset caller.firstrow = #firstrow#>
<cfset caller.first    = #firstrow#>


