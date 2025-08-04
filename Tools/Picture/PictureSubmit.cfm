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

<!----------------------------------------------------------------------------->
<cfif DirectoryExists("#SESSION.rootDocumentPath#\#url.path#\#url.dir#\")>	
        <!--- skip--->			
<cfelse>  	
	  
	    <cfdirectory 
		  action   = "CREATE" 
		  directory= "#SESSION.rootDocumentPath#\#url.path#\#url.dir#\">
		 				  
</cfif>	  
		
<cfif ParameterExists(Form.Upload)> 
	
	<cffile action="UPLOAD"
	        filefield="UploadedFile"
	        destination="#SESSION.rootDocumentPath#\#url.path#\#url.dir#\#URL.filter##url.dir#.jpg"
	        nameconflict="OVERWRITE">
			
</cfif>

<cfif ParameterExists(Form.Delete)> 

	<cffile action="DELETE" 
            file="#SESSION.rootDocumentPath#\#url.path#\#url.dir#\#URL.filter##url.dir#.jpg">

</cfif>

<cfset oSecurity = CreateObject("component","Service.Process.System.UserController")/>
<cfset mid = oSecurity.gethash()/>   

<cfoutput>  

	<script>		
	    _cf_loadingtexthtml='';	
		parent.ColdFusion.navigate('#session.root#/Tools/Picture/PictureView.cfm?mode=view&path=#url.path#&dir=#url.dir#&filter=#url.filter#&width=#url.width#&height=#url.height#&mid=#mid#','pictureshow');
		parent.ColdFusion.navigate('#SESSION.root#/Tools/Picture/PictureView.cfm?mode=edit&path=#url.path#&dir=#url.dir#&filter=#url.filter#&width=#url.width#&height=#url.height#&mid=#mid#','picturebox');
	</script>

</cfoutput>



