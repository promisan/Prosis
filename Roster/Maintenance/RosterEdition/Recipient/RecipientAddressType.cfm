<cfquery name="qTypes" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
  SELECT AddressType, Operational, T.Description
  FROM   Ref_SubmissionEditionAddressType R
  LEFT   OUTER JOIN Organization.dbo.Ref_AddressType T
  		ON R.AddressType = T.Code
  WHERE  SubmissionEdition = '#URL.SubmissionEdition#'
</cfquery>

<cfoutput>

<cfset TotalActive = 0>

<table border="0" cellspacing="0" cellpadding="0">
	
	
	<TR valign="top">

	<TD style="padding-left:53px"></TD>	
	<TD>
		<table border="0">
			<tr height="20px" align="left">
			<cfloop query="qTypes">
				
					<td width="2%">
						<cfif operational eq 1>
							<input type="checkbox" onclick="recipienttype('disable','#URL.SubmissionEdition#','#AddressType#')" checked>
							<cfset TotalActive = TotalActive + 1>
						<cfelse>
							<input type="checkbox" onclick="recipienttype('enable','#URL.SubmissionEdition#','#AddressType#')">
						</cfif>
	
					</td>		
					<td  class="labelmedium" style="padding-left:4px;padding-right:10px;">
						<cfif Description neq "">	
							#Description#
						<cfelse>
							#AddressType#
						</cfif>
					</td>
							
			</cfloop>
		   </tr>
		</table>
	</TD>

	</TR>		

</TABLE>

<script language="JavaScript1.1">
	$('##ltypesrecipients').html('<b>Types of Addressee (#TotalActive#)</b>');
</script>

</cfoutput>


