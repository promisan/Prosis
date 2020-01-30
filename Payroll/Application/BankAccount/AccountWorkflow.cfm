<cfquery name="Person" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Person
			WHERE  PersonNo = '#Form.PersonNo#' 
		</cfquery>
		
		<cfquery name="getParam" 
            datasource="AppsEmployee" 	           
            username="#SESSION.login#" 
            password="#SESSION.dbpw#">
			SELECT * 
			FROM   Parameter
		</cfquery>		
		
		<cfset dateValue = "">
		<CF_DateConvert Value="#DateFormat('#now()-getParam.AssignmentLatency#',CLIENT.DateFormatShow)#">
		<cfset date = dateValue>	
		
		<cfquery name="OnBoard" 
		  datasource="AppsEmployee" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
			SELECT TOP 1 *
			FROM      PersonAssignment
			WHERE     PersonNo       = '#Form.PersonNo#' 
			AND       DateEffective  <= '#Dateformat(now(), CLIENT.DateSQL)#'
			AND       DateExpiration >= #date#
			AND       AssignmentStatus IN ('0','1') 
			ORDER BY  DateExpiration DESC
		</cfquery>
		
		<cfif OnBoard.recordcount eq "0">
		
			<cf_tl id="Problem, no active assignment found">
		
		<cfelse>
		
			<cfquery name="currentContract" 
			datasource="AppsEmployee" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT   TOP 1 L.*, 
			             R.Description as ContractDescription, 
				         A.Description as AppointmentDescription
			    FROM     PersonContract L, 
				         Ref_ContractType R,
					     Ref_AppointmentStatus A
				WHERE    L.PersonNo   = '#form.personno#'
				AND      L.ContractType = R.ContractType
				AND      L.AppointmentStatus = A.Code
				AND      L.ActionStatus != '9'
				ORDER BY L.DateEffective DESC 
		 	</cfquery>	
			
			<cfset link = "Payroll/Application/BankAccount/AccountEdit.cfm?id=#form.personno#&id1=#rowguid#">
		
			<cf_ActionListing 
			    EntityCode       = "PayBank"
				EntityClass      = "Standard"
				EntityGroup      = ""
				EntityStatus     = ""
				Mission			 = "#currentContract.Mission#"		
				OrgUnit          = "#OnBoard.OrgUnit#" 
				PersonNo         = "#Person.PersonNo#"
				ObjectReference  = "#Form.AccountName# #Form.AccountNo#"
				ObjectReference2 = "#Person.FirstName# #Person.LastName#" 
			    ObjectKey1       = "#form.personno#"
				ObjectKey4       = "#rowguid#"
				ObjectURL        = "#link#"
				Show             = "No"
				CompleteFirst    = "Yes">
			
		 </cfif>	  