<!--
    Copyright © 2025 Promisan

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
 
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

