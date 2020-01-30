
<cfparam name="Form.Workgroup" default="">

<cfif Form.Workgroup eq "">

	<script>
		alert("Workflow has not been completely configured. Workgroup is not configured.")
	</script>
	<CFABORT>

</cfif>

<cfquery name="get" 
	datasource="AppsControl" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *
		FROM    Observation
		WHERE   ObservationId = '#URL.id#'
</cfquery>

<cfquery name="Update" 
	 datasource="AppsControl" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 UPDATE Observation
	 SET   <cfif get.ObservationClass eq "Inquiry">
   	       ApplicationServer     = '#Form.ApplicationServer#',
		   <cfelse>
		   Owner				 = '#Form.Owner#',
	       </cfif>
   	 	   SystemModule          = '#Form.SystemModule#', 
		   Requester             = '#Form.Requester#',
		   RequestName           = '#Form.RequestName#', 
	       RequestPriority       = '#Form.RequestPriority#',
		   ObservationFrequency  = '#Form.ObservationFrequency#',
		   ObservationImpact     = '#Form.ObservationImpact#',
		   ObservationOutline    = '#Form.ObservationOutline#'
	 WHERE ObservationId = '#URL.Id#'	
</cfquery>	

<cfquery name="Update" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 UPDATE OrganizationObject
	 SET    EntityGroup       = '#Form.Workgroup#',
	        PersoneMail       = '#Form.PersonMail#'
	 WHERE  ObjectKeyValue4   = '#URL.Id#'	
</cfquery>	

<cfoutput>

<script>
  		
	try {	
	parent.opener.applyfilter('','','#url.id#') } catch(e) {}
	parent.window.close()
	
</script>
	

</cfoutput>
