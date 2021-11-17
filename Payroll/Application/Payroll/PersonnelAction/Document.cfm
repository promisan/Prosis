<!--- present the option to define: in-cycle, off-cycle or deny final payment --->

<cfparam name="url.wParam"				default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.stage"				default="show">
<cfparam name="Object.ObjectKeyValue4"  default="00000000-0000-0000-0000-000000000000">
<cfparam name="Object.ObjectId"  default="00000000-0000-0000-0000-000000000000">

<cfif url.stage eq "show">

	<cfquery name="Object" 
    datasource="appsOrganization"  
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   TOP 1 *
		FROM     Organization.dbo.OrganizationObject
		WHERE    ObjectKeyValue4 = '#Object.ObjectKeyValue4#'
	</cfquery>

	<cfquery name="getContract" 
    datasource="appsOrganization"  
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
			SELECT *
			FROM Employee.dbo.PersonContract
			WHERE ContractId = '#Object.ObjectKeyValue4#'
	</cfquery>

	<cfquery name="getAction" 
    datasource="appsOrganization"  
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
			SELECT TOP 1 *
			FROM Employee.dbo.EmployeeAction
			WHERE 1=1
			AND ActionSourceID  = '#getContract.ContractId#'
			ORDER BY ActionDate DESC 
	</cfquery>

	<cfquery name="getSeparation" 
    datasource="appsOrganization"  
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
			SELECT *
			FROM  Employee.dbo.EmployeeActionSource 
			WHERE 1=1
			AND 	ActionDocumentNo ='#getAction.ActionDocumentNo#'
 			AND 	ActionStatus = '9'
	</cfquery>

	<cfif getSeparation.recordCount eq 0>
			<cfset thisSeparation= "00000000-0000-0000-0000-000000000000">
		<cfelse>
			<cfset thisSeparation=getSeparation.ActionSourceID>
	</cfif>

	
	<cfquery name="getSeparationLine" 
    datasource="appsOrganization"  
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
			SELECT *
			FROM Employee.dbo.PersonContract
			WHERE ContractId = '#thisSeparation#' 
	</cfquery>
	
	<cfif getSeparationLine.recordCount eq 1>
		<cfset thisPersonNo = getSeparationLine.PersonNo>
		<cfset thisSalarySch= getSeparationLine.SalarySchedule>
		<cfset thisMission  = getSeparationLine.Mission>
		<cfelse>
			<cfset thisPersonNo = getSeparationLine.PersonNo>
			<cfset thisSalarySch= getSeparationLine.SalarySchedule>
			<cfset thisMission  = getSeparationLine.Mission>
	</cfif>

	<!--- with the separation date, we get the FinalPay settlement --->
	<cfquery name="getSettlementFP" 
    datasource="appsOrganization"  
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
			SELECT TOP 1*
			FROM   Payroll.dbo.EmployeeSettlement
			WHERE  1=1
			AND    PaymentFinal  = '1'
			AND    ActionStatus  = '1'
			AND    PersonNo 		= '#thisPersonNo#'
			AND    SalarySchedule= '#thisSalarySch#'
			AND    Mission 		= '#thisMission#'
			ORDER BY PaymentDate DESC  
	</cfquery>

	<cfif getSettlementFP.recordCount gte 1>
		<cfquery name="currentMisc" 
	    datasource="appsOrganization"  
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT REPLACE(P.CostID,'-','_') cost_, P.*, Pit.PayrollItemName
			FROM   Payroll.dbo.PersonMiscellaneous as P
				   INNER JOIN Payroll.dbo.Ref_PayrollItem as Pit ON P.PayrollItem =  Pit.PayrollItem
			WHERE  P.Source = 'final'
			AND    P.SourceId = '#getSettlementFP.SettlementID#'
		</cfquery>

		
		<cfform name="definecycle" >
			<input name="doPost"     type="hidden" value="yes">
			<table align="center" width="98%">
				<cfset thisClass = "labelmedium">
				<tr><td height="20px" colspan="2"></td></tr>
				<tr><td height="20"></td></tr>
				<cfif currentMisc.recordCount gte 1>
					<tr><td colspan="2">
					<table width="90%">
						<tr class="fixlengthlist labelmedium">
							<td>Document Date</td>
							<td>PayrollItem</td>
							<td>Type</td>
							<td>Amount</td>
							<td>Keep</td>
						</tr>
						<cfloop query="currentMisc">
							<cfoutput>
								<tr  class="fixlengthlist labelmedium">
									<td>#CurrentMisc.DocumentDate#</td>
									<td>#CurrentMisc.PayrollItemName#</td>
									<td>#CurrentMisc.EntitlementClass#</td>
									<td>#CurrentMisc.Amount#</td>
									<td><input type="checkbox" name="SelectedPM_#CurrentMisc.cost_#" id="SelectedPM_#CurrentMisc.cost_#" value="1" checked> </td>
								</tr>
							</cfoutput>
						</cfloop>
					</table>
					</td></tr>
				</cfif>
			</table>

		</cfform>
		<cfoutput> 
	  		<input name="savecustom" type="hidden"  value="Custom/stl/payroll/dataExport/FinalPayment/reinstatement/DocumentSubmit.cfm">
	  		<input name="Key4"       type="hidden" value="#getSettlementFP.SettlementID#">
	  		<input name="ObjectID"   type="hidden" value="#Object.ObjectID#">
	  		<input name="Object.ObjectKeyValue4"       type="hidden" value="#getSettlementFP.SettlementID#">
	  		<input name="thisSettlement"       type="hidden" value="#getSettlementFP.SettlementID#">
	  		<input name="wParam"     type="hidden" value="#url.wParam#">
		</cfoutput>
		<cfelse>
			<cfoutput> 
		  		<input name="savecustom" type="hidden"  value="Custom/stl/payroll/dataExport/FinalPayment/reinstatement/DocumentSubmit.cfm">
		  		<input name="Key4"       type="hidden" value="00000000-0000-0000-0000-000000000000">
		  		<input name="ObjectID"   type="hidden" value="00000000-0000-0000-0000-000000000000">
		  		<input name="thisSettlement"       type="hidden" value="00000000-0000-0000-0000-000000000000">
		  		<input name="Object.ObjectKeyValue4"       type="hidden" value="00000000-0000-0000-0000-000000000000">
		  		<input name="wParam"     type="hidden" value="#url.wParam#">
			</cfoutput>
	</cfif>

	<cfelse>
		<cfoutput> 
		  <input name="savecustom" type="hidden"  value="Custom/stl/payroll/dataExport/FinalPayment/reinstatement/DocumentSubmit.cfm">
		  <input name="Key4"       type="hidden" value="00000000-0000-0000-0000-000000000000">
		  <input name="ObjectID"   type="hidden" value="00000000-0000-0000-0000-000000000000">
		  <input name="thisSettlement"       type="hidden" value="00000000-0000-0000-0000-000000000000">
		  <input name="Object.ObjectKeyValue4"       type="hidden" value="00000000-0000-0000-0000-000000000000">
		  <input name="wParam"     type="hidden" value="#url.wParam#">
		</cfoutput>
</cfif>