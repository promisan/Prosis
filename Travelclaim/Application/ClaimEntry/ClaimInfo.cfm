<!--
    Copyright © 2025 Promisan

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

<cfajaximport tags="cftooltip">

<cfparam name="ProcessWF" default="0">

<cfoutput>
	<script language="JavaScript">
	
	function claimAs() {
	    window.location = "../Express/ExpressEntry.cfm?ClaimId=#IdClaim#";
	 }
	
	function pdf() {
		   window.open("../PDF/TravelClaim.cfm?#CGI.QUERY_STRING#","_blank","width=900,height=800")
	}   
	
	function addevent(event) {
	    parent.window.location= "../FullClaim/FullClaimView.cfm?ClaimId=#IdClaim#&ID1={00000000-0000-0000-0000-000000000000}&ID2=" + event;
	}	
	
	function refresh(box,req,val,cat) {
	 	
		url = "#SESSION.root#/travelclaim/application/claimentry/ClaimInfoLineOTH_editsave.cfm?claimcategory="+cat+"&claimrequestid=#claim.claimrequestid#&transactionno="+box+"&claimrequestlineno=" + req + "&amount=" + val
			 
	 	AjaxRequest.get({
	        'url':url,
	        'onSuccess':function(test){ 	
			 			
	     document.getElementById("ln_"+box).innerHTML = test.responseText;					
			 },						
	        'onError':function(test) { 			
			 document.getElementById("ln_"+box).innerHTML = test.responseText;
			 }	
	       });			
	 }	
				
	function calculate(express,enforce) {	    
	    ColdFusion.navigate('#SESSION.root#/travelclaim/application/claimentry/ClaimValidationResult.cfm?processwf=1&reload=0&Progress=0&ClaimId=#URL.ClaimId#&enforce='+enforce+'&express='+express+'&mode=line','validation')
	}
	
</script>
	
<table width="100%" border="0" cellspacing="0" align="center" cellpadding="0" rules="rows">

 
<cfif processWf eq "0">
	<tr><td>
	 
	   <cfinclude template="ClaimPreparation.cfm">
	   </td>
	 </tr> 
	 <tr><td height="13"></td></tr>
</cfif>
		
<cfif Claim.ActionStatus neq "0">
	
	<tr><td>

	<table width="100%" cellspacing="0" cellpadding="0" align="center">
			
		<tr>
		  <td height="20" colspan="1">
		  		  
		  <table width="100%" cellspacing="0" cellpadding="0">	  
		  <tr><td height="1" colspan="2" bgcolor="C0C0C0"></td></tr>
		  <tr>
		  
		  <cfif processWf eq "0">
		  
			  	<td bgcolor="f4f4f4" height="20">&nbsp;
			  
			 	<cfif Claim.ActionStatus eq "">
				  <cfset cl = "regular">
				  <cfset clA = "hide">
				<cfelse>
				  <cfset cl = "hide">  
				  <cfset clA = "regular">
				</cfif>		
				
				<cfif claim.actionStatus neq "6">
				
			    <img src="#SESSION.root#/Images/icon_expand.gif" 
						alt="Show payment details"  
						id="paymentExp" border="0" class="#clA#" 
						align="absmiddle" style="cursor: hand;" 
						onClick="maximizereq('payment')">
						
						<img src="#SESSION.root#/Images/icon_collapse.gif" 
						id="paymentMin" 
						alt="Hide payment details"  border="0" 
						align="absmiddle" class="#cl#" style="cursor: hand;" 
						onClick="maximizereq('payment')">
			  			&nbsp;&nbsp;<b>
					  <a href="javascript:maximizereq('payment')">
					  <font color="0066CC"><cfif Claim.ActionStatus lte "1">My&nbsp;</cfif>Claim</font>
					  </a>
				
				<cfelse>
				
				<font color="0066CC"><b>Claim</font>
				
				</cfif>	  
				
				 <button class="button3" onClick="javascript:pdf()">
				 <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/pdf_button.png"
				     alt="Prepare PDF"
				     border="0"
					 class="noprint"
					 align="absmiddle"
				     style="cursor: hand;">
					<font color="808080">
				 </button>
					  
				</td>					  
		  
		  <cfelse>
		  
		  	   <td bgcolor="f4f4f4">
			   <table width="100%" border="0" cellspacing="0" cellpadding="0">
			   			   
			   <tr>
			   <td>&nbsp;&nbsp;&nbsp;<b><font color="0066CC">Claim</font>
			   </td>			  
			   
			   <cfif URL.WParam eq "EO">
			   
			   		<TD width="30">
					
					<!--- check if final claim is enforced --->					
										 							
						<cfif Claim.PointerClaimFinal eq "1">
					   		<input type="checkbox" name="PointerClaimFinal" value="1" checked>
						<cfelse>
						    <input type="Checkbox" name="PointerClaimFinal" value="1">
						</cfif>
											
					</td>					
					<td width="100">
					
						<cf_helpfile code     = "TravelClaim" 
							 id       = "fnlclm" 
							 class    = "General"
							 name     = "Final Claim"
							 display  = "Both"
							 color    = "black">
							 <!--- displayText = "Final Claim" --->
															
				    </td>
				
			  <cfelse>
			  
			  		<TD width="80">
			  		<cfif Claim.PointerClaimFinal eq "1">[Final Claim]</cfif>			 			 
					</td>
				    <input type="hidden" name="PointerClaimClaim" value="#Claim.PointerClaimFinal#">
				  
			  </cfif>	 		
			  			   
			   	    <cfquery name="Calc" 
						datasource="appsTravelClaim" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT TOP 1 *
						FROM   ClaimCalculation
						WHERE  ClaimId = '#URL.ClaimId#'
						AND    CalculationId IN (SELECT CalculationId 
						                         FROM   ClaimValidationLog)
						ORDER BY Created DESC 
					</cfquery>	
					
					<cfif calc.recordcount eq 1>
					   <cfset calcid = calc.calculationid>
					<cfelse>
					   <cfset calcid = "00000000-0000-0000-0000-000000000000"> 
					</cfif>
															
					<cfquery name="Check" 
						datasource="appsTravelClaim" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT   *
						FROM     ClaimValidation LV INNER JOIN
				                 Ref_Validation R ON LV.ValidationCode = R.Code INNER JOIN
			                     Ref_DutyStationActor A ON LV.ClearanceActor = A.ClearanceActor
						WHERE    LV.ClaimId = '#URL.ClaimId#'    
						AND      LV.CalculationId = '#calcid#' 		 
					    AND      A.ClaimException = 1
						AND      A.Mission = '#ClaimTitle.Mission#'
					 </cfquery>
					 
					 <cfif check.recordcount gte "1">
						
						<td></td>
						
						<!--- this will set the exception as 1 automatically upon submitting --->
						<input type="hidden" name="ClaimException" value="">
							
					 <cfelse> 		
					 
					 	<TD width="30">
			
							<cfif Claim.ClaimException eq "1">
							   <cfinput type="Checkbox" name="ClaimException" checked="Yes" value="1">
							<cfelse>
							   <cfinput type="Checkbox" name="ClaimException" value="1">
							</cfif>
						
						</td>
			   
			   			<td>
					
							<cf_helpfile code     = "TravelClaim" 
								 id       = "incplte" 
								 class    = "General"
								 name     = "Incomplete Claim"
								 display  = "Both"
								 displayText = "Set as incomplete"
								 color    = "black">	
							 
						 </td>	 														
				    
					 </cfif>	
					 										   
			   </tr>
			   </table>
					  
		  </cfif>
		  
		  <td align="right" bgcolor="f4f4f4">
		  		  	  
		  <cfif Claim.ClaimAsIs eq "1">
		   
		  	<font color="0066CC">
			  <b>Express Claim&nbsp;</b>
			</font>
		  </cfif>
		  	  
		  </td>
		  
		</tr>
		</table>
			
		</td></tr>
		<tr><td bgcolor="C0C0C0"></td></tr>
		
		 <cfquery name="Payment" 
		   datasource="appsTravelClaim" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
				SELECT *
			    FROM Ref_PaymentMode
				WHERE Code = '#Claim.PaymentMode#'
	     </cfquery>
				 		
		<tr>
		   <td height="25">
		   <table width="98%" align="center" cellspacing="2" cellpadding="1">
			   <tr>
			   <td width="10" align="center"></td>
			   
			   <td><font color="gray">Portal Status:</td>
			   <td>	
			   
			   <cfquery name="Status" 
			   datasource="appsTravelClaim" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">			   
				   SELECT    *
					FROM     Ref_Status
					WHERE    StatusClass = 'TravelClaim'
					AND      Status = '#Claim.ActionStatus#'
				</cfquery>	
				
				<cfif claim.exportNo gt "0" and Claim.ActionStatus lt "3">
				
				<a href="##" title="Claim status has been tampered with as claim has been exported already">
				<font color="FF0000">#Status.Description#</font></a>
				<cfelse>
				<cfif claim.ActionStatus eq "6"><font color="0D86FF"><b></cfif>
				#Status.Description#
				</cfif>
				
				<cfif claim.exportNo gt "0">				
				<font color="0080C0">Export batch: #Claim.ExportNo#</font>
				</cfif>
				
			   </td>
			   
			   <td><font color="gray">TCP Number:</td>
			   <td>
			   <cfif claim.documentNo neq "0">#Claim.DocumentNo#
			   <cfelseif Claim.ActionStatus eq "6">N/A
			   <cfelse>--</cfif></td>
			 			   
			   <cfif Claim.Reference neq "">		   
			   <td align="right"><font color="gray">Voucher:</td>
			   <td align="right">#Claim.Reference# #Claim.ReferenceNo#
			 		   
			     <cfquery name="Status" 
			   datasource="appsTravelClaim" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">			   
				   SELECT    *
					FROM     Ref_Status
					WHERE    StatusClass = 'TVCV'
					AND      Status = '#Claim.ReferenceStatus#'
				</cfquery>	
				(#Status.Description#)
				
			   
			   </td>
			    </cfif>		
			   
			   <!---
			   [<cfif #Claim.ActionStatus# eq "2"><b><font color="76CBD1">Submitted</font></b><cfelse>Under preparation</cfif>]
			   --->
			   </td>			 
			   </tr>
			   <tr>
			   <td width="10" align="center"></td>
			   <td><font color="gray">Travel Mode:</td>
			   <td>
			   
			   <cfif claim.ActionStatus eq "6">
			   
			   	   Undefined
			   
			   <cfelse>
			   
				    <cfquery name="Mode" 
				    datasource="appsTravelClaim" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">		
					    SELECT DISTINCT R.Description
						FROM         ClaimEvent Ev INNER JOIN
		                      ClaimEventTrip Ct ON Ev.ClaimEventId = Ct.ClaimEventId INNER JOIN
		                      Ref_ClaimEvent R ON Ct.EventCode = R.Code
						WHERE ClaimId = '#URL.ClaimId#'	
					</cfquery>  
					
					<table border="0" cellspacing="0" cellpadding="0">
					<cfloop query="Mode">
						<tr><td>#Description#</td></tr>
					</cfloop>
					</table>		   
				
			   </cfif>	
			   
			   </td>
			   <td><font color="gray">EMail:</td>
			   <td>#Claim.eMailAddress#</td>
			   <td align="right"><a href="javascript:maximizereq('payment')"><font color="gray">Payment:</b>
			   </a></td>
			   <td align="right">
			   <a href="javascript:maximizereq('payment')">
			   <cfif #Payment.Description# eq "">Undefined<cfelse>#Payment.Description#</cfif>&nbsp;[#Claim.PaymentCurrency#]
			   </a>
			   </td>
			   </tr>
			   
		   </table>
		   </td>
		</tr>
				
				
		<cfif processWf eq "0">		
		
			<tr><td>
						
				<!--- general information --->
				<table width="100%" align="center" border="0" cellspacing="0" cellpadding="1" 
				bordercolor="C0C0C0" bgcolor="ffffff" rules="rows" id="payment" class="#cl#">
				<tr>
				  <td height="25" colspan="1">
				    &nbsp;
				    <!--- <img src="<cfoutput>#SESSION.root#</cfoutput>/images/submit.gif" alt="Claim events" border="0" align="absmiddle">&nbsp; --->
				   &nbsp;<b>Reimbursement method <font color="0080C0">: <cfif #Payment.Description# eq "">Undefined<cfelse>#Payment.Description#</cfif></font></td>
				  <td align="right">&nbsp;
					
					</td>
				</tr>
				
				<tr><td colspan="2">
				<table width="100%" border="0" cellspacing="1" align="center" cellpadding="0" frame="hsides" rules="rows">
				 <cfset mode = "info">
				 <cfinclude template="ClaimInfoPayment.cfm"> 
				</table>
				</td></tr>
				
				</table>
			
			</td></tr>
		
		</cfif>
		
		<cfif Claim.ActionStatus neq "">
								  
		<tr><td>
		
		<cfset ClaimId=IDclaim>		
		<cfinclude template="ClaimInfoLine.cfm">
										
		</td></tr>
				
		</cfif>
		
		<cfif claim.ActionStatus eq "1">
		
		<tr><td height="1"></td></tr>
		
		
		<tr><td colspan="2">
		  <table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" bordercolor="silver">
		  <tr><td>				
			<cfinclude template="../Workflow/Correction/ActionIndicator.cfm">
			</td></tr>
		  </table>	
		  </td>
		</tr>
		
		
		</cfif>	
		
		<cfquery name="Lines" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   SELECT sum(AmountClaim) as Total
		   FROM ClaimLine
		   WHERE ClaimId = '#IDClaim#'
		</cfquery>
		
		<cfquery name="LinesExt" 
		datasource="appsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   SELECT sum(AmountClaim) as Total
		   FROM ClaimLineExternal
		   WHERE ClaimId = '#IDClaim#' 
		</cfquery>
		
		<cfset HideProcessButton = "0">
		<cfset submission = "">
				
		<cfif Lines.Total gt "0" or LinesExt.Total gt "0">
									
			<cfif Claim.ActionStatus lte "1">
			
				<cfset HideProcessButton = "1">
							
				<tr><td>
			
				<table width="100%" align="center" border="0" cellspacing="0"  cellpadding="0">
				<tr>
			
			  	<td width="100%">
			  
				  <table width="99%" align="center" border="0" cellspacing="0" cellpadding="0" bordercolor="silver">
								  
				  <cfset submission = "1">
				  
				  <cfif claim.actionStatus lte "1">
	 				  
					  <cfinclude template="../Process/ValidationRules/ValidationSubmission.cfm">
					  				  
				  </cfif>
				 				 				  				 				  
				  <cfif submission eq "1">					  		   
				 				 			 				  
					  <cfif parameter.EnableActorSubmit eq "1" 
					     or Employee.PersonNo eq client.PersonNo 
						 or SESSION.isAdministrator eq "Yes">
						 
						 	<tr><td height="10"></td></tr>
						 
						 	<tr><td>
						 	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="noprint">
		
							<tr><td bgcolor="gray" height="2"></td></tr>
								<tr><td height="22" bgcolor="d4d4d4"><font size="2"><b>&nbsp; Step 3 of 3 : Claim Submission</font></td></tr>
							<tr><td bgcolor="gray" height="2"></td></tr>
							
							</table>
							</td></tr>						
							
							  <tr id="statement">
								  <td valign="top" bgcolor="DFEFFF">
									  <table width="94%" cellspacing="2" cellpadding="2" align="center">
									  <tr><td valign="top" height="30">
									  <cfinclude template="../Workflow/SubmissionStatement.cfm">
									  </td></tr>
									  </table>
								  </td>	  
							  </tr>
								 
						 	  <tr><td height="30" align="left">
							  &nbsp;I agree with the information in this claim:
							   <input type="checkbox" name="Agreement" value="1" onclick="javascript:showsubmit(this.checked)">
							  </td></tr>				  				  	  
													  
							  <script language="JavaScript">
							  
							  function showsubmit(val)  {
							  
							      se = document.getElementById("boxflow")
								  if (val == false) {
								  	  se.className = "hide";
								  } else {
								      se.className = "regular";							    
								  }
								  
								  se = document.getElementById("boxsubmit")
								  if (val == false) {
								  se.className = "hide"
								  } else {
								  se.className = "regular"
								  }
							  }
							  </script>
							  
							  <tr id="boxflow" class="hide"><td align="left" bgcolor="F4F4F4">
								  <table border="0" bordercolor="silver" cellspacing="0" cellpadding="1" rules="rows">
								  <tr bgcolor="F4F4F4">
								     <td width="25" align="center"></td>
								     <td align="left" height="34">
									
								  	 Claimant: #Employee.FirstName# #Employee.LastName#&nbsp;&nbsp;
									 
									  <cfinput type="Text" 
									    name="DateSubmission" 
										message="Please enter a valid date" 
										validate="eurodate"
										value="#Dateformat(Claim.ClaimDate, CLIENT.DateFormatShow)#" 
										required="No"
										class="regular" 
										visible="Yes" 
										enabled="Yes" 
										size="8" 
										style="text-align : center;"
										maxlength="10">
										
									&nbsp;	
									
									<cfquery name="Validation" 
										datasource="appsTravelClaim" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
										SELECT    *
									    FROM       ClaimValidation
										WHERE      ClaimId = '#ClaimId#' 
									</cfquery>										
									
									<cfquery name="Object" 
											datasource="appsOrganization" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
											SELECT *
											FROM  OrganizationObject 
											WHERE ObjectKeyValue4 = '#URL.ClaimId#' 										
									</cfquery>	
									
									<cfif Object.recordcount eq "0">
										  <td>
										  <cfif len(claim.remarks) gte "10">
										       <input type="hidden" name="workflowenforce" value="1">
										  <cfelse>	
										  	   <input type="hidden" name="workflowenforce" value="0">   
										  </cfif>										
										  </td>
										  <td id="boxsubmit" class="hide">
										 	 <input type="submit" class="button10g" name="submit"  value="Submit Now">&nbsp;
										  </td>										  
									 <cfelse>
										  <td id="boxflow" class="hide">
										  </td>
										  <td id="boxsubmit" class="hide">
											 <input type="submit" class="button10g" name="submit"  value="Resubmit">&nbsp;
										  </td>
									 </cfif> 
							         </td>	
								  </td></tr>
								  </table>
							  </td></tr>
							  
						  <cfelse>	  
						  
						  <tr><td align="left"><font color="0080C0">
						  <table>
						  <tr>
						  <td><img src="#SESSION.root#/Images/warning.gif" alt="" border="0"></td>
						  <td><b>Claim is pending re-submission by claimant</b></td>
						  </tr></table>					  
						  </td></tr>
						
					  </cfif>						  
					  
				  </cfif>	  
				  
				  </table>
				  
			  	</td>
				  
			  </tr>
			 	 	
			</table>			
			</td></tr>			
		
		</cfif>
	
	</cfif>		
		
	<tr><td colspan="2" >
						
			<cfif submission eq "1" or claim.actionstatus gte "2" or SESSION.isAdministrator eq "Yes">
				
				<cfif (claim.actionstatus gte "2" and claim.personNo neq client.personNo) 
				   or processWF eq "1"
				   or parameter.ShowUserValidation eq "1" 
				   or SESSION.isAdministrator eq "Yes">
				   
				   <cfdiv id="validation">
				
			    	<cfinclude template="ClaimValidationResult.cfm">
					
				   </cfdiv>	
				
				</cfif>
				
			<cfelseif submission eq "0">	
			
			    <cfdiv id="validation">
				    <cfinclude template="ClaimValidationResult.cfm">
				</cfdiv>
			
			</cfif>		
		
	</td></tr>	
	
	<tr><td height="5"></td></tr>
		
    <cfif processWF eq "0"> 
			
		<cfif claim.actionstatus gte "2" and claim.actionStatus neq "6">
									
			<tr><td colspan="2">
			
			<table width="98%" cellspacing="0" cellpadding="0" align="center">
							
			<tr><td>
			
			    <!--- trigger CORRECT workflow --->
				
				<cfquery name="Parameter" 
						datasource="appsTravelClaim" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT    *
						FROM      Parameter
				</cfquery>	
				
				<cfquery name="Calc" 
						datasource="appsTravelClaim" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT TOP 1 *
						FROM   ClaimCalculation
						WHERE  ClaimId = '#URL.ClaimId#'
						AND    CalculationId IN (SELECT CalculationId 
						                         FROM   ClaimValidationLog)
						ORDER BY Created DESC 
				</cfquery>	
					
				<cfif calc.recordcount eq 1>
				   <cfset calcid = calc.calculationid>
				<cfelse>
				   <cfset calcid = "00000000-0000-0000-0000-000000000000"> 
				</cfif>							
			   						
				<!--- determine workflow --->
				
				<cfquery name="Workflow" 
					datasource="appsTravelClaim" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT  DISTINCT WorkflowClass
					FROM    ClaimValidation Val INNER JOIN
	                		Ref_DutyStationActor R ON Val.ClearanceActor = R.ClearanceActor
					WHERE   R.WorkflowClass IS NOT NULL 
					AND     R.Mission         = '#ClaimTitle.Mission#'
					AND     Val.CalculationId = '#calcid#' 	
					AND     Val.ClaimId  = '#URL.ClaimId#'   					
				</cfquery>
											
				<cfif Workflow.recordcount eq "0">
				
					<cfset flow = Parameter.WorkflowClass>  <!--- default = claimAsIs --->
								
				<cfelseif Workflow.recordcount eq "1">   <!--- only one actor defined --->
				
					<cfset flow = Workflow.WorkflowClass>
								
				<cfelse>
				
					<cfset flow = "ClaimManager">  <!--- hardcoded flow in case of mutiple eo/account val --->
									
				</cfif>		
				
				
				<!--- in case the default workflow is to be applied, 
				we have to check if the user initiated an enforcing workflow		
				--->
				
				<cfif flow eq Parameter.WorkflowClass 
				   and claim.WorkFlowEnforce eq "1"
				   and Parameter.workflowSelect neq "N/A">
				
					<cfset flow = Parameter.WorkflowSelect>
					
				</cfif>
				
				
				<!--- testing 10/4
				<cfset flow = "ClaimAccount">
				 --->
		
				
				
				<!--- DETERMINE if actions can be processed --->
				
				<cfquery name="Verify" 
					datasource="appsTravelClaim" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					SELECT  *
					FROM    ClaimValidation Val,
	                		Ref_Validation R
					WHERE   Val.ValidationCode = R.Code
					AND     ClaimId = '#URL.ClaimID#'
					AND     R.ValidationClass IN (SELECT Code 
					                              FROM Ref_ValidationClass 
												  WHERE WorkflowEnabled = 0)
				</cfquery>
				
				<cfif Verify.recordcount gte "1">
					<cfset prevent = "Travel request requires to be modified/corrected:">
				<cfelse>
					<cfset prevent = "">
				</cfif>
				
				<cfparam name="URL.Complete" default="No">
										
				<cfset link = "TravelClaim/Application/FullClaim/FullClaimView.cfm?claimid=#Claim.claimId#&requestid=#URL.RequestId#">														
												
				<cfif claim.actionStatus neq "6">
																
					<cf_ActionListing 
						EntityCode       = "EntClaim"
						EntityClass      = "#flow#"				
						EntityGroup      = ""
						EntityStatus     = ""				
						OrgUnit          = "#claimTitle.orgunit#"
						PersonNo         = "#Claim.PersonNo#" 
						PersonEMail      = "#Claim.EMailAddress#"
						ObjectReference  = "Travel claim portal No: #Claim.DocumentNo#"
						ObjectReference2 = "#Parameter.ClaimRequestPrefix#-#ClaimTitle.DocumentNo# for #Employee.FirstName# #Employee.LastName# (#Employee.IndexNo#)"
						ObjectKey1       = "#Claim.PersonNo#"
						ObjectKey4       = "#Claim.ClaimId#"
						ObjectURL        = "#link#"
						Show             = "Yes"
						Header           = "Travel Claim Status"
						Toolbar          = "No"				
						Framecolor       = "ECF5FF"
						CompleteFirst    = "Yes"
						CompleteCurrent  = "#URL.complete#"
						HideProcess      = "#hideProcessButton#"
						PreventProcess   = "#prevent#">
					
				</cfif>	
					
			
			</td></tr>
			</table>
			
			</td></tr>		
					
			</cfif>
			
	</cfif>	
	
	
	</table>
	</td></tr>
	
		
</cfif>		

</table>
	
</cfoutput>