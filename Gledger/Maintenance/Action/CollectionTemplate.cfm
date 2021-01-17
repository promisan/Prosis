
<!--- facility to verify if template exists --->

<cfparam name="url.template" default="">
<cfparam name="url.container" default="">
<cfparam name="url.resultField" default="directoryVal">

<table class="formpadding" width="5px">

<cfoutput>

<cfif url.template neq "">
	
	<cftry>

		<cfif FileExists("#SESSION.rootpath#/#url.template#")>					
			
			<tr>
			<td align="left" width="5px">
			<img src="#SESSION.root#/Images/check_mark.gif" alt="" border="0" align="absmiddle">
			<input type="hidden" value="1" name="#url.resultField#">
			</td>
			</tr>
					
		<cfelse>
		
			<tr>
			<td align="left">
				<img src="#SESSION.root#/Images/alert.gif" alt="" border="0">
				<input type="hidden" value="0" name="#url.resultField#">
			</td>
			</tr>
		
		</cfif>
		
	<cfcatch>
	
			<tr>
			<td align="left">
				<img src="#SESSION.root#/Images/alert_stop.gif" alt="" border="0">
				<input type="hidden" value="0" name="#url.resultField#">
			</td>
			</tr>
	
	</cfcatch>
	
	</cftry>

</cfif>

</cfoutput>

</td></tr>
</table>

