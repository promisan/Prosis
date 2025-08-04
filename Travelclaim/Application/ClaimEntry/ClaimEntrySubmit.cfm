<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
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
