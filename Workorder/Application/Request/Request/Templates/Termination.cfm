
<!--- termination --->

<cfquery name="LinePersonal" 
   datasource="AppsWorkOrder" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	 SELECT RW.ValueTo 
     FROM   RequestWorkorderDetail RW
	 <cfif url.requestid neq ""> 
	 WHERE  RW.Requestid       = '#url.requestid#'
	 <cfelse>
	 WHERE 1=0
	 </cfif>
	 AND    Amendment          = 'Personal'			
</cfquery>

<table width="100%" cellspacing="0" cellpadding="0">
<tr>
	
	<td><cf_space spaces="40"><font color="808080">Personal Usage:</td>
	
	<td width="90%" style="padding-left:1px">
	<cfif url.Accessmode eq "Edit">
	<table cellspacing="0" cellpadding="0">
	<tr>
		<td><input type="radio" name="PersonalTo" id="PersonalTo" value="Y" <cfif LinePersonal.ValueTo eq "Y">checked</cfif>></td><td>YES</td>
		<td>&nbsp;</td>
		<td><input type="radio" name="PersonalTo" id="PersonalTo" value="N" <cfif LinePersonal.ValueTo neq "Y">checked</cfif>></td><td>NO</td>
	</tr>
	</table>
	<cfelse>
	<cfoutput>
	#LinePersonal.ValueTo#
	</cfoutput>
	</cfif>
	</td>

</tr>
</table>