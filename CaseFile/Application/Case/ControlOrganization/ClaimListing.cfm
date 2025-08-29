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
<!--- show the matching lines --->

<cfsavecontent variable="qSelect">
	          C.ClaimId, 
		      O.OrgUnit, 
			  O.OrgUnitName, 
			  C.DocumentNo, 
			  C.DocumentDate, 
			  C.Created,
			  C.DocumentSource,
			  C.DocumentDescription, 
			  C.ClaimType, 
			  C.OfficerLastName, 
			  C.OfficerFirstName, 
              C.ClaimantEMail, 
			  C.ActionStatus, 			 
			  S.Description AS Status, 
			  C.CaseNo, 
              R.Description AS ClaimTypeClassDescription
</cfsavecontent>

<cfsavecontent variable="qAccess">

<cfoutput>

		AND C.ClaimType IN (SELECT ClassParameter 
        	                FROM   Organization.dbo.OrganizationAuthorization
		  			        WHERE  UserAccount = '#SESSION.acc#'
					        AND    ((OrgUnit = C.OrgUnit) or (OrgUnit is NULL and Mission = C.Mission))
					        AND    Role IN ('CaseFileManager')				 
				   ) 

</cfoutput>
				   
</cfsavecontent>

<cfset condition = "WHERE 1=1 ">

<cfsavecontent variable="qQuery">

	<cfoutput>
   
	<cfswitch expression="#URL.ID#">
		  	
		<cfcase value="status">
		
	        <cfif url.id1 neq "">
				<cfset condition = "#condition# AND C.Mission = '#url.id1#'">
			</cfif>
			
			<cfif url.id2 neq "">
				<cfset condition = "#condition# AND C.ActionStatus = '#URL.ID2#'">
			</cfif>
			
			<cfif url.id3 neq "">
				<cfset condition = "#condition# AND C.ClaimType = '#URL.ID3#'">
			</cfif>
			
			<cfif url.id4 neq "">
				<cfset condition = "#condition# AND C.ClaimTypeClass = '#URL.ID4#'">
			</cfif>
						
			SELECT  #preservesinglequotes(qSelect)# 				      
			FROM    Claim C LEFT OUTER JOIN
    	            Ref_ClaimTypeClass R ON C.ClaimType = R.ClaimType AND C.ClaimTypeClass = R.Code 
					LEFT OUTER JOIN Organization.dbo.Organization O ON O.OrgUnit = C.OrgUnitClaimant 
					LEFT OUTER JOIN	Ref_Status S ON C.ActionStatus = S.Status AND S.StatusClass = 'clm'				
				    
					#preserveSingleQuotes(Condition)#	
				
				<cfif getAdministrator("*") eq "0">
				    #preservesinglequotes(qAccess)# 				
				</cfif>		
													
		</cfcase>	
		
		<cfcase value="entity">
		
			 <cfif url.id1 neq "">
				<cfset condition = "#condition# AND C.Mission = '#url.id1#'">
			</cfif>
			
			<cfif url.id2 neq "">
				<cfset condition = "#condition# AND C.ActionStatus = '#URL.ID2#'">
			</cfif>
			
			<cfif url.id3 neq "">
				<cfset condition = "#condition# AND C.ClaimType = '#URL.ID3#'">
			</cfif>
			
			<cfif url.id4 neq "">
				<cfset condition = "#condition# AND C.ClaimTypeClass = '#URL.ID4#'">
			</cfif>
						
			SELECT  #preservesinglequotes(qSelect)# 	
							      
			FROM    Claim C 
			        INNER JOIN  Ref_ClaimTypeClass R ON C.ClaimType = R.ClaimType AND C.ClaimTypeClass = R.Code 
					LEFT OUTER JOIN  Organization.dbo.Organization O ON O.OrgUnit = C.OrgUnitClaimant
					LEFT OUTER JOIN  Organization.dbo.Ref_EntityStatus S ON C.ActionStatus = S.EntityStatus AND S.EntityCode = 'clm'+R.ClaimType				
					    
					#preserveSingleQuotes(Condition)#	
					
				<cfif getAdministrator("*") eq "0">
				    #preservesinglequotes(qAccess)# 				
				</cfif>		
					
		</cfcase>		
		
		<cfcase value="node">
		
		<!--- pending for nodes tree --->
		
		</cfcase>
						
	</cfswitch>
	
	</cfoutput>
	
</cfsavecontent>	

<cfset itm = 0>

<cfset fields=ArrayNew(1)>
					
<cfset itm = itm+1>					
<cfset fields[itm] = {label     = "No",                    
					 field       = "DocumentNo", 		
					 formatted   = "DocumentNo",	
					 filtermode  = "4",									
					 search      = "text"}>	
		
<cfset itm = itm+1>
<cfset fields[itm] = {label     = "Description",                   		
					 field       = "DocumentDescription",					
					 alias       = "",		
					 filtermode  = "4",														
					 search      = "text"}>							

<cfset itm = itm+1>
<cfset fields[itm] = {label       = "Status",                   		
					 field       = "Status",					
					 alias       = "",														
					 searchfield  = "Description",
					 searchalias  = "S",												
					 search      = "text",
					 filtermode  = "2"}>					
						
<cfset itm = itm+1>					
<cfset fields[itm] = {label     = "Case Date",                    
					 field       = "DocumentDate", 	
					 alias       = "C",	
					 formatted   = "dateformat(documentdate,CLIENT.DateFormatShow)",			
					 search      = "date"}>		
		
<cfset itm = itm + 1>															
<cfset fields[itm] = {label    = "Type", 					
					 field      = "ClaimType",	
					 alias       = "C",		
					 searchalias = "C",
					 align      = "left",															
					 search     = "text",
					 filtermode  = "2"}>	
					
<cfset itm = itm + 1>															
<cfset fields[itm] = {label    = "Case", 					
					 field      = "ClaimTypeClassDescription",	
					 searchfield = "Description",
					 searchalias = "R",
					 align      = "left",																	
					 search     = "text"}>													
	
<cfset itm = itm + 1>															
<cfset fields[itm] = {label    = "Officer", 					
					field      = "OfficerLastName",	
					alias       = "C",		
					searchalias = "C",
					align      = "left",																		
					search     = "text"}>						

<cfset itm = itm+1>					
<cfset fields[itm] = {label     = "Recorded",                    
					field       = "Created", 	
					searchfield = "Created",
					searchalias = "C",												
					formatted   = "dateformat(created,CLIENT.DateFormatShow)",			
					search      = "date"}>					
									

<!--- define access --->

<cfset menu = "">

<!--- to be defined

<cfinvoke component = "Service.Access"  
	method          = "WorkorderProcessor" 
	mission         = "#workorder.mission#" 
	serviceitem     = "#workorder.serviceitem#"
	returnvariable  = "access">		   
					
	<cfif access eq "EDIT" or access eq "ALL">		
													
		<cfset menu[1] = {label  = "Add Transaction", 
		                  icon   = "insert.gif", 
						  script = "addusage('#workorder.mission#','#url.workorderid#','#url.workorderline#')"}>				 
						  
	<cfelse>	
	
		<cfset menu = "">					  
			
	</cfif>			
	
--->
	
<!--- get entity --->

<cfquery name="Entity" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
    FROM     Ref_Entity	
	WHERE    EntityTableName = 'CaseFile.dbo.Claim' 
</cfquery>	
				
									
<cf_listing
    header         = "caselist"
    box            = "casebox"
	link           = "#SESSION.root#/casefile/application/Case/ControlOrganization/ClaimListing.cfm?id=#url.id#&id1=#url.id1#&id2=#url.id2#&id3=#url.id3#&id4=#url.id4#"
    html           = "No"		
	tableheight    = "100%"
	tablewidth     = "100%"
	datasource     = "AppsCaseFile"
	listquery      = "#qQuery#"
	listorderfield = "CaseNo"
	listorderalias = ""
	listorder      = "CaseNo"
	listorderdir   = "ASC"
	headercolor    = "ffffff"
	show           = "40"			
	menu           = "#menu#"			
	filtershow     = "Hide"
	excelshow      = "Yes" 		
	listlayout     = "#fields#"
	drillmode      = "securewindow" 
	drillargument  = "#client.height-80#;#client.widthfull-60#;true;true"			
	drilltemplate  = "CaseFile/Application/Case/CaseView/CaseView.cfm?claimId="
	drillkey       = "ClaimId"
	drillbox       = "addcasefile"
	annotation     = "#Entity.EntityCode#">	  