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
