
<cfquery name="Position" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM  PositionParent 
	WHERE PositionParentId = '#URL.ID#'
</cfquery>

<cfquery name="Funding" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   F.DateEffective,F.DateExpiration, R.*    		    
    FROM     PositionParentFunding F, Purchase.dbo.RequisitionLine R
	WHERE    PositionParentId = '#URL.ID#'	
	AND      F.RequisitionNo = R.RequisitionNo
	AND      R.ActionStatus NOT IN ('0','0z','9')			
	ORDER BY DateEffective, DateExpiration
</cfquery>
 
<cf_tl id="Save" var="1">
<cfset vsave=lt_text>	

<cfoutput>

<!--- this is for viewing only --->

   
<table border="0" align="center" width="99%" cellspacing="0" cellpadding="0" class="formpadding">
	    
	  <tr>
	  		    	    
	    <td>
		
			  <table width="100%" border="0" cellspacing="0" cellpadding="0">
						
				<tr><td height="4"></td></tr>
			
				<tr class="labelit linedotted">
				
					<td height="20" width="80"><cf_tl id="Effective"></td>
					<td width="80"><cf_tl id="Expiration"></td>
					<td width="20"><cf_tl id="Reference"></td>
					<td width="40%"><cf_tl id="Description"></td>
					<td align="right" width="30%"><cf_tl id="Requester"></td></td>					
														
				</tr>
				
				<cfif funding.recordcount eq "0">
					<tr><td colspan="6" height="20" align="center" class="labelmedium"><font color="gray"><cf_tl id="No records to show in this view"></td></tr>				
				</cfif>
			
				<cfloop query="Funding">
															
					<TR class="labelit linedotted" height="20">
					   <td>#Dateformat(dateeffective,CLIENT.DateFormatShow)#</td>	
					   <td>#Dateformat(dateexpiration,CLIENT.DateFormatShow)#</td>	
					   <td><a href="javascript:ProcReqEdit('#RequisitionNo#','dialog')"><font color="0080C0">#Reference#</font></a></td>				   				   					   
					   <td>#RequestDescription#</td>
					   <td>#OfficerFirstName# #OfficerLastName#</td>	
				    </TR>				
				
				</cfloop>
			
			</table>	
				
		</td>
		
	</tr>	
						
</table>	

</cfoutput>		