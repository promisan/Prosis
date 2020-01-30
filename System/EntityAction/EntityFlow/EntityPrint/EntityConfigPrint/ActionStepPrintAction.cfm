
<cfparam name="URL.Tab" default="tab1">
<cfparam name="URL.PublishNo" default="">

<cfoutput>

<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr><td>
		<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr>
				<td width="30%" height="6"></td>
				<td width="20%"></td>
				<td width="30%"></td>
				<td width="25%"></td>	
			</tr>									
			<TR>
			<cfif GetAction.ActionParent eq "INIT">
			    <TD>Initial Step</TD>
			<cfelse>
			    <TD >Parent #Parent.ActionType# Step:</TD>
			    <TD>
				<cfif URL.PublishNo eq "">				
					<cfif GetAction.ActionOrder neq "" and GetAction.ActionParent neq "INIT"> 
						#Parent.ActionCode# #Parent.ActionDescription#
					<cfelse>	
						<cfif GetAction.ActionParent eq "INIT">
						First step
						</cfif>
					</cfif>					
					</TD>
					</TR>							
				<cfelse>				
					<table width="100%" cellspacing="0" cellpadding="0">
						<tr><td>												
						<cfif GetAction.ActionParent eq "INIT">
							First action
						<cfelse>
							#Parent.ActionCode# #Parent.ActionDescription#
						</cfif>
						<cfif GetAction.ActionType eq "Decision">				
						    <TD>&nbsp;Show as Separate Branch:</TD>
						    <TD>
							<cfif GetAction.ShowAsBranch eq "1">Yes<cfelse>No</cfif>
							</TD>							
						</cfif>					
					</table>
					</TD>
					</TR>
				</cfif>
			</cfif>
			
			<cfif Parent.BranchLabel neq "">
				<TR>
			    <TD >Under Parent Branch:</TD>
			    <TD>#Parent.BranchLabel#</td>
				</tr>
			</cfif>
																											
		    <TR>
		    <TD>Descriptive Completed:</TD>
		    <TD>
			#GetAction.ActionCompleted#
			</TD>
			</TR>
			
			 <TR>
		    <TD>Descriptive Denied:</TD>
		    <TD>
			#GetAction.ActionDenied#
			</TD>
			</TR>
			
			<TR>
		    <TD>Completed Box Color:</TD>
		    <TD>
			#GetAction.ActionCompletedColor#
			</TD>
			</TR>
			
		    <TR>
		    <TD>Actor Name:</TD>
		    <TD>
			#GetAction.ActionReference#
			</TD>
			</TR>					
		   
		    <TR>
	        <td >Action Performed by API:</td>
	        <TD >
			<cfif #GetAction.ActionTrigger# eq "External">
			 	Disable action dialog
			<cfelse>
				No
			</cfif>	
			</TR>
													
			<tr><td height="5"></td></tr>
	</table>
	</td>
	</tr>		
	<cfset Seperator = "6">
	
	<tr><td height="#Seperator#"></td></tr>
	
	<tr><td>	<strong>Instructions:</strong>
	</td></tr>
	<tr><td colspan="2" class="line"></td></tr>			
	<tr><td colspan="2">
	<table width="90%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr><td>
		<cfinclude template="ActionStepPrintMemo.cfm">	
		</td></tr>
	</table>	
	</td></tr>	
	
	<tr><td height="#Seperator#"></td></tr>	
		
	<tr><td>	<strong>Standard Settings:</strong>
	</td></tr>
	
	<tr><td colspan="2" class="line"></td></tr>			
												
	<tr><td colspan="2">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr><td>
					
		<cfquery name="Access" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_EntityAction
			WHERE  EntityCode = '#URL.EntityCode#'
			AND    Operational = '1' 
			AND    ListingOrder <= (SELECT ListingOrder 
			                      FROM Ref_EntityAction 
								  WHERE ActionCode = '#GetAction.ActionCode#')
			</cfquery>
											
		<cfinclude template="ActionStepPrintActionSettings.cfm">				
		</td></tr>
	</table>	
	</td></tr>

	
	<tr><td height="#Seperator#"></td></tr>
	
	<tr><td>	<strong>Workflow Process:</strong>
	</td></tr>
	<tr><td colspan="2" class="line"></td></tr>			
	<tr><td colspan="2">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr><td>
		<cfinclude template="ActionStepPrintFlow.cfm">	
		</td></tr>
	</table>	
	</td></tr>	
	
	
	<tr><td height="#Seperator#"></td></tr>
	
	<tr><td>	<strong>Authorization Settings:</strong>
	</td></tr>
	<tr><td colspan="2" class="line"></td></tr>			
	<tr><td colspan="2">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr><td>
		<cfinclude template="ActionStepPrintActionAuth.cfm">	
		</td></tr>
	</table>	
	</td></tr>
	
	<tr><td height="#Seperator#"></td></tr>

	<tr><td>	<strong>Custom Dialogs and Fields:</strong>
	</td></tr>	
	<tr><td colspan="2" class="line"></td></tr>			
	<tr><td colspan="2">				
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr><td>
		<cfinclude template="ActionStepPrintCustomFields.cfm">										
		</td></tr>
	</table>
	</td></tr>	
									   
	<tr><td height="#Seperator#"></td></tr>

	<tr><td>	<strong>Mail and Miscellaneous:</strong>
	</td></tr>
	<tr><td colspan="2" class="line"></td></tr>			
	<tr><td colspan="2">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr><td>
	  	<cfinclude template="ActionStepPrintActionMail.cfm">	
		<tr><td>
		<table width="96%" align="center" cellspacing="0" cellpadding="0">
			<tr><td class="line"></td></tr>				
		</table>	
		</td></tr>
		<tr><td>
	  	<cfinclude template="ActionStepPrintActionMisc.cfm">	
		</td></tr>
	</table>	
	</td></tr>
				
	<tr><td height="#Seperator#"></td></tr>

	<tr><td>	<strong>Documents:</strong>
	</td></tr>
	<tr><td colspan="2" class="line"></td></tr>			
	<tr><td colspan="2">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr><td>
	  	<cfinclude template="ActionStepPrintActionEmbed.cfm">													
		</td></tr>
	</table>	
	</td></tr>
									

	<tr><td height="#Seperator#"></td></tr>

	<tr><td>	<strong>Flow Methods:</strong>
	</td></tr>
	<tr><td colspan="2" class="line"></td></tr>			
	<tr><td colspan="2">
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr><td>
			<cfinclude template="ActionStepPrintActionMethod.cfm">		
		</td></tr>
	</table>	
	</td></tr>
</table>	


</cfoutput>
