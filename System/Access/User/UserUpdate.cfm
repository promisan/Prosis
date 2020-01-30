
<cfoutput>

<cfquery name="UpdateUser" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
UPDATE   UserNames 
SET      IndexNo                = '#Form.IndexNo#',
		 LastName               = '#Form.LastName#',
		 FirstName              = '#Form.FirstName#',
		 eMailAddress           = '#Form.eMailAddress#',
		 eMailAddressExternal   = '#Form.eMailAddressExternal#',
         Remarks                = '#Form.Remarks#' 
WHERE Account = '#Form.Account#'
</cfquery>

<cflocation url="UserDetail.cfm?ID=#URLEncodedFormat(Form.Account)#" addtoken="No">		  

</cfoutput>	
