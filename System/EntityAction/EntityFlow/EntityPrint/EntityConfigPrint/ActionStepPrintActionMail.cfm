<cfoutput>

<table width="97%" align="center" cellspacing="0" cellpadding="0">
	<tr><td height="6"></td></tr> 
	
	<tr>
	<td width="30%">Send a custom EMail</td>
	</tr>
	<tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;once this action becomes DUE:</td>
	<TD>
	<table border="0" cellspacing="0" cellpadding="0">
		<tr>
		<td width="30">
		<cfif #GetAction.PersonMailCode# neq "">Yes
			</td>
			<td>					
			<cfif GetAction.PersonMailCode neq "">

				<cfquery name="ActionMail" 
					dbtype="query">
					SELECT *
					FROM Mail
					Where DocumentCode = '#GetAction.PersonMailCode#'
					</cfquery>				
		
				 #ActionMail.DocumentDescription#
								 
			</cfif>
					
		<cfelse>
			No
		</cfif>
					
		</td>
		</tr>
	</table>
   </td>
	</tr>
						
	<tr>
	<td>Send a custom EMail</td>
	</tr>
	<tr>
	<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;once this action is PROCESSED:</td>
	<TD>												
	<table cellspacing="0" cellpadding="0">					
		<tr>						
		<td width="40">
		<cfif GetAction.PersonMailAction neq "">Yes
			</td>
							
			<cfquery name="ActionMail" 
				dbtype="query">
				SELECT *
				FROM Mail
				Where DocumentCode = '#GetAction.PersonMailAction#'
				</cfquery>				

			<TD>
			 #ActionMail.DocumentDescription#
			 
		<cfelse>
			No
		</cfif>							
		</td>							
		</tr>													
	</table>						
	</td>
	</tr>
				
	<cfif GetAction.PersonMailAction neq "">				
		<tr valign="top">
		<td align="left">
			<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/join.gif" align="absmiddle"	alt="" border="0">
			Attach "for this step" generated Documents:
		</td>									
		<td>
			<cfif GetAction.PersonMailActionAttach eq "1">Yes<cfelse>No</cfif>
		</td>
		</tr>	
	</cfif>			
</table>
		
</cfoutput>		
	