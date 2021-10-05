 
<cfajaximport>

<cfparam name="SESSION.authent"   default="">	

<cf_screentop html="no" menuaccess="context" jquery="Yes">

<cfif SESSION.authent eq 1>
	
	<cftry>
		<cfdirectory action="CREATE" directory="#SESSION.rootDocumentPath#\User\Signature">
		<cfdirectory action="CREATE" directory="#SESSION.rootDocumentPath#\CFRStage\Signature">
		<cfcatch></cfcatch>
	</cftry>

	<cftry>
		 
		<cfif ParameterExists(Form.load)> 
		
				<!--- upload file with unique name --->
				<cffile action="UPLOAD"
		        	filefield="UploadedFile"
			        destination="#SESSION.rootDocumentPath#\User\Signature\#account#.png"
		    	    nameconflict="OVERWRITE">
	
				<cfif not IsImageFile("#SESSION.rootDocumentPath#\User\Signature\#account#.png")>
					<cffile action="DELETE" file="#SESSION.rootDocumentPath#\User\Signature\#account#.png">
					<script>
						alert('Image file not accepted');
					</script>
					<cfabort>
				</cfif>
			
		</cfif>
		
		<cfif ParameterExists(Form.Delete)> 
		
			<cffile action="DELETE" 
		        file="#SESSION.rootDocumentPath#\User\Signature\#account#.png">
		
		</cfif>
		
		<cfoutput>
		
			<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
			<cfset mid = oSecurity.gethash()/>  
			
			<script>	
				   
				parent.ColdFusion.navigate('SignatureView.cfm?account=#account#&mid=#mid#','signatureshow')
				
			</script>
			
		</cfoutput>
		
	<cfcatch>
		
		<script>
			alert("Nothing to associate to your account")
		</script>
				
	</cfcatch>	
	
	</cftry>

</cfif>



