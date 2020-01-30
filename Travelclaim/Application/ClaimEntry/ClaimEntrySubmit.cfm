<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html><head><title>Saving</title></head><body>
<!--- validation --->
<cfif ParameterExists(Form.Submit)> 
	<cfset validate = "1">
	<cfset status = "2">
<cfelse>
	<cfset status = "1">	
</cfif>
<!--- <cftransaction> --->

<cfinclude template="ClaimEntrySubmitData.cfm">
  		 
<!--- </cftransaction> --->

<!--- trigger workflow --->
<cfif ParameterExists(Form.Submit)>
    <cfinclude template="../Process/Calculation/Calculate.cfm">
	<cfset client.resubmit = "Yes"> <!--- triggers the next step to be completed --->
</cfif>	

<cfoutput>

	<cfif ParameterExists(Form.Save)> 
	
		<script language="JavaScript">
	       window.location= "ClaimEntry.cfm?ClaimId=#URL.ClaimId#&PersonNo=#Claim.PersonNo#&RequestId=#Claim.ClaimRequestId#";
	    </script>
	
	<cfelse>
		
		<script language="JavaScript">
		    window.location = "claimEntry.cfm?PersonNo=#Claim.PersonNo#&RequestId=#Claim.ClaimRequestId#&ClaimId=#URL.ClaimId#"
		</script>
	
	</cfif>

</cfoutput>

</body>
</html>
