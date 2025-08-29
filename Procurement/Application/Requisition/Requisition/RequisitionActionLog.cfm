<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfparam name="url.close" default="0">

<cfquery name="get" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT   *
	FROM     RequisitionLine R, ItemMaster I
	WHERE    R.ItemMaster = I.Code
	AND      R.RequisitionNo = '#URL.ID#'	
</cfquery>


<cfquery name="RootUnit" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT    Root.OrgUnit
    FROM      Organization Org INNER JOIN
              Organization Root ON Org.HierarchyRootUnit = Root.OrgUnitCode AND Org.Mission = Root.Mission AND Org.MandateNo = Root.MandateNo
	WHERE     Org.OrgUnit = '#get.OrgUnit#'
</cfquery>

<cfquery name="Action" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    SELECT   R.ActionId, 
	         R.ActionDate, 
			 R.OfficerLastName, 
			 R.OfficerFirstName, 
				 (SELECT Description 
				  FROM Status 
				  WHERE Status = R.ActionStatus AND StatusClass = 'Requisition') as StatusToDescription,
				 (SELECT StatusDescription 
				  FROM Status 
				  WHERE Status = R.ActionProcess AND StatusClass = 'Requisition') as ProcessDescription,  			
			 R.ActionStatus,
			 R.ActionProcess,			 
			 R.ActionMemo,
			 (SELECT count(*) FROM RequisitionLineActionReason WHERE RequisitionNo = '#URL.ID#'
			 AND ActionId = R.ActionId) as Reason
	FROM     RequisitionLineAction R 
	WHERE    R.RequisitionNo = '#URL.ID#'
	AND      R.ActionDate IN (SELECT TOP 30 ActionDate FROM RequisitionLineAction WHERE RequisitionNo = '#URL.ID#' ORDER BY ActionDate DESC)
	AND      (R.ActionMemo != 'Print' or ActionMemo is NULL)
	ORDER BY R.Created 
</cfquery>
			
<table width="97%" border="0" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

	<tr><td height="4"></td></tr>
	
	<tr class="labelmedium line">
	  <td height="20" width="30"></td> 
	  <td width="120"><cf_tl id="Timestamp"></td>
	  <td width="160"><cf_tl id="Name"></td>
	  <td width="100"><cf_tl id="Module"></td>
	  <td width="160"><cf_tl id="Set Status to"></td>
	  <td width="25%"><cf_tl id="Memo"></td>	 
	</tr>	
	
	<cf_RequisitionNextStep RequisitionNo = "#url.id#">
		
	<cfset prior = "">
	
	<cfoutput query="Action">	
						
		<cfif recordcount eq currentrow>
			<cfset cl = "ffffcf">
		<cfelse>
			<cfset cl = "white">
		</cfif>		
		
		<tr bgcolor="#cl#" style="height:24px" class="labelmedium line navigation_row">
		  <td style="padding-left:3px;padding-right:2px">#currentRow#.</td> 
		  <td><a href="javascript:showarchive('#actionid#','#url.id#')" class="navigation_action">
		  	#DateFormat(ActionDate,CLIENT.DateFormatShow)# #TimeFormat(ActionDate,"HH:MM")#
		  </a>
		  </td>
		  <td>#OfficerFirstName# #OfficerLastName#</td>
		  <td>#ProcessDescription#</td>		 
		  <td><cfif ActionStatus eq "9"><font color="FF0000"></cfif>		  
		  	  <!--- check prior status --->		  
			  <cfif prior neq actionstatus>		  
				  #StatusToDescription# <font size="1">(#ActionStatus#)
			  </cfif>		  
		  </td>
		  
		  <td>
		  
		  	 <table cellspacing="0" cellpadding="0">
		  
		  	   <cfif actionmemo neq "">	
		
					<tr style="height:18px"  class="labelmedium"><td>#ActionMemo#</td></tr>	
		
			   </cfif>
		  
		       <cfif Reason gte "1">
								  
				   <cfquery name="ReasonList" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT  R.Description, A.ReasonCode, A.Remarks
						FROM    RequisitionLineActionReason A INNER JOIN
					            Ref_StatusReason R ON A.ReasonCode = R.Code
						WHERE  ActionId = '#ActionId#' 
				   </cfquery>	
				  			  
				   <cfloop query="ReasonList">
						<tr style="height:18px"  class="labelmedium"><td>#Description# <cfif remarks neq "">- #Remarks#</cfif></td></tr>
				   </cfloop>			
			   		  
		      </cfif>		
			  
			  </table>  
			  
		  </td>
		  
		</tr> 
		
		<cfset prior = actionstatus>
						
	</cfoutput>		
	
	<cfif Action.ActionStatus neq "3">
	
		<cfoutput>
		<!---
		<tr><td colspan="6" class="linedotted"></td></tr>
		<tr><td height="20" colspan="6" style="padding-left:10px" class="labelmedium" bgcolor="DFEFFF">Next action:&nbsp;<b>#NextStepDescription#</b></td></tr>
		--->
		
		<cfif get.ActionStatus lt "2k">
								
			<!--- get the flow structure --->
			
			<cfquery name="Flow" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT    *
				FROM      Ref_ParameterMissionEntryClass
				WHERE     Mission    = '#get.Mission#'
				AND       Period     = '#get.Period#' 
				AND       EntryClass = '#get.EntryClass#'
			</cfquery>
				
			<cfquery name="Roles" 
			datasource="AppsOrganization" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				
				SELECT   R.Role, 
						 R.Description,
						 R.ListingOrder
								  
				FROM     Ref_AuthorizationRole R
					 
			   	WHERE    R.Area      = 'Material Management'  	
				AND      Role IN (SELECT Role 
					                  FROM   Purchase.dbo.Status 
									  WHERE  StatusClass = 'Requisition' 
									  AND    Status > '#get.ActionStatus#')					  
				AND      R.Role IN ('ProcReqReview'<cfif flow.EnableClearance eq "1">,'ProcReqApprove'</cfif><cfif flow.EnableBudgetReview eq "1">,'ProcReqBudget'</cfif>,'ProcReqCertify') 
									
				<cfif flow.EnableFundingClear eq "1">
				
					UNION
					
					SELECT   R.Role, 
							 R.Description,
							 R.ListingOrder								  
					
					FROM     Ref_AuthorizationRole R
						 
				   	WHERE    R.Area      = 'Material Management'  				  
					AND      Role     = 'ProcReqObject' 	
					AND      Role IN (SELECT Role 
					                  FROM   Purchase.dbo.Status 
									  WHERE  StatusClass = 'Requisition' 
									  AND    Status > '#get.ActionStatus#')							
								
				</cfif>									   
				
				ORDER BY R.ListingOrder 	
		
			</cfquery>		
			
			<cfset row = 0>					
														
			<cfloop query="Roles">
										
				<cfset row = row+1>
						
			    <cfif row eq "1">		
				
					<tr><td class="line" colspan="6"></td></tr>							
					<tr class="line navigation_row" bgcolor="98EFA7">
				
				<cfelse>
				
					<tr class="linedotted navigation_row">
									
				</cfif>
			
				<cfset cnt = action.recordcount + currentrow>
								
					<td class="labelmedium" valign="top" style="padding-left:3px;padding-top:3px">#cnt#. </td>
					<td class="labelmedium" valign="top" style="padding-left:2px;padding-top:3px">#Description#</td>
					
					<td colspan="4">
					
						<table cellspacing="0" cellpadding="0">
						
						<cfif Role neq "ProcReqObject">
						
								<cfquery name="Users" 
								datasource="AppsOrganization" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									
									SELECT   DISTINCT S.Account, 
									                  S.PersonNo, 
													  S.FirstName, 
													  S.LastName
													  
									FROM     OrganizationAuthorization AS OA INNER JOIN
								             System.dbo.UserNames AS S ON OA.UserAccount = S.Account
										 
								   	WHERE    OA.Mission  = '#get.Mission#' 
									AND      OA.Role = '#Role#'						
									AND      (OA.OrgUnit = '#get.OrgUnitImplement#' OR OA.OrgUnit IS NULL) 
									AND      OA.ClassParameter = '#get.EntryClass#' 									
									AND      S.Disabled  = 0 
									AND      S.AccountType = 'Individual' AND S.Account <> 'Administrator'						
									
									UNION
									
									SELECT  DISTINCT S.Account, 
									                  S.PersonNo, 
													  S.FirstName, 
													  S.LastName
									FROM   Purchase.dbo.RequisitionLineAuthorization OA INNER JOIN
								           System.dbo.UserNames AS S ON OA.UserAccount = S.Account
									WHERE  OA.Role = '#Role#'
									AND    OA.RequisitionNo = '#get.RequisitionNo#'			
									
								</cfquery>
							
							<cfelse>
							
								<cfquery name="Users" 
								datasource="AppsOrganization" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								
									
									SELECT   DISTINCT S.Account, 
									                  S.PersonNo, 
													  S.FirstName, 
													  S.LastName
													  
									FROM     OrganizationAuthorization AS OA INNER JOIN
								             System.dbo.UserNames AS S ON OA.UserAccount = S.Account
										 
								   	WHERE    OA.Mission  = '#get.Mission#' 
									AND      (OA.OrgUnit = '#rootunit.OrgUnit#' OR OA.OrgUnit IS NULL) 									  
									AND      OA.Role     = 'ProcReqObject' 								
									AND      S.Disabled  = 0 
									AND      S.AccountType = 'Individual' AND S.Account <> 'Administrator'				
									
										   
												
								</cfquery>					
							
						</cfif>			
						
						<cfif users.recordcount eq "0">
						
							<tr><td class="labelmedium"><font color="FF0000"><b>Attention</b>: No authorised users found</font></td></tr>
						
						<cfelse>
						
							<cfloop query="Users">
							<tr><td class="labelmedium">#FirstName# #LastName#</td></tr>
							</cfloop>
						
						</cfif>
						
						</table>
						
					</td>	
					
			</tr>		
																	
			</cfloop>
									
		
		</cfif>
		
		<cfquery name="Buyer" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     RequisitionLineActor
			WHERE    RequisitionNo = '#url.id#' 
			AND      Role          = 'ProcBuyer'   		
		</cfquery>
				
		<cfif buyer.recordcount gte "1">
			
			<tr><td colspan="6" class="labelmedium" bgcolor="f4f4f4" style="padding-left:30px">
			
				<table><tr>
					<td>				
					<cf_tl id="Assigned Buyer(s)">:
					</td>
					<td class="labelmedium">
					<cfloop query="Buyer">
					<cfif currentrow neq "1">|</cfif>
					#ActorFirstName# #ActorLastName# (#dateformat(created,CLIENT.DateFormatShow)#)	
					</cfloop>
					</td>
					
				</tr></table>			
								
		</tr>		
		
	<cfquery name="Purchase" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   P.Purchaseno, P.ActionStatus
		FROM     Purchaseline PL, Purchase P
		WHERE    PL.PurchaseNo = P.PurchaseNo
		AND      RequisitionNo = '#url.id#'   
		AND      P.ActionStatus != '3'
		AND      PL.ActionStatus != '9'		
	</cfquery>
		
	<cfif purchase.recordcount gte "1">
	
	<tr><td class="labelmedium" style="min-width:120px;padding-left:30px" height="22"><cf_tl id="Purchase">:</td>
		
		<td class="labelmedium" colspan="5">
		<a href="javascript:ProcPOEdit('#purchase.purchaseno#')">#Purchase.PurchaseNo# <cfif Purchase.ActionStatus lt "3"><font color="FF0000">[<cf_tl id="Pending">]</cfif></font></a>
		</td>
		
	</tr>
	
	</cfif>		
			
		</cfif>	
		
		</cfoutput>
	
	</cfif>
			
</table>

<cfset AjaxOnLoad("doHighlight")>	