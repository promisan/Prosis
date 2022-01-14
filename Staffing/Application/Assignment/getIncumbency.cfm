
<cfquery name="get" 
    datasource="AppsEmployee" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
	     SELECT *
	     FROM   Ref_AssignmentClass
	     WHERE AssignmentClass = '#url.assignmentclass#' 
</cfquery>	

<cfif get.Incumbency eq "100">

  <script>
  	try{
     se = document.getElementsByName("incumbency")
	 se[0].checked = true
	}
	catch(e)
	{
	} 
   </script>
   
<cfelseif get.Incumbency eq "50">

	<script>
  	try{

     se = document.getElementsByName("incumbency")
	 se[1].checked = true
	}
	catch(e)
	{
		
	} 
	 
   </script>

<cfelse>

	<script>
		try {
			se = document.getElementsByName("incumbency")
			se[2].checked = true
		}
		catch(e)
		{
			
		}
   </script>
   
</cfif>	