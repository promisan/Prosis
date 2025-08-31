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
<cfsilent>
<cfoutput>
	
	<cfsavecontent variable="myquery">	
		SELECT 	*
		FROM
			(
				SELECT	OO.Objectid,
				        OO.EntityCode, 
						R.EntityDescription, 
						OO.Owner, 
						OO.Mission, 
						OO.ObjectReference + ' - ' + OO.ObjectReference2 as DocumentReference, 
						OOA.ActionCode, 
						P.ActionDescription, 
						OO.ObjectURL, 
						OOA.OfficerUserId, 
						OOA.OfficerLastName, 
						OOA.OfficerFirstName, 
						OOA.OfficerDate,
						MAX(OOA.ActionFlowOrder) LastActivity
				FROM	OrganizationObjectAction AS OOA 
						INNER JOIN OrganizationObject AS OO 
							ON OOA.ObjectId = OO.ObjectId 
							AND OO.Operational = 1
						INNER JOIN Ref_Entity AS R   		
							ON OO.EntityCode = R.EntityCode 
						INNER JOIN Ref_EntityActionPublish AS P 
							ON OOA.ActionPublishNo = P.ActionPublishNo 
							AND OOA.ActionCode = P.ActionCode
				WHERE 	OOA.OfficerUserId = '#session.acc#'
				GROUP BY 
						OO.Objectid,
				        OO.EntityCode, 
						R.EntityDescription, 
						OO.Owner, 
						OO.Mission, 
						OO.ObjectReference,
						OO.ObjectReference2, 
						OOA.ActionCode, 
						P.ActionDescription, 
						OO.ObjectURL, 
						OOA.OfficerUserId, 
						OOA.OfficerLastName, 
						OOA.OfficerFirstName, 
						OOA.OfficerDate
			) AS Data
			
	</cfsavecontent>

</cfoutput>

</cfsilent>

<cfset fields=ArrayNew(1)>

<cfset itm = 0>
						  
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "Document",    					             
					  field       = "EntityDescription",	
					  Width       = "50",  
					  filtermode    = "2",
					  displayfilter = "Yes",				
					  search      = "text"}>						  
					  


<!---					  
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "Owner",    
					  Width       = "20",               
					  field       = "Owner",					
					  search      = "text"}>	
--->					  
					  
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "Reference",    					  				                
					  field       = "DocumentReference",	
					  Width       = "50%",     				
					  search      = "text"}>	
					  
				
<cfset itm = itm+1>		
<cfset fields[itm] = {label       = "Entity",                  
					  field         = "Mission",
					  Width         = "12",
					  filtermode    = "2",
					  displayfilter = "Yes",
					  search        = "text"}>							  					  				  
					  
					  
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "Last Activity",    
					  Width       = "25",               
					  field       = "ActionDescription",					
					  search      = "text"}>	
				
<cfset itm = itm+1>							
<cfset fields[itm] = {label         = "Date",  					
					  field         = "OfficerDate",					  
					  search        = "date",					  
					  formatted     = "dateformat(OfficerDate,'#CLIENT.DateFormatShow#')"}>	
					  
<cfset itm = itm+1>							
<cfset fields[itm] = {label         = "",  					
					  field         = "OfficerDate",					  					  			  
					  formatted     = "timeformat(OfficerDate,'HH:MM')"}>						  
			
	   
<table width="100%" height="100%">
<tr><td>	
		
	<cf_listing
	    header         = "Actions"
	    box            = "actionList"
		link           = "#SESSION.root#/Portal/Topics/MyActions/ActionListingContent.cfm?systemfunctionid=#url.systemfunctionid#"
	    html           = "No"		
		datasource     = "AppsOrganization"
		listquery      = "#myquery#"			
		listgroup      = "EntityDescription"		
		listgroupdir   = "ASC"			
		listorder      = "OfficerDate"
		listorderfield = "OfficerDate"		
		listorderdir   = "DESC"		
		headercolor    = "ffffff"
		listlayout     = "#fields#"
		filterShow     = "Hide"
		excelShow      = "Yes"
		drillargument = "920;1200;false;false"
		drillmode      = "window"	
		drilltemplate  = "ActionView.cfm?id="
		drillkey       = "ObjectId">		
	
	</td></tr>
</table>			