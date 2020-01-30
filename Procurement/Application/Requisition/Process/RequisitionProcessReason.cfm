
<cfparam name="URL.actionId" default="{00000000-0000-0000-0000-000000000000}">

<cfquery name="Line" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT L.*, M.EntryClass
    FROM   RequisitionLine L, ItemMaster M
	WHERE  L.ItemMaster = M.Code
	AND    RequisitionNo = '#url.requisitionNo#'
</cfquery>

<cfquery name="Revert" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   System.dbo.UserNames
	WHERE  Disabled = 0
	AND    AccountType = 'Individual'
	
	AND   ( Account IN (SELECT OfficerUserId 
	                   FROM   RequisitionLine
					   WHERE  Mission = '#Line.Mission#'
					   AND    Period  = '#Line.Period#'
					   AND    OrgUnit = '#Line.OrgUnit#')
			OR
			
			Account IN (SELECT UserAccount
			            FROM   Organization.dbo.OrganizationAuthorization
						WHERE  Mission 	     = '#line.mission#'
						AND    (OrgUnit      = '#Line.OrgUnit#' or OrgUnit is NULL)
						AND    Role           = 'ProcReqEntry'
						AND    ClassParameter = '#Line.EntryClass#')
		  )						   
					   
</cfquery>
      				
<cfquery name="GroupAll" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT    R.*, L.RequisitionNo as Selected
	FROM      RequisitionLineActionReason L RIGHT OUTER JOIN
              Ref_StatusReason R ON L.ReasonCode = R.Code AND L.RequisitionNo = '#url.requisitionNo#' 
			  AND L.ActionId = '#url.actionid#'	
	WHERE     Status      = '#URL.Status#'
	AND       StatusClass = '#URL.StatusClass#'		
	AND       (Mission = '#Line.Mission#' or Mission is NULL)
	AND       R.Operational = 1
</cfquery>
						
   <table width="100%">
   
	    <cfoutput>
        		
		<cfif url.status eq "9">
		
			<tr class="line"><td>
			
				<table cellspacing="0" cellpadding="0" class="formpadding">
				<tr>
				<td height="26">&nbsp;&nbsp;&nbsp;</td>
				<td class="labelmedium" style="padding-right:5px"><cf_tl id="Revert this request to the following requester" class="message">:</td>
				<td>
				<select name="RevertTo_#url.row#" id="RevertTo_#url.row#" class="regularxl">
					<cfloop query="Revert">
					<option value="#Account#" <cfif account eq line.officerUserId>selected</cfif>>#FirstName# #LastName#</option> 
					</cfloop>		
				</select>
				</td>		
				</tr>
				</table>
			
			</td></tr>
						
		</cfif>	
		
		</cfoutput>
   	 	   	  							
   		<TR><td width="100%" style="padding-bottom:4px">
							
	    <cfoutput>
					
		<table width="100%" border="0">
		
		<tr>
   			<td width="100%">
			
			<table width="100%"
		       border="0"			  
		       cellspacing="0"
		       cellpadding="0"			  
		       align="left">
			   
		
				</cfoutput>
			
			    <cfset row = 0>
									
				<cfoutput query="GroupAll">
														
					<cfif row eq "2">
					    <TR>						
						<cfset row = 0>
																		
					</cfif>
				
				    <cfset row = row + 1>
					
					<td width="50%" valign="top">
											
					<table width="100%">
					
						<cfif Selected eq "">
						  <TR class="regular" id="f#url.row#_#code#_0" style="border-bottom:1px solid silver">
						<cfelse> 
						  <TR class="highlight4" id="f#url.row#_#code#_0" style="border-bottom:1px solid silver">							         
						</cfif>		
						
						<TD width="5%" align="right" style="padding-left:3px;padding-right:4px">												
																				
						<cfif Selected eq "">
							<input type="hidden" name="f#url.row#_#code#" id="f#url.row#_#code#">
							<input type="checkbox" class="radiol"
							 name="f#url.row#_#code#_check" id="f#url.row#_#code#_check"
							 onClick="hla('f#url.row#_#code#','#code#',this.checked)"></TD>
						<cfelse>
							<input type="hidden" name="f#url.row#_#code#" id="f#url.row#_#code#" value="#code#">
							<input type="checkbox" class="radiol" name="f#url.row#_#code#_check" id="f#url.row#_#code#_check" 
							checked 
							onClick="hla('f#url.row#_#code#','#code#',this.checked)"></td>								
					    </cfif>
						</td>
										
						<td class="labelmedium" style="padding-left:4px;padding-right:5px" width="97%">#Description#</td>
						
						</tr>
						
						<cfif includespecification eq "1">

							<tr id="f#url.row#_#code#_1" class="<cfif Selected eq "">hide<cfelse>regular</cfif>">																						
							<td style="width:80%;padding:3px" colspan="2">
								<textarea style="width:100%;font-size:13px;font-size:13px;padding:3px" 
								    class="regular2" 
									rows="3" 
									name="f#url.row#_#code#_remarks"></textarea>								
							</td>							
							</tr>
						
						</cfif>
						
					</table>
					
					</td>
					<cfif GroupAll.recordCount eq "1">
   						<td width="50%"></td>
					</cfif>
				
				</CFOUTPUT>
														
				<cfif row eq "1">
					<td width="50%"></td>
				</cfif>
											
		    </table>
			
			</td></tr>
			
			</table>
								
		</td></tr>
						
	</table>
		
