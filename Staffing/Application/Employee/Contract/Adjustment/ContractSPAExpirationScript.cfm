
<!--- ------------------------------------------------------------- --->
<!--- run a script with ajax upon changing the effective date ----- ---> 
<!--- --------------------------contract edit form effective------- --->
<!--- ------------------------------------------------------------- --->

<cfoutput>
<script>
	
	effec = document.getElementById("DateEffective")    
	expir = document.getElementById("DateExpiration")
	
	if (effec.value != '') {
	   ColdFusion.navigate('#SESSION.root#/staffing/Application/Employee/Contract/ContractEditFormIncrement.cfm?reset=1&eff='+effec.value,'increment')	
	}
	
</script>
</cfoutput>
