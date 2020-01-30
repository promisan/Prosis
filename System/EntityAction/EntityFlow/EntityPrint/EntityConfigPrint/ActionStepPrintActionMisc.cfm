<cfoutput>

<table width="97%" align="center" cellspacing="0" cellpadding="0">
	<tr><td height="6"></td></tr>
    <TR>
	<TD width="30%">&nbsp;Lead-time:</b></TD>
	<TD>
	#GetAction.ActionLeadtime# days
	</TD>
	</TR>
				
	<TR>
	<TD>&nbsp;Color of the completed step (Box):</b></TD>
	<TD>
	#GetAction.ActionCompletedColor# 	   
	</TD>
	</TR>
				
	<TR>
	<TD>&nbsp;Show Reference:</b></TD>
	<TD>
	<cfif #GetAction.ActionReferenceShow# eq "1">Yes<cfelse>No</cfif>
	</td>
	<TR>				
</table>
		
</cfoutput>		
	