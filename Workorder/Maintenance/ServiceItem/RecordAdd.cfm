<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Service Item" 
			  option="Record Service Item" 
			  scroll="Yes" 
			  layout="webapp" 			  
			  menuAccess="Yes" 
			  jQuery = "Yes"
			  systemfunctionid="#url.idmenu#">

<cfoutput>
	<cf_ColorScript>

	<script>
	
		function validate() {
			document.editform.onsubmit() 
			if( _CF_error_messages.length == 0 ) {        
				ColdFusion.navigate('RecordSubmit.cfm?action=save','addItemDiv','','','POST','editform')
			 }   
		}	
	
	</script>

</cfoutput>

<cfdiv id="addItemDiv">
<cfinclude template="ServiceItemEdit.cfm">
</cfdiv>

