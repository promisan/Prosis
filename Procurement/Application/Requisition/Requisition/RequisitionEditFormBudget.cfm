
<!--- budget definition 

steps

1. define if budget needs to be shown

Budget NO
2.0 i Clean possible entries
2.1 hide entry screen

Budget YES
3.0  determine if same edition, if not clean as well
3.1  show entry screen

--->

<cfquery name="Budget" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM    Ref_ParameterMissionEntryClass
	WHERE   Mission = '#url.mission#' 
	AND 	Period = '#url.period#' 
	AND     EntryClass IN
                     (SELECT   entryClass
                      FROM     ItemMaster
                       WHERE   Code = '#url.itemmaster#')
</cfquery>			
 			
<cfif Budget.EditionId eq "">

	<!--- no budget required --->
	
	<cfquery name="Budget" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM RequisitionLineBudget
		WHERE  RequisitionNo = '#URL.RequisitionNo#'
	</cfquery>
	
	<script>
	
		document.getElementById("budgetentry1").className = "hide"
		document.getElementById("budgetentry2").className = "hide"
	
	</script>
	
<cfelse>

	<cfquery name="Clean" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		DELETE FROM RequisitionLineBudget
		WHERE  RequisitionNo = '#URL.RequisitionNo#'
		AND    EditionId    <> '#Budget.EditionId#'
	</cfquery>
	
	<cfoutput>
		<input type="hidden" name="editionid" id="editionid" value="#Budget.EditionId#">
	</cfoutput>
	
	<script>
		document.getElementById("budgetentry1").className = "regular"
		document.getElementById("budgetentry2").className = "regular"
		budget()
	</script>
	
</cfif>
