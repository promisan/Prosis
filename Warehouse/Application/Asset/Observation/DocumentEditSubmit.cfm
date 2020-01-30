
<cfparam name="Form.Workgroup" default="">

<cfif form.workgroup eq "">

	<script>
		alert("Workflow has not been completely configured. Workgroup is not configured.")
	</script>
	<CFABORT>

</cfif>

<cfset dateValue = "">
<CF_DateConvert Value="#DateFormat(Form.ObservationDate,CLIENT.DateFormatShow)#">
<cfset dte = dateValue>

<cfquery name="Update" 
	 datasource="AppsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 UPDATE AssetItemObservation
	 SET    ActionCategory        = '#Form.ActionCategory#', 
			Category              = '#url.category#' ,
			ObservationDate       = #dte#,
			Observation  		  = '#Form.Observation#',
	        ObservationPriority   = '#Form.ObservationPriority#',		   
		    ObservationOutline    = '#Form.ObservationOutline#'
	 WHERE  ObservationId = '#URL.Id#'	
</cfquery>	

<cfquery name="Update" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 UPDATE OrganizationObject
	 SET    EntityGroup       = '#Form.Workgroup#'
	 WHERE  ObjectKeyValue4   = '#URL.Id#'	
</cfquery>	


<cfoutput>

<script>
  		
	try {	
	parent.opener.applyfilter('','','#url.id#') } catch(e) {}
	parent.window.close()
	
</script>
	

</cfoutput>
