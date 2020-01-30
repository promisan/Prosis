
<!--- facility to verify if directory exists and allows for creation --->

<cfparam name="url.mode" default="">
<cfparam name="url.path" default="">
<cfparam name="url.container" default="">
<cfparam name="url.resultField" default="directoryVal">

<table cellspacing="0" cellpadding="0" width="5px" class="formpadding">

<cfoutput>

<cfif path neq "">
	
	<cftry>

		<cfif DirectoryExists("#path#")>					
			
			<tr>
			<td align="left" width="5px">
			<img src="#SESSION.root#/Images/check_mark.gif" alt="" border="0" align="absmiddle">
			<!--- By printing this field I can validate from javascript if the directory exists or not --->
			<input type="hidden" value="1" name="#url.resultField#" id="#url.resultField#">
			</td>
			</tr>
					
		<cfelse>
		
			<tr>
			<td align="left">
				<img src="#SESSION.root#/Images/alert.gif" alt="" border="0">
			<!--- By printing this field I can validate from javascript if the directory exists or not --->
				<input type="hidden" value="0" name="#url.resultField#" id="#url.resultField#">
			</td>
			</tr>
		
		</cfif>
		
	<cfcatch>
	
			<tr>
			<td align="left">
				<img src="#SESSION.root#/Images/alert_stop.gif" alt="" border="0">
			<!--- By printing this field I can validate from javascript if the directory exists or not --->
				<input type="hidden" value="0" name="#url.resultField#" id="#url.resultField#">
			</td>
			</tr>
	
	</cfcatch>
	
	</cftry>
	
<cfelse>

		<!---
		<tr>
		<td>&nbsp;</td>
		<td><img src="#SESSION.root#/Images/alert_stop.gif" alt="" border="0"></td>
		<td>Please define directory</td>
		</tr>		
	 	--->
</cfif>

</cfoutput>

</td></tr>
</table>

