 
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



