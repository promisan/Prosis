<cfoutput>

	<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" bordercolor="silver" rules="rows">
	
		<tr><td height="4"></td></tr>
		
		<cfset link = "#SESSION.root#/procurement/application/quote/reviewpanel/ReviewPanelMember.cfm?jobNo=#Object.ObjectKeyValue1#&PanelType=#URL.WParam#">
				
		<tr><td height="40" colspan="6" align="left">
		
		   <cf_selectlookup
		    class    = "Employee"
		    box      = "member"
			title    = "Add Panel Member"
			link     = "#link#"			
			dbtable  = "Purchase.dbo.stJobReviewPanel"
			des1     = "PersonNo">
					
		</td>
		</tr> 
			
		
		<tr bgcolor="ffffff">
	    <td width="100%" colspan="2">
		
			<cfdiv bind="url:#link#" id="member"/>
		
		</td>
		</tr>  
		
		<tr><td colspan="6" bgcolor="DADADA"></td></tr> 		
	
    </table>
      
</cfoutput>