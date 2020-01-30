
<cfparam name="url.reload" default="1">

<cfinvoke component="Service.Access.AccessLog"  
		  method       = "SyncGroup"
		  UserGroup    = "#URL.Role#"
		  Mode         = "Enforce"
		  UserAccount  = ""
		  Role         = "">	 
		  
<!--- still needed don't think so --->
 
<cfif url.reload eq "1">

 	 <script language="JavaScript">
	     window.location = "RecordListing.cfm"
	  </script>
	  
<cfelse>	 

	<script>
	Prosis.busy('no') 
	</script>

	<font color="#6AB5FF">done! <cfoutput>#timeformat(now(),"HH:MM:SS")#</cfoutput></font>
	
</cfif>



