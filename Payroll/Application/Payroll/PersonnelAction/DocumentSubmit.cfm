<!--- define the action based on the selection for in/off cycle or deny --->
<cfparam name="Form.defcycle"  default="0">
<cfparam name="Form.doPost"  default="no">

<cfif Form.doPost eq "yes">

	<cfquery name="currentMisc" 
    datasource="appsOrganization"  
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
			SELECT  REPLACE(P.CostID,'-','_') cost_,P.*, Pit.PayrollItemName
			FROM Payroll.dbo.PersonMiscellaneous as P
			INNER JOIN Payroll.dbo.Ref_PayrollItem as Pit
			ON P.PayrollItem =  Pit.PayrollItem
			WHERE P.Source = 'final'
			AND  P.SourceId = '#Form.thisSettlement#' 
	</cfquery>

	<cfloop query="currentMisc">
		<cfset currentCost = currentMisc.CostID>
		<cfparam name="Form.SelectedPM_#CurrentMisc.cost_#" default="">
		<cfset selected = Evaluate("Form.SelectedPM_#CurrentMisc.cost_#")>

		<cfif selected neq "1">
			<cfquery name="update" 
		    datasource="appsOrganization"  
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">

					INSERT INTO Payroll.dbo.PersonMiscellaneous(
								PersonNo,Mission,DateEffective, DateExpiration, DocumentDate,PayrollItem, EntitlementClass, 
								Quantity, Currency, Rate, Amount, Status, Source, SourceId, OfficerUserId, OfficerLastName,OfficerFirstName
							)
					SELECT 		PersonNo,Mission,DateEffective, DateExpiration, DocumentDate,PayrollItem, EntitlementClass, 
								Quantity, Currency, Rate*-1 as Rate, Amount*-1 as Amount, '2' Status, 'Manual' as Source, costId as SourceId, OfficerUserId, OfficerLastName,OfficerFirstName
					FROM 		Payroll.dbo.PersonMiscellaneous
					WHERE CostId = '#currentCost#' 
					AND NOT EXISTS (SELECT 'X' FROM Payroll.dbo.PersonMiscellaneous WHERE SourceId = '#currentCost#')  
					/*
					DELETE
					FROM Payroll.dbo.PersonMiscellaneous 
					WHERE CostID = '#currentCost#'
					*/
			</cfquery>

			<cfelse>

				<cfquery name="update" 
			    datasource="appsOrganization"  
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
						UPDATE PM
						SET PM.DocumentReference ='FP kept'
						FROM Payroll.dbo.PersonMiscellaneous as PM
						WHERE PM.CostID = '#currentCost#'
				</cfquery>
		</cfif>
	</cfloop>
</cfif>
<!---
<cfoutput>

	<script language="JavaScript">
		ptoken.navigate('#session.root#/Custom/stl/payroll/dataExport/FinalPayment/reinstatement/Document.cfm?settlementid=#form.Key4#&wParam=#form.wParam#&stage=submit','dialog')
	</script>
	
</cfoutput>

--->