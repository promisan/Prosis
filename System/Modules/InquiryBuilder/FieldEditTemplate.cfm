
<!--- verifies if template exists --->

<cfparam name="url.template" default="">
<cfparam name="url.resultField" default="templateVal">

<table cellspacing="0" cellpadding="0" width="5px" class="formpadding">

<cfoutput>
	
	<cftry>

		<cfif FileExists("#SESSION.root#/#url.template#")>					
			
			<tr>
			<td align="left" width="5px">
				<img src="#SESSION.root#/Images/check_mark.gif" alt="" border="0" align="absmiddle" title="Template exists.">
				<input type="hidden" value="1" name="#url.resultField#" id="#url.resultField#">
			</td>
			</tr>
					
		<cfelse>
		
			<tr>
			<td align="left">
				<img src="#SESSION.root#/Images/alert.gif" alt="" border="0" title="Template does not exist.">
				<input type="hidden" value="0" name="#url.resultField#" id="#url.resultField#">
			</td>
			</tr>
		
		</cfif>
		
	<cfcatch>
	
			<tr>
			<td align="left">
				<img src="#SESSION.root#/Images/alert_stop.gif" alt="" border="0" title="Template does not exist.">
				<input type="hidden" value="0" name="#url.resultField#" id="#url.resultField#" >
			</td>
			</tr>
	
	</cfcatch>
	
	</cftry>

</cfoutput>

</td></tr>
</table>

