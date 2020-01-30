
<cfquery name="set"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE SalaryScale
		SET    Operational = '#url.operational#'
		WHERE  ScaleNo = '#url.scaleNo#'			
</cfquery>

<cfquery name="get"
	datasource="AppsPayroll" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM SalaryScale
		WHERE ScaleNo = '#url.scaleNo#'		  
</cfquery>
	
<cfif get.operational eq "1">
	 <cf_tl id="Active">
<cfelse>
	 <cf_tl id="Disabled">
</cfif>

<cfoutput>

<script language="JavaScript">
	parent.ptoken.navigate('RateViewTree.cfm?idmenu=#url.idmenu#&location=#get.servicelocation#&schedule=#get.salaryschedule#&mission=#get.mission#&operational=#url.operational#','treeview')
	document.getElementById('header').style.background = <cfif get.operational eq '1'>'eaeaea'<cfelse>'FF8080'</cfif>
	$('##operational',window.parent.document).val('#url.operational#');
</script>

</cfoutput>


