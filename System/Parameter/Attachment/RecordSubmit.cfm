<!--
    Copyright © 2025 Promisan B.V.

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