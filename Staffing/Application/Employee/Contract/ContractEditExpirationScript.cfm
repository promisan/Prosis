
<!--- ------------------------------------------------------------- --->
<!--- run a script with ajax upon changing the effective date ----- ---> 
<!--- --------------------------contract edit form effective------- --->
<!--- ------------------------------------------------------------- --->

<cfparam name="url.lastcontractid" default="">

<cfoutput>
	
	<script language="JavaScript">
		
		effec = document.getElementById("DateEffective")    
		expir = document.getElementById("DateExpiration")	

		if (expir.value != '') {		    
			_cf_loadingtexthtml='';	 
			ptoken.navigate('#SESSION.root#/staffing/Application/Employee/Contract/ContractEditExpirationAssignment.cfm?contractid=#url.contractid#&personNo=#url.personNo#&mission=#url.mission#&effective='+effec.value+'&expiration='+expir.value,'DateExpiration_trigger')
		}
				
	</script>

</cfoutput>
