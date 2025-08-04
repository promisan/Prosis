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

		   
<cfparam name="Form.ReqList" default="">

<cfif Form.ReqList eq "">

	<cf_tl id="REQ009" var="1">
	<cfset vReq009=#lt_text#>
	
	<cf_tl id="REQ010" var="1">
	<cfset vReq010=#lt_text#>

    <cfset message = "<font color='FF0000'>#vReq009# #vReq010#</font>"> 
	
<cfelse>

	<cfset message = "">
	
	<cfquery name="Parameter" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM Ref_ParameterMission
			WHERE Mission = '#URL.Mission#' 
	</cfquery>
		
	<!---	
		  1. update requisition lines 
		  2. enter action 
		  3. return to screen
	--->	
	
	<!--- process selected lines action --->			  
		  		   
		   <cfset rowline = 0>
		   
		   <!--- -------------------------------------------------------- --->
		   <!--- ---  strange issue with Form.ReqList duplication in ajax --->
		   <!--- -------------------------------------------------------- --->
		   		   
		   <cfset reqlist  = "">
		   
		   <cfloop index="str" list="#PreserveSingleQuotes(Form.ReqList)#" 
				delimiters=",">
				<cfif not find(str,reqlist)>
					 <cfif reqlist eq "">
					 	 <cfset reqlist = "#str#">
					 <cfelse>
					 	 <cfset reqlist = "#reqlist#,#str#">
					 </cfif>
				</cfif> 
				
		   </cfloop>	
		   		   		   		   		  		   		   
		   <cfloop index="str" 
		        list="#PreserveSingleQuotes(ReqList)#" 
				delimiters=",">
					   		   	   				   		   
		   		<cfset rowline = rowline+1>				
						   
		        <cfset val = evaluate("Form.#str#")> 	
			
										
				<cfif val neq "">		
				
						   
			   		<cfset l = len(val)>
			   		<cfset action = left(val,  1)>
					
					<!--- determine the requisitionNo --->	
					<cfset req = mid(val, 3, l-2)>	
					
					<!--- check if fully funded --->	   	   
					
					<cfif action eq "D">
					
					    <cfset st = "9">
						
					<cfelseif action eq "R">
					
					    <cfset st = "1">    
						
					<cfelse>
					
						<cfset next = "2f">
				
					    <!--- define next status --->
						
						<cfquery name="FlowSetting" 
						datasource="AppsPurchase" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">		
								SELECT   S.*
								FROM     RequisitionLine R INNER JOIN
						                 ItemMaster M ON R.ItemMaster = M.Code INNER JOIN
						                 Ref_ParameterMissionEntryClass S ON R.Mission = S.Mission AND R.Period = S.Period AND M.EntryClass = S.EntryClass
								WHERE    (R.RequisitionNo = '#req#')
								
						</cfquery>	
	
						<cfif next eq "2f">
						
							<cfif FlowSetting.EnableCertification eq "0">
							
							    <!--- set status as certified--->
								<cfset next = "2i">
								
							<cfelse>
							
								    <!--- enabled certification --->
									
									<cfif FlowSetting.CertificationThreshold gte "0">
									
										<cfquery name="Check" 
										     datasource="AppsPurchase" 
										     username="#SESSION.login#" 
										     password="#SESSION.dbpw#">
										     SELECT  * 
											 FROM    RequisitionLINE									 
											 WHERE   RequisitionNo = '#req#' 
										</cfquery>
										
										<!--- find the total amount --->
							
										<cfquery name="Total" 
										     datasource="AppsPurchase" 
										     username="#SESSION.login#" 
										     password="#SESSION.dbpw#">
										     SELECT  sum(RequestAmountBase) as Amount 
											 FROM    RequisitionLINE									 
											 WHERE   Mission = '#Check.mission#'
											 AND     Reference = '#Check.Reference#'
											
										</cfquery>
										
										<cfif FlowSetting.CertificationThreshold gte Total.Amount>
											<!--- skipping --->
											<cfset next = "2i">																
										</cfif> 
										
									</cfif>	
								
							</cfif>
							
						</cfif>						
					
					    <!--- status will be 2f or 2i --->
					    <cfset st = next> 
												 
					</cfif>										
			     
				    <cfquery name="Fund" 
						datasource="AppsPurchase" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT    ROUND(SUM(Percentage),2) AS Funding
						FROM      RequisitionLineFunding
						WHERE     RequisitionNo = '#req#'
					</cfquery>
					
					<!--- process only when complete funded or cancelled --->
																
					<cfif Fund.Funding eq "1" or st eq "9">		
					
						<CF_RequisitionFundingCheck RequisitionNo="'#req#'">
																					  		
						<cfif Funds eq "No" and st neq "9" and Parameter.FundingByReviewer neq "2"> 
					     											
							<cfif st eq "1">
							
								<!---  1. update requisition line status --->
								<cfquery name="Update" 
								     datasource="AppsPurchase" 
								     username="#SESSION.login#" 
								     password="#SESSION.dbpw#">
								     UPDATE  RequisitionLINE
									 SET     ActionStatus  = '#st#'
									 WHERE   RequisitionNo = '#req#' 
								</cfquery>
							
							</cfif>
						
							<cf_assignId>
											
							<!---  action not processed make a recording in the log --->
							<cfquery name="InsertAction" 
							     datasource="AppsPurchase" 
							     username="#SESSION.login#" 
							     password="#SESSION.dbpw#">
							     INSERT INTO RequisitionLineAction 
								 (RequisitionNo, ActionId, ActionProcess, ActionStatus, ActionMemo, ActionDate, OfficerUserId, OfficerLastName, OfficerFirstName) 
								 SELECT RequisitionNo,
								        '#rowguid#', 
										'2f',
										'#st#', 
										'Insufficient Funds', 
										getDate(), 
										'#SESSION.acc#', 
										'#SESSION.last#', 
										'#SESSION.first#'
								 FROM RequisitionLine
								 WHERE RequisitionNo = '#req#'
							</cfquery>
						
				        <cfelse>
						
							<cf_assignId>
							
							<!--- capture screen --->
							
							<cfset url.id = req>
							<cfset url.archive = 1>
							<cfsavecontent variable="content">
							    <cfoutput>
								   <cfinclude template="../Requisition/RequisitionEditLog.cfm">
								</cfoutput>
							</cfsavecontent>
														
							<cftransaction>
						
							<!---  1. update requisition line status --->
							<cfquery name="Update" 
							     datasource="AppsPurchase" 
							     username="#SESSION.login#" 
							     password="#SESSION.dbpw#">
							     UPDATE RequisitionLINE
								 SET ActionStatus    = '#st#'
								 WHERE RequisitionNo = '#req#'
							</cfquery>
												
							<!---  2. enter action --->
							<cfquery name="InsertAction" 
							     datasource="AppsPurchase" 
							     username="#SESSION.login#" 
							     password="#SESSION.dbpw#">
							     INSERT INTO RequisitionLineAction 
								 (RequisitionNo, 
								  ActionId, 
								  ActionProcess,
								  ActionStatus, 
								  ActionContent, 
								  ActionDate, 
								  <cfif st eq "1">
								  ActionMemo,
								  </cfif>
								  OfficerUserId, 
								  OfficerLastName, 
								  OfficerFirstName) 
								 SELECT RequisitionNo, 
								       '#rowguid#', 
									   '2f',
									   '#st#', 
									   '#content#', 
									   getDate(), 
									   <cfif st eq "1">
									   'Reverted by Fund Reviewer',
									   </cfif>
									   '#SESSION.acc#', 
									   '#SESSION.last#', 
									   '#SESSION.first#'
								 FROM   RequisitionLine
								 WHERE  RequisitionNo = '#req#'
							</cfquery>
													
							
							<!--- retrieve adn save reasons --->
						
							<cfif st eq "9"  or st eq "1">
																
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
							
							<cfelse>
							
								<cfquery name="Options" 
									datasource="AppsPurchase" 
									username="#SESSION.login#" 
									password="#SESSION.dbpw#">
									SELECT    *
									FROM      Ref_StatusReason
									WHERE     Status = '2i'
									AND       StatusClass = 'requisition'		
									AND       Operational = 1  		
								</cfquery>
							
							</cfif>
							
							<cfloop query="Options">
							
								<cfparam name="FORM.f#rowline#_#code#"         default="">
								<cfparam name="FORM.f#rowline#_#code#_remarks" default="">
								
								<cfset cde = evaluate("FORM.f#rowline#_#code#")>
																
								<cfif cde neq "">
								
									<cfset memo = evaluate("form.f#rowline#_#code#_remarks")>
								
									<!---  3. enter reasons --->
									<cfquery name="InsertActionReason" 
									     datasource="AppsPurchase" 
									     username="#SESSION.login#" 
									     password="#SESSION.dbpw#">
									     INSERT INTO RequisitionLineActionReason
										 (RequisitionNo, ActionId, ReasonCode, Remarks, OfficerUserId, OfficerLastName, OfficerFirstName) 
										 VALUES  
										 ('#req#', '#rowguid#', '#cde#', '#memo#', '#SESSION.acc#', '#SESSION.last#', '#SESSION.first#')						
									</cfquery>					
								
								</cfif>		
								
								<cfparam name="FORM.revertTo_#rowline#"  default="">
							
								<cfset user = evaluate("FORM.revertTo_#rowline#")>
								
								<cfif user neq "">
																
									<cfquery name="checkUser" 
									     datasource="AppsPurchase" 
									     username="#SESSION.login#" 
									     password="#SESSION.dbpw#">
									     SELECT * 
										 FROM   RequisitionLineActor 
										 WHERE  RequisitionNo = '#req#'
										 AND    Role          = 'ProcReqEntry'
										 AND    ActorUserid   = '#user#'
									</cfquery>			
								
									<cfif checkUser.recordcount eq "0">
									
									    <cfquery name="UserName" 
									     datasource="AppsPurchase" 
									     username="#SESSION.login#" 
									     password="#SESSION.dbpw#">
									     SELECT * FROM System.dbo.UserNames 
										 WHERE Account = '#user#'									
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
											 FROM RequisitionLine
											 WHERE RequisitionNo = '#req#'
										</cfquery>		
									
									</cfif>
				
								</cfif>		
							
							</cfloop>		
							
							<cfif (st eq "9" or st eq "1") and Parameter.EnableDenyMail eq "1" and Parameter.TemplateEMail neq "">
							
									<!--- user selected denied which will trigger an eMail 
									script to send a denial message and attachment --->
										
										<cfinclude template="../../../Workflow/ReqMail.cfm">								
							
							</cfif>					
											
							<!--- record buyer : bypass assignment : like CMP --->
							
							<cfif st eq "2i">
							
								<cfinclude template="setDefaultBuyer.cfm">										
								 
							</cfif> 					
														
							</cftransaction>	
							
							<!--- ----------------------------------------------------- --->
							<!--- send eMail to the actors for the next step if enabled --->
							<!--- ----------------------------------------------------- --->						
							
							<cfif Parameter.EnableActorMail eq "1" and st neq "1" and st neq "9">
							
							
								<cfinclude template="ActorMail.cfm">					
											
							</cfif>
							
							<!--- ----------------------------------------------------- --->
							<!--- end mail -------------------------------------------- --->
							<!--- ----------------------------------------------------- --->
													
							
						</cfif>	
						
					</cfif>	
					
				</cfif>
				
			</cfloop>
				
	</cfif>	

<cfoutput>


<script>
    Prosis.busy('no')
	refreshtree('#url.mission#','#url.period#','#url.role#');
	#ajaxLink('RequisitionFundingPending.cfm?process=radio&message=#message#&mission=#URL.Mission#&period=#URL.Period#')#
	try { 
		se = opener.document.getElementById('button_#URL.Role#') 		
		se.click() } catch(e) {}
</script>


</cfoutput>	
