
<cf_dialogLedger>

<cf_screentop height="100%" scroll="Yes" jquery="Yes" html="No" MenuAccess="Yes" SystemFunctionId="#url.idmenu#">

<cf_ProcessScript>
<cf_listingscript>
<cf_dialogstaffing>

<table width="94%" height="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">

<TR class="hide"><TD id="contentbox1" height="10"></TD></TR>

<cfoutput>

<script>
	
	function morea(box,act) {
					
		icM  = document.getElementById(box+"Min")
	    icE  = document.getElementById(box+"Exp")
		se   = document.getElementsByName("detail"+box);
				 		 
		if (act == "show") {	 
				
	     	 icM.className = "regular";
		     icE.className = "hide";
			 cnt = 0
			 while (se[cnt]) {
			    se[cnt].className = "regular"
				cnt++
			 }	    	
		 } else {
		   	 icM.className = "hide";
		     icE.className = "regular";
			 cnt = 0
			 while (se[cnt]) {
			    se[cnt].className = "hide"
				cnt++
			 }	     	
		 }
					 		
	  }

	  	  
	  function getDetails(sc,m,pe,cid,act)  {

		icM  = document.getElementById(cid+"Final_Min")
	    icE  = document.getElementById(cid+"Final_Exp")
		se   = document.getElementById('final'+cid);
		if (se.className == "regular") {
			se.className = "hide";
			act = 'hide' 
		} else {
			ptoken.navigate('ProcessListDetails.cfm?systemfunctionid=#url.idmenu#&SalarySchedule='+sc+'&Mission='+m+'&PayrollEnd='+pe,'final_details'+cid);
			se.className = "regular";
			act = 'show';
		}
		
		if (act == "show") {
	     	 icM.className = "regular";
		     icE.className = "hide";			
		} else {
		   	 icM.className = "hide";
		     icE.className = "regular";						
		}		 
	  	
	  }
	  
	  function openfinal(id) {
	     ptoken.open('#session.root#/Payroll/Application/Payroll/FinalPayment/FinalPaymentView.cfm?settlementid='+id+'&systemfunctionid=#url.idmenu#','_blank')
	  }
		  
</script>		  

</cfoutput>

<!--- recommendation which periods should be recalculated --->
					
<cfinclude template="CalculationPreparation.cfm">
			
<cfquery name="SearchResult"
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   S.Description, 
	         S.PaymentCurrency, 
		     S.ProcessMode,
		     P.*,
		     (SELECT Reference 
			 FROM   Purchase.dbo.Requisition
		     WHERE  Reference = P.Reference) as ObligationLink,
			 
			(SELECT TOP 1 ReferenceId 
			 FROM   Accounting.dbo.TransactionHeader
		     WHERE  ReferenceId = P.CalculationId) as PostingLink,
			 
			 (SELECT   TOP (1) Created
			  FROM     CalculationLog
              WHERE    (PersonNo = '') 
			  AND      ProcessClass = 'Calculation'
			  AND      ProcessBatchId = P.CalculationId
			  ORDER BY ProcessNo DESC	
			  ) as LastCalculation,
	 
			 
			 SettleInitial,
			 M.DateEffectivePosting,
			 M.DateExpiration,
			 M.DateEffectivePortal

	FROM     SalarySchedule S, 
	         SalaryScheduleMission M, 
		     SalarySchedulePeriod P
		   
	WHERE    S.SalarySchedule  = M.SalarySchedule
	AND      M.Mission         = '#URL.Mission#'
	AND      M.SalarySchedule  = P.SalarySchedule
	AND      M.Mission         = P.Mission
	AND      P.PayrollStart < (SELECT  ISNULL(DateExpiration,'9999/12/31') as Date
				               FROM    SalaryScheduleMission
							   WHERE   Mission        = '#URL.Mission#'
				               AND     SalarySchedule = S.SalarySchedule) 
	AND      S.Operational     = 1
	ORDER BY S.ListingOrder, P.SalarySchedule, P.PayrollStart DESC 	
</cfquery>		



<tr>
	<td height="20" colspan="1" align="left" style="padding-top:5px;padding-left:4px">
	    <cf_tl id="Calculate Selected In-cycle periods" var="1">
		<cfoutput>
		<input type="button" class="button10g" style="width:360;height:35;font-size:15px" id="submit" name="submit" value="#lt_text#" onclick="calc()">
		</cfoutput>	
	</td>
</tr>

<tr><td valign="top">

	<cf_divscroll>
				
		<table width="98%" border="0" align="center">
		
		<tr class="labelmedium line fixrow">
		
		<td style="min-width:10px"></td>
		<td style="min-width:200px;width:100%"><cf_tl id="Month"></td>
		<td style="min-width:150px"><cf_tl id="Last calculated"></td>
		<td style="min-width:250px"><cf_tl id="Separation"></td>
		<td style="min-width:250px"><cf_tl id="Status"></td>
		
		</tr>
					
		<!--- ------------------------------ --->
		<!--- preparation of the calculation --->
		<!--- ------------------------------ --->
						
		<cfoutput query="SearchResult" group="SalarySchedule">
		
		<cfset row = 0>
				
		<cfquery name="Current"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				 SELECT   TOP 1 *
				 FROM     SalarySchedulePeriod
				 WHERE    Mission        = '#URL.Mission#'
				 AND      SalarySchedule = '#SalarySchedule#'
				 AND      CalculationStatus IN ('0','1') 
				 AND      PayrollStart < (SELECT  ISNULL(DateExpiration,'9999/12/31') as Date
				                          FROM    SalaryScheduleMission
										  WHERE   Mission        = '#URL.Mission#'
				                          AND     SalarySchedule = '#SalarySchedule#') 
				 ORDER BY PayrollStart
		</cfquery>		
		
		<cfquery name="Last"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				 SELECT   MAX(SettlementFinalDate) as LastProcessDate
				 FROM     SalarySchedulePeriod
				 WHERE    Mission        = '#URL.Mission#'
				 AND      SalarySchedule = '#SalarySchedule#'
				 AND      CalculationStatus IN ('3') 				 
		</cfquery>		
		
		<!--- check pending actions to determine proposal calculation date --->
		
		<cfquery name="Pending"
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">		
			
			   <!--- we take the lowest entitlementment of an overtime which has not been settled yet --->
								
				SELECT   PersonNo,MIN(OvertimeDate) AS FirstAction,'Overtime' as Class
				FROM     PersonOvertime AS P
				WHERE    Mission = '#url.mission#' <!--- same entity --->
				AND      OvertimePayment = 1       <!--- payable --->
				AND      Status = '2'              <!--- cleared --->
				AND      PersonNo IN
	                             (SELECT   PersonNo
	                               FROM    Employee.dbo.PersonContract
	                               WHERE   Mission        = '#url.mission#'
								   AND     SalarySchedule = '#SalarySchedule#'
								   AND     DateEffective  <  getDate() 
								   AND     DateExpiration >= getDate()-40 
								   AND     ActionStatus IN ('0','1')) <!--- staff with valid contract for this schedule and entity --->
								   
			    AND       NOT EXISTS
	                             (SELECT   'X' AS Expr1
	                               FROM    EmployeeSalaryLine
	                               WHERE   ReferenceId = P.OvertimeId) <!--- not settled yet --->
								   
								   
				AND    Remarks NOT LIKE 'Prosis Automatic%'		
				
				AND    OvertimeDate > getDate() - 400 		   
				
				GROUP BY PersonNo
							   
								   
				UNION
				
				<!--- we take the lowest effective date of an action for which we have 
				    a workflow processing date after the last payroll calculation date which we then know has not been
					processed yet --->
				
				SELECT       PersonNo, MIN(EA.ActionDate) AS FirstAction,'Action' as Class			
				FROM         Employee.dbo.EmployeeAction AS EA INNER JOIN
	                         Organization.dbo.OrganizationObject AS OO ON EA.ActionSourceId = OO.ObjectKeyValue4 INNER JOIN
	                         Organization.dbo.OrganizationObjectAction AS OA ON OO.ObjectId = OA.ObjectId
				WHERE        OA.OfficerDate >= '#dateFormat(Last.LastProcessDate,client.dateSQL)#' <!--- last payroll process date to pick up matter --->
				AND          EA.ActionSourceId IN
	                             (SELECT  ContractId
	                              FROM    Employee.dbo.PersonContract							  
	                              WHERE   Mission        = '#url.mission#'
								  AND     SalarySchedule = '#SalarySchedule#'
								  AND     DateEffective  <  getDate() 
								  AND     DateExpiration >= getDate()-40 
								  AND     ActionStatus IN ('0','1')) 
			    AND           OA.OfficerLastName NOT IN ('Prosis')
				
				GROUP BY PersonNo
									   
		 </cfquery>				 			   
				
		<tr>
					
		     <td style="padding-top:5px;font-weight:200;height:40px;font-size:23px;" valign="top" class="labelmedium" colspan="2">
			   <a href="javascript:scheduleedit('#SalarySchedule#')"><font color="black">#Description# 
			   <cfif dateExpiration neq ""><font size="2" color="FF0000"><cf_tl id="Expiry">: #dateFormat(DateExpiration,client.dateformatShow)#</font></cfif>
			   </a>
			 </td>
	    	
			 <td align="right" colspan="3" style="font-weight:200;padding-right:28px;font-size:16px">
			 
			  <cfquery name="Last" dbtype="query">
				 SELECT *
				 FROM Pending
				 ORDER BY FirstAction ASC
			 </cfquery>		
			 
				 <cfif Last.FirstAction neq "" and PayrollStart gt Last.FirstAction>
				 <table class="navigation_table">
				 <tr class="labelmedium line">
				 <td colspan="6">
				 	Recommended recalculation:<font color="FF0000"> <b>#dateFormat(Pending.FirstAction,'MMMM YYYY')#</b>						
				 </td></tr>
				 
				 <cfset row = "0">
				 
				 <cfloop query="Pending">
				 
				 	<cfset row = row+1>
					 <cfif row eq "1">
					 <tr class="line labelmedium">
					 </cfif>
					 <td style="padding-left:3px;padding-right:7px">
					 <a href="javascript:EditPerson('#PersonNo#','#url.idmenu#','Contract')">#PersonNo#</a>
					 </td>
					 
					 <cfquery name="Person"
						datasource="AppsEmployee" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">		
						SELECT *
						FROM Person
						WHERE PersonNo = '#PersonNo#'
					  </cfquery>
					  
					  <td style="padding-left:3px;padding-right:7px">#Person.FirstName# #Person.LastName#</td>
					  <td align="right" style="padding-left:3px;padding-right:7px">#Class#</td>
					 
					 <cfif row eq "2">
					 </tr><cfset row = "0">
					 </cfif>
					 
				 </cfloop>
				 					 
				 </table>
				 </cfif>
			 
			 </td>
		
		</tr>
			
		<tr><td style="height:5px"></td></tr>
		
		<tr class="line">
		
		    <td style="padding-left:10px;padding-right:10px" colspan="5">
		
			<table width="100%" border="0" class="navigation_table">
						
			<cfinclude template="CalculationStart.cfm">
				
			<cfset p = "">
			
				<cfoutput group="PayrollEnd">	
					
					<cfoutput>
					
						<cfquery name="Schedule"
						datasource="AppsPayroll" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT *
							FROM   SalarySchedule
							WHERE  SalarySchedule = '#SalarySchedule#'				
						</cfquery>		
					
						<cfset row = row+1>
										
						<cfif row lte 4>
						  <cfset show = "regular navigation_row line">		
						  <cfset name = "">		
						<cfelse>
						  <cfset show = "hide">
						  <cfset name = "#SalarySchedule#">
						</cfif>
						
						<!--- --------------------------- --->
						<!--- ------ Period Lines ------- --->
						<!--- --------------------------- --->
								
						<TR id="#SalarySchedule#" name="#name#" class="#show#" style="height:20px"> 
						
							<cfif p neq PayrollEnd>
							
							   <td align="center" style="border:1px solid silver;border-bottom:0px;width:4%;padding-left:10px;padding-right:5px">
							       <cfif DateEffectivePosting lte PayrollEnd>
								      <input type="checkbox" class="radiol" name="calculate" value="'#CalculationId#'">	
								   </cfif>
							   </td>
							  
							   <TD class="labelmedium" style="border:1px solid silver;;border-bottom:0px;padding-left:4px;width:100%;min-width:200px">
							   
								   <cfif CalculationStatus gte "1"><font color="black"><cfelse><font color="red"></cfif>#dateformat(PayrollStart, "MMMM")#
								   #dateformat(PayrollStart, "YYYY")#</font>
							   
							   </td>
							   
							   <TD class="labelmedium" align="center" style="border:1px solid silver;border-bottom:0px;;padding-left:4px;min-width:150px">						   
							       #dateFormat(LastCalculation,client.dateformatshow)# #timeFormat(LastCalculation,"HH:MM")# 						   
							   </td>
							   
							   <td class="labelmedium" style="min-width:250;border:1px solid silver;;border-bottom:0px;">
							   					   					  					   
							  			<table>
										<tr>
																			
										<cfquery name="Expiry"
										datasource="AppsEmployee" 
										username="#SESSION.login#" 
										password="#SESSION.dbpw#">
											SELECT     DISTINCT P.PersonNo
											FROM       Person P INNER JOIN 
											           PersonContract PC ON P.PersonNo = PC.PersonNo 			             
							   			    WHERE      PC.SalarySchedule = '#SalarySchedule#'			 
							  				AND        PC.ActionStatus    != '9'		
											AND        PC.EnforceFinalPay  = 1
											AND        PC.Mission          = '#mission#'
										    AND        (PC.DateExpiration >= '#PayrollStart#' and PC.DateExpiration <= '#PayrollEnd#') 
											AND        PC.PersonNo NOT IN
											
									                    	      (SELECT     PersonNo
										                            FROM      PersonContract
									    	                        WHERE     PersonNo       = PC.PersonNo 
																	AND       Mission        = PC.Mission 
																	AND       SalarySchedule = PC.SalarySchedule 
																	AND       ActionStatus != '9' 
																	AND       (DateExpiration IS NULL OR DateExpiration > '#PayrollEnd#')
																  )
																  		
										</cfquery>			
														
										
										<td style="padding-left:4px;padding-right:6px" class="labelmedium">									
										#Expiry.recordcount#
										</td>										 	
							   
							   			<cfquery name="Final"
											datasource="AppsEmployee" 
											username="#SESSION.login#" 
											password="#SESSION.dbpw#">
												SELECT     DISTINCT PersonNo
												FROM       Payroll.dbo.EmployeeSettlement
												WHERE      PaymentFinal   = '1'
												AND        SalarySchedule = '#SalarySchedule#'			 
								  				AND        Mission        = '#mission#'
											    AND        PaymentDate    = '#PayrollEnd#' 														  		
										</cfquery>	
										
										<cfif Final.recordcount gte "1">
										
											<cfquery name="Pending"
												datasource="AppsEmployee" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
													SELECT     DISTINCT PersonNo
													FROM       Payroll.dbo.EmployeeSettlement
													WHERE      PaymentFinal   = '1'
													AND        ActionStatus   = '0'
													AND        SalarySchedule = '#SalarySchedule#'			 
									  				AND        Mission        = '#mission#'
												    AND        PaymentDate    = '#PayrollEnd#' 														  		
											</cfquery>	
																													
											<td>
											
												<table>
												  <tr onclick="getDetails('#SalarySchedule#','#Mission#','#dateformat(PayrollEnd,client.dateformatshow)#','#CalculationId#')">										 
												  <td  style="padding-left:4px;padding-right:4px;min-width:80" class="labelmedium">
												     <cfif pending.recordcount gte "1"><font color="FF0000"></cfif>
													 <cf_tl id="Final Pay">:
												  </td>
											      <td class="labelmedium" style="padding-left:5px"><cfif pending.recordcount gte "1"><font color="FF0000"></cfif>#Final.recordcount#</td>									 										  
												  <td style="padding-left:4px;padding-right:5px">												
														
														<img src="#SESSION.root#/Images/Expand.png" alt="" width="14"
															id="#CalculationId#Final_Exp" border="0" class="regular" 
															align="absmiddle" style="cursor: pointer;">															
														<img src="#SESSION.root#/Images/Collapse.png" width="14"
															id="#CalculationId#Final_Min" alt="" border="0" 
															align="absmiddle" class="hide" style="cursor: pointer;">												
															
												  </td>										  
				  								  </tr>										  
												</table>
											
											</td>
																										
										</cfif> 
										
										</tr>
										</table>
														    
							   </td>
							   
							   <td colspan="8" align="right" style="border:1px solid silver;border-bottom:0px;padding-right:5px;min-width:250" class="labelit">
							   					   
							        <table class="formpadding">
									
										<tr style="height:20px">				
										
										<td id="st#calculationid#" class="labelmedium" style="padding-right:10px">
								   		
										<table>
										
										<tr class="labelmedium" style="height:20px">
																	   				
							   			<cfif CalculationStatus eq "0">
																							
											<cfif SettleInitial neq "100">
											
												<td style="padding-right:5px"><cf_tl id="Process">:</td>
												<td style="padding-left:5px">#SettleInitial# %</td>
																	
											<cfelse>
											
												<td style="padding-right:5px"></td>
																	
											</cfif>
										
									    <cfelseif CalculationStatus eq "1">
										
											<cfif SettleInitial neq "100">									
												<td style="padding-right:5px"><cf_tl id="Calculated">:</td>
												<td style="padding-left:5px;padding-right:5px">#SettleInitial# %</td>															
											<cfelse>									
												<td style="padding-right:5px;padding-right:5px"><cf_tl id="Calculated">:</td>															
											</cfif>
										
										    <cfif ProcessMode eq "Financials">
											
												<cfif SettleInitial neq "100">		
												
													<cfif CalculationStatus eq "1" and transactionCount gte "0" and accessPayroll eq "ALL">
												
														<td>
														<!--- initial mode not enabled --->
													    <a href="javascript:lock('#CalculationId#','2')" title="Lock and Record Advance"><font color="0080C0">
														<cf_tl id="Post Advance to Ledger"></font></a>
														<td>
																							
													</cfif>				
												
												<cfelse>
											
													<cfif CalculationStatus eq "1" and transactionCount gte "0" and accessPayroll eq "ALL">
												
														<td>
														<!--- initial mode not enabled --->
													    <a href="javascript:lock('#CalculationId#','3')" title="Lock and Record Final Settlement"><font color="0080C0">
														<cf_tl id="Post to Ledger"></font></a>
														<td>
																							
													</cfif>		
												
												</cfif>							
										
										    <cfelse>
											
												<!---
											
												<cfif CalculationStatus eq "1" and transactionCount gte "0" and accessPayroll eq "ALL">
											
													<td>
												    <a href="javascript:lock('#CalculationId#','2')" title="Lock and Record Settlement and Obligation"><font color="0080C0">
													<cf_tl id="Lock Initial Settlement"></font></a>
													</td>
																						
												</cfif>		
												
												--->
											
											</cfif>
										
										<cfelseif CalculationStatus eq "2">							
										
										    <td style="padding-right:4px">					
											<cfif TransactionPayment neq "0">								
											<font color="6688aa"><cf_tl id="Advance processed"></b> 
											</cfif>
											</td>
						
											 <cfif ProcessMode eq "Procurement">
											 
											     <!---
												 <td>					 
												 [<a href="javascript:RequisitionView('#mission#','','#reference#')">
												 <cfif ObligationLink eq Reference>#Reference#<cfelse><font color="FF0000">Disconnected</cfif></a>]
												 </td>
												 --->
												 
											 <cfelse>
											 												 	
												 <cfif PostingLink neq "">
												 
													<cfquery name="Header"
														datasource="AppsLedger"
														username="#SESSION.login#" 
														password="#SESSION.dbpw#">
													    SELECT   *
														FROM     TransactionHeader
														WHERE    ReferenceId = '#PostingLink#'		
														AND 	 Journal in (
																SELECT Journal FROM Accounting.dbo.Journal WHERE SystemJournal ='Payroll' AND TransactionCategory != 'Payables'
															)
													</cfquery>	
													
													 <td>
													 	
													 
													 <table>
													 
													 <cfloop query="Header">	
													 
													 <tr style="height:20px">								
													 	 <td style="min-width:165px" class="labelit"><a href="javascript:ShowTransaction('#Header.Journal#','#Header.JournalSerialNo#','1')">
														 #Header.Journal#-#Header.JournalSerialNo# #referenceno#</a>
														 </td>
													 </tr>
													 
													 </cfloop>
													 
													 </table>
													 
													 </td>
													
												 </cfif>							 
												 
											 </cfif>
											 
											 <cfquery name="due"
												datasource="AppsPayroll" 
												username="#SESSION.login#" 
												password="#SESSION.dbpw#">
													 SELECT   TOP 1 *
													 FROM     SalarySchedulePeriod
													 WHERE    Mission        = '#URL.Mission#'
													 AND      SalarySchedule = '#SalarySchedule#'
													 AND      CalculationStatus = '2' 
													 ORDER BY PayrollStart
											  </cfquery>		
											
											  <cfif due.CalculationId eq calculationid>
											  											  											  											  											 							 									 								 											 
												 <cfif CalculationStatus eq "2" and transactionCount gt "0" and accessPayroll eq "ALL">
												 
												    <!--- posting only if final records are found and caculated --->
																									
												    <cfif TransactionPaymentFinal neq "0">
												
														<td style="padding-left:5px">
														    <a href="javascript:lock('#CalculationId#','3')" title="Lock and Record Settlement">
															<font color="green"><cf_tl id="Post Final Settlement"></font>
															</a>
														</td>													
																							
													</cfif>
																																
												</cfif>		
																													
											  </cfif>
															
										<cfelseif CalculationStatus eq "3">
										
										    <td>
											
											<table width="100%">
											
												<tr class="labelmedium" style="height:20px">
												<td style="padding-right:9px">		
														
												<font color="green"><cf_tl id="Locked">
												</td>
																			
												<cfif PostingLink neq "">
												
												     <cfquery name="Header"
														datasource="AppsLedger"
														username="#SESSION.login#" 
														password="#SESSION.dbpw#">
													    SELECT   *
														FROM     TransactionHeader
														WHERE    ReferenceId = '#PostingLink#'	
														AND 	 Journal in (
																         SELECT Journal
																		 FROM   Accounting.dbo.Journal 
																		 WHERE  SystemJournal ='Payroll' 
																		 AND    TransactionCategory != 'Payables'
															)	
													</cfquery>	
													
													 <td>
													 
													 <table>
													 
													 <cfloop query="Header">	
													 
													     <cfif currentrow eq "1"><tr></cfif>									 							
														 	<td class="labelit" style="padding-right:5px;min-width:135px">
															 <a href="javascript:ShowTransaction('#Header.Journal#','#Header.JournalSerialNo#','1')">
															 #referenceno#: #Header.Journal#-#Header.JournalSerialNo#</a>
															</td>
														<cfif currentrow eq "2"></tr></cfif>	
												 
													 </cfloop>
													 
													 </table>	
													 
													 </td>													 
																			
												<cfelseif ObligationLink neq "">		
												
												 <td>						
												 <a href="javascript:RequisitionView('#mission#','','#reference#')">#Reference#</a>;
												 <a href="javascript:RequisitionView('#mission#','','#referenceFinal#')">#ReferenceFinal#</a>
												 </td>
												
												</cfif> 	
												
												</tr>
												
											</table>
											
											</td>	 				 						 				
										
										</cfif>
										
										</table>
										
										</td>
														
									  
									   
									   <td style="min-width:30px;padding-left:4px">
									   
									  
										   	<cfif transactioncount gt "0">
										
										
											<img src="#SESSION.root#/Images/Expand.png" alt="" width="18" height="16"
												id="#CalculationId#Exp" border="0" class="regular" 
												align="absmiddle" style="cursor: pointer;" 
												onClick="morea('#CalculationId#','show')">
													
											<img src="#SESSION.root#/Images/Collapse.png" width="18"  height="16"
												id="#CalculationId#Min" alt="" border="0" 
												align="absmiddle" class="hide" style="cursor: pointer;" 
												onClick="morea('#CalculationId#','hide')">
											
												
											</cfif>	
											
										
										</td>
										
										 <cfif CalculationStatus lte "2" and CalculationStatus gt "0">			
									   		<td style="padding-left:1px">				  
									            <cf_img icon="delete" onClick="del('#CalculationId#')">								  							
											</td>																																			
									   </cfif>		
									   
									   </tr>
									   
									   </table>
														
							        </TD>
											   
								</tr>
													 
								<!--- ---------------------------- --->
								<!--- ---- Calculation Line ------ --->
								<!--- ---------------------------- --->			
									
								<cfset show = "hide">		
									
								<tr><td></td>
									<td colspan="5">
								
									<table width="100%">		
															 
										<TR id="detail#CalculationId#" name="detail#CalculationId#" style="border-top:1px solid silver;border-left:1px solid silver;border-right:1px solid silver;" class="#show#" bgcolor="<cfif calculationstatus eq "3">e4e4e4<cfelse>eaeaea</cfif>"> 
										   
										   <td colspan="2" style="border:0px solid silver;padding:2px"></td>			    
										   <td class="labelit" style="border:0px solid silver;padding:2px">
										   <cfif CalculationStatus neq "0">					   
											    <cfif getAdministrator("*") eq "1" and transactionCount gte "1">
													<a href="javascript:recap('#CalculationId#')"><font color="0080C0"><cf_tl id="Entitlement calculation">:</font></a> 
												<cfelse>		   
													<font color="808080"><cf_tl id="Entitlement calculation">:
												</cfif>   
										   </cfif>
										   </td>
										   <TD class="labelit" style="border:0px solid silver;padding:2px"><cfif CalculationStatus neq "0">#Dateformat(CalculationDate, "#CLIENT.DateFormatShow#")#</cfif></TD>
										   <td class="labelit" style="border:0px solid silver;padding:2px"><cfif CalculationStatus neq "0">#OfficerFirstName# #OfficerLastName#</cfif></td>
														  
										   <td class="labelit" style="min-width:120px;border:0px solid silver;padding:2px;padding-left:20" align="right">
										   <cfif CalculationStatus neq "0">
												<cfif transactioncount eq "0"><font color="FF8040"></cfif>
												<font color="808080">Staff:</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#TransactionCount#
											</cfif>
										   </td>
											
										   <td class="labelit" style="border:0px solid silver;padding:2px;padding-left:20px"><cfif CalculationStatus neq "0"><font color="808080"><font color="808080">Control SUM:</font></cfif></td>			   
										   <td class="labelit" style="border:0px solid silver;padding:2px"><cfif CalculationStatus neq "0"><font color="808080">#PaymentCurrency#</font></cfif></td>
										   <TD class="labelit" align="right" colspan="2" style="border:0px solid silver;padding:2px">					
												 <cfif CalculationStatus eq "1"> #NumberFormat(TransactionValue, ",.__")#
										   		 <cfelseif CalculationStatus eq "2" or CalculationStatus eq "3"><font color="408080">#NumberFormat(TransactionValue, ",.__")#</font></b>
											     </cfif>
										   </td>
										  
										   <td width="20" class="labelit" align="center" style="border:0px solid silver;padding-top:3px">
												<cfif CalculationStatus neq "0">							
													<cf_img icon="open" tooltip="Verify Calculation with source data" onClick="javascript:check('#CalculationId#')"> 					   												
										   	    </cfif>										 
											</td>
		
											<td width="20" class="labelit" align="center" style="border:0px solid silver;padding-top:3px">
												<cfif CalculationStatus neq "0">							
													<cf_img icon="open" tooltip="check balances of financial posted transaction" onClick="javascript:checkBalances('#CalculationId#')"> 
										   	    </cfif>										 
											</td>
														   
									   <cfelse>
									   
									       <td colspan="11" bgcolor="white"></td>
										   
									   </cfif>
									
									</tr>
						
										<!--- --------------------------- --->
										<!--- ---- Settlement Line ------ --->
										<!--- --------------------------- --->
								
										<cfif CalculationStatus neq "0">
														
											<tr id="detail#CalculationId#" name="detail#CalculationId#" class="#show#" style="border-right:1px solid silver;border-left:1px solid silver;border-top:1px solid silver"
											bgcolor="<cfif calculationstatus eq "3">ffffaf<cfelse>ffffcf</cfif>">
												
											   <td style="border:0px solid silver;padding:2px"></td>	
											   <td align="center" class="labelit" style="min-width:150px;border:0px solid silver;padding:2px">
											      									  		  
											   		<cfif transactionCount eq "0" and calculationStatus eq "1">
													
													  <font color="FF0000"><cf_tl id="Empty Payroll"></font>
													  
													   <img src="#SESSION.root#/Images/alert.gif" 
														     name="img6#currentrow#" 						 
															 style="cursor: pointer;"
															 width="12" 
															 height="13" 
															 alt="Empty Payroll" 
															 border="0" 
															 align="absmiddle">
																
													</cfif>
											  		   						
													<cfif CalculationStatus eq "2" or CalculationStatus eq "3">
													
													<!---
													<img src="#SESSION.root#/Images/key.gif" alt="Locked Settlement" 
													      name="img6#currentrow#" 
														  style="cursor: pointer;" width="13" height="14" alt="" border="0" align="absmiddle">
														  --->
														  <cfinvoke component="Service.Access"
																	Method="PayrollOfficer"
																	Role="PayrollOfficer"
																	Mission="#mission#"
																	ReturnVariable="PayrollAccess">	
													
														<cfif getAdministrator("*") eq "1" or  PayrollAccess eq "ALL">
														
															 <cfif CalculationStatus eq "2">
							
																 <cfif TransactionPayment eq "0" and TransactionPaymentFinal neq "0">
																 
																 <!--- NADA --->
																 
																 <cfelseif TransactionPayment neq "0">
																 
																 <input type="button" value="Undo Posting Initial" id="undo_#CalculationId#" name="undo" class="button10g" style="height:20px;width:140px" onclick="unlock('#CalculationId#')">
																 										 								 
																 </cfif>
																 
															 <cfelseif CalculationStatus eq "3">
															 
															 	<cfif TransactionPayment neq "0">									 
															 	<input type="button" value="Undo posting Final" id="undo_#CalculationId#" name="undo" class="button10g" style="height:20px;width:140px" onclick="unlock('#CalculationId#')">										
																<cfelse>	
		
																	<input type="button" value="Undo posting" id="undo_#CalculationId#" name="undo" class="button10g" style="height:20px;width:140px" onclick="unlock('#CalculationId#')">
		
																</cfif>
																										 
															</cfif>
													
													</cfif>   
													
												 </cfif>	
											   
											   </td>		
											   
											   <td class="labelit" style="border:0px solid silver;padding:2px"><font><cf_tl id="Payroll Entitlements">:</td>	
											   	   		   	   
											   <td colspan="2" class="labelit" height="100%">
												   	<table width="100%" height="100%">
													
													   <cfif TransactionPayment eq "0" and TransactionPaymentFinal neq "0">
													   
													   <tr>
														   <td class="labelit" style="border-left:1px solid silver;padding-right:4px" align="center">#dateFormat(SettlementFinalDate, "#CLIENT.DateFormatShow#")#</td>
														   <td class="labelit" style="border-left:1px solid silver;padding-right:4px" align="right">#NumberFormat(TransactionPaymentFinal, ",.__")#</td>
													   </tr>
													   
													   <cfelse>
													   
													   <tr>
														   <td class="labelit" style="border-left:1px solid silver;padding-left:4px"><cf_tl id="Initial">:</td>
														   <td class="labelit" style="border-left:1px solid silver;padding-right:4px" align="center"> #dateFormat(SettlementDate, "#CLIENT.DateFormatShow#")#</td>
														   <td class="labelit" style="border-left:1px solid silver;padding-right:4px" align="right">#NumberFormat(TransactionPayment, ",.__")#</td>
													   </tr>
													   
													    <tr>
														   <td class="labelit" style="border-left:1px solid silver;padding-left:4px"><cf_tl id="Final">:</td>
														   <td class="labelit" style="border-left:1px solid silver;padding-right:4px" align="center"> #dateFormat(SettlementFinalDate, "#CLIENT.DateFormatShow#")#</td>
														   <td class="labelit" style="border-left:1px solid silver;padding-right:4px" align="right">#NumberFormat(TransactionPaymentFinal, ",.__")#</td>
													   </tr>
													   
													   </cfif>
													   
													  
												   </table>
											   
											   </td>		
											   					   
											   <td style="border:1px dotted silver;padding:2px"></td>	
											   
											   <cfif ProcessMode eq "Financials">
											   
											  	   <td class="labelit" style="border-left:1px solid silver;padding-left:6px"><cf_tl id="For staff net payments">:</td>
												   <td class="labelit" colspan="3" align="right" style="border-left:1px solid silver;padding-right:4px">#NumberFormat(TransactionPosting, ",.__")#</font></td>		  
											   
											   <cfelse>   
											   		   
												   <td class="labelit" style="border:0px solid silver;padding:2px"><font color="808080"><cf_tl id="Settlement Final">:</td>
												   <td class="labelit" style="border:0px solid silver;padding:2px">#dateFormat(SettlementFinalDate, "#CLIENT.DateFormatShow#")#</td>
												   <td class="labelit" align="right" style="border:0px solid silver;padding:2px;padding:2px">
												   <b><font color="408080">#NumberFormat(TransactionPaymentFinal, ",__.__")#</font></b>	  
												   </td>		 
											   
											   </cfif>
											   
											   <td></td>
											   <td></td>
												
										</tr>		
				
										<tr class="hide" id="final#CalculationId#">			   										  
										   <td id="final_details#CalculationId#" colspan="8" align="right" style="padding:3px;border:0px solid silver;"></td>
									    </tr>
									    									
										<tr class="hide" id="cd#CalculationId#" colspan="2">			   
										   <td id="ci#CalculationId#" colspan="12" align="right"></td>
									    </tr>
														
										<tr bgcolor="ffffef" class="hide" id="ed#CalculationId#">
										    <td id="ei#CalculationId#" colspan="12"></td>
									    </tr>						
										
								</cfif>
								
								</table>
								</td>
								</tr>
							
						<cfset p = PayrollEnd>	    
					   
					</cfoutput>  	 
						
				</cfoutput>	
				
				</TABLE>
			
		</td>
		</tr>
		
		<cfif row gte "5">
			<tr><td height="20" colspan="9" class="labelmedium" style="padding-left:30px;padding-top:5px;font-size:12px">						
			<a href="javascript:more('#salaryschedule#')">
			>> <cf_tl id="Toggle additional payroll periods of">#salaryschedule#</a></td></tr>
		</cfif>	
			
		</cfoutput>
				
		</TABLE>
			
	</cf_divscroll>

</td></tr>

</table>

<cfset ajaxOnLoad("doHighlight")>

