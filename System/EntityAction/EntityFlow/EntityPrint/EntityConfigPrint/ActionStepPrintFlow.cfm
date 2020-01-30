
<cfif URL.PublishNo eq "">

	<cfquery name="NEXT" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  A.ActionCode, A.ActionDescription, A.ActionType, A.ActionReference, Go.ConditionScript, Go.ProcessActionCode AS Enabled
		FROM    Ref_EntityClassAction A INNER JOIN
                Ref_EntityClassActionProcess Go ON A.EntityCode = Go.EntityCode 
				AND A.EntityClass = Go.EntityClass 
				AND A.ActionCode = Go.ProcessActionCode 
				AND Go.ProcessClass = 'GoTo'  
				AND Go.Operational = '1'  
				AND Go.ActionCode = '#GetAction.ActionCode#'
		WHERE   A.EntityCode = '#URL.EntityCode#'
		 AND    A.EntityClass = '#URL.EntityClass#'
		 AND    A.ActionOrder is not NULL
		ORDER BY A.ActionCode						 						 
	</cfquery>
	
<cfelse>	

	<cfquery name="Next" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT  A.ActionCode, A.ActionDescription, A.ActionType, A.ActionReference, Go.ConditionScript, Go.ProcessActionCode AS Enabled
		FROM    Ref_EntityActionPublish A INNER JOIN
                Ref_EntityActionPublishProcess Go ON A.ActionPublishNo = Go.ActionPublishNo
				 AND A.ActionCode = Go.ProcessActionCode 
				 AND Go.ProcessClass = 'GoTo' 
				 AND Go.Operational = '1' 
				 AND Go.ActionCode = '#GetAction.ActionCode#'
		WHERE   A.ActionPublishNo = '#URL.PublishNo#'
		 AND    A.ActionOrder is not NULL
		ORDER BY A.ActionOrder,A.ActionCode						 						 
	</cfquery>

</cfif>

<cfoutput>
	
<table width="97%" align="center" cellspacing="0" cellpadding="0" border="0" class="formpadding">
			
	<tr><td height="6"></td></tr> 
	<TR>

		<TD width="30%" height="25">Next action:</TD>
		<TD>
		<cfSwitch Expression="#GetAction.ActionGoTo#">
			<cfcase value="0">
				Disabled
			</cfcase>
			<cfcase value="1">
				Enabled, for pending steps only
			</cfcase>
			<cfcase value="2">
				Enabled, for already performed steps (send back)
			</cfcase>
			<cfcase value="3">
				Enabled, for all steps
			</cfcase>
		</cfswitch>		
							
		</td>
	</tr>
		
	<cfif GetAction.ActionGoTo gte "1" AND Next.RecordCount gte "1">

		<tr><td height="1"></td></tr>
		<tr><td height="20" colspan="2">Actions that may be performed once this step has been reached (besides the predefined next action)</td></tr>
		<tr>
			
		<td height="95%"colspan="2">
																						
			<table width="97%" height="100%" border="0" align="center" cellspacing="0" cellpadding="0">
				<cfloop query="Next">
					<tr class="line">
						<td width="30%"></td>
						<td width="10%">#ActionCode#</td>
						<td width="30%">#ActionDescription#</td>
						<td width="10%">#ActionType#</td>
						<td width="20">#ActionReference#</td>
					</tr>
				</cfloop>
			</table>		
									
		</TD>
		</TR>
	</cfif>	
</table>	
			
</cfoutput>		
	