<cfparam name="url.template" default="">
<cfparam name="url.resultField" default="">


<table cellspacing="0" cellpadding="0" width="5px" class="formpadding">

<cfoutput>
	
	<cftry>

		<cfif FileExists("#SESSION.root#/#url.template#")>					
			
			<tr>
			<td align="left" width="5px">
				<img src="#SESSION.root#/Images/check_mark.gif" alt="Template validated!" border="0" align="absmiddle">
				<input type="hidden" value="1" name="#url.resultField#" id="#url.resultField#">
			</td>
			</tr>
					
		<cfelse>
		
			<tr>
			<td align="left">
				<img src="#SESSION.root#/Images/alert.gif" alt="Alert: Template does not exist." border="0">
				<input type="hidden" value="0" name="#url.resultField#" id="#url.resultField#">
			</td>
			</tr>
		
		</cfif>
		
	<cfcatch>
	
			<tr>
			<td align="left">
				<img src="#SESSION.root#/Images/alert_stop.gif" alt="Alert: Template does not exist." border="0">
				<input type="hidden" value="0" name="#url.resultField#" id="#url.resultField#">
			</td>
			</tr>
	
	</cfcatch>
	
	</cftry>

</cfoutput> 
</table>