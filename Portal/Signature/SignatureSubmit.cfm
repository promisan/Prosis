 
<cfajaximport>

<cfparam name="SESSION.authent"   default="">	
<cf_screentop html="no" menuaccess="context" jquery="Yes">

<cfif SESSION.authent eq 1>
	
	<cftry>
		<cfdirectory action="CREATE" directory="#SESSION.rootDocumentPath#\User\Signature">
		<cfdirectory action="CREATE" directory="#SESSION.rootDocumentPath#\CFRStage\Signature">
		<cfcatch></cfcatch>
	</cftry>

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
		
		    <cftry>
			
				<cffile action="DELETE" 
		    	    file="#SESSION.rootDocumentPath#\User\Signature\#account#.png">
				
				<cfcatch></cfcatch>
				
			</cftry>
			
			 <cftry>
				
			<cffile action="DELETE" 
		        file="#SESSION.rootDocumentPath#\User\Signature\#account#.jpg">	
				
			<cfcatch></cfcatch>
				
			</cftry>	
		
		</cfif>
		
		<cfoutput>
		
			<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
			<cfset mid = oSecurity.gethash()/>  
			
			<script>	
				   
				parent.ptoken.navigate('SignatureView.cfm?account=#account#&mid=#mid#','signatureshow')
				
			</script>
			
		</cfoutput>
		
		
</cfif>

