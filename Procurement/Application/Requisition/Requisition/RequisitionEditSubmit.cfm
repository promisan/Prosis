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
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>
<!--- End Prosis template framework --->

<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cfset funds     = "Yes">
<cfset showentry = 0>	

<cfparam name="URL.Mode"                default="workflow">
<cfparam name="URL.refer"               default="">
<cfparam name="Form.StandardCode"       default="">
<cfparam name="Form.ItemNo"             default="">
<cfparam name="Form.RequestDescription" default="">
<cfparam name="Form.WarehouseUoM"       default="">
<cfparam name="Form.AmountHasChanged"   default="0">

<cfif URL.refer eq "workflow">
     <cfset URL.ID = "#form.key1#">
</cfif>

<cfquery name="ReqLine" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  L.*,S.EnableClearance,S.EnableBudgetReview				
		FROM    RequisitionLine L INNER JOIN 
		        ItemMaster I ON I.Code = L.ItemMaster INNER JOIN 
				Ref_ParameterMissionEntryClass S ON L.Mission = S.Mission AND L.Period = S.Period AND I.EntryClass = S.EntryClass
		WHERE   RequisitionNo = '#URL.ID#' 
		
</cfquery>

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#ReqLine.Mission#'
</cfquery>

<cfparam name="url.action" default="">

<!--- ---------------------------------- --->
<!--- --- Send back to requisitioner --- --->
<!--- ---------------------------------- --->

<cfif url.action eq "clone">

	<cf_copyRequisitionLine requisitionNoFrom="#url.id#" workorder="Yes">

</cfif>

<cfif url.action eq "revert">

    <cftransaction>

	<cfquery name="Line" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    UPDATE  RequisitionLine
		SET     ActionStatus = '1'
		WHERE   RequisitionNo = '#URL.ID#' 
	</cfquery>
	
	<cfparam name="Form.ActionMemo"    default="">
	<cfparam name="Form.ActionContent" default="">		
	
	<cfif len(form.actionMemo) lte 70>
		<cfset memo = "#form.ActionMemo# Sent back to Requester">
	<cfelse>
	    <cfset memo = "Sent back to Requester">
	</cfif>	
	
	<cf_assignId>
		
	<cfquery name="InsertAction" 
	     datasource="AppsPurchase" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     INSERT INTO RequisitionLineAction 
				 (RequisitionNo, 
				  ActionId,	
				  ActionStatus, 
				  ActionDate, 
				  ActionMemo,
				  ActionContent,
				  OfficerUserId, 
				  OfficerLastName, 
				  OfficerFirstName) 
	     VALUES ('#URL.ID#',
		         '#rowguid#', 
		         '1', 
				  getDate(), 
				 '#memo#',
				 '#Form.ActionContent#',
				 '#SESSION.acc#', 
				 '#SESSION.last#', 
				 '#SESSION.first#')
	</cfquery>
						
	<cfquery name="Options" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT    *
			FROM      Ref_StatusReason
			WHERE     Status      = '9'
			AND       StatusClass = 'requisition'		 		
			AND       Operational = 1
	</cfquery>		
		
	<cfloop query="Options">
		
			<cfparam name="FORM.f1_#code#"         default="">
			<cfparam name="FORM.f1_#code#_remarks" default="">
			
			<cfset cde = evaluate("FORM.f1_#code#")>
											
			<cfif cde neq "">
			
				<cfset memo = evaluate("form.f1_#code#_remarks")>
								
				<cfif Len(memo) gt 400>
					 <cfset memo = left(memo,400)>
				</cfif>
			
				<!---  3. enter reasons --->
				<cfquery name="InsertActionReason" 
				     datasource="AppsPurchase" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					     INSERT INTO RequisitionLineActionReason
							 (RequisitionNo, 
							  ActionId, 
							  ReasonCode, 
							  Remarks, 
							  OfficerUserId, 
							  OfficerLastName, 
							  OfficerFirstName) 
						 VALUES  
							 ('#URL.ID#', 
							  '#rowguid#', 
							  '#cde#', 
							  '#memo#', 					 
							  '#SESSION.acc#', 
							  '#SESSION.last#', 
							  '#SESSION.first#')						
				</cfquery>					
			
			</cfif>				
		
		</cfloop>	
					
		<cfparam name="FORM.revertTo_1"  default="">
							
		<cfset user = evaluate("FORM.revertTo_1")>
				
		<cfif user neq "">
										
			<cfquery name="checkUser" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				     SELECT * 
					 FROM   RequisitionLineActor 
					 WHERE  RequisitionNo = '#URL.ID#'
					 AND    Role          = 'ProcReqEntry'
					 AND    ActorUserid   = '#user#'
			</cfquery>			
		
			<cfif checkUser.recordcount eq "0">
			
			    <cfquery name="UserName" 
			     datasource="AppsPurchase" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
				     SELECT * 
					 FROM   System.dbo.UserNames 
					 WHERE  Account = '#user#'									
			    </cfquery>		
									
			    <!---  3. enter action --->
				<cfquery name="InsertAction" 
				     datasource="AppsPurchase" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     INSERT INTO RequisitionLineActor 
						   (RequisitionNo, 
						    Role,
						    ActorUserId,
						    ActorLastName,
						    ActorFirstName,									 
						    OfficerUserId, 
						    OfficerLastName, 
						    OfficerFirstName) 
					 SELECT RequisitionNo, 
					        'ProcReqEntry',
					        '#user#', 
							'#userName.lastName#',
							'#userName.firstName#',											
							'#SESSION.acc#', 
							'#SESSION.last#', 
							'#SESSION.first#'
					 FROM  RequisitionLine
					 WHERE RequisitionNo = '#URL.ID#'
				</cfquery>		
			
			</cfif>

		</cfif>		
		
		</cftransaction>
		
		<cfif Parameter.EnableDenyMail eq "1" and Parameter.TemplateEMail neq "">				 
		 
		   <cfset req = url.id>							
		   <cfinclude template="../../../Workflow/ReqMail.cfm">	
		   
		   <script>		    
		     	alert("Request has been sent back to requester and an eMail has been sent to notify him/her")
		   </script>
		   
		<cfelse>  
		
		   <cfoutput>
			   <script>		    
			   	   alert("Request was sent back to requester (#ReqLine.OfficerFirstName# #ReqLine.OfficerLastName#).")
			   </script> 
		   </cfoutput>
		
		</cfif>			
	
<cfelseif url.action eq "cancel">

<!--- ---------------------------------- --->
<!--- ---- cancel requisition ---------- --->
<!--- ---------------------------------- --->

	<cftransaction>

	<cfquery name="Line" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    UPDATE RequisitionLine
		SET    ActionStatus = '9'
		WHERE  RequisitionNo = '#URL.ID#'  
	</cfquery>
	
	<cf_assignId>
	
	<cfquery name="InsertAction" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO RequisitionLineAction 
					 (RequisitionNo, 
					  ActionId,
					  ActionStatus, 
					  ActionDate, 
					  OfficerUserId, 
					  OfficerLastName, 
					  OfficerFirstName) 
		     VALUES ('#URL.ID#', 
			         '#rowguid#',
			         '9', 
					 '#DateFormat(Now(),CLIENT.dateSQL)#', 
					 '#SESSION.acc#', 
					 '#SESSION.last#', 
					 '#SESSION.first#')
		</cfquery>
		
	   <!--- retrieve adn save reasons --->
				
		<cfquery name="Options" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    *
			FROM      Ref_StatusReason
			WHERE     Status      = '9'
			AND       StatusClass = 'requisition'		 		
		</cfquery>		
			
		<cfloop query="Options">
			
				<cfparam name="FORM.f1_#code#"         default="">
				<cfparam name="FORM.f1_#code#_remarks" default="">
				
				<cfset cde = evaluate("FORM.f1_#code#")>
												
				<cfif cde neq "">
				
					<cfset memo = evaluate("form.f1_#code#_remarks")>
															
					<cfif Len(memo) gt 400>
						<cfset memo = left(memo,400)>
					</cfif>
				
					<!---  3. enter reasons --->
					<cfquery name="InsertActionReason" 
					     datasource="AppsPurchase" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">						
					     INSERT INTO RequisitionLineActionReason
						 (RequisitionNo, ActionId, ReasonCode, Remarks, OfficerUserId, OfficerLastName, OfficerFirstName) 
						 VALUES  
						 ('#URL.ID#', '#rowguid#', '#cde#', '#memo#', '#SESSION.acc#', '#SESSION.last#', '#SESSION.first#')						
					</cfquery>					
				
				</cfif>				
			
		</cfloop>	
		
		</cftransaction>	
		
		<!--- user selected denied which will trigger an eMail 
				script to send a denial message and attachment --->
				
		<cfif Parameter.EnableDenyMail eq "1" and Parameter.TemplateEMail neq "">		
			
			<cfset req = url.id>						
			<cfinclude template="../../../Workflow/ReqMail.cfm">	
						  
			<cf_tl id="Request has been cancelled and an eMail has been sent to notify the requester" var="vMessage">
			
			<cfoutput>
		    <script>
		     	alert("#vMessage#.")				
		    </script>
			</cfoutput>	
		   
		<cfelse>
			
			 <cf_tl id="Request has been cancelled and will appear under the tree node: Cancelled" var="vMessage">
			 
			 <cfoutput>		
			 <script>
		    	alert("#vMessage#.")				
		    </script>		
			</cfoutput>	   
		
		</cfif>			
			
<cfelseif url.action eq "Reinstate">

<!--- ---------------------------------- --->
<!--- ------- reinstate ---------------- --->
<!--- ---------------------------------- --->

	<cfquery name="Check" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * FROM RequisitionLine
		WHERE  RequisitionNo = '#URL.ID#'		
	</cfquery>
	
	<!--- check the CMP mode --->
	
	<cfquery name="CheckPurchaseLine" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * FROM InvoicePurchase
		WHERE  RequisitionNo = '#URL.ID#'				
	</cfquery>
	
	<cfif checkPurchaseLine.recordcount eq "0">
	
		<cfquery name="ClearPurchaseLine" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    DELETE FROM PurchaseLine
			WHERE  RequisitionNo = '#URL.ID#'		
			AND    ActionStatus = '9'
		</cfquery>
		
		<!--- check if a valid job exists --->
	
		<cfquery name="Job" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
			FROM   Job
			WHERE  JobNo = '#Check.JobNo#'
			AND    ActionStatus != '9'
		</cfquery>
		
		<cfif Check.JobNo eq "" or Job.ActionStatus eq "2">
		
		    <!--- we reinstate this to the last logged status != '3' --->
			
			<cfquery name="LineLog" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT   TOP 1 *
				FROM     RequisitionLineAction
				WHERE    RequisitionNo = '#URL.ID#'			
				AND      ActionStatus NOT IN ('3','9')
				ORDER BY ActionDate DESC
			</cfquery>
			
			<cfif LineLog.recordcount eq "1">	
	
				<cfquery name="Line" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    UPDATE RequisitionLine
					SET    ActionStatus = '#LineLog.ActionStatus#', 
					       JobNo = NULL
					WHERE  RequisitionNo = '#URL.ID#'			
				</cfquery>
			
			<cfelse>
			
				<cfquery name="Line" 
				datasource="AppsPurchase" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				    UPDATE RequisitionLine
					SET    ActionStatus = '1', 
					       JobNo = NULL
					WHERE  RequisitionNo = '#URL.ID#'			
				</cfquery>
			
			</cfif>
			
		<cfelse>
		
			<cfquery name="Line" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    UPDATE RequisitionLine
				SET    ActionStatus = '2k'
				WHERE  RequisitionNo = '#URL.ID#'			
			</cfquery>	
			
			 <script>
			   	alert("Request has been reinstated under its predefined procurement job.")
			 </script>	
		
		</cfif>	
				
	<cfelse>
	
		<cfquery name="ClearPurchaseLine" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    UPDATE PurchaseLine
			SET    ActionStatus = '3'
			WHERE  RequisitionNo = '#URL.ID#'					
		</cfquery>
				
	</cfif>	
	
	<cfquery name="InsertAction" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
		     INSERT INTO RequisitionLineAction 
					 (RequisitionNo, 
					  ActionStatus, 
					  ActionDate, 
					  ActionMemo,
					  OfficerUserId, 
					  OfficerLastName, 
					  OfficerFirstName) 
		     VALUES ('#URL.ID#', 
			         '1', 
					 '#DateFormat(Now(),CLIENT.dateSQL)#', 
					 'Reinstated',
					 '#SESSION.acc#', 
					 '#SESSION.last#', 
					 '#SESSION.first#')
		</cfquery>
		
<cfelseif url.action eq "purge">		
	
	<cfquery name="Line" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    DELETE FROM RequisitionLine
		WHERE RequisitionNo = '#URL.ID#'
	</cfquery>
	
	 <script>
		   	// alert("Request has been removed from the system.")
			try { parent.document.getElementById("Close").click() } catch(e) {}
	 </script>	
		 
	<cfset showentry = 1>

<cfelse>	

	<cfparam name="FORM.REQUESTQUANTITY" default="">
	<cfparam name="FORM.RequestDate"     default="">
	<cfparam name="FORM.PersonNo"        default="">
	<cfparam name="Form.QuantityUom"     default="Each">
		
	<!--- ----------------------------------------- --->
	<!--- ------- save/submit requisition---------- --->
	<!--- ----------------------------------------- --->

	<cfif ParameterExists(Form.Save) or 
	      ParameterExists(Form.saveaction) or 
		  ParameterExists(Form.EmbedSave)> 
		  					
		  <cftry>		
		  	
			<cfquery name="Line" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
			    FROM RequisitionLine
				WHERE RequisitionNo = '#URL.ID#' 
			</cfquery>			
						
			<!--- verify --->
			
			<cfparam name="form.orgunit1" default="">
			
			<!--- error message --->
			<cfif form.orgunit1 eq "">
					
				 <cf_tl id="REQ024" var="1">
				 <cfset vReq024=lt_text>
			
				<script>
					Prosis.busy('no')
				</script>
			     <cf_messageDialog message = "#vReq024# : No OrgUnit defined">
				  <cfabort>
			   
			</cfif>
			
			<cfset client.orgunit = "#form.orgunit1#">
			<cfif parameter.EnableDueDate eq "1">
			
				<cfset dateValue = "">
				<CF_DateConvert Value="#Form.RequestDue#">
				<cfset due = dateValue>		
				<cfif due gte now()>
				    <!--- remember due date date --->
					<cfset client.duedate = due>
				</cfif>	
			
			<cfelse>
			
			</cfif>				
					
			<cfset qty  = replace(Form.RequestQuantity,",","","ALL")>
																
			<cfquery name="Percentage" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT SUM(Percentage) as Percentage
			    FROM   RequisitionLineFunding F  
				WHERE  RequisitionNo = '#URL.ID#' 
			</cfquery>
			
			<cfquery name="Check" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT *
				FROM   RequisitionLine  
				WHERE  RequisitionNo = '#URL.ID#' 
			</cfquery>
				
			<cfset text = "">
			
			<cf_tl id="Organizational Unit" var="1">
			<cfset vOrgUnit        = lt_text>	
		
			<cf_tl id="Funding"         var="1">
			<cfset vFunding        = lt_text>
		
			<cf_tl id="Item Master"     var="1">
			<cfset vItemMaster     = lt_text>
		
			<cf_tl id="Description"     var="1">
			<cfset vDescription    = lt_text>
		
			<cf_tl id="Warehouse item" var="1">
			<cfset vWarehouseItem  = lt_text>
		
			<cf_tl id="Quantity"       var="1">
			<cfset vQuantity       = lt_text>
			
			<cf_tl id="Cost price"     var="1">
			<cfset vCostPrice      = lt_text>
		
			<cf_tl id="REQ025"         var="1">
			<cfset vReq025         = lt_text>		
			
			<cfquery name="Checkwf" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 SELECT     P.EntityClass as ReviewClass, 
						IM.code
			 FROM       ItemMaster IM INNER JOIN
		                RequisitionLine L ON IM.Code = L.ItemMaster INNER JOIN
		                Ref_ParameterMissionEntryClass P ON IM.EntryClass = P.EntryClass 
					AND L.Mission = P.Mission 
					AND L.Period = P.Period
			 WHERE      L.RequisitionNo = '#URL.ID#' 
		   </cfquery>		
		   		   
			<cfquery name="FlowSetting" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
					SELECT   S.*
					FROM     RequisitionLine R INNER JOIN
			                 ItemMaster M ON R.ItemMaster = M.Code INNER JOIN
			                 Ref_ParameterMissionEntryClass S ON R.Mission = S.Mission AND R.Period = S.Period AND M.EntryClass = S.EntryClass
					WHERE    R.RequisitionNo = '#URL.ID#'
			</cfquery>		
								   	   	
			<cfif Line.JobNo eq "">
					
				<cfif Form.OrgUnit1 eq "">
				   <cfset text = #text#&"<tr><td class='labelmedium'>&nbsp;- #vOrgUnit#</td></tr>">
				</cfif>
				
				<!--- ------------------------------------------------------------------------ --->
				<!--- check if the requisition is 100% funded, this is NOT a fund availability --->
				<!--- ------------------------------------------------------------------------ --->
				
				<cfif Parameter.FundingByReviewer lt "2" or
				     (Parameter.FundingByReviewer eq "2" and Line.ActionStatus gt "2") or
					 (FlowSetting.EnableFundingClear eq "0" and checkwf.reviewclass eq "")>
				
					<cfif Percentage.Percentage neq "1">
					   <cfset text = #text#&"<tr><td class='labelmedium'>&nbsp;- #vFunding#</td></tr>"> 
					</cfif>
				
				</cfif>
				
				<cfparam name="Form.EditionId" default="">
				
				<!--- ---------------------------------------------------------------------------- --->
				<!--- check if the requisition is 100% internal budgetted, NOT a fund availability --->
				<!--- ---------------------------------------------------------------------------- --->
								
				<cfquery name="Person" 
				  datasource="AppsPurchase" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				    SELECT  * 
					FROM    ItemMaster I, Ref_EntryClass R
					WHERE   I.EntryClass = R.Code
					AND     I.Code       = '#Line.ItemMaster#'		
				</cfquery>	
					
				<cfif Person.EmployeeLookup eq "1" and ReqLine.ActionStatus gt "2f" and Person.CustomDialog eq "Travel" and form.personno eq "">
					<cfset text = #text#&"<tr><td class='labelmedium'>&nbsp;- You need to select an person/employee</td></tr>">				
				</cfif>				
				
				<cfif form.EditionId neq "">
				
					<cfquery name="BudgetPercentage" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT SUM(Percentage) as Percentage
					    FROM   RequisitionLineBudget F  
						WHERE  RequisitionNo = '#URL.ID#' 
					</cfquery>
					
					<cfif BudgetPercentage.Percentage neq "1">
						   <cfset text = #text#&"<tr><td class='labelmedium'>&nbsp;- Internal Budget</td></tr>"> 
					</cfif>
							
				</cfif>			
				
				<cfif Form.Itemmaster eq "">
				   <cfset text = #text#&"<tr><td class='labelmedium'>&nbsp;- #vItemMaster#</td></tr>">
				</cfif>
				
				<cfif Form.RequestDescription eq "" and Form.RequestType neq "Warehouse">
				   <cfset text = #text#&"<tr><td class='labelmedium'>&nbsp;- #vDescription#</td></tr>">
				</cfif>
				
				<cfif Form.RequestType eq "Warehouse">
					<cfif Form.ItemNo eq "">
					   <cfset text = #text#&"<tr><td class='labelmedium'>&nbsp;- #vWarehouseItem#</td></tr>">
					</cfif>   
				</cfif>
				
				<cfif Form.RequestQuantity eq "">
				   <cfset text = #text#&"<tr><td class='labelmedium'>&nbsp;- #vQuantity#</td></tr>">
				</cfif>			
															
				<cfif (Check.RequestAmountBase eq "0" or Check.RequestAmountBase eq "") and Line.actionStatus gt "1">
				   <cfset text = #text#&"<tr><td class='labelmedium'>&nbsp;- #vCostPrice#</td></tr>">
				</cfif>
			
			</cfif>		
			
			<cfoutput>
				
												
			<!--- if one or more errors are detected --->		
				
			<cfif text neq "">
			
			    <script>
					Prosis.busy('no')
				</script>
			
				<cfif url.mode neq "Workflow">
			
				    <cfif Line.ActionStatus eq "1"> 
						
						<cf_messageDialog title = "Alert" color="green" message = "<table border='0' cellspacing='3' cellpadding='3'><tr><td class='labelmedium'>#vReq025#:</td></tr>#text#</table>">
						<cfabort>
						
					<cfelse>	
					
						<cf_messageDialog title = "Alert" color="green"  message = "<table border='0' cellspacing='3' cellpadding='3'><tr><td class='labelmedium'>#vReq025#:</td></tr>#text#</table>">
						<cfabort>
															   
					</cfif>
					
				<cfelse>
				
					<cf_messageDialog title = "Alert" color="green" message = "<table border='0'><tr><td class='labelmedium'>#vReq025#:</td></tr>#text#</table>">
						<cfabort>
								
				</cfif>	
			
			</cfif>			
							
			</cfoutput>
			
			<!--- ----------------------------------- --->
			<!--- if line is CENCELLED omit the check --->
			<!--- ----------------------------------- --->
														
			<cfif ReqLine.ActionStatus neq "9">
			
				<!--- perform a fund availability check, method defines itself if this is needed --->		
				<CF_RequisitionFundingCheck 
				       RequisitionNo="'#URL.ID#'">
				
				<!--- ------------------------------------------------- --->
				<!--- determine if requistion is going to be sent back --->
				<!--- ------------------------------------------------- --->
								
				<cfset allow = "Yes">
				
				<cfif Parameter.EnableRequisitionEditMode eq "0">
				
					<!--- ----------------------------------------------- --->
					<!--- will allow the change to be made no matter what --->
					<!--- ----------------------------------------------- --->
				
				     <cfset allow = "Yes">
					 
				<cfelseif Parameter.EnableRequisitionEditMode eq "1">
				
					<!--- -------------------------------------------------------------- --->
					<!--- will allow the change to be made only if this is the certifier --->
					<!--- -------------------------------------------------------------- --->
				
				     <!--- check if user is a certifier if status is 2f, he/she has access otherwise you can not save 
					 
						 <cfquery name="Check" 
						datasource="AppsPurchase" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT AccessId
							FROM  Organization.dbo.OrganizationAuthorization A
							 WHERE A.Role IN ('ProcReqCertify')
							 AND   A.UserAccount = '#SESSION.acc#'
							 AND   A.OrgUnit     = '#ReqLine.OrgUnit#'
							 AND   A.AccessLevel IN ('1','2')
						    UNION				 
							SELECT AccessId
							FROM Organization.dbo.OrganizationAuthorization 
							WHERE Role IN ('ProcReqCertify')
							AND   UserAccount = '#SESSION.acc#'
							AND   OrgUnit is NULL
							AND   Mission = '#OrgUnit.Mission#'
							AND   AccessLevel IN ('1','2')
					    </cfquery>			 
					 
					 --->
					 
				     <cfif ReqLine.ActionStatus eq "2f" or ReqLine.ActionStatus eq "2i">
					 	
						<cfset allow = "Yes">
						
					 <cfelse>
					    
						<cfset allow = "No">
							
					 </cfif>		
				</cfif>		
				
			<cfelse>	
			
				<cfset allow = "Yes">
			
			</cfif>		
		
			<cfif Funds eq "Yes" and Parameter.EnableRequisitionEdit eq "1" and Allow eq "Yes">
									
					<!--- do not change it --->		
					<cfset st = "same">					
										
			<cfelse>				
																	
			      <cfif Check.actionStatus eq "1" or Check.ActionStatus eq "1p" or Check.ActionStatus eq "1f">		
				  				   
					    <!--- do not change it --->
												
						<cfset st = "same">									
					
				  <cfelse>				 			  
				  
				  		<!--- if something substantive was changed --->
									  			  
					  	<cfif (Form.Period                            neq Line.Period or
					          Form.OrgUnit1                           neq Line.OrgUnit or
					          Form.ItemMaster                         neq Line.ItemMaster or
						      Form.RequestDescription                 neq Line.RequestDescription)
							  and Parameter.EnableRequisitionEditMode neq "2">
			    			 
						<!--- resubmission by requisitioner --->	
							 					  
					     	 <cfset st = "1">						 
						 
							 <cfquery name="ResetWorkflow" 
						     datasource="AppsOrganization" 
						     username="#SESSION.login#" 
						     password="#SESSION.dbpw#">
								UPDATE  OrganizationObject
								SET     Operational     = 0
								WHERE   ObjectkeyValue1 = '#URL.ID#' 
								AND     EntityCode      = 'ProcReview'
							</cfquery>	
							 
						<!--- if amounts/value was recalculated and the status does not exceed funding review --->	 
							
						<!--- if something substantive was changed except for description --->
									  			  
					  	<cfelseif (Form.Period      neq Line.Period or
					               Form.OrgUnit1    neq Line.OrgUnit or
					               Form.ItemMaster  neq Line.ItemMaster)
							       and Parameter.EnableRequisitionEditMode eq "2">
			    			 
							 <!--- resubmission by requisitioner --->						  
					     	 <cfset st = "1">						 
						 
							 <cfquery name="ResetWorkflow" 
						     datasource="AppsOrganization" 
						     username="#SESSION.login#" 
						     password="#SESSION.dbpw#">
								UPDATE   OrganizationObject
								SET      Operational     = 0
								WHERE    ObjectkeyValue1 = '#URL.ID#' 
								AND      EntityCode      = 'ProcReview'
							</cfquery>		
							
														
						<cfelseif Form.AmountHasChanged eq "1" and 
							 (
							     (ReqLine.EnableBudgetReview eq "1" and Line.actionStatus gte "2b")
								 or
								 (ReqLine.EnableBudgetReview eq "0" and Line.actionStatus gte "2a")
								 or 
								 (ReqLine.EnableClearance eq "0" and (Line.actionStatus eq "2" or Line.actionStatus gte "2a"))
							 )>		
							 	
													
							<!--- determines if there is fund sufficiency --->
							
							<CF_RequisitionFundingCheck RequisitionNo="'#URL.ID#'">
						
							<cfif Funds eq "Yes">
														
								<cfset st = "same">	
							
							<cfelse>
																			
							     <!--- reviewer --->										
								 <cfset st = "1p">	
								 
								 <!--- in cmp model we reset theworkflow for this as well --->
							 						 
								 <cfquery name="ResetWorkflow" 
								     datasource="AppsOrganization" 
								     username="#SESSION.login#" 
								     password="#SESSION.dbpw#">
										UPDATE OrganizationObject
										SET    Operational     = 0
										WHERE  ObjectkeyValue1 = '#URL.ID#' 
										AND    EntityCode      = 'ProcReview'
								</cfquery>	
							
							</cfif>
							 
						<cfelse>
						
							 <!--- any other scenario send back to requester --->	 									
						     <cfset st = "same">	
					
						</cfif>	
									
				  </cfif>	
			</cfif>			
							
			<cfif parameter.EnableDueDate eq "1">
			 
			    <cfparam name="Form.RequestDue" 
				   default="#dateformat(now(),CLIENT.DateFormatShow)#">
				<cfset dateValue = "">
				<CF_DateConvert Value="#Form.RequestDue#">
				<cfset due = dateValue>
			
			</cfif>
			
			<cfparam name="Form.StandardCode" default="">
			<cfparam name="Form.PersonNo"     default="">
			<cfparam name="Form.CaseNo"       default="">
						
			<cfset dateValue = "">
			<CF_DateConvert Value="#Form.RequestDate#">
			<cfset dte = dateValue>		
			
			<cfif len(Form.RequestDescription) gte "200">
			  <cfset desc = left(Form.RequestDescription,200)>
			<cfelse>
			  <cfset desc = Form.RequestDescription>
			</cfif>
			
			<!---- JM:  In the following query I changed from Standard to StandardCode ---->
			
			<cfif Line.WorkOrderId neq "">

				<!--- we immediately create a reference here as the requisition is grouped by workorder line --->				
						
				<!---  1. define reference No  --->
				<cflock timeout="30" throwontimeout="No" name="SerialNo" type="EXCLUSIVE">
				
					<cfquery name="Parameter" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT *
					    FROM Ref_ParameterMission
						WHERE Mission = '#Line.Mission#' 
					</cfquery>
											
					<cfset No = Parameter.RequisitionSerialNo+1>
					
					<cfif len(No) eq "3">
					     <cfset No = "0#No#">
					<cfelseif len(No) eq "2">
					     <cfset No = "00#No#">
					<cfelseif len(No) eq "1">
					     <cfset No = "000#No#"> 
					</cfif>
						
					<cfquery name="Update" 
					datasource="AppsPurchase" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    UPDATE Ref_ParameterMission
						SET    RequisitionSerialNo = RequisitionSerialNo+1		
						WHERE  Mission = '#Line.Mission#' 
					</cfquery>
						
				</cflock>		
			
				<!--- To be used in Requisition.RequisitionPurpose for now --->
				<cfquery name="WorkOrder" 
						 datasource="AppsWorkOrder" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 	SELECT Reference
							FROM   WorkOrder
							WHERE  WorkOrderId = '#Line.WorkOrderId#'
				</cfquery>
				
				<cfquery name="WorkOrderLine" 
						 datasource="AppsWorkOrder" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
						 	SELECT Reference
							FROM   WorkOrderLine
							WHERE  WorkOrderId   = '#Line.WorkOrderId#'
							AND    WorkOrderLine = '#Line.WorkOrderLine#'
				</cfquery>
			
				<cfquery name="Insert" 
				     datasource="AppsPurchase" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					     INSERT INTO Requisition 
								 (Reference, RequisitionPurpose, EntryClass, Period, OfficerUserId, OfficerLastName, OfficerFirstName) 
					     VALUES ('#Parameter.MissionPrefix#-#Parameter.RequisitionPrefix#-#No#', 
						 		 '#WorkOrder.Reference# - #WorkOrderLine.Reference#',
								 '#Person.EntryClass#',
								 '#Form.Period#', 
						         '#SESSION.acc#', 
								 '#SESSION.last#', 
								 '#SESSION.first#') 
				 </cfquery>	
						
			</cfif>			 		
			
			<cfquery name="UpdateRequisition" 
			    datasource="AppsPurchase" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				
			    UPDATE RequisitionLine 
				SET 		
					 Period               = '#Form.Period#',		    				 
			         OrgUnit              = '#Form.OrgUnit1#',
					 <cfif form.OrgUnit2 eq "0">
					 OrgUnitImplement     = '#Form.OrgUnit1#',
					 <cfelse>
					 OrgUnitImplement     = '#Form.OrgUnit2#',
					 </cfif>
					 RequestType          = '#Form.RequestType#',
					 CaseNo               = '#Form.CaseNo#',
					 RequestDescription   = '#desc#', 
					 QuantityUoM          = '#Form.QuantityUoM#', 
					 RequestDate          = #dte#, 	
					 <cfif form.PersonNo neq "">
					 PersonNo             = '#Form.PersonNo#',			 		 
					 </cfif>
					 
					 <cfif ItemMaster neq "">
						 ItemMaster       = '#Form.ItemMaster#', 						  
					 </cfif>
					 					 
					 <cfif Form.StandardCode eq "">
					     StandardCode     = NULL,
					 <cfelse>
						 StandardCode     = '#Form.StandardCode#',	 					 
					 </cfif>
					 				 
					 <cfif Form.RequestType eq "Warehouse"> 
						 WarehouseItemNo  = '#Form.ItemNo#', 
						 WarehouseUoM     = '#Form.WarehouseUoM#',
					 </cfif>
					 
					 <!--- set the status --->
					 
					 <cfif st neq "same">
					 	<cfif url.mode eq "Budget">
						    <!--- hanno shortcut --->
						    ActionStatus         = '2i',	
						<cfelse>	
						 	ActionStatus         = '#st#', 
						</cfif>	
					 <cfelseif Line.ActionStatus eq "0">						 	
						<cfif url.mode eq "Budget">
						    ActionStatus         = '2i',							
						<cfelseif url.mode eq "WorkOrder" or Line.WorkOrderId neq "">
							<!--- if the request comes through a workorder it is submitted by default --->
							ActionStatus         = '1p',
							Reference            = '#Parameter.MissionPrefix#-#Parameter.RequisitionPrefix#-#No#',
						<cfelse>
							ActionStatus         = '1',
						</cfif>			 	
					 						
					 </cfif>					
					 
					 <!--- reset the requester --->
					 
					 Remarks    = '#Form.Remarks#',
					 
					 <cfif Line.ActionStatus eq '0'>				 				 
						 OfficerUserId        = '#SESSION.acc#',
						 OfficerLastName      = '#SESSION.last#',
						 OfficerFirstName     = '#SESSION.first#',	
						 Created              = getDate(), 			 				 
					 </cfif>	
					 
					 <cfif parameter.EnableDueDate eq "1">
						 RequestDue           = #due#
					 <cfelse>
					     RequestDue           = NULL	  						
					 </cfif>				 
									 
				WHERE RequisitionNo = '#URL.ID#'
			</cfquery>
			
			<!--- -------------------- --->	
			<!--- saving custom fields --->
			<!--- -------------------- --->
			
			<cfquery name="CleanTopics" 
			  datasource="AppsPurchase" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  DELETE FROM RequisitionLineTopic
			  WHERE RequisitionNo = '#URL.ID#'
			</cfquery>
			
			<cfquery name="Item" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 SELECT     *
			 FROM       ItemMaster 			
			 WHERE      Code = '#Line.ItemMaster#' 
		    </cfquery>	
				
			<cfquery name="GetTopics" 
			  datasource="AppsPurchase" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  SELECT *
			  FROM   Ref_Topic 
			  WHERE  Code IN (SELECT Code 
		                      FROM   Ref_TopicEntryClass 
					          WHERE  EntryClass = '#Item.EntryClass#')
		      AND    (Mission = '#Line.Mission#' or Mission is NULL)				 
		      AND    Operational = 1 			  
			</cfquery>
				
			<cfloop query="getTopics">
			
				 <cfif ValueClass eq "List">
			
						<cfparam name="FORM.Topic_#Code#" default="">
			
						<cfset value  = Evaluate("FORM.Topic_#Code#")>
						
						 <cfquery name="GetList" 
								  datasource="AppsPurchase" 
								  username="#SESSION.login#" 
								  password="#SESSION.dbpw#">
								  SELECT *
								  FROM   Ref_TopicList T
								  WHERE  T.Code = '#Code#'
								  AND    T.ListCode = '#value#'				  
						</cfquery>
									
						<cfif value neq "">
									
							<cfquery name="InsertTopics" 
							  datasource="AppsPurchase" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
							  INSERT INTO RequisitionLineTopic
								 		 (RequisitionNo,
										  Topic,
										  ListCode,
										  TopicValue,
										  OfficerUserId,
										  OfficerLastName,
										  OfficerFirstName)
							  VALUES ('#URL.ID#',
							          '#Code#',
									  '#value#',
									  '#getList.ListValue#',
									  '#SESSION.acc#',
									  '#SESSION.last#',
									  '#SESSION.first#') 
							</cfquery>
						
						</cfif>
						
				<cfelse>
					
						<cfif ValueClass eq "Boolean">					
							<cfparam name="FORM.Topic_#Code#" default="0">						
						</cfif>
						
						<cfif ValueClass eq "Text">					
							<cfparam name="FORM.Topic_#Code#" default="">						
						</cfif>
						
						<cfset value  = Evaluate("FORM.Topic_#Code#")>
						
						<cfif value neq "">
						
							<cfquery name="InsertTopics" 
							  datasource="AppsPurchase" 
							  username="#SESSION.login#" 
							  password="#SESSION.dbpw#">
							  INSERT INTO RequisitionLineTopic
							 		 (RequisitionNo, Topic, TopicValue,OfficerUserId,OfficerLastName,OfficerFirstName)
							  VALUES ('#url.id#','#Code#','#value#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
							</cfquery>	
						
						</cfif>
					
				</cfif>	
		
			</cfloop>
							
			<cfif Line.ActionStatus eq "0">
			 <cfset showentry = 1> 
			</cfif>				
			
			<!--- check the determination of the entry class --->
			
			<cfparam name="form.serviceinput" default="No">
			
			<cfif form.serviceinput eq "No">
					
				<cfquery name="Delete" 
				     datasource="AppsPurchase" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     DELETE FROM RequisitionLineService 
					 WHERE  RequisitionNo = '#URL.ID#'
				</cfquery>
				
				<cfquery name="Delete" 
				     datasource="AppsPurchase" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     DELETE FROM RequisitionLineTravel 
					 WHERE  RequisitionNo = '#URL.ID#'
				</cfquery>
				
				<cfquery name="Delete" 
				     datasource="AppsPurchase" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     DELETE FROM RequisitionLineItinerary
					 WHERE  RequisitionNo = '#URL.ID#'
				</cfquery>
			
			</cfif>
					
			<cfparam name="Form.ActionMemo"    default="">
			<cfparam name="Form.ActionContent" default="">				
			
		<!--- ------------------------------------------------ --->
		<!--- ----- check for workflow on the review --------- --->
		<!--- ------------------------------------------------ --->
		
		<cfquery name="Check" 
		     datasource="AppsPurchase" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
			 SELECT    P.EntityClass
			 FROM      ItemMaster IM INNER JOIN
	                   RequisitionLine L ON IM.Code = L.ItemMaster INNER JOIN
	                   Ref_ParameterMissionEntryClass P
					   ON  IM.EntryClass = P.EntryClass AND L.Mission = P.Mission 
	    			   AND L.Period = P.Period
			 WHERE     L.RequisitionNo = '#URL.ID#' 
		</cfquery>		
		
		<cfif Check.entityclass eq "">					
		
			<cfquery name="Update" 
		     datasource="AppsOrganization" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">
				UPDATE OrganizationObject
				SET    Operational     = 0
				WHERE  ObjectkeyValue1 = '#URL.ID#' 
				AND    EntityCode      = 'ProcReview'
			</cfquery>	
		
		</cfif>		
				
		<!--- ------------------------------------------------ --->
		<!--- ---------------------logging-------------------- --->
		<!--- ------------------------------------------------ --->
		
		<cfset log = 0>
						
		<cfif  Form.Period neq Line.Period or
			   Form.OrgUnit1 neq Line.OrgUnit or
			   Form.ItemMaster neq Line.ItemMaster or
			   Form.RequestDescription neq Line.RequestDescription>
			 
			<cfset log = 1>
										
		</cfif>		
				
		<!--- status has changed or content has changed so logging will be enabled --->	  
				
		<cfif st neq "same" or log eq "1">
						
		    <cfif st neq "same" and Line.ActionStatus neq "1" and Line.actionStatus neq "0">
			    
				<cfif st eq "1">
				
					<cf_alert message="Requisition was sent back to the requester for resubmission.">
					
				<cfelseif st eq "1p">
							    				
					<!--- ------------------------------ --->
					<!--- revert the workflow for review --->
					<!--- ------------------------------ --->
						
					<cfquery name="Check" 
						     datasource="AppsPurchase" 
						     username="#SESSION.login#" 
						     password="#SESSION.dbpw#">
							 SELECT     P.EntityClass
							 FROM       ItemMaster IM INNER JOIN
					                    RequisitionLine L ON IM.Code = L.ItemMaster INNER JOIN
					                    Ref_ParameterMissionEntryClass P ON IM.EntryClass = P.EntryClass 
									AND L.Mission = P.Mission 
									AND L.Period = P.Period
							 WHERE     L.RequisitionNo = '#url.id#' 
					</cfquery>						
							
					<cfif check.entityclass neq "">		
					
						<cf_alert message="Requisition was reverted to the request review workflow.">	
									
						<cfset link = "Procurement/Application/Requisition/Requisition/RequisitionEdit.cfm?mode=workflow&id=#url.id#">
								
						<cfquery name="ArchivePrior" 
								datasource="AppsPurchase" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
									UPDATE Organization.dbo.OrganizationObject
									SET    Operational = '0'
									WHERE  ObjectKeyValue1 = '#url.id#'
						</cfquery>
								
						<cfif Line.caseNo neq "">
							  <cfset ref = "#ReqLine.CaseNo# (#ReqLine.RequisitionNo#)">
						<cfelse>
							  <cfset ref = "#ReqLine.RequisitionNo#">  
						</cfif>
					 										
						<cf_ActionListing 
							    EntityCode       = "ProcReview"
								EntityClass      = "#Check.EntityClass#"
								EntityGroup      = ""
								EntityStatus     = ""
								CompleteFirst    = "Yes"							
								OrgUnit          = "#ReqLine.OrgUnit#"
								Mission          = "#ReqLine.Mission#"
								ObjectReference  = "#ref#"
								ObjectReference2 = "#ReqLine.RequestDescription#"
								ObjectKey1       = "#ReqLine.RequisitionNo#"
							  	ObjectURL        = "#link#"						
								Show             = "No" 
								DocumentStatus   = "0">			
																		
					<cfelse>
					
						<cf_alert message="Requisition is sent back to the first reviewer [batch].">		
							
					</cfif>
									
				</cfif>
			
			</cfif>				
					
			<cf_assignId>
					
			<cfsavecontent variable="content">
			    <cfinclude template="RequisitionEditLog.cfm">							
			</cfsavecontent>
				
			<cfquery name="InsertAction" 
				     datasource="AppsPurchase" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     INSERT  INTO RequisitionLineAction 
						 (RequisitionNo, 
						  ActionId,
						  ActionStatus, 
						  ActionDate, 
						  ActionMemo,
						  ActionContent,
						  OfficerUserId, 
						  OfficerLastName, 
						  OfficerFirstName) 
				     VALUES ('#URL.ID#', 
					         '#rowguid#',
						     <cfif st neq "same">
					         '#st#', 
						     <cfelse>
						     '#Line.ActionStatus#',
						     </cfif>
						     getdate(), 
						     'Update Line',
						     '#Content#',
						     '#SESSION.acc#', 
						     '#SESSION.last#', 
						     '#SESSION.first#')
			</cfquery>
			
		</cfif>
							
		<!--- ------------------------------------------------------------------------------------------- --->
		<!--- special provision for returning back to buyer, but not if this is trigger through workflow- --->
		<!--- ------------------------------------------------------------------------------------------- --->
							
		<cfif Line.JobNo neq "" and url.mode neq "workflow" and (Line.actionStatus eq "1" or Line.actionStatus eq "1p")>   
						
			<!--- determines if funding exists --->
			<CF_RequisitionFundingCheck RequisitionNo="'#URL.ID#'">
						
			<cfif Funds eq "Yes">
				
				<!--- return to job immediately --->
				
				<cfquery name="CheckQuotes" 
				     datasource="AppsPurchase" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     SELECT * 
					 FROM   RequisitionLineQuote					
					 WHERE  RequisitionNo = '#URL.ID#'
				</cfquery>
				
				<cfif CheckQuotes.recordcount eq "0">
				    <cfset st = "2k">
				<cfelse>
				    <cfset st = "2q">
				</cfif>
											
				<cfquery name="UpdateRequisition" 
				     datasource="AppsPurchase" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     UPDATE RequisitionLine 
					   SET  ActionStatus   = '#st#'
					 WHERE  RequisitionNo = '#URL.ID#'
				</cfquery>
				
				<cf_assignId>
				
				<cfquery name="InsertAction" 
				     datasource="AppsPurchase" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
					 INSERT INTO RequisitionLineAction 
					   (RequisitionNo, 
					    ActionId, 
						ActionStatus, 
						ActionMemo, 
						ActionDate, 
						OfficerUserId, 
						OfficerLastName, 
						OfficerFirstName) 
					 SELECT RequisitionNo, 
					        '#rowguid#', 
							'#st#', 
							'Returned to Buyer/Job', 
							getDate(), 
							'#SESSION.acc#', 
							'#SESSION.last#', 
							'#SESSION.first#'
					 FROM   RequisitionLine
					 WHERE  RequisitionNo = '#URL.ID#' 
				</cfquery>		
		
			</cfif>			
		
		</cfif>	
		
		
		<cfcatch>
				
			<script>
			  document.getElementById("resultbox").className = "regular"	 
			</script>
			
			<cf_screentop height="100%" scroll="Yes" html="no">
			<table width="100%" border="1" bordercolor="silver" cellspacing="0" cellpadding="0" class="formpadding">
			
				<tr><td class="top4n" align="center"><b>An error has occurred.</b></td></tr>
				<tr><td bgcolor="yellow" align="center">
			
				    <cfoutput>
				   	    #CFCatch.Message# - #CFCATCH.Detail#	
					</cfoutput>
				
				</td></tr>
			
			</table>
			
			<cfabort>			
		  
		</cfcatch>
		
		</cftry>
		
		
	</cfif>

</cfif>

<cfoutput>

<cfif url.refer neq "Workflow">
	
	<script>			
					
				
	    <cfif URL.Mode eq "Portal">
			
			try {	
			
			// opener.history.go()  			
			opener.requisitionrefresh('#url.id#') } catch(e) {  }			
			window.close()
			
		<cfelseif URL.Mode eq "Entry">
				
			<!--- direct entry from module --->	
			parent.document.getElementById("reqno").value = '#url.id#'
			parent.document.getElementById("menu1").click()
													
		<cfelseif URL.Mode eq "dialog">		
														
			 <!--- openeded as dialog in the edit mode --->			
			
			 <!--- opened from a listing --->					 		   	 
			 try {						   
			 opener.applyfilter('1','','#url.id#') } catch(e) {}		
						 
			 <!--- opened from the usual screen with tree on the left --->			 
			 try {						
			 opener.document.getElementById('refreshbutton').click() } catch(e) {}
						  			 				
			 try { opener.history.go() } catch(e) {}				
			 
			 window.close()			 	    
			 			 
						  			 
		<cfelseif URL.Mode eq "listing">	
		
			<!--- generic called from edit in the listing --->
				    
		    try {						   
			parent.opener.applyfilter('1','','#url.id#') } catch(e) { returnValue = 1}			
			window.close()		
			
		<cfelseif URL.Mode eq "workorder">	
		
			<!--- generic called from add in the listing, needs a refresh to show --->
						 				    
		     try {					 
			 parent.opener.document.getElementById('process_#url.refer#').click() } catch(e) {}			
			 window.close()		
			 
		<cfelseif URL.Mode eq "budget">	
		
			<!--- generic called from add in the listing, needs a refresh to show --->
					 				    
		     try {				 
			 parent.opener.document.getElementById('refresh_#url.refer#').click(); } catch(e) { }			
			 window.close()			 		
			 
		<cfelse>
		
		     <!--- safeguard --->
			
			 parent.document.getElementById("menu3").click()
			<!--- window.location = "RequisitionEntryListing.cfm?add=0&mode=Entry&ID=&Mission=#ReqLine.Mission#&Period=#Form.Period#" --->
			
		   	 <!--- window.location = "RequisitionView.cfm?showentry=#showentry#&ID=new&Mission=#ReqLine.Mission#&Period=#Form.Period#"	--->

		</cfif>
				
	</script>	
	
<cfelse>

	<script>alert("Information was updated !")</script>	
	
</cfif>

</cfoutput>

<table align="center"><tr><td style="color: 4169E1;" align="center" class="labelit"><font color="0080C0">Information was updated</td></tr></table>

<!---<cfoutput>
   
	<script>
		//WorkOrder
		try { parent.opener.ColdFusion.navigate('#session.root#/WorkOrder/Application/WorkOrder/ServiceDetails/Items/FinalProduct/FinalProductDetail.cfm?workorderid=#url.workOrderId#&workorderline=#url.workOrderLine#','topSection'); } catch(e) {}
	</script>

</cfoutput>--->
