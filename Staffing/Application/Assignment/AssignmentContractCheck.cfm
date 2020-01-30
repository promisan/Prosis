
<!--- -------------------------------- --->
<!--- assignment and contract check up --->
<!--- -------------------------------- --->

<cfparam name="attributes.mission"   default="">
<cfparam name="Attributes.mandateno" default="">
<cfparam name="Attributes.personno"  default="">

<cfif attributes.mandateno eq "">
	
	<cfquery name="current" 
	     datasource="AppsOrganization" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">
	     SELECT TOP 1 * 
		 FROM   Ref_Mandate
		 WHERE  Mission   = '#Attributes.Mission#'	 
		 ORDER BY MandateDefault DESC
	</cfquery>	

	<cfset mandateno = current.MandateNo>

<cfelse>

	<cfset mandateno = attributes.mandateno>

</cfif>

<cfquery name="MandateContractCheck" 
     datasource="AppsOrganization" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT * 
	 FROM   Ref_Mandate
	 WHERE  Mission   = '#Attributes.Mission#'
	 AND    MandateNo = '#MandateNo#' 
</cfquery>	

<cfquery name="AssignmentContractCheck" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
     SELECT * 
	 FROM   PersonAssignment PA, Position P
	 WHERE  PA.PositionNo = P.PositionNo
	 AND    P.Mission   = '#Attributes.Mission#'
	 AND    P.MandateNo = '#MandateNo#' 
	 AND    PA.Personno = '#attributes.Personno#'
	 AND    PA.AssignmentStatus IN ('0','1')
</cfquery>	

<!--- check if there are any valid contracts for this mandate --->

<cfquery name="ContractContractCheck" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		SELECT   *
		FROM     PersonContract C
		WHERE    Mission          = '#Attributes.Mission#'
		AND      PersonNo         = '#Attributes.personno#'
		AND      ActionStatus    != '9'
		AND      HistoricContract = 0
		AND      DateEffective   <= '#mandateContractCheck.DateExpiration#'
		AND      (DateExpiration is NULL OR DateExpiration >= '#MandateContractCheck.DateEffective#')
		AND      C.ActionCode IN (SELECT ActionCode 
		                          FROM  Ref_Action
								  WHERE ActionCode = C.ActionCode) <!--- rules out ETL --->
		ORDER BY DateEffective DESC
		
</cfquery>		

<cfif ContractContractCheck.recordcount gte "1">

	<CFSET Caller.ValidContract = "1">
	
	<cfif ContractContractCheck.dateExpiration eq "" or (ContractContractCheck.dateexpiration gt mandateContractCheck.DateExpiration)>	 
		<CFSET Caller.ValidContractExpiration = MandateContractCheck.DateExpiration>
	<cfelse>	
		<CFSET Caller.ValidContractExpiration = ContractContractCheck.DateExpiration>
	</cfif>	
	
	<cfif AssignmentContractCheck.recordcount eq "0">
		<CFSET Caller.ValidAssignment = "0">
	<cfelse>
		<CFSET Caller.ValidAssignment = "1">
	</cfif>

<cfelse>

	<CFSET Caller.ValidContractExpiration = "0">

	<CFSET Caller.ValidContract = "0">

</cfif>
 
	 

