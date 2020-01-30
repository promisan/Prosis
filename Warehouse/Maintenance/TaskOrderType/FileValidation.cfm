
<!--- facility to verify if template exists --->

<cfparam name="url.template" default="">
<cfparam name="url.container" default="">
<cfparam name="url.resultField" default="directoryVal">

<table cellspacing="0" cellpadding="0" width="5px" class="formpadding">

<cfoutput>

<cfif url.template neq "">
	
	<cftry>
	
		<cfset vTemplate = "#url.template#">
		<cfset vTemplate = replace("#url.template#","..","","ALL")>
		<cfset vTemplate = replace("#url.template#","/","\","ALL")>

		<cfif FileExists("#SESSION.rootpath#\#vTemplate#")>							
			
			<tr>
			<td align="left" width="5px">
			<img src="#SESSION.root#/Images/check_mark.gif" alt="" border="0" align="absmiddle" title="Path validated">
		    <input type="hidden" value="1" name="#url.resultField#" id="#url.resultField#">
			</td>
			</tr>
					
		<cfelse>
		
			<tr>
			<td align="left">
				<img src="#SESSION.root#/Images/alert.gif" alt="" border="0" align="absmiddle" title="Path not validated!">
				<input type="hidden" value="0" name="#url.resultField#" id="#url.resultField#">
			</td>
			</tr>
		
		</cfif>
		
	<cfcatch>
	
			<tr>
			<td align="left">
				<img src="#SESSION.root#/Images/alert_stop.gif" alt="" border="0" align="absmiddle" title="Error trying to validate path">
				<input type="hidden" value="0" name="#url.resultField#" id="#url.resultField#">
			</td>
			</tr>
	
	</cfcatch>
	
	</cftry>

</cfif>

</cfoutput>

</td></tr>
</table>

