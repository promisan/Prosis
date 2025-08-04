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

<!--- set as amendment 

reset the workflow
adjust the class 

--->


<cfquery name="object" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT * FROM OrganizationObject	 
	 WHERE  ObjectkeyValue4 = '#URL.Id#'	
</cfquery>	

<cfquery name="get" 
	 datasource="AppsControl" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT * FROM Observation	 
	 WHERE  ObservationId = '#URL.Id#'	
</cfquery>	


<cfquery name="Update" 
	 datasource="AppsControl" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 UPDATE Observation
	 SET    <cfif url.ObservationClass eq "Inquiry">
   	        ApplicationServer     = '#Form.amendApplicationServer#',
		    <cfelse>
		    Owner				  = '#Form.amendOwner#',
	        </cfif>
		    ObservationClass      = '#url.observationclass#'   	 	  
	 WHERE  ObservationId = '#URL.Id#'	
</cfquery>	

<cfquery name="Update" 
	 datasource="AppsOrganization" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 UPDATE OrganizationObject
	 SET    Operational = 0
	 WHERE ObjectkeyValue4 = '#URL.Id#'	
</cfquery>	



<cfset link = "System/Modification/DocumentView.cfm?id=#get.ObservationId#">

<cfif url.observationclass eq "Inquiry">
	
		<cfset entitycode = "SysTicket">		
			
		<cf_ActionListing 
			EntityCode       = "#entitycode#"
			EntityGroup      = "#Form.rapplication#"
			EntityClass      = "#Form.amendEntityClass#"
			EntityStatus     = "0"		
			PersonEMail      = "#object.PersoneMail#"
			ObjectReference  = "#Form.rapplication# Ticket No: #get.ObservationNo#"
			ObjectReference2 = "#SESSION.first# #SESSION.last#"
			ObjectKey4       = "#get.ObservationId#"
			ObjectURL        = "#link#"
			Show             = "No"			
			Toolbar          = "No"
			Framecolor       = "ECF5FF"
			CompleteFirst    = "No">	
		
	<cfelse>
	
		<cfset entitycode = "SysChange">	
			
		<cf_ActionListing 
			EntityCode       = "#entitycode#"
			EntityGroup      = "#Form.amendWorkgroup#"
			EntityClass      = "#Form.amendEntityClass#"
			EntityStatus     = "0"		
			PersonEMail      = "#object.PersoneMail#"
			ObjectReference  = "Amendment for #get.SystemModule# No: #get.ObservationNo#"
			ObjectReference2 = "#SESSION.first# #SESSION.last#"
			ObjectKey4       = "#get.Observationid#"			
			ObjectURL        = "#link#"
			Show             = "No"
			Toolbar          = "No"
			Framecolor       = "ECF5FF"
			CompleteFirst    = "Yes">	
						
			
	</cfif>
	
	
<cfoutput>	
<script>
  		
	try {	
	parent.opener.applyfilter('','','#url.id#') } catch(e) {}
	parent.window.close()
	
</script>
</cfoutput>

