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

<cfparam name="URL.context"     default="status">
<cfparam name="URL.contextid"   default="">

<cfquery name="Entity" 
  datasource="AppsOrganization" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT   *
  FROM     Ref_Entity
  WHERE    EntityCode  = 'AuthRequest'
</cfquery>
  
<cfquery name="Parameter" 
  datasource="appsSystem"
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT  *
  FROM     Parameter
</cfquery>

<cfset currrow = 0>

<cfoutput>

	<cfsavecontent variable="myquery">		
	
		SELECT 	*
		FROM
		(
		SELECT UR.RequestId, 
		       UR.Reference, 
			   UR.RequestNo,
			   UR.Owner, 
			   UR.Application, 
			   UR.RequestName, 
			   UR.Mission,			  
			   UR.ActionStatus,
			   
			   (SELECT count(*) 
			    FROM   System.dbo.UserRequestNames
			    WHERE  RequestId = UR.RequestId) as Users,
				
				
			   <!--- determine access of the erspn to have workorder processor --->
			   
			   <cfif SESSION.isAdministrator eq "Yes">
			   
			   (CASE ActionStatus WHEN 0 THEN '2' ELSE '0' END) as AccessLevel,
			   
			   <cfelse>
			   
			    (CASE ActionStatus WHEN 0 THEN (
							
							 CASE  	(SELECT   count(*) 
									 FROM     Organization.dbo.OrganizationAuthorization AS A INNER JOIN
								              Organization.dbo.Ref_EntityGroup AS R ON A.GroupParameter = R.EntityGroup
									 WHERE    A.UserAccount   = '#SESSION.acc#' 
									 AND      A.Role          = '#Entity.role#' 
									 AND 	 R.EntityCode    = 'AuthRequest' )
						 
							 	WHEN 0 THEN '0' ELSE '2' END
							 
							 ) ELSE '0' END) as AccessLevel,			  
			   
			   </cfif>				   					
				
			   CASE
			   		WHEN E.EntityStatus = '0' THEN 'In Progress'
					WHEN E.EntityStatus = '1' THEN 'In Progress'
					WHEN E.EntityStatus = '2' THEN 'In Progress'
					WHEN E.EntityStatus = '3' THEN 'Closed'
					WHEN E.EntityStatus = '4' THEN 'Closed'
					ELSE 'Cancelled'
			   END AS RequestStatusDescription,
			   V.ActionDescriptionDue,
					
			   UR.RequestMemo, 
			   UR.OfficerLastName, 
			   UR.Created,
			   UR.OfficerUserId
			   
		FROM   System.dbo.UserRequest UR  
			   LEFT OUTER JOIN userquery.dbo.#SESSION.acc#wfAuthorization V ON ObjectkeyValue4 = UR.RequestId				   
			   LEFT OUTER JOIN Organization.dbo.Ref_EntityStatus E ON E.EntityCode = 'AuthRequest' AND E.EntityStatus = UR.ActionStatus
		) as Data 
					
		<cfif SESSION.isAdministrator eq "No">
		
				<!--- has access been granted access for the role for the owner --->
				
				WHERE       (
				
							<!--- is defined as a owner controller --->
							
							Owner IN (
				
								SELECT   DISTINCT R.Owner
								FROM     Organization.dbo.OrganizationAuthorization AS A INNER JOIN
					    	             Organization.dbo.Ref_EntityGroup AS R ON A.GroupParameter = R.EntityGroup
								WHERE    A.UserAccount   = '#SESSION.acc#' 
								AND      A.Role          = '#Entity.role#' 
								AND 	 R.EntityCode    = 'AuthRequest' 			
								)		
							
							OR
							
							<!--- raised by this person --->
							
							OfficerUserId = '#SESSION.acc#'
							
							)
							
		<cfelse>
		
		WHERE 1 = 1					
				
		</cfif>
		
		AND	ActionStatus <> '9'
						
	</cfsavecontent>	

</cfoutput>
		
<cfparam name="client.header" default="">

<cfset fields=ArrayNew(1)>

<cfset itm = 0>
					
<cfset itm = itm+1>		
<cfset fields[itm] =  {label           = "Status",      
					   field           = "ActionStatus",     
					   align           = "center",
					   formatted       = "Rating",	
					   search          = "text",
					   ratinglist      = "0=White,1=Yellow,9=Red,3=Green,2=Yellow",
					   processmode     = "checkbox",				
					   processlist     = "0,1",					
					   processtemplate = "System/AccessRequest/setActionStatus.cfm?requestid="}>
	
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "Status",	
                      field       = "RequestStatusDescription",		
					  filtermode  = "3",
					  search      = "text"}>		
							
<cfset itm = itm+1>							
<cfset fields[itm] = {label       = "Reference",                  
					field       = "Reference",
					filtermode  = "0",
					search      = "text"}>	
						
<cfset itm = itm+1>	
<cfset fields[itm] = {label       = "No",                  
					field       = "RequestNo",
					search      = "text"}>	
										
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "Owner",                  
					field       = "Owner"}>	
					
<cfset itm = itm+1>									
<cfset fields[itm] = {label       = "Application", 		
					field       = "Application"}>	
					
<cfset itm = itm+1>									
<cfset fields[itm] = {label       = "Entity", 		
					field         = "Mission",					
					filtermode    = "2",    
					search        = "text"}>						

<!---					
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "Descriptive", 	
                    LabelFilter = "RequestName",				
					field       = "RequestName",					
					filtermode  = "2"}>	
					
					--->
					
<cfset itm = itm+1>						
<cfset fields[itm] = {label       = "Usr", 	
                    LabelFilter   = "Users",				
					field         = "Users",	
					align         = "center",				
					filtermode    = "0"}>								
		  
								
<cfset itm = itm+1>								
<cfset fields[itm] = {label         = "Stage", 					
					field           = "ActionDescriptionDue",
					formatted       = "left(ActionDescriptionDue,35)",	
					search          = "text",			
					filtermode      = "2"}>									

<cfset itm = itm+1>			
<cfset fields[itm] = {label         = "access",  					
					field           = "AccessLevel",
					isAccess        = "Yes",
					display         = "No"}>		
					
<cfset fields[10] = {label          = "id",  					
					field           = "Requestid",					
					isKey           = "Yes",
					display         = "No"}>							
					
<cfset itm = itm+1>																					
<cfset fields[itm] = {label       = "Officer",		
					field       = "OfficerLastName"}>	
					
<cfset itm = itm+1>							
<cfset fields[itm] = {label      = "Entered",  					
					field       = "Created",
					search      = "date",
					formatted   = "dateformat(Created,'#CLIENT.DateFormatShow#')"}>	
					
	
	   
<cfset menu=ArrayNew(1)>	
	
<cfinvoke component = "Service.Access"  
   method           = "createwfobject" 
   entitycode       = "AuthRequest"
   returnvariable   = "accesscreate">   
			   
<cfif accesscreate eq "EDIT" or SESSION.isAdministrator eq "Yes">		
					
	<cfset menu[1] = {label = "New Request", script = "addRequestAccess('#url.context#')"}>				 
	
</cfif>		
	
<cfset filters=ArrayNew(1)>		
<cfset filters[1] = {field = "RequestStatusDescription", value= "In Progress"}>
	
	<table width="100%" height="100%" cellspacing="0" cellpadding="0" class="formpadding"><tr><td style="padding-left:10px;padding-right:10px">
	
	<cf_listing
	    header           = "RequestAccess"
		menu             = "#menu#"
	    box              = "requestaccess"
		systemfunctionid = "#url.systemfunctionid#"
		link             = "#SESSION.root#/System/AccessRequest/AccessRequestListingContent.cfm?systemfunctionid=#url.systemfunctionid#&context=#url.context#&contextid=#url.contextid#"
	    html             = "No"
		datasource       = "AppsSystem"
		listquery        = "#myquery#"				
		listorder        = "Created"
		listorderdir     = "DESC"
		headercolor      = "ffffff"
		listlayout       = "#fields#"
		filterShow       = "Hide"
		listfilter       = "#filters#"
		excelShow        = "Yes"
		drillmode        = "window"	
		drillargument    = "900;#client.width#;true;true"	
		drilltemplate    = "System/AccessRequest/DocumentEntry.cfm?drillid="		
		drillkey         = "RequestId"
		annotation       = "AuthRequest">
	
	</td></tr>
	</table>	