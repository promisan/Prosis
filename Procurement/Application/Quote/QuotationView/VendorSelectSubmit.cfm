
<!--- update only lines that have not turned into a PO yet --->

<cfquery name="Update" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	UPDATE RequisitionLineQuote
	SET    Award           = NULL,
	       AwardRemarks    = NULL,
	       Selected        = 0
	WHERE  JobNo = '#URL.ID1#'
	AND    RequisitionNo IN (SELECT RequisitionNo 
	                         FROM   RequisitionLine 
							 WHERE  ActionStatus IN ('2k','2q'))
</cfquery>

<cfquery name="Job" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT * 
	FROM   Job 
	WHERE  JobNo ='#URL.Id1#'
</cfquery>

<cfquery name="Parameter" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM Ref_ParameterMission
		WHERE Mission = '#Job.Mission#' 
</cfquery>

<cfquery name="Update" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	UPDATE RequisitionLineQuote
	SET    Award           = '#Parameter.AwardLowestBid#',
	       Selected        = 1
	WHERE  JobNo = '#URL.ID1#'
	  AND  OrgUnitVendor = '#URL.OrgUnit#'
</cfquery>

<cfoutput>

<cfinclude template="JobViewVendor.cfm">

<script>
   if (document.getElementById('fundingstatus')) {
	ptoken.navigate('JobFundingSufficient.cfm?id1=#url.id1#','fundingstatus')
	}
</script>

</cfoutput>
