
<cfparam name="url.action" default="init">

<cfoutput>

<cfif url.action eq "init">
	
	<script>
	
		effec = document.getElementById("DateEffective")    
		expir = document.getElementById("DateExpiration")	
		
		if (expir.value != '') {		    
			_cf_loadingtexthtml='';	 
			ptoken.navigate('MandateExpirationScript.cfm?action=apply&id=#URL.ID#&id1=#URL.ID1#&effective='+effec.value+'&expiration='+expir.value,'DateExpiration_trigger')
		}
		
	</script>

<cfelse>
	
	<cfquery name="Get" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM   Ref_Mandate
		WHERE  Mission   = '#URL.ID#'
		AND    MandateNo = '#URL.ID1#'		
	</cfquery>
	
	<cfset dateValue = "">
	<CF_DateConvert Value="#url.effective#">
	<cfset EFF = dateValue>
	
	<cfset dateValue = "">
	<CF_DateConvert Value="#url.expiration#">
	<cfset EXP = dateValue>

	<cfif IsDate(EXP)>
	
	<script>
	
	<cfif get.DateExpiration lt EXP>		
	  ColdFusion.navigate('setMandateEditPosition.cfm?show=1','positionexpirationadjust')	
	  ColdFusion.navigate('setMandateEditAssignment.cfm?show=1','assignmentexpirationadjust')
	<cfelse>	
	  ColdFusion.navigate('setMandateEditPosition.cfm?show=0','positionexpirationadjust')	
	  ColdFusion.navigate('setMandateEditAssignment.cfm?show=0','assignmentexpirationadjust')
	</cfif>
	</script>
	
	</cfif>
	
</cfif>

</cfoutput>