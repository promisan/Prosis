
<cfoutput>

<cfif Len(URL.ID1) gt 200>

    <script language="JavaScript">
	
	   {
		alert("You entered a memo that exceeded the allowed length of 200 characters.")
	   }
	
	</script>

<cfelse>
  
	<cfquery name="UpdatePosition1" 
	    datasource="AppsSelection" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	  	UPDATE ApplicantFunction
		SET   FunctionJustification  = '#URL.ID1#'
		WHERE ApplicantNo            = '#URL.ApplicantNo#'
		AND   FunctionId             = '#URL.FunctionId#'
		
	</cfquery>	
	
	Saved
	
	<!---
	
	<script language="JavaScript">
	
	{
	parent.document.getElementById("#url.frm#Min").click()
	
	}
	
	</script>
	
	--->

</cfif>
</cfoutput>
