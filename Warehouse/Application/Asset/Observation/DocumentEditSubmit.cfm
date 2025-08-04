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
