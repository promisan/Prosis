
<cfif ParameterExists(Form.Update)>
  
	
	<cfquery name="Update" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Ref_Attachment
		SET 
			<cfif Form.SystemModule neq ''>
				SystemModule = '#Form.SystemModule#',
			<cfelse>
				SystemModule = NULL,
			</cfif>
			DocumentFileServerRoot = '#Form.DocumentFileServerRoot#',
			DocumentServer         = '#Form.DocumentServer#',
			DocumentServerLogin    = '#Form.DocumentServerLogin#',
			DocumentServerPassword = '#Form.DocumentServerPassword#',
			AttachMultiple         = '#Form.AttachMultiple#',
			AttachExtensionFilter  = '#Form.AttachExtensionFilter#',
			AttachLogging          = '#Form.AttachLogging#',
			Memo                   = '#Form.Memo#',
			AttachmodeOpen         = '#Form.AttachModeOpen#',
			AttachMultipleSize     = '#Form.AttachMultipleSize#',
			AttachMultipleFiles    = '#Form.AttachMultipleFiles#'
		WHERE DocumentPathName     = '#Form.DocumentPathName#'
	</cfquery>

</cfif>
	
<script language="JavaScript">
   
     window.close()
	 opener.location.reload()
        
</script>  