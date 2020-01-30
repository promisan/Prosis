
<!--- ------------------------------------------------------------- --->
<!--- run a script with ajax upon changing the effective date ----- ---> 
<!--- --------------------------contract edit form effective------- --->
<!--- ------------------------------------------------------------- --->

<cfoutput>

<script>

    Prosis.busy('yes')
	
	effec = document.getElementById("dateeffective")   
				
	if (effec.value != '') {
	    ColdFusion.navigate('#SESSION.root#/workorder/Application/workorder/servicedetails/billing/detailbillingformentry.cfm?workorderid=#url.workorderid#&workorderline=#url.workorderline#&date='+effec.value,'billingselect')					  								
	}
	
</script>

</cfoutput>
