
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
	
	
<cfquery name="Get" 
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   PersonContract
	WHERE  PersonNo = '#url.personNo#'
	AND    ActionStatus != '9'
	ORDER BY DateEffective DESC
</cfquery>


<cfif get.dateExpiration lt selecteddate>

	<cf_tl id="Attention">:<cf_tl id="There is no valid contract for this person">
	

</cfif>


</cfoutput>
