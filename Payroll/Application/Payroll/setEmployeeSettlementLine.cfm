<!--- applies the reset of the amount to a prior month --->

<!--- update record --->

<cfparam name="url.action" default="reset">

<cftransaction>

	<cfquery name="get" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   EmployeeSettlementLine		
		WHERE  PaymentId = '#url.paymentid#'
	</cfquery>
	
	<cfswitch expression="#url.action#">
	
	<cfcase value="edit">
			
		<cfquery name="get" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT * 
			FROM   EmployeeSettlementLine		
			WHERE  PaymentId = '#url.paymentid#' 
		</cfquery>
		
		<cfset rat1 = abs(form.amount)/abs(get.paymentamount)>
		<cfset rat2 = 1 - rat1>
						
		<!--- create record --->
		
		<!--- check if the prior period exists as settlement --->
		
			<cftransaction>
			
			<cfquery name="getPrior" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT * 
					FROM   EmployeeSettlement
					WHERE  Mission        = '#get.Mission#'
					AND    SalarySchedule = '#get.SalarySchedule#'
				    AND    PersonNo       = '#get.PersonNo#'
				    AND    PaymentStatus  = '#form.PaymentStatus#'
				    AND    PaymentDate    = '#form.PaymentDate#'
			</cfquery>
			
			<cfif getPrior.recordcount eq "0">
			
				<!--- insert --->
				
				<cf_tl id="Amount">
				
				<cfif form.PaymentStatus eq "0">
					<cfset actionStatus = "1">
				<cfelse>
					<cfset actionStatus = "3">
				</cfif>
				
				<cfquery name="setHeader" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO EmployeeSettlement
						( PersonNo, 
						  SalarySchedule, 
						  SettlementSchedule,
						  Mission, 
						  PaymentDate, 
						  PaymentStatus, 			 
						  PaymentFinal, 
						  ActionStatus, 
						  OfficerUserId, 
						  OfficerLastName, 
						  OfficerFirstName)
					VALUES
						('#get.PersonNo#',
						 '#get.SalarySchedule#',
						 '#get.SalarySchedule#',
						 '#get.Mission#',
						 '#form.PaymentDate#',
						 '#form.PaymentStatus#',
						 '0',
						 '#actionStatus#',					 
						 '#session.acc#',
						 '#session.last#',
						 '#session.first#')
						 
				</cfquery>	
			
			</cfif>	
					
			<cfinvoke component 	= "Service.Process.System.Database"  
				   method           = "getTableFields" 
				   datasource	    = "AppsPayroll"	  
				   tableName        = "EmployeeSettlementLine"
				   ignoreFields		= "'PaymentId','PaymentDate','PaymentStatus'"
				   returnvariable   = "fields">	
				   
			<!--- set the start and enddate --->	
			
			<cfif rat1 lt 1>
			
				<cf_assignId>   
					   
				<cfquery name="applyratio" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">	   
					INSERT INTO  EmployeeSettlementLine (#fields#,PaymentId,PaymentDate,PaymentStatus)
		 			SELECT       #preservesinglequotes(fields)#,'#rowguid#','#form.PaymentDate#','#form.PaymentStatus#'
					FROM         EmployeeSettlementLine
					WHERE        PaymentId = '#url.paymentid#'	   
				</cfquery>	
				
				<!--- Pending define the exchange rate for documentamount and amountbase --->
				
				<cfquery name="applyratio1" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">		
					UPDATE     EmployeeSettlementLine
					SET        PaymentAmount    = round(PaymentAmount * #rat1#,2),
					           Amount           = round(Amount * #rat1#,2), 
							   DocumentAmount   = round(documentAmount * #rat1#,2), 
							   AmountBase       = round(AmountBase * #rat1#,2),
							   Memo             = '#form.memo#',
							   OfficerUserId    = '#session.acc#',
							   OfficerLastName  = '#session.last#',
							   OfficerFirstName = '#session.first#'							   
					WHERE      PaymentId        = '#rowguid#'
				</cfquery>
				
				<cfquery name="applyratio2" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					UPDATE     EmployeeSettlementLine
					SET        PaymentAmount    = round(PaymentAmount * #rat2#,2),
					           Amount           = round(Amount * #rat2#,2), 
							   DocumentAmount   = round(documentAmount * #rat2#,2), 
							   AmountBase       = round(AmountBase * #rat2#,2),
							   Memo             = '#form.memo#'
					WHERE      PaymentId        = '#url.paymentid#'				 
				</cfquery>
				
				<!--- log the action --->
			
				<cfquery name="setLine" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO EmployeeSettlementLineAction
					(PaymentId, ActionCode, ActionDate, ActionStatus, ActionMemo, OfficerUserId, OfficerLastName, OfficerFirstName)
					VALUES
						('#rowguid#',
						 'edit',
						 getDate(),
						 '1',
						 'Generated from #get.PaymentDate#',
						 '#session.acc#',
						 '#session.last#',
						 '#session.first#')
				</cfquery>
				
			<cfelseif rat1 eq 1>
			
				<!--- the line is fully moved --->
									
				<cfquery name="setLine" 
				datasource="AppsPayroll" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					UPDATE  EmployeeSettlementLine
					SET     PaymentDate   = '#form.PaymentDate#',	
					 		PaymentStatus = '#form.PaymentStatus#'		      
					WHERE   PaymentId   = '#url.paymentid#'
			    </cfquery>
		
				<!--- log the action --->
				
				<cfquery name="setLine" 
					datasource="AppsPayroll" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					INSERT INTO EmployeeSettlementLineAction
					(PaymentId, ActionCode, ActionDate, ActionStatus, ActionMemo, OfficerUserId, OfficerLastName, OfficerFirstName)
					VALUES
						('#url.paymentid#',
						 'reset',
						 getDate(),
						 '1',
						 'Reset from #get.PaymentDate#',
						 '#session.acc#',
						 '#session.last#',
						 '#session.first#')
				</cfquery>
				
			<cfelse>
			
				<script>
					alert("Operation not supported")
				</script>	
						
			</cfif>	
			
			<script>
				ProsisUI.closeWindow('editsettlement')
			</script>
			<cfoutput>			
			<a href="javascript:document.getElementById('show#url.box#').click();document.getElementById('show#url.box#').click()">please refresh view</a>
			</cfoutput>
			
			<!--- correction for exchange rate in Euros --->
			
			</cftransaction>
	
	</cfcase>
			
	<cfcase value="delete">
		
		<cfquery name="setLine" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE EmployeeSettlementLine			
			WHERE  PaymentId = '#url.paymentid#'
		</cfquery>
		
		deleted!
	
	</cfcase> 
	
	</cfswitch>	
	
	<!--- set value --->
	
	<cfquery name="getvalue" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT       *
		FROM         EmployeeSettlementLine E 
		WHERE        PaymentId = '#url.paymentid#'
		AND          PaymentDate = '#get.PaymentDate#'
	</cfquery> 	
	
	<cfif url.PrintGroup eq "Contributions">
		<cfset val = "#NumberFormat(getvalue.Amount,",.__")#">
	<cfelse>
		<cfset val = "#NumberFormat(getvalue.PaymentAmount,",.__")#">
	</cfif>
	
	<cfoutput>	
	<script>	
	document.getElementById('val#url.paymentid#').innerHTML = "#val#"
	</script>	
	</cfoutput>

</cftransaction>

