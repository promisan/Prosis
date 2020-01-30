<cfoutput>

<table width="97%" border="0" cellspacing="0" align="center" cellpadding="0">
			
	<tr>
		<td width="30%" height="6"></td>
		<td width="20%"></td>
		<td width="30%"></td>
		<td width="20%"></td>	
	</tr>
			
	<cfif GetAction.ActionType eq "Decision">	

		<cfquery name="ActionYes" 
			dbtype="query">
			SELECT *
			FROM QueryActions
			Where ActionCode = '#GetAction.ActionGoToYes#'
			</cfquery>		
						
		<cfquery name="ActionNo" 
			dbtype="query">
			SELECT *
			FROM QueryActions
			Where ActionCode = '#GetAction.ActionGoToNo#'
			</cfquery>					
		<tr>
	    <TD>Decision:</b></TD>
	    <TD colspan="3">				
    	<table cellspacing="0" cellpadding="0">		
			<tr><td>
			<table>
				<tr bgcolor="CEFFCE">
					<td width="10">Label:</td>
					<td width="20">#GetAction.ActionGoToYesLabel#</td>
					<td><cfif ActionYes.ActionType eq "Action">Acion<cfelse>Decision</cfif>: #ActionYes.ActionCode# #ActionYes.ActionDescription#</td>
				</tr>
				<tr><td height="1"></td></tr>
				<tr bgcolor="FDDFDB">
				<td>Label:</td>
				<td>#GetAction.ActionGoToNoLabel#</td>
				<td>
					<cfif ActionNo.ActionType eq "Action">Action<cfelse>Decision</cfif>: #ActionNo.ActionCode# #ActionNo.ActionDescription#</option>
				</td></tr>
		    </table>
			</td></tr>
		</table>
										
		</TD>
		</TR>
			
	<cfelse>
				
		<TR>
	    <TD>Submit Label:</TD>
	    <TD>
		#GetAction.ActionGoToYesLabel#
		</TD>
		</TR>
						
	</cfif>
					
	<TR>
    <TD>URL embed details:</TD>
    <TD>
	#GetAction.ActionURLDetails#
	</TD>
	</TR>
			
	<TR>
    <TD>			
	Embedded Workflow:
	</td>
	 <td>
	 #GetAction.EmbeddedClass#
	</td>
	</tr>		
			
	<TR>
    <TD>			
	Custom Dialog:	
	</TD>
    <td>
	<cfif GetAction.ActionDialog neq "">

		<cfquery name="ActionDialog" 
			dbtype="query">
			SELECT *
			FROM Dialog
			Where DocumentCode = '#GetAction.ActionDialog#'
			</cfquery>				
	
		 #ActionDialog.DocumentDescription# [#ActionDialog.DocumentMode#]
		</td>
		
		</TR>

		<TR>
	    <TD class="regular">			
		Disable standard dialog:
		</td>
		<td><cfif #GetAction.disableStandardDialog# eq "1">Yes<cfelse>No</cfif></td>
		</tr>		
	<cfelse>
		Standard</td></tr>
	</cfif>				
			
	<tr><td colspan="4" bgcolor="E8E8E8"></td></tr>
	<tr><td height="6"></td></tr>

									
	<TR>
	<TD>Quick process:</b></TD>
	<TD>
	<cfif GetAction.ActionDialog neq "">
		disabled
	<cfelse>
		<cfif #GetAction.enableQuickProcess# eq "1">
			Yes
		<cfelse>
			No
		</cfif>
	</cfif>	
	</td>

   	<TD>Show Area for Notes:</TD>
	<TD>
	   <cfif GetAction.enableTextArea eq "1">Yes<cfelse>No</cfif>
	</td>					
	</tr>
			
	<TR>
    <TD>View Embedded Documents:</TD>
	<TD>
			#GetAction.ActionViewMemo#   <!--- need to add name here --->
	</TD>
	
   	<TD>Show Notes as Rich Text Area:</TD>
	<TD>
	   <cfif GetAction.enableHTMLEdit eq "1">Yes<cfelse>No</cfif>
	</td>					
	</tr>
	
	<tr valign="top">				
   	<TD>Allow Custom Attachments 
	</TD>
	<TD>
		<cfif GetAction.enableAttachment eq "1">Yes<cfelse>No</cfif>
	</td>			

   	<TD>Show in [My Clearances]
	</TD>
	<TD>
		<cfif #GetAction.EnableMyClearances# eq "1">Yes<cfelse>No</cfif>
	</td>			
	
	</tr>
		
	<tr valign="top">				
   	<TD>Sent Due Mail to Actor
	</TD>
	<TD>
		<cfif #GetAction.enableNotification# eq "1">Yes<cfelse>No</cfif>
	</td>			
	</tr>
	
	<cfif #GetAction.enableNotification# eq "1">
	
		<tr valign="top">				
		<TD>
			Confirm email:
		</td>
		<td>
			<cfif GetAction.enableQuickProcess eq "1">disabled
			<cfelse>
				<cfif #GetAction.NotificationManual# eq "1">Yes<cfelse>No</cfif>
			</cfif>	
		</td>
		</tr>

		<tr>
		<TD>
			Include global users:
		</td><td>	
			<cfif #GetAction.NotificationGlobal# eq "1">Yes<cfelse>No</cfif>		
		</td>
		</tr>
	
		<TR>
		<td>
		Mail template:
		</td><td>
		<cfif GetAction.DueMailCode neq "">

			<cfquery name="ActionMail" 
				dbtype="query">
				SELECT *
				FROM Mail
				Where DocumentCode = '#GetAction.DueMailCode#'
				</cfquery>				

			 #ActionMail.DocumentDescription#
		
		<cfelse>
			Default
		</cfif>				
		</td>
		</tr>		
			
	</cfif>	
	
	<tr><td ></td></tr>
	</TD></TR>
									
</table>
			
</cfoutput>			