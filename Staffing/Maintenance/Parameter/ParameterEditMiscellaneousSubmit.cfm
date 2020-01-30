
<cfquery name="Log" 
		 datasource="AppsEmployee" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 
			SELECT Max(LogSerialNo) as Last
			FROM   ParameterLog 		
		
</cfquery>
	
<cfif Log.Last eq "">
	  <cfset No = "1">
<cfelse>
	  <cfset No = #Log.Last#+1>
</cfif>

<cfinvoke component = "Service.Process.System.Database"  
	   method           = "getTableFields" 
	   datasource	    = "AppsEmployee"	  
	   tableName        = "Parameter"
	   ignoreFields		= "'LogSerialNo','LogStamp','OfficerUserId','OfficerLastName','OfficerFirstName'"
	   returnvariable   = "fields">	

<cftransaction>
	   
	<cfquery name="Log" 
			 datasource="AppsEmployee" 		 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 
				INSERT INTO ParameterLog ( 
					  LogSerialNo,
					  LogStamp,
					  OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName,
					  #fields# )
					  
				SELECT '#No#' AS LogSerialNo,
					    getDate() AS LogStamp,
						'#SESSION.acc#' AS OfficerUserId,
						'#SESSION.last#' AS OfficerLastName,
						'#SESSION.first#' AS OfficerFirstName,
						#fields#	
				FROM   Parameter
	</cfquery>
		   
	
	<cfquery name="Update" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Parameter
		SET    DependentEntitlement  = '#Form.DependentEntitlement#', 
	    	   ActionMode            = '#Form.ActionMode#',
			   PictureWidth          = '#Form.PictureWidth#',
			   PictureHeight         = '#Form.PictureHeight#',
			   AddressType           = '#Form.AddressType#',
			   IndexNoName           = '#Form.IndexnoName#',
			   <cfif form.Indexno eq "">
			   IndexNo               = NULL,
			   <cfelse>
			   IndexNo               = '#Form.IndexNo#', 
			   </cfif>
			   LeaveFieldsEnforce    = '#LeaveFieldsEnforce#',
			   EnablePersonGroup     = '#Form.EnablePersonGroup#',
			   GenerateApplicant     = '#Form.GenerateApplicant#'
	</cfquery>

</cftransaction>

<cfoutput>

<script>
	#ajaxLink('ParameterEditMiscellaneous.cfm')#	
</script>

</cfoutput>
