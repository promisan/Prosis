<cfparam name="url.scope" default="Backoffice">
<cfparam name="url.myCl" default="0">
<cfparam name="url.ovtMode" default="">

<cfif url.scope neq "Backoffice">
	 <cfset url.id = CLIENT.personno>
</cfif>

<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop height="100%" scroll="Yes" html="No" jQuery="Yes" actionobject="Person"
		actionobjectkeyvalue1="#url.id#">

<cf_actionListingScript>
<cf_FileLibraryScript>
<cf_dialogPosition>

<cfajaximport>
	
<cfoutput>
		
	<script language="JavaScript">
	
	function viewovertime(persno,mode) {
	    ptoken.location ("#session.root#/Payroll/Application/Overtime/EmployeeOvertime.cfm?ID=" + persno + "&ovtmode=" + mode);
	}
		
	function overtime(persno) {
	    ptoken.location ("#session.root#/Payroll/Application/Overtime/OvertimeEntry.cfm?ID=" + persno);
	}
	
	function overtimeedit(persno,overtimeid) {
	    ptoken.location ("#session.root#/Payroll/Application/Overtime/OvertimeEdit.cfm?ID=" + persno + " &id1=" + overtimeid);
	}
	
	function workflowdrill(key,box,mode) {
		
	    se = document.getElementById(box)
		ex = document.getElementById("exp"+key)
		co = document.getElementById("col"+key)
			
		if (se.className == "hide") {		
		   se.className = "regular" 		   
		   co.className = "regular"
		   ex.className = "hide"	
		   ptoken.navigate('#SESSION.root#/Payroll/Application/Overtime/OvertimeWorkflow.cfm?ajaxid='+key,key)		   		 
		} else {  se.className = "hide"
		          ex.className = "regular"
		   	      co.className = "hide" 
	    } 		
	}		
					
	function detail(box,mis,settleid) {
		
		 se = document.getElementById("d"+box)		 		 
		 if (se.className == "regular") {		 
		     se.className = "hide"						
		 } else {	
		 se.className = "regular"		 		
		 ptoken.navigate('#SESSION.root#/Payroll/Application/Payroll/SalarySlip.cfm?id=#url.id#&mission='+mis+'&settlementid='+settleid,'i'+box)    				     				
     	}		
	}
		
	</script>
		
</cfoutput>

<table height="100%" width="100%" align="center">

<tr><td style="height:10px">

<table cellpadding="0" cellspacing="0" width="100%" align="center">

	<tr><td height="10" style="padding-top:3px;padding-left:7px">	
		  <cfset ctr      = "0">		
	      <cfset openmode = "open"> 
		  <cfinclude template="../../../Staffing/Application/Employee/PersonViewHeaderToggle.cfm">		  
		 </td>
	</tr>	
	
</table>

</td></tr>

<!--- provision only --->

<cfquery name="SearchResult" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    UPDATE PersonOvertime 
	SET    Status = '5'
	WHERE  EXISTS (SELECT OvertimeId 
		 		   FROM  EmployeeSalaryLine 	  		  			
				   WHERE Referenceid = OvertimeId) 		
	AND    Status != '9'			   
</cfquery>

<!--- Query returning search results --->
<cfquery name="SearchResult" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

    SELECT   *,
	         Year(OvertimePeriodEnd) as OvertimeYear,
			 Month(OvertimePeriodEnd) as OvertimeMonth,
			
			(SELECT  TOP 1 ObjectKeyValue4 
			 FROM    Organization.dbo.OrganizationObject 
			 WHERE   (Objectid   = L.OvertimeId OR ObjectKeyValue4 = L.OvertimeId)
			 AND     EntityCode = 'EntOvertime' 
			 AND     Operational = 1) as Workflow,		
			 
		    (SELECT  TOP 1 OvertimeId 
			 FROM    EmployeeSalaryLine 	  		  			
			 WHERE   Referenceid = OvertimeId) as Payroll
					 
			 
    FROM     PersonOvertime L
	WHERE    L.PersonNo = '#URL.ID#' 
	AND      L.Status != '9'
	
	<cfif url.OvtMode eq "Pay">
	
	AND      (OvertimePayment = '1' or EXISTS (SELECT 'X'
	                                           FROM   PersonOvertimeDetail
											   WHERE  BillingPayment = '1'
											   AND    OvertimeId = L.OvertimeId ))
	
	<cfelseif url.ovtmode eq "Time">
	
	AND      (OvertimePayment = '0' or EXISTS (SELECT 'X'
	                                           FROM   PersonOvertimeDetail
											   WHERE  BillingPayment = '0'
											   AND    OvertimeId = L.OvertimeId ))											 
	
	</cfif>
	
	ORDER BY L.Mission,
	         L.OvertimePeriodEnd DESC, 
	         OvertimePeriodStart DESC
	
</cfquery>



<cfquery name="Check" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   MIN(DateEffective) as DateEffective, 
	         MAX(DateExpiration) as DateExpiration
    FROM     Employee.dbo.PersonContract L
	WHERE    L.PersonNo = '#URL.ID#' 
	AND      L.ActionStatus != '9'
</cfquery>	

<tr><td style="height:100%;padding:10px">
	
<cf_divscroll>
	
<table align="left" width="98%">

  <tr><td colspan="2"></td></tr>
  
  <tr>
  
    <td height="24" style="padding:15px 20px 20px">
	
	 <table><tr><td style="padding-left:10px">
		    <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/Logos/Payroll/Overtime.png" height="64" alt=""  border="0" align="absmiddle">
			</td>
			<td valign="middle" class="fixlength" style="font-size:28px">
	    	 <cf_tl id="Overtime" var="1">&nbsp;
			 <cfoutput><span style="font-size: 30px;text-transform: capitalize;font-weight: 200;padding:16px 0 25px;">#lt_text#</span></cfoutput></font></b>
			</td></tr>
 	 </table>
	 
	 	 
	</td>
	<cfoutput>
	    <td align="right" height="30" valign="bottom" style="padding-bottom:9px">
		
		<table>
		<tr class="labelmedium">
		<td style="padding-left:18px">
		 <cf_tl id="New Overtime Request" var="1">
			<input type="button" value="#lt_text#" class="button10g" style="min-width:240px;height:29px;font-size:15px" onClick="overtime('#URL.ID#','#URL.ID1#')">
		</td>
		<td style="padding-left:4px"><input type="radio" name="mode" value="All" onclick="viewovertime('#url.id#','')" <cfif url.ovtmode eq "">checked</cfif>></td>
		<td style="padding-left:4px"><cf_tl id="All"></td>
		<td style="padding-left:8px"><input type="radio" name="mode" value="Pay" onclick="viewovertime('#url.id#','pay')" <cfif url.ovtmode eq "pay">checked</cfif>></td>
		<td style="padding-left:4px"><cf_tl id="Pay"></td>
		<td style="padding-left:8px"><input type="radio" name="mode" value="Time" onclick="viewovertime('#url.id#','time')" <cfif url.ovtmode eq "time">checked</cfif>></td>
		<td style="padding-left:4px"><cf_tl id="Time"></td>
		
		</tr>
		</table>	
		
	    </td>
	</cfoutput>
  </tr>
          
  <tr>
  <td width="100%" colspan="2" style="padding-left:10px;padding-right:10px">
  
  <table width="100%" class="navigation_table">
  
  <cfquery name="Summary" 
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  SELECT    P.Mission,
		            YEAR(P.OvertimePeriodEnd) AS OvertimeYear, 				
					ESL.PayrollItem, 
					R.PayrollItemName, 
					ESL.Currency, 
					ROUND(SUM(ESL.AmountPayroll), 2) AS Amount
		  FROM      PersonOvertime AS P INNER JOIN
		            EmployeeSalaryLine AS ESL ON P.OvertimeId = ESL.ReferenceId INNER JOIN
		            Ref_PayrollItem AS R ON ESL.PayrollItem = R.PayrollItem
		  WHERE     P.PersonNo = '#url.id#' AND (P.Status = '5')
		  GROUP BY  P.Mission, YEAR(P.OvertimePeriodEnd), ESL.PayrollItem, R.PayrollItemName, ESL.Currency
		  ORDER BY  P.Mission, ESL.PayrollItem, R.PayrollItemName, ESL.Currency
	</cfquery>
	
	<TR class="line labelmedium fixrow fixlengthlist">
	    <td></td>
	    <td height="20" align="center"></td>
		<td></td>		
	    <td><cf_tl id="Period"></td>		
		<td><cf_tl id="Type"></td>	
		<TD><cf_tl id="Reference"></TD>		
		<TD align="right" style="padding-right:10px"><cf_tl id="Overtime"></TD>
		<TD align="right" style="padding-right:10px"><cf_tl id="Accrue"></TD>
		<TD align="center"><cf_tl id="Pay"></TD>
		<TD><cf_tl id="Status"></TD>
		<td><cf_tl id="To Settle"></td>
		<TD><cf_tl id="Amount Payable"></TD>
		<TD><cf_tl id="Officer"></TD>
	</TR>
	
	<cfif searchresult.recordcount eq "0">
	
	<tr><td colspan="13" align="center" class="labelmedium" style="padding-top:10px;font-size:16px"><cf_tl id="There are no records to show in this view"></td></tr>
	
	</cfif>
			
	<cfset last = '1'>
	
	<cf_tl id="Pending"	var="1">
	<cfset vPending=#lt_text#>
	
	<cf_tl id="Submitted"	var="1">
	<cfset vSubmitted=#lt_text#>
	
	<cf_tl id="Cleared"	var="1">
	<cfset vCleared=#lt_text#>
	
	<cf_tl id="Paid"	var="1">
	<cfset vPaid=#lt_text#>
	
	<cf_tl id="Cancelled"	var="1">
	<cfset vCancelled=#lt_text#>
	
	<cf_tl id="Yes"	var="1">
	<cfset vYes=#lt_text#>
	
	<cf_tl id="No"	var="1">
	<cfset vNo=#lt_text#>
	
	<cf_tl id="Payroll"	var="1">
	<cfset vPayroll=#lt_text#>
	
	<cf_tl id="No active contract"	var="1">
	<cfset vOvertime=#lt_text#>
	
	<cfset priorstart = "01/01/2000">
	
	<cfoutput query="SearchResult" group="Mission">
	
	<cfoutput group="OvertimeYear">
	
	<cfset row = 0>
		
	<tr class="line labelmedium"><td style="font-size:20px;padding-left:4px;font-weight:200" colspan="2">#Mission# #OvertimeYear#<td>
	
	<cfif url.ovtmode neq "Time">
	
		<td colspan="12">
		
		<cfquery name="year" dbtype="query">
			SELECT * FROM Summary
			WHERE OvertimeYear = #OvertimeYear#
		</cfquery>
		
		<table width="100%" class="formpadding formspacing">
		<tr class="labelmedium">
		<cfloop query="Year">
			<td style="padding-left:4px;border:1px solid silver">#PayrollItemName#</td>
			<td align="center" style="width:40px;border:1px solid silver">#currency#</td>
			<td align="right" style="background-color:eaeaea;border:1px solid silver">#numberformat(amount,',.__')#</td>
			<td style="width:20px"></td>
		</cfloop>
		</tr>
		</table>
			
		</td>	
	
	</cfif>
	
	</tr>
	
	<cfset prior = "">
	
	<cfoutput>
	
			<cfset row = row+1>
		
			<TR class="navigation_row labelmedium line fixlengthlist" style="height:21px;<cfif TransactionType eq 'correction'>background-color:ffffaf</cfif>">
			<td>
			<cfif prior neq overtimemonth>#MonthAsString(OverTimeMonth)#</cfif>
			</td>
			
			<cfif workflow neq "">
		 
				 <td align="center" style="cursor:pointer;padding-left:5px" 
					onclick="workflowdrill('#workflow#','box_#workflow#')" >
					
					<cf_wfActive entitycode="entOvertime" objectkeyvalue4="#overtimeid#">	
				 
				 	<cfif wfStatus eq "Open">
					
						  <img id="exp#Workflow#" class="hide" src="#SESSION.root#/Images/arrowright.gif" 
						 align="absmiddle" alt="Expand" height="9" width="7"> 	
										 
					   <img id="col#Workflow#" class="regular" src="#SESSION.root#/Images/arrowdown.gif" 
						 align="absmiddle" height="10" width="9" alt="Hide"> 
					
					<cfelse>
					
						   <img id="exp#Workflow#" class="regular" src="#SESSION.root#/Images/arrowright.gif" 
						 align="absmiddle" alt="Expand" height="9" width="7"> 	
										 
					   <img id="col#Workflow#" class="hide" src="#SESSION.root#/Images/arrowdown.gif" 
						 align="absmiddle" height="10" width="9" alt="Hide" border="0"> 
					
					</cfif>
					
					</td>
					
				<cfelse>
				
				<td align="center"></td>	
				  
				</cfif>	 
				
			<td align="center" style="padding-top:3px">
			<cfif status neq "5">
				<cfif status gte "1" and url.scope eq "portal">				
					<!--- we are no showing to edit --->					
				<cfelse>
				    <cf_img icon="edit" navigation="Yes" onclick="overtimeedit('#URL.ID#','#OvertimeId#')">			   
				</cfif>
			</cfif>	
			</td>									
			<td>#Dateformat(OvertimePeriodStart, CLIENT.DateFormatShow)# <cfif OvertimePeriodEnd neq OvertimePeriodStart>- #Dateformat(OvertimePeriodEnd, CLIENT.DateFormatShow)#</cfif></td>			
			<td>#TransactionType#</td>	
			<td>#DocumentReference#</td>						
			<TD align="right">
			<cfif transactiontype neq "Correction">
				#OvertimeHours#:<cfif OvertimeMinutes lt 10>0#OvertimeMinutes#<cfelse>#OvertimeMinutes#</cfif>
			<cfelse>
			
			<cfquery name="getOvertime" 
			       datasource="AppsEmployee" 		   
			       username="#SESSION.login#" 
			       password="#SESSION.dbpw#">				
					SELECT     SUM(OvertimeHours) as Hours
					FROM       Payroll.dbo.PersonOvertimeDetail
					WHERE      OvertimeId = '#overtimeid#'
					AND        BillingPayment = 1
			</cfquery>
			
			#getOvertime.Hours#:00
			
												
			</cfif>	
			</TD>			
			
			<td align="right" style="padding-right:10px">
			
			<cfif transactiontype neq "Correction">
			
					<cfquery name="getOvertime" 
			           datasource="AppsEmployee" 		   
			           username="#SESSION.login#" 
			           password="#SESSION.dbpw#">		
	
					   SELECT ISNULL(SUM(Hours*Multiplier),0)   as Hours, 
					          ISNULL(SUM(Minutes*Multiplier),0) as minutes
							  
					   FROM (				     
					  			  
							  	SELECT   SalaryTrigger,
								
								 		 ISNULL((SELECT C.SalaryMultiplier
										         FROM   Payroll.dbo.Ref_PayrollTrigger AS R INNER JOIN
						                                Payroll.dbo.Ref_PayrollComponent AS C ON R.SalaryTrigger = C.SalaryTrigger
										         WHERE  R.SalaryTrigger = OTD.SalaryTrigger),1) as Multiplier,
												 
								         SUM(OTD.OvertimeHours)   AS Hours, 
								         SUM(OTD.OvertimeMinutes) AS Minutes
										 
								FROM     Payroll.dbo.PersonOvertimeDetail AS OTD INNER JOIN
		                                 Payroll.dbo.PersonOvertime AS O ON OTD.PersonNo = O.PersonNo AND OTD.OvertimeId = O.OvertimeId					 							
								WHERE    O.PersonNo = '#url.id#' 
								AND      O.OvertimeId  = '#overtimeid#'								
								AND      O.Status IN ('0','1','2','3','5')		
								-- AND      O.OvertimePayment = 0		
								GROUP BY SalaryTrigger		
													
							) as Base
																						
					</cfquery>
																		
					<cfif getOvertime.Minutes gt "0">					
						<cfset ovt = getOvertime.Hours+(getOvertime.Minutes/60)>
					<cfelse>									
						<cfset ovt = getOvertime.Hours>
					</cfif>
								
					<cfset hr = int(ovt)>										
					<cfset mn = (ovt - hr)*60>
					<cfif mn eq 0>
					  <cfset mn = "00">
					</cfif>					
					#hr#:#mn#	
					
					<cfelse>
					
						<cfquery name="getOvertime" 
						   datasource="AppsEmployee" 		   
						   username="#SESSION.login#" 
						   password="#SESSION.dbpw#">				
								SELECT     SUM(OvertimeHours) as Hours
								FROM       Payroll.dbo.PersonOvertimeDetail
								WHERE      OvertimeId = '#overtimeid#'
								AND        BillingPayment = 0
						</cfquery>
			
					#getOvertime.Hours#:00
			
			</cfif>
							
			</td>
			
			<TD align="center">
			
				<cfquery name="Detail" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT DISTINCT BillingPayment
						FROM   PersonOvertimeDetail
						WHERE  OvertimeId = '#overtimeid#'					
					</cfquery>
			
			    <cfif OvertimePayment eq "1">
					<cf_tl id="Yes">	
					<cfset dosettle = "1">		
				<cfelseif detail.recordcount gte "2">
					<cf_tl id="Mixed">
					<cfset dosettle = "1">		
				<cfelseif detail.billingPayment eq "1">
					<cf_tl id="Yes">
					<cfset dosettle = "1">		
				<cfelseif detail.billingPayment eq "0">
					<cf_tl id="No">				
					<cfset dosettle = "0">	
				<cfelse>
					<cfset dosettle = "0">					
				</cfif>	
			
			</TD>
			<TD>		
			    
				<cfif payroll neq "">
				
				  #vPaid#
				
				<cfelse>
				
					<cfswitch expression="#Status#">
					 <cfcase value="0">#vPending#</cfcase>
					 <cfcase value="1">#vSubmitted#</cfcase>
					 <cfcase value="2">#vCleared#</cfcase>
					 <cfcase value="3">#vCleared#</cfcase>
					 <cfcase value="5">#vPaid#</cfcase>
					 <cfcase value="9">#vCancelled#</cfcase>
					</cfswitch>
				
				</cfif>	
				
			</TD>					
			
			<cfif dosettle eq "0">			
				
				<td></td>
			
			<cfelse>
			
				<td><a href="javascript:overtimeedit('#URL.ID#','#OvertimeId#')"> #Dateformat(OvertimeDate, 'YYYY/MM')#</a>			    								
				<cfif check.dateEffective gt overtimedate><br><font color="red">#vOvertime#!</cfif>	
				</td>	
				
			</cfif>	
			
			<cfif payroll eq "">
				
				<td></td>
			
			<cfelse>
				
				<td>
				
				<cfquery name="getPayroll" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					  SELECT   ES.SalarySchedule,
					  		   ES.Mission,
							   ES.PayrollEnd,
							   ESL.PaymentCurrency, 
							   SUM(ESL.PaymentAmount) as total
					  FROM     EmployeeSalary AS ES INNER JOIN
                      		   EmployeeSalaryLine AS ESL ON ES.SalarySchedule = ESL.SalarySchedule AND ES.PayrollStart = ESL.PayrollStart AND ES.PersonNo = ESL.PersonNo AND 
		                       ES.PayrollCalcNo = ESL.PayrollCalcNo
					  WHERE    ReferenceId = '#payroll#'	
					  GROUP BY ES.SalarySchedule,
					  		   ES.Mission,
							   ES.PayrollEnd,
							   ESL.PaymentCurrency				
					</cfquery>
			
		         <cfquery name="getSettlement" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					    SELECT TOP 1 *
					    FROM   EmployeeSettlement
						WHERE  PersonNo       = '#PersonNo#'
						AND    SalarySchedule = '#getPayroll.SalarySchedule#'
						AND    Mission        = '#getPayroll.Mission#'
						AND    PaymentDate    >= '#overtimedate#'	
						ORDER BY PaymentDate ASC						
					</cfquery>
					
					<table style="width:90%">
					<tr class="labelmedium" style="height:20px">
						<td style="min-width:20px;padding-top:4px">					
						<cfif getSettlement.recordcount eq "1">					
							<!--- drilldown to payroll --->																								
							<cf_img icon="expand" toggle="yes"
						     onClick="detail('#currentrow#','#getSettlement.Mission#','#getSettlement.SettlementId#')">						 
						</cfif>	 											
						</TD>				
						<cfloop query="getPayroll">		
						<TD align="right">#NumberFormat(total,",.__")#</TD>
						</cfloop>					
						
					</tr>
					</table>
			
			</td>
			
			</cfif>			
			
			<td><cfif OfficerLastName eq "">External<cfelse>#OfficerLastName#</cfif>&nbsp;#dateformat(created,client.dateformatshow)#</td>	
								
			</tr>
			
			<!---
			<cfif Remarks neq "">
				<TR bgcolor="#IIf(CurrentRow Mod 2, DE('FFFFFF'), DE('F6F6F6'))#">
				<td></td><td></td><td class="labelit" colspan="5">#Remarks#</b></td>
				</tr>
			</cfif>
			--->
													
			<tr class="hide" id="d#currentrow#">
			      
				  <td id="i#currentrow#" colspan="13" style="padding-left:10px"></td>
			</tr>			
		
			<cfif OvertimePeriodEnd gte priorStart and row gt "1" and transactiontype neq "Correction">				   
		    	<tr><td colspan="2"></td>
				    <td style="height:30px" colspan="12" class="labelmedium"><font color="FF0000">Attention</b>:&nbsp;There is an overlap in submitted overtime.</font></td>
				</tr>		   
		    </cfif>
		
		<cfset priorStart = OvertimePeriodStart>
				 
		<cfif workflow neq "">
		
			<input type="hidden" 
		       name="workflowlink_#workflow#" id="workflowlink_#workflow#" 		   
		       value="#session.root#/Payroll/Application/Overtime/OvertimeWorkflow.cfm">			   
		  
		   <!---
			<input type="hidden" 
			   name="workflowlinkprocess_#workflow#" id="workflowlinkprocess_#workflow#" 
			   onclick="ColdFusion.navigate('setOvertimeStatus.cfm?ajaxid=#workflow#','status_#workflow#')">		    
			   --->
			   
			<tr id="box_#workflow#">
			
				    <td colspan="13" id="#workflow#" style="padding-left:10px">
					
					<cfif wfstatus eq "open">
					
						<cfset url.ajaxid = workflow>					
						<cfinclude template="OvertimeWorkflow.cfm">
														
					</cfif>
				
				</td>
				<td></td>
			
			</tr>
		
		</cfif>
		
		<cfset prior = overtimemonth>
						
		</cfoutput>	
	
	</cfoutput>
	
	</cfoutput>
	
	</TABLE>
	
	</td>
	</tr>

</table>

</cf_divscroll>

</td></tr>

</table>

<cfset AjaxOnLoad("doHighlight")>	
