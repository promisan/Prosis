<!--- applies the reset of the amount to a prior month --->

<!--- update record --->

<cfparam name="url.action" default="associate">

<cftransaction>

	<cfquery name="get" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT * 
		FROM   EmployeeSettlement		
		WHERE  SettlementId = '#url.id#'
	</cfquery>
	
	<cfif url.action eq "associate">
	
		<!--- check if the prior period exists as settlement --->
		
		<cfquery name="getAssociated" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE EmployeeSettlement
			SET    SettlementSchedule = '#url.value#'
			WHERE  Mission        = '#get.Mission#'
			AND    SalarySchedule = '#get.SalarySchedule#'
		    AND    PersonNo       = '#get.PersonNo#'
		    AND    PaymentStatus  = '#get.PaymentStatus#'
		    AND    PaymentDate    = '#get.PaymentDate#'
		</cfquery>
		
		<cfquery name="getAssociatedDistribution" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		
			UPDATE  EmployeeSettlementDistribution
					SET SalaryScheduleDistribution = ES.SettlementSchedule
			FROM    EmployeeSettlementDistribution AS ESD INNER JOIN
	                EmployeeSettlement AS ES ON ESD.PersonNo = ES.PersonNo AND ESD.SalarySchedule = ES.SalarySchedule AND ESD.Mission = ES.Mission AND 
	                ESD.PaymentDate = ES.PaymentDate AND ESD.PaymentStatus = ES.PaymentStatus 
	        WHERE   ES.SettlementId = '#url.id#'
		
		</cfquery>
				
		<cfquery name="clean" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM EmployeeSettlementAction			
			WHERE  Mission        = '#get.Mission#'
			AND    SalarySchedule = '#get.SalarySchedule#'
		    AND    PersonNo       = '#get.PersonNo#'
		    AND    PaymentStatus  = '#get.PaymentStatus#'
		    AND    PaymentDate    = '#get.PaymentDate#'
			AND    ActionCode     = '#url.action#'
		</cfquery>
								
		<!--- log the action --->
		
		<cfquery name="setAction" 
			datasource="AppsPayroll" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO EmployeeSettlementAction
				(Mission,
				 SalarySchedule,
				 PersonNo,
				 PaymentStatus,
				 PaymentDate,
				 ActionCode, 
				 ActionDate, 
				 ActionContent, 
				 OfficerUserId, 
				 OfficerLastName, 
				 OfficerFirstName)			 
			VALUES
				('#get.Mission#',
				 '#get.SalarySchedule#',
				 '#get.PersonNo#',
				 '#get.PaymentStatus#',
				 '#get.PaymentDate#',
				 '#url.action#',
				 getDate(),
				 '#url.value#',
				 '#session.acc#',
				 '#session.last#',
				 '#session.first#')
		</cfquery>
	
	</cfif>

</cftransaction>

