
<cfquery name="get" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	     SELECT *
	     FROM   Ref_AssignmentClass
	     WHERE AssignmentClass = '#url.assignmentclass#' 
</cfquery>	

<script>
 
    se = document.getElementsByName("Incumbency")
	cnt = 0
	while se[cnt] {
	 se[cnt].checked = false
	 cnt++
	}
	
</script>	

<cfif get.Incumbency eq "100">

  <script>
     se = document.getElementsByName("Incumbency")
	 se[0].checked = true
   </script>
   
<cfelseif get.Incumbency eq "50">

	<script>
     se = document.getElementsByName("Incumbency")
	 se[1].checked = true
   </script>

<cfelse>

	<script>
     se = document.getElementsByName("Incumbency")
	 se[2].checked = true
   </script>
   
</cfif>	