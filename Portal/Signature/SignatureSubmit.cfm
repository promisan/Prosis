 
<cfajaximport>

<cf_screentop html="no" menuaccess="context">

<cftry>
	<cfdirectory action="CREATE" directory="#SESSION.rootDocumentPath#\User\Signature">
	<cfcatch></cfcatch>
</cftry>

<cftry>
	 
	<cfif ParameterExists(Form.load)> 
	
			<!--- upload file with unique name --->
			<cffile action="UPLOAD"
	        	filefield="UploadedFile"
		        destination="#SESSION.rootDocumentPath#\User\Signature\#account#.jpg"
	    	    nameconflict="OVERWRITE">
		
	</cfif>
	
	<cfif ParameterExists(Form.Delete)> 
	
		<cffile action="DELETE" 
	        file="#SESSION.rootDocumentPath#\User\Signature\#account#.jpg">
	
	</cfif>
	
	<cfoutput>
		
		<script>		
			parent.ColdFusion.navigate('SignatureView.cfm?account=#url.account#','signatureshow')
		</script>
		
	</cfoutput>
	
<cfcatch>
	
		<script>
			alert("Nothing to associate to your account")
		</script>
			
</cfcatch>	

</cftry>



