<cfparam name="Object.ObjectKeyValue1" default="">
<cfparam name="Form.ReqList" default="#Object.ObjectKeyValue1#">
<cfparam name="url.Role" default="">

<!--- ---------------------------------------------------------------------------- --->
<!--- 12/4/2009 provision if this is called by a workflow method, triggered by CMP --->
<!--- ---------------------------------------------------------------------------- --->

<cfif Object.ObjectKeyValue1 neq "">

	<cfquery name="Check" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT *
		    FROM   RequisitionLine
			WHERE  RequisitionNo = '#Object.ObjectKeyValue1#'
	</cfquery>		
	
	<cfset url.mission = Check.Mission>
	<cfset url.period  = Check.Period>
	
	<cfif Form.ActionStatus eq "2N">
		<cfset url.mode    = "Deny">
		<cfset val = "D_#Object.ObjectKeyValue1#">
	<cfelse>
		<cfset url.mode    = "Process">
		<cfset val = "C_#Object.ObjectKeyValue1#">
	</cfif>	
		
</cfif>

<cf_tl id="REQ009" var="1">
<cfset vReq009=lt_text>
	
<cf_tl id="REQ010" var="1">
<cfset vReq010=lt_text>

<cfif Form.ReqList eq "">

    <cfset message = "<font color='FF0000'>#vReq009# #vReq010#</font>"> 	
		
<cfelse>

	<cfset message = "">

	<!--- 
      0. verify funding is 100%
      1. update requisition lines 
	  2. enter action 
	  3. return to screen
	--->
	
  <cfquery name="Parameter" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.Mission#'
  </cfquery>		
  
  <cfif Parameter.RequisitionProcessMode eq "0">
	   <cfset processlevel = "Line">
  <cfelse>
	   <cfset processlevel = "Header">
  </cfif>
  	
  <cfif url.mode eq "Deny"> 
  			
	   <cfset st = "9">
	   <cfset txt = "cancelled">
	   
	   <cfloop index="req"
	        list="#PreserveSingleQuotes(Form.ReqList)#" delimiters=",">
	   	   
	       <!--- capture archive log --->		   
		   <cfset url.id      = req>		   
		   <cfset url.archive = 1>		   
		   <cfsavecontent variable="content">
		  	    <cfinclude template="../Requisition/RequisitionEditLog.cfm">							
		   </cfsavecontent>
		
		   <cftransaction>	
	   
			   <!---  1. update requisition lines --->
				<cfquery name="Update" 
				     datasource="AppsPurchase" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     UPDATE RequisitionLine 
					 SET    ActionStatus  = '#st#' 
					 WHERE  RequisitionNo = '#req#'
				</cfquery>
				
				<!---  3. enter action --->
				<cfquery name="InsertAction" 
				     datasource="AppsPurchase" 
				     username="#SESSION.login#" 
				     password="#SESSION.dbpw#">
				     INSERT INTO RequisitionLineAction 
					 (RequisitionNo, 
					   ActionProcess,
					   ActionStatus, 
					   ActionDate,
					   ActionContent,
					   OfficerUserId, 
					   OfficerLastName, 
					   OfficerFirstName) 
					 SELECT RequisitionNo, 
					        '#proc#',
					        '#st#', 
							getDate(), 
							'#content#', 
							'#SESSION.acc#', 
							'#SESSION.last#', 
							'#SESSION.first#'
					 FROM  RequisitionLine
					 WHERE RequisitionNo = '#req#'
				</cfquery>
				
			</cftransaction>	
			
			<cfif Parameter.EnableDenyMail eq "1" and Parameter.TemplateEMail neq "">
					
				<!--- user selected denied which will trigger an eMail 
					script to send a denial message and attachment --->
								
					<cfinclude template="../../../Workflow/ReqMail.cfm">								
							
			</cfif>		
		
	   </cfloop>
	  	
	<cfelse>
							
		<!--- process selected lines action and normal processing --->
						  		   
		<cfset rowline = 0>
			   
		<!--- -------------------------------------------------------- --->
		<!--- strange issue with Form.ReqList duplication in ajax----- --->
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
		
		
		<!--- action itself --->
		<cfif url.role eq "ProcReqReview">		
		    <cfset proc = "2">		
		<cfelseif url.role eq "ProcReqApprove">		
			<cfset proc = "2a">				
		<cfelse>
		    <cfset proc = "2b">
		</cfif>	
				
		<!--- ----------------------------------------------------- --->				  
		<!--- Pre=check Fund availability for all selected lines--- --->
		<!--- ----------------------------------------------------- --->
			  
		<cfloop index="req" list="#PreserveSingleQuotes(Form.ReqList)#" delimiters=",">
			   
			    <cfset funds = "">
				
		     	<CF_RequisitionFundingCheck RequisitionNo="'#req#'">
			  		
				<cf_tl id="REQ011" var="1">
				<cfset vReq011=lt_text>
					
				<cfif Funds eq "No">
			        <cf_message message = "#req# #vReq011# #vReq010#" return = "back">
				    <cfabort>
				</cfif>
						
		</cfloop>		   
		
		<!--- Process now --->  
					
	    <cfloop index="str" list="#PreserveSingleQuotes(ReqList)#" delimiters=",">
		   
		   		<cfset rowline = rowline+1>				
				
				<cfif Object.ObjectKeyValue1 eq "">			
			        <cfset val = evaluate("Form.#str#")> 				
				</cfif>	
				
				<cfif val neq "">				
						   
			   		<cfset l = len(val)>
			   		<cfset action = left(val,1)>
					
					<!--- determine the requisitionNo --->					
					<cfset req = mid(val, 3, l-2)>	
					
					<!--- check if fully funded --->	 
					
					<cfset txt = "cleared">
										
					<cfset next = "2">
							
				    <!--- define if status should moved forward beyond "2" --->
					
					<cfif url.role eq "ProcReqBudget">
					
					    <!--- status is 2b or beyond --->
					
						<cfquery name="FlowSetting" 
							datasource="AppsPurchase" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">		
									SELECT   S.*
									FROM     RequisitionLine R INNER JOIN
							                 ItemMaster M ON R.ItemMaster = M.Code INNER JOIN
							                 Ref_ParameterMissionEntryClass S ON R.Mission = S.Mission AND R.Period = S.Period AND M.EntryClass = S.EntryClass
									WHERE    R.RequisitionNo = '#req#'
							</cfquery>	
															
							<cfset next = "2b">   			
				   
						    <cfif FlowSetting.EnableFundingClear eq "0" or Parameter.FundingClearPurchase eq "1"> 
						   
						        <!--- funding processing ala mozambique, so SKIP the funding step --->
						       	<cfset next = "2f">   
														
								<cfif FlowSetting.EnableCertification eq "0">
								      
									  <cfset next = "2i"> 							  
									  <!--- set status as certified so immediately to buyer assign or if buyer is predefined it goes straight to the buy for action --->								  	  				  
									  
								</cfif>
					
						    </cfif>		
										
					<cfelseif url.role eq "ProcReqApprove">		
					
							<!--- status is 2a or beyond --->
					
							<cfquery name="FlowSetting" 
							datasource="AppsPurchase" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">		
									SELECT   S.*
									FROM     RequisitionLine R INNER JOIN
							                 ItemMaster M ON R.ItemMaster = M.Code INNER JOIN
							                 Ref_ParameterMissionEntryClass S ON R.Mission = S.Mission AND R.Period = S.Period AND M.EntryClass = S.EntryClass
									WHERE    R.RequisitionNo = '#req#'
							</cfquery>	
															
							<cfset next = "2a">   
							
							<cfif FlowSetting.EnableBudgetReview eq "0">	
							
						    	<cfset next = "2b">  		
				   
							    <cfif FlowSetting.EnableFundingClear eq "0" or Parameter.FundingClearPurchase eq "1"> 
							   
							        <!--- funding processing ala mozambique, so SKIP the funding step --->
							       	<cfset next = "2f">   
															
									<cfif FlowSetting.EnableCertification eq "0">
									      
										  <cfset next = "2i"> 							  
										  <!--- set status as certified so immediately to buyer assign or if buyer is predefined it goes straight to the buy for action --->								  	  				  
										  
									</cfif>
						
							    </cfif>		
							
							</cfif>
							
					<cfelse>
					
						<!--- we determine if we forward, we also forward 10/1/2015 if the reviewer = approver --->
													
						<cfquery name="FlowSetting" 
						datasource="AppsPurchase" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">		
								SELECT   S.*, R.Orgunit,M.EntryClass, R.OrgUnitImplement
								FROM     RequisitionLine R INNER JOIN
						                 ItemMaster M ON R.ItemMaster = M.Code INNER JOIN
						                 Ref_ParameterMissionEntryClass S ON R.Mission = S.Mission AND R.Period = S.Period AND M.EntryClass = S.EntryClass
								WHERE    R.RequisitionNo = '#req#'
						</cfquery>	
						
						<!--- we determine if the reviewer is also the approver = approver --->
						
						<cfquery name="isApprover" 
						datasource="AppsOrganization" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">	
							SELECT   *
							FROM     OrganizationAuthorization
							WHERE    Role        = 'ProcReqApprove' 
							AND      Mission     = '#url.mission#' 
							AND      (OrgUnit IS NULL OR OrgUnit = '#FlowSetting.OrgUnitImplement#')
							AND      UserAccount = '#session.acc#'
							AND      ClassParameter = '#FlowSetting.EntryClass#' 
						</cfquery>
						
						<cfquery name="checkFly" 
						datasource="AppsPurchase" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">	
							SELECT   *
							FROM     RequisitionLineAuthorization
							WHERE    Role        = 'ProcReqApprove' 
							AND      RequisitionNo = '#req#'							
						</cfquery>
						
						<!--- check if the reviewer is also a preset approver --->						
						
						<cfif isApprover.recordcount gte "1" and checkFly.recordcount eq "0">
						    <cfset SkipApproval = "1">
						<cfelse>
							<cfset SkipApproval = "0">
						</cfif>
											
						<cfif FlowSetting.EnableClearance eq "0" or SkipApproval eq "1">	
						
							 <!--- skip approval --->							 
													
							 <cfset next = "2a">   
							 
							 <cfif FlowSetting.EnableBudgetReview eq "0">	
							 
							 	<cfset next = "2b">   
																				 							 																
								 <cfif FlowSetting.EnableFundingClear eq "0" or Parameter.FundingClearPurchase eq "1"> 							 							
							   
							        <!--- funding processing ala mozambique, so SKIP the funding step --->
							       	<cfset next = "2f">   
															
									<cfif FlowSetting.EnableCertification eq "0">
									      
										  <cfset next = "2i"> 							  
										  <!--- set status as certified so immediately to buyer assign or if buyer is predefined it goes straight to the buy for action --->								  	  				  
										  
									</cfif>
						
							    </cfif>		
							
							</cfif>
							
						</cfif>											
					
					</cfif>		  	   
					
					<cfif action eq "D">
					    <!--- delete --->
					    <cfset st = "9">
					<cfelseif action eq "R">
					    <!--- return --->
					    <cfset st = "1">  
					<cfelse>
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
										
					<!--- check if certification is needed in case of 
					clearance for the complete line --->
	
					<cfquery name="Check" 
					     datasource="AppsPurchase" 
					     username="#SESSION.login#" 
					     password="#SESSION.dbpw#">
					     SELECT  * 
						 FROM    RequisitionLINE									 
						 WHERE   RequisitionNo = '#req#' 
					</cfquery>
											
					<cfif st eq "2f">
						
						    <!--- enabled certification --->
							
							<cfif FlowSetting.CertificationThreshold gt "0">	
							
								<!--- find the total amount to compare --->
							
								<cfquery name="Total" 
								     datasource="AppsPurchase" 
								     username="#SESSION.login#" 
								     password="#SESSION.dbpw#">
								     SELECT  sum(RequestAmountBase) as Amount 
									 FROM    RequisitionLINE									 
									 WHERE   Mission   = '#Check.mission#'
									 AND     Reference = '#Check.Reference#'						
								</cfquery>			
								
								<cfif FlowSetting.CertificationThreshold gte Total.amount>
								
									<!--- skipping --->
									<cfset st = "2i">		
										
								<cfelse>
								
									<cfset st = next>								
										
								</cfif> 
								
							<cfelse>
							
								<cfset st = next>		
							
							</cfif>	
										
					</cfif>			
									
					<!--- -------------- define funding requirements------------ --->					
	
					<cfif Parameter.FundingByReviewer lt "2" or
					    (Parameter.FundingByReviewer eq "2" and Check.ActionStatus gt "2")>								
							<cfset checkfunding="1">
					<cfelse>
							<cfset checkfunding="0">
					</cfif>
					
					<!--- ------------------------------------------------ --->
					<!--- process the batch action only if 100% funded 
					         AND funding is already required at this stage --->
					<!--- ------------------------------------------------ --->		 
									
					<cfif (Fund.Funding eq "1" and checkfunding eq "1") or checkfunding eq "0" or st eq "9" or st eq "1">
									
						<cfset url.id = req>	
							
						<cfset url.archive = 1>			
						
						<cfquery name="Line" 
						datasource="AppsPurchase" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						    SELECT L.*
						    FROM   RequisitionLine L
							WHERE  RequisitionNo = '#url.id#'
						</cfquery>
						
						<cfsavecontent variable="content">
						   	<cfinclude template="../Requisition/RequisitionEditLog.cfm">						
						</cfsavecontent>
						
						<cftransaction>
						
						<cfif line.jobNo neq "">
						    
							<!--- direct return --->
							
							<cfquery name="Line" 
							datasource="AppsPurchase" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT L.*
							    FROM   RequisitionLineQuote L
								WHERE  RequisitionNo = '#url.id#'
								AND    JobNo = '#line.JobNo#'
							</cfquery>
							
							<cfif line.recordcount gte "1">
							  <cfset st = "2q">
							<cfelse>
							  <cfset st = "2k">
							</cfif>
							
						</cfif>
			   
						<!---  1. update requisition lines --->
						<cfquery name="Update" 
						     datasource="AppsPurchase" 
						     username="#SESSION.login#" 
						     password="#SESSION.dbpw#">
						     UPDATE RequisitionLINE
							 SET    ActionStatus    = '#st#' 
							 WHERE  RequisitionNo   = '#req#'
						</cfquery>
						
						<cf_assignId>
						
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
							  ActionDate, 
							  ActionContent, 							 
							  ActionMemo,							 					 
							  OfficerUserId, 
							  OfficerLastName, 
							  OfficerFirstName) 
							 SELECT RequisitionNo, 
							        '#rowguid#',
									'#proc#',
							        '#st#', 
									getDate(), 
									'#content#', 
									<cfif st eq "1">
									'Sent back to requester',
									<cfelseif Object.ObjectKeyValue1 neq "">
									'End of workflow',
									<cfelse>
									'',
									</cfif>
									'#SESSION.acc#', 
									'#SESSION.last#', 
									'#SESSION.first#'
							 FROM RequisitionLine
							 WHERE RequisitionNo = '#req#'
						</cfquery>
						
						<!--- retrieve and save reasons --->
						
						<cfif st eq "9" or st eq "1">
																
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
								WHERE     Status   = '2i'
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
							
						</cfloop>	
						
						<!--- ---------------------------------------------- --->
						<!--- update actor if a send back actor was selected --->
						<!--- ---------------------------------------------- --->
							
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
									 WHERE RequisitionNo = '#req#'
								</cfquery>		
							
							</cfif>
			
						</cfif>
												
						<cfif (st eq "9" or st eq "1") and Parameter.EnableDenyMail eq "1" and Parameter.TemplateEMail neq "">
							
								<!--- user selected denied which will trigger an eMail 
									script to send a denial message and attachment --->
										
								<cfinclude template="../../../Workflow/ReqMail.cfm">								
										
						<cfelse>			
						
							<!--- check if the status is set for the procurement supervisor to assign --->
								
							<cfif st eq "2i">
							
								<!--- ------------------------------------------------ --->
								<!--- record buyer instantly : bypass assignment : CMP --->
								<!--- ------------------------------------------------ --->								
								<cfinclude template="setDefaultBuyer.cfm">									
								
							</cfif>	
							
						 </cfif>	
						 							
						</cftransaction>		
				
					</cfif>
					
					<!--- ----------------------------------------------------- --->
					<!--- send eMail to the actors for the next step if enabled --->
					<!--- ----------------------------------------------------- --->						
					
					<cfif Parameter.EnableActorMail eq "1" and st neq "1" and st neq "9">					
						<cfinclude template="ActorMail.cfm">														
					</cfif>
					
				 </cfif>	
					
		   </cfloop>
		 		
	</cfif>
	
</cfif>	

<cfoutput>

<cfif Object.ObjectKeyValue1 eq "">

    <cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
	<cfset mid = oSecurity.gethash()/>   

	<script>  	 
	   
	    Prosis.busy('no')    				
		#ajaxLink('RequisitionClearPending.cfm?role=#url.role#&message=#message#&mission=#URL.Mission#&period=#URL.Period#&mid=#mid#')#
		try { 
		refreshtree('#url.mission#','#url.period#','#url.role#');
		se = opener.document.getElementById('button_#URL.Role#') 		
		se.click() } catch(e) {}
		
	</script>

</cfif>

</cfoutput>
