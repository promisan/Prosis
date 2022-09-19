<!--- relevant acquisition and sale topics --->

<cfquery name="ItemUoM"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
		FROM     ItemUoM
		WHERE    ItemNo = '#URL.ID#'		
		AND      Operational = 1		
		ORDER BY UoM
</cfquery>	


<cfloop query="ItemUoM">

	<cf_applyTopic mode="Mission" row="#currentrow#" mis="#url.mission#" uom="#uom#">

</cfloop>

<cfinclude template="ItemUoM.cfm">		

<script>
	alert('saved')
</script>
