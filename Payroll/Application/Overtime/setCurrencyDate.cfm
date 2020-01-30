
<!--- ------------------------------------------------------------- --->
<!--- run a script with ajax upon changing the effective date ----- ---> 
<!--- --------------------------contract edit form effective------- --->
<!--- ------------------------------------------------------------- --->

<cfset selectedDate = ParseDateTime("#url.thisdate#")>
<cfset newMask = dateFormat(selectedDate,'MM-YYYY')>

<cfoutput>
	
	<script language="JavaScript">
		
	effec = document.getElementById("OvertimePeriodEnd").value    
			
		if (effec != '') {
		   document.getElementById('OvertimeDate').value = effec;
		   //document.getElementById('overTimeDateMY').innerHTML = "#newMask#";
		}
		
	</script>

</cfoutput>
