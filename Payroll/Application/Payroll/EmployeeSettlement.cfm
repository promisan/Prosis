
<cfparam name="url.scope" default="">

<!---
<cf_divscroll overflowy="scroll">
--->

<table width="93%" align="center" class="formpadding navigation_table">
		
	<cfquery name="Settlement" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT    TOP 100 P.SettlementId,
		          P.PersonNo, 
		          P.PaymentDate, 		
				  Year(P.PaymentDate) as PaymentYear,		 
				  P.SalarySchedule, 
				  P.Mission,
				  P.PaymentStatus,
				  P.PaymentFinal,
				  P.Source,				  
				  P.Created,
				  (SELECT MAX(Created)
				   FROM EmployeeSettlementLine S
				   WHERE S.PersonNo        = P.PersonNo 
                   AND S.SalarySchedule  = P.SalarySchedule 
				   AND S.Mission         = P.Mission 
				   AND S.PaymentDate     = P.PaymentDate 
				   AND S.PaymentStatus   = P.PaymentStatus ) as LastUpdated,
				  M.SettleInitialMode,
				  P.ActionStatus,
				  F.PaymentCurrency,
				  F.Description as SalaryScheduleName,
				  S.CalculationStatus,
				  Stl.SettlementPhase,
				  Stl.Currency,
				  MAX(DocumentCurrency) as DocumentCurrency, 
				  (SELECT TOP 1 ActionDate
				   FROM   EmployeeSettlementAction
				   WHERE  PersonNo        = P.PersonNo
				   AND    SalarySchedule  = P.SalarySchedule
				   AND    Mission         = P.Mission
				   AND    PaymentDate     = P.PaymentDate
				   AND    PaymentStatus   = P.PaymentStatus
				   AND    ActionCode      = Stl.SettlementPhase
				   ORDER BY PaymentDate DESC
				  ) as PayslipSent,			
				  
				    (SELECT count(*)
				   FROM   Employee.dbo.PersonContract
				   WHERE  PersonNo        = P.PersonNo
				   AND    SalarySchedule  = P.SalarySchedule
				   AND    Mission         = P.Mission
				   AND    RecordStatus    = '1'
				   AND    DateEffective  <=  P.PaymentDate
				   AND    DateExpiration >=  S.PayrollStart				   
				   ) as hasContract,		
				  	  
				  SUM(Stl.PaymentAmount)  AS NetPayment,			
				  SUM(Stl.DocumentAmount) AS NetPaymentDocument
				  <!---
				  ,
				  (SELECT H.TransactionId FROM Accounting.dbo.TransactionHeader as H WHERE H.Journal = STL.Journal and H.JournalSerialNo = STL.JournalSerialNo) as TransID
				  --->
		FROM      EmployeeSettlement P INNER JOIN
	              EmployeeSettlementLine Stl ON P.PersonNo        = Stl.PersonNo 
				                            AND P.SalarySchedule  = Stl.SalarySchedule 
											AND P.Mission         = Stl.Mission 
											AND P.PaymentDate     = Stl.PaymentDate 
											AND P.PaymentStatus   = Stl.PaymentStatus 
									   INNER JOIN
		          Ref_PayrollItem R ON Stl.PayrollItem = R.PayrollItem 
				                       INNER JOIN
		          SalarySchedulePeriod S ON  S.Mission = P.Mission AND S.SalarySchedule = P.SettlementSchedule AND S.PayrollEnd = P.PaymentDate
				   					   INNER JOIN
		          SalaryScheduleMission M ON  M.Mission = Stl.Mission AND M.SalarySchedule = Stl.SalarySchedule
									   INNER JOIN
		          SalarySchedule F ON F.SalarySchedule = P.SalarySchedule 
		WHERE     P.PersonNo = '#URL.ID#'  	
		AND       R.PrintGroup IN (SELECT PrintGroup 
		                           FROM   Ref_SlipGroup 
								   WHERE  NetPayment = 1) 
		<!---
		AND P.PayslipSent IS NOT NULL		
		---->
		<cfif url.scope eq "portal" and getAdministrator("*") eq "0">
				
			AND       S.CalculationStatus >= '2'
			AND       P.PaymentDate >= (SELECT DateEffectivePortal 
			                            FROM   SalaryScheduleMission 
										WHERE  SalarySchedule = P.SalarySchedule 
									AND    Mission        = P.Mission)
			
			
									
			AND      EXISTS (
			
			          SELECT 'X'
					  FROM   Accounting.dbo.TransactionHeader TH
					  WHERE  TH.TransactionSourceId = S.CalculationId 
					  ) 						

		   <!--- only of the finance posting workflow is finished --->						
			AND      NOT EXISTS (
						
						SELECT       'X'
						FROM         Accounting.dbo.TransactionHeader          AS TH INNER JOIN
	                    		     Organization.dbo.OrganizationObject       AS OO ON TH.TransactionId = OO.ObjectKeyValue4 INNER JOIN
			                         Organization.dbo.OrganizationObjectAction AS OOA ON OO.ObjectId = OOA.ObjectId
						WHERE        TH.TransactionSourceId = S.CalculationId 
						AND          TH.TransactionCategory = 'Memorial' 
						AND          OOA.ActionStatus       = '0' <!--- if pending steps it will not show --->
						AND          OO.Operational         = 1 )
						
						
									
		<cfelse>
			<!--- AND      ( S.CalculationStatus >= '1' OR P.PaymentFinal = 1 OR P.ActionStatus = '3') --->
		</cfif>
		
		GROUP BY P.SettlementId, 
		         Stl.SettlementPhase,
				 M.SettleInitialMode,
		         P.PersonNo, 
				 P.PaymentDate, 
				 P.PaymentStatus,
				 P.PaymentFinal, 
				 Stl.Currency, 				 
				 P.SalarySchedule, 
				 F.PaymentCurrency,
				 F.Description,
				 P.Mission, 
				 P.Source,
				 S.CalculationStatus,
				 S.PayrollStart,
				 P.ActionStatus,
				 P.Created
				 <!---,
				 Stl.Journal,
				 Stl.JournalSerialNo
				 --->
				 
		ORDER BY P.PaymentDate DESC, 				 
				 P.PaymentStatus,
				 P.SalarySchedule,
		         SettlementPhase
		
	</cfquery>	


	<cfquery name="getPayrollOfficers" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT 	DISTINCT P.*, A.Account
			FROM 	OrganizationAuthorization OA
					INNER JOIN System.dbo.UserNames A
						ON OA.UserAccount = A.Account
					INNER JOIN Employee.dbo.Person P
						ON A.PersonNo = P.PersonNo
			WHERE 	OA.Mission     = '#Settlement.Mission#'
			AND 	OA.Role        = 'PayrollStatement'
			AND 	OA.AccessLevel = '2'
			AND 	A.AccountType  = 'Individual'
			ORDER BY P.LastName, P.FirstName			
	</cfquery>
	
		
	<tr class="line labelmedium2 fixrow fixlengthlist" style="background-color:white">
	 <td align="right">C</td>
	 <td></td>
	 <td style="background-color:white"><cf_tl id="Period"></td>
	 <td style="background-color:white"><cf_tl id="Entity"></td>	
	 <td style="background-color:white"><cf_tl id="Schedule"></td>	 
	 <td style="background-color:white"><cf_tl id="Prepared"></td>	 
	 <td style="background-color:white"><cf_tl id="Updated"></td>	 
	 <td style="background-color:white"><cf_tl id="Mode"></td>	 
	 <td style="background-color:white"><cf_tl id="Status"></td>
	 <td style="background-color:white"><cf_tl id="Phase"></td>
	 <td style="background-color:white"><cf_tl id="Sent Slip"></td>	 
	 <td style="background-color:white" colspan="2" align="right"><cf_tl id="Net Pay"></td>	
	 <cfif url.scope neq "portal">
	 <td style="background-color:white" colspan="2" align="right"><cf_tl id="Net Pay"></td>		 
	 <cfelse>
	 <td style="background-color:white"></td><td></td>
	 </cfif>
	</tr>			
		
	<cf_tl id="Final"	var="1">
	<cfset vFinal=#lt_text#>

	<cf_tl id="Draft"	var="1">
	<cfset vClosed = lt_text>

	<cf_tl id="Open"	var="1">
	<cfset vOpen   = lt_text>
	
	<cf_tl id="Posted"	var="1">
	<cfset vLocked = lt_text>
	
	<cfif Settlement.recordcount eq "0">
	
	<tr>
	<td colspan="15" style="padding-top:10px" align="center" class="labelmedium2" height="50"><cf_tl id="There are no records found to show in this view">.</td>
	</tr>
	
	</cfif>
	
	<cfset prior = "1900">
	<cfset pdate = "1900">
						
		<cfoutput query="Settlement" group="PaymentDate">
		
			<cfif year(PaymentDate) neq prior>
			
			<tr class="line fixrow2">
					<td colspan="15" style="padding-left:13px;height:35px;padding-top:8px" class="labellarge">
					<cfif url.scope neq "portal">
						<table width="100%" border="0">
						    <tr>
							<td valign="top" style="height:40px;padding-left:10px;font-size:27px;padding-right:10px;" class="labelmedium">
								#year(PaymentDate)#
							</td>
							<td style="width:96%">
							
							<cfquery name="sub" dbtype="query">
								SELECT   Mission,PaymentYear, PaymentCurrency, SUM(NetPayment) as NetPayment
								FROM     Settlement
								WHERE    PaymentYear = '#year(paymentdate)#'	
								AND      CalculationStatus = '3'	
								GROUP BY Mission,PaymentYear,PaymentCurrency				
							</cfquery>
							
							<table style="width:100%;border:1px solid silver;background-color:e9e9e9;">
							
							<cfloop query="sub">
							<tr class="<cfif currentrow neq recordcount>line</cfif>">
								<td align="center" style="cursor:pointer;" onclick="showYearReport('#mission#','#URL.ID#','#PaymentYear#','#paymentCurrency#');">
									<table style="width:100%" height="100%">
										<tr class="labelmedium">
											<td align="center" style="min-width:30px;border-right:1px solid silver">
												<img src="#session.root#/images/pdf.png" style="height:18px;">	
											</td>
											<td align="center" style="min-width:120px;border-right:1px solid silver">
												<cf_tl id="Annual Statement">
											</td>
										</tr>
									</table>
								</td>
								<td  style="background-color:white;padding-left:10px;padding-right:10px" align="center">
									<table style="width:100%">
										<tr class="labelmedium">
											<td>
												<input type="Checkbox" id="Deductions_#PaymentYear#_#PaymentCurrency#" class="regularxl" checked="checked">
											</td>
											<td style="padding-left:5px;">
												<label for="Deductions_#PaymentYear#_#PaymentCurrency#"><cf_tl id="Deductions"></label>
											</td>
											<td style="padding-left:15px;">
												<input type="Checkbox" id="Contributions_#PaymentYear#_#PaymentCurrency#" class="regularxl">
											</td>
											<td style="padding-left:5px;">
												<label for="Contributions_#PaymentYear#_#PaymentCurrency#"><cf_tl id="Contributions"></label>
											</td>
											<td style="padding-left:15px;">
												<input type="Checkbox" id="Miscellaneous_#PaymentYear#_#PaymentCurrency#" class="regularxl">
											</td>
											<td style="padding-left:5px;">
												<label for="Miscellaneous_#PaymentYear#_#PaymentCurrency#"><cf_tl id="Miscellaneous"></label>
											</td>					
										</tr>
									</table>
								</td>
								<td>
									<table  style="width:100%">
										<tr class="labelmedium">
											<td style="border-left:1px solid silver;padding-left:5px"><cf_tl id="Signature"></td>
											<td style="padding-left:10px;">
												<select class="regularxl" id="Sign_#PaymentYear#_#PaymentCurrency#" style="border:0px;border-right:1px solid silver;border-left:1px solid silver">
													<option value=""> - <cf_tl id="No sign"> -
													<cfloop query="getPayrollOfficers">
														<option value="#Account#"> #LastName#, #FirstName#
													</cfloop>
												</select>
											</td>
										</tr>
									</table>
								</td>
								<td align="right" style="width:30%;padding-left:20px;font-size:16px;padding-top:2px;padding-right:10px" class="labelmedium">
									<font size="1">#PaymentCurrency#</font>&nbsp; #numberformat(NetPayment,",.__")#
								</td>
							</tr>
							</cfloop>
							
							</table>
							</td>
							</tr>
						</table>
					</td>
				</cfif>	
			</tr>
			
			<cfset prior = year(PaymentDate)>
			
			</cfif>
			
			<cfoutput>
						
				<cfif paymentFinal eq "1">
				   <cfset c = "DDFFDD">		
				<cfelseif paymentstatus eq "1">		
				   <cfset c = "FFCAFF">		      		   
				<cfelse>			
					<cfif CalculationStatus lt "2">
						<cfset c = "DADADA">
					<cfelse>
					   	<cfset c = "transparent">
					</cfif>			   
				</cfif>
		
				<tr bgcolor="#c#" style="height:21px" class="line labelmedium2 navigation_row fixlengthlist">
				
					<cfif hasContract eq "0" and ActionStatus neq "3" and PaymentFinal eq "0">
					<td align="right" style="background-color:red">
					<cfelse>
					<td align="right">
					</cfif>		
					
					<td align="center" width="50" style="padding-top:8px">																
						<cf_img icon="expand" id="show#currentrow#" navigation="Yes" toggle="yes" onclick="detail('#currentrow#','#settlementid#','#currency#','#settlementphase#')">		
					</td>
					<td><cfif pdate neq paymentdate>#DateFormat(PaymentDate,"MMMM")#<cfelse>..</cfif></td>
					<td>#Mission#</td>	
					<td>#SalaryScheduleName#</td>	
					<td>#DateFormat(Created,client.dateformatshow)#-<font size="1">#TimeFormat(Created,"HH:MM")#</font></td>	
					<td><cfif Created neq LastUpdated>#DateFormat(LastUpdated,client.dateformatshow)#-<font size="1">#TimeFormat(Created,"HH:MM")#</font><cfelse>..</cfif></td>	
					<td>	
					<cfif PaymentStatus eq "1"><cf_tl id="Off cycle"><cfelse><cf_tl id="In cycle"></cfif></td>						
					<td>
					    <cfif PaymentStatus eq "1">
					        <cfif ActionStatus eq "3">#vlocked#
							<cfelseif actionStatus eq "1">#vOpen#
							<cfelse>On Hold</cfif>
						<cfelse>
							<cfif     CalculationStatus gte "3">#vlocked#
						    <cfelseif CalculationStatus gte "2">#vClosed#
							<cfelse>#vOpen#</cfif>
						</cfif>	
					</td>
					<td><cfif PaymentFinal eq "1"><cf_tl id="Separation"><cfelseif settleInitialMode eq "1">#SettlementPhase#</cfif></td>
					<td>#DateFormat(PayslipSent,CLIENT.DateFormatShow)#</td>
						
					<td align="right" style="padding-right:0px">
						<table width="100%">
							<tr clss="fixlengthlist">
							<td style="font-size:10px">#currency#</td>
							<td align="right">#numberFormat(NetPayment,",.__")#</td>			
							</tr>
						</table>
					</td>			
					<td style="4px;padding-top:4px">
						<cf_img icon="print" onclick="print('#settlementid#','#settlementphase#',0)">			
					</td>	
							
					<cfif url.scope neq "portal" and documentcurrency neq "" and currency neq documentcurrency and calculationstatus eq "3">
						<td align="right">
							<table width="100%">
							<tr class="fixlengthlist">
							<td style="font-size:10px">#documentcurrency#</td>
							<td align="right">#numberFormat(NetPaymentDocument,",.__")#</td>			
							</tr>
							</table>
						</td>				
						<td style="padding-top:4px">
							<cf_img icon="print" onclick="print('#settlementid#','#settlementphase#',1)">
						</td>
					<cfelse>
						<td colspan="2"></td>	
					</cfif>
		
				</tr>	
				
				<cfset pdate = PaymentDate>
				
				<cfif month(paymentdate) gte "10">
					<cfset mt = month(paymentdate)>
				<cfelse>
				    <cfset mt = "0#month(paymentdate)#">
				</cfif>	
				
				<cfquery name="check" 
				datasource="AppsLedger" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">		
					SELECT    H.Journal
					FROM      TransactionHeader AS H 
					WHERE     H.Mission           = '#Mission#' 
					AND       H.ReferencePersonNo = '#URL.ID#' 
					AND       H.Reference         = '#year(paymentDate)#-#mt#'
				</cfquery>		
				
				<cfif check.recordcount gte "1">
				
				    <!--- posted records --->
											
					<cfquery name="ChargeBudget" 
					datasource="AppsLedger" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
						SELECT    L.Journal, 
						          L.Fund, 
								  L.ProgramCode, 
								  P.ProgramName, 
								  L.ProgramPeriod, 
								  L.ObjectCode, 
								  Pe.Reference,
								  O.Description, 
								  L.AmountBaseDebit
						FROM      TransactionLine AS L INNER JOIN
			    	              TransactionHeader AS H ON L.Journal = H.Journal AND L.JournalSerialNo = H.JournalSerialNo INNER JOIN
			        	          Program.dbo.Program AS P ON L.ProgramCode = P.ProgramCode LEFT OUTER JOIN
								  Program.dbo.ProgramPeriod AS Pe ON L.ProgramCode = Pe.ProgramCode and L.ProgramPeriod = Pe.Period INNER JOIN
			            	      Program.dbo.Ref_Object AS O ON L.ObjectCode = O.Code
						WHERE     H.Mission           = '#Mission#' 
						AND       H.ReferencePersonNo = '#URL.ID#' 
						AND       H.Reference         = '#year(paymentDate)#-#mt#'
					</cfquery>		
					
					<cfif ChargeBudget.recordcount gte "1">
					
						<cfloop query="ChargeBudget">
						
						<tr class="navigation_row_child">
						    <td></td>
						    <td colspan="9" style="padding:2px">
								<table border="1" bordercolor="silver" cellspacing="0" cellpadding="0">
								<tr bgcolor="D0E8E8">					
								<td style="padding:2px" width="300"><cfif Reference neq "">#Reference#<cfelse>#ProgramCode#</cfif> #ProgramName#</td>	
								<td style="padding:2px" width="70">#Fund#</td>
								<td style="padding:2px" width="300">#ObjectCode# #Description#</td>
								<td style="padding:2px" width="140" align="right">#numberformat(AmountBaseDebit,',.__')#</td>										
								</tr>
								</table>
							</td>					
							
						</tr>
						
						</cfloop>
					
					</cfif>
				
				</cfif>
								
				<tr class="hide" id="d#currentrow#">
				<td id="i#currentrow#" colspan="14" style="padding-bottom:3px"></td>
				</tr>		
					
			</cfoutput>	
				
		</cfoutput>
	
		
	<tr><td height="10"></td></tr>

</table>

<cfset ajaxonload("doHighlight")>
