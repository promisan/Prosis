<!--- author:matt perry      email:mattp@theshop.com   created:03/06/99 //--->

<cfset #numofimages# = #ListLen(#Attributes.nameofimages#)#>

<cfif #IsDefined("Attributes.nameConflict")#>
	<cfset #nameConflict# = #Attributes.nameConflict#>
<cfelse>
	<cfset #nameConflict# = 'overwrite'>
</cfif>

<cfif #IsDefined("Attributes.accept")#>
	<cfset #accept# = #Attributes.accept#>
<cfelse>
	<cfset #accept# = "text/*, image/*, application/*">
</cfif>

<cfloop index="curImage" from="1" to="#numofimages#">

<cfset #filefield# = #ListGetAt(#Attributes.nameofimages#, #curImage#, ",")#>
<cfset #weight# = #ListGetAt(#Attributes.weight#, #curImage#, ",")#>
<cfset #weight# = #weight# * 1000>

<cfif #Evaluate("Form.#filefield#")# is "">
	<cfif #IsDefined("Attributes.default")#>
		<cfset #incoming# = #Attributes.default#>
	<cfelse>
		<cfset #incoming# = 'unavailable'>
	</cfif>
<cfelse>
	<cffile action="upload" filefield="#filefield#"	destination="#Attributes.directory#"
	nameconflict="#nameConflict#" accept="#accept#">
	
	<cfoutput> <cfset #incoming# = #File.ServerFile#> </cfoutput>
</cfif>	
	
<cfdirectory action="list" directory="#Attributes.directory#"
name="fileRead" filter="#incoming#">

<cfif #fileRead.size# GT #weight#>
	<cffile action="delete"
	file="#Attributes.directory##incoming#">
	
	<cfoutput>
	<cfset #weight# = #weight# / 1000>
	<cfset #size# = #fileRead.size# / 1000>
	<font face="arial" size="2">
	<font size="3"><b>Notice of oversize file!</b></font>
	<p><b>Uploaded Image:</b> #incoming#<br>
	<b>Max KB:</b> #weight#<br>
	<b>#incoming# KB:</b>  #size#<br>
	</font>
	</cfoutput>
	
	<cfbreak>
<cfelse>
	<cfoutput> <cfset Result = setVariable("Caller.#filefield#", #incoming#)> </cfoutput>
</cfif>
	
</cfloop>