
<cfparam name="attributes.settlementId"    default="">
<cfparam name="attributes.SettlementPhase" default="">
<cfparam name="attributes.Serial"          default="">
<cfparam name="attributes.TransactionId"   default="">

<cfquery name="get" 
    datasource="AppsPayroll" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	SELECT   *
	FROM     EmployeeSettlement S 
	WHERE    SettlementId = '#attributes.settlementId#'	
</cfquery>

<cfif get.recordcount eq "1">
	
	<cfquery name="Settlement" 
	    datasource="AppsPayroll" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT   SettlementId,
		         Mission,
				 SalarySchedule,
				 PaymentDate,
				 S.PersonNo,
				 LastName, 
				 FirstName, 
				 eMailAddress
		FROM     EmployeeSettlement S INNER JOIN
	             Employee.dbo.Person P ON S.PersonNo = P.PersonNo
		WHERE    Mission        = '#get.Mission#'
		AND      SalarySchedule = '#get.SalarySchedule#'
		AND      PaymentDate    = '#get.PaymentDate#'	
		AND 	 S.PersonNo     = '#get.personno#'
		
		AND      NOT EXISTS (SELECT 'X'
							 FROM   EmployeeSettlementAction 
							 WHERE  Mission        = '#get.Mission#'
							 AND    SalarySchedule = '#get.SalarySchedule#'
							 AND    PaymentDate    = '#get.PaymentDate#'	
							 AND    PersonNo       = S.PersonNo
							 AND    ActionCode     = '#attributes.SettlementPhase#' 
							 )	
		ORDER BY PersonNo					 			
		
	</cfquery>
	
	<cfquery name="Schedule" 
	    datasource="AppsPayroll" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT   *
		FROM     SalarySchedule
		WHERE    SalarySchedule = '#get.SalarySchedule#'   	
	</cfquery>
	
	<cfquery name="MissionSchedule" 
	    datasource="AppsPayroll" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT   *
		FROM     SalaryScheduleMission
		WHERE    SalarySchedule = '#get.SalarySchedule#'   	
		AND      Mission        = '#get.Mission#'
	</cfquery>	
	
	<cfquery name="Param" 
	    datasource="AppsPayroll" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_ParameterMission
		WHERE    Mission        = '#get.Mission#'
	</cfquery>
	
	<cf_tl id="Email logged sent to" var="vEmailLoggedLabel">
	
	<cfset per = dateformat(get.PaymentDate,"YYYYMM")>
		
	<cfquery name="Header" 
	    datasource="AppsLedger" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			SELECT   *
			FROM     TransactionHeader
			WHERE    TransactionId = '#attributes.TransactionId#'  
	</cfquery>	
			
	<cfif Header.referenceNo neq "">	
		<cfset path = "#get.Mission#_#get.SalarySchedule#\#per#_#Header.referenceNo#">		
	<cfelse>	
		<cfset path = "#get.Mission#_#get.SalarySchedule#\#per#">	
	</cfif>	
	
	<cfoutput query="Settlement">
	
	<cfif attributes.serial eq "0">
	
		<cfset filename = "#SESSION.rootDocumentPath#\Payslip\#path#\#PersonNo#.pdf">
		
	<cfelse>
	
		<cfset filename = "#SESSION.rootDocumentPath#\Payslip\#path#\#PersonNo#_#attributes.serial#.pdf">
	
	</cfif>		
	
	<cfif isValid("email", "#eMailAddress#") or eMailAddress eq "">	
						
		<cfif MissionSchedule.DisableMailPayslip eq "0"> 
		 
			   <cfsavecontent variable="mailbody">

			   		<style>
						body {
							font-size: 130%;
							font-family:  -apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,Oxygen-Sans,Ubuntu,Cantarell,"Helvetica Neue",sans-serif;
						}
		            </style>
				   
				   <cfoutput>				   		   			  
				   
				   <table width="98%" align="center">
				   
					    <tr><td>#PersonNo# #FirstName# #LastName# (#eMailAddress#)</td></tr>		
					    <tr><td height="1" class="line"></td></tr>										
						<tr><td>#Schedule.description# <cfif settlementPhase neq "Final">(<cf_tl id="#settlementPhase#">)</cfif></td></tr>		
					    <tr><td height="1" class="line"></td></tr>		
					    <tr><td>#Schedule.PaySlipMailText#</td></tr>
					    <tr><td height="1" class="line"></td></tr>			
						   
						<tr>
						 <td align="center">
						 <font size="1" color="808080">
						 This message, including any attachments, contains confidential information intended for a specific individual and purpose, and is protected by law. If you are not the intended recipient, please contact the sender immediately by reply e-mail and destroy all copies. You are hereby notified that any disclosure, copying, or distribution of this message, or the taking of any action based on it, is strictly prohibited.
						 </font>
						 </td>
						</tr>
					
				   </table>				  
				   
				   </cfoutput>
				   
			 </cfsavecontent>
			 					 
			 <cf_tl id="Payslip" var="pay">
			 
			 <cfif Param.PayslipEMail neq "">
			   <cfset mailfrom  = Param.PayslipEMail>			   
			 <cfelse>
			   <cfset mailfrom =  client.eMail>			 
			 </cfif>
			 
			 <cfif Param.PayslipDestination neq "" or eMailAddress eq "">
			   <cfset address  = Param.PayslipDestination>			   
			 <cfelse>
			   <cfset address =  eMailAddress>			 
			 </cfif>			
													 				
			 <cfmail to    = "#Address#"	
		        from       = "#mailfrom#"
				FailTo     = "#client.eMail#" 
				replyto    = "#mailfrom#"
		        subject    = "#Schedule.description# #per# #FirstName# #LastName#"		       
		        type       = "HTML"
		        mailerID   = "#SESSION.welcome#"
		        spoolEnable= "Yes">					
				#mailbody#
						
				     <cfmailparam remove="no" file = "#filename#">
															
			</cfmail>	
							
			<!--- now we update the table to prevent that e payslip is going to be sent again ---> 
			
			<cfquery name="ConfirmMailAction" 
				    datasource="AppsPayroll" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">
					INSERT INTO EmployeeSettlementAction
								(PersonNo, 
								 SalarySchedule, 
								 Mission, 
								 PaymentDate, 
								 ActionCode, 
								 ActionDate, 
								 ActionContent, 
								 DocumentPath, 
								 OfficerUserId, 
								 OfficerLastName, 
								 OfficerFirstName)
					 VALUES	 ('#PersonNo#',
							  '#SalarySchedule#',
							  '#Mission#',
							  '#PaymentDate#',
							  '#Attributes.SettlementPhase#',
							  '#dateformat(now(),client.dateSQL)#',
							  '#mailbody#',
							  '#filename#',
							  '#session.acc#',
							  '#session.last#',
							  '#session.first#')						
			</cfquery>	
	
			<cfoutput>#vEmailLoggedLabel#: #eMailAddress#.</cfoutput>		
		
		</cfif>		
							
	<cfelse>
	
	<!--- failed email delivery --->	
	
	</cfif>			
	
	</cfoutput>
	
</cfif>

