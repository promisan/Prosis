
<cfoutput>
<script language="JavaScript">
 dte = document.getElementById('dateexpiration').value
 ColdFusion.navigate('AssignmentEditExpiration.cfm?validcontract=#url.validcontract#&dateexpiration='+dte+'&assignmentNo=#url.assignmentNo#','reason')			
</script>
</cfoutput>