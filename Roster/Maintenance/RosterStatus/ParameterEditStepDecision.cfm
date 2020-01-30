
<cfquery name="Decision" 
 datasource="AppsSelection" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT    *
 FROM      Ref_RosterDecision 
 </cfquery>

<table width="95%" align="center" cellspacing="0" cellpadding="0">

<tr><td height="4"></td></tr>

<cfoutput query="Decision">

	<cfquery name="Decision" 
	 datasource="AppsSelection" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		 SELECT  *
		 FROM    Ref_StatusCodeCriteria
		 WHERE   Owner   = '#URL.Owner#'
		 AND     ID      = 'Fun'
		 AND     Status  = '#URL.Status#'
		 AND     DecisionCode = '#Code#'  
	 </cfquery>
				
	<tr onMouseOver="this.bgColor='FFFFCF'" 
	    onMouseOut="this.bgColor='FFFFFF'" 
		bgcolor="FFFFFF">
		
	<td width="25">
		<input type="checkbox" name="DecisionCode" value="#Code#" <cfif Decision.recordcount eq "1">checked</cfif>>
	</td>	
	<td width="96%" class="labelit">#Description#-#DescriptionMemo#</td>
	</tr>
	<cfif CurrentRow neq Recordcount>
	<tr><td height="1" colspan="2" class="linedotted"></td></tr>
	</cfif>						
			
</cfoutput>

</table>
