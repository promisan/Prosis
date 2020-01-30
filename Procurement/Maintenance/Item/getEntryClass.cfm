
<cfquery name="Entry" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_EntryClass
		WHERE Code = '#url.code#'			
</cfquery>


<cfif entry.customdialog eq "Materials">

	 <script>
		  document.getElementById('material').className = "regular"
		  // document.getElementById('travel').className = "hide"
	 </script>

<cfelseif entry.customdialog eq "Travel">

	 <script>
	 	  document.getElementById('material').className = "hide"
		  // document.getElementById('travel').className = "regular"
	 </script>
	  
<cfelse>

	 <script>
		  document.getElementById('material').className = "hide"
		  // document.getElementById('travel').className = "hide"
	 </script>
 
</cfif>