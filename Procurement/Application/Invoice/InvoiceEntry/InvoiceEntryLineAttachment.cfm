<cfparam name="access"                default="">
<cfparam name="Invoice.ActionStatus"  default="">

<cfquery name="Parameter" 
 datasource="AppsPurchase" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ParameterMission
	WHERE  Mission = '#URL.Mission#' 
</cfquery>

<cfif  (access eq "edit") and (Access eq "Edit" or Invoice.ActionStatus eq "0" or Invoice.ActionStatus eq "9" or Access eq "ALL") >
	
	<cf_filelibraryN
			DocumentPath="#Parameter.InvoiceLibrary#"
			SubDirectory="#URL.lineid#" 
			Box="#URL.lineid#"
			Filter=""
			LoadScript="no"
			Insert="yes"
			Remove="yes"
			reload="true">	
			
<cfelse>

	<cf_filelibraryN
		DocumentPath="#Parameter.InvoiceLibrary#"
		SubDirectory="#URL.lineid#" 
		Box="#URL.lineid#"
		Filter=""
		LoadScript="no"
		Insert="no"
		Remove="no"
		reload="true">	

</cfif>	
