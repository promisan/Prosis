

<cftry>
	<cfdirectory action="CREATE" directory="#SESSION.rootDocumentPath#\EmployeeFiles\#account#">
	<cfcatch></cfcatch>
</cftry>

<cftry>

	<cfif ParameterExists(Form.UploadedFile)>
		<!--- upload file with unique name --->			
		<cffile action="UPLOAD"
        	filefield="UploadedFile"
	        destination="#SESSION.rootDocumentPath#\EmployeeFiles\#account#\"
    	    nameconflict="OVERWRITE">
			
		<cfset filesuccess = "1">
	
	<cfelse>
		<script>
			alert('Please browse and select file');
		</script>
		<cfset filesuccess = "0">
	</cfif>

	

	<cfoutput>
		<cfif filesuccess eq "1">
		<script>	
			parent.document.getElementById('fileuploadsuccess').innerHTML = 'File has been successfully uploaded to your account'
		</script>
		</cfif>
	</cfoutput>

	
<cfcatch>

	<cfoutput>
	<script>
		alert("Nothing to associate to your account")
	</script>
	</cfoutput>
	
</cfcatch>	

</cftry>



