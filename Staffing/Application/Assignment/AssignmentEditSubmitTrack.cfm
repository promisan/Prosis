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

<cfquery name="CheckExist" 
datasource="appsVacancy" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Document D, DocumentPost P
	WHERE    P.PositionNo     = '#Form.PositionNo#'
	AND      D.DocumentNo     = P.DocumentNo
	AND      D.EntityClass    = '#Form.EntityClass#'
	AND      D.Status         = '0' 
</cfquery>

<cfif CheckExist.recordCount gte 1> 

	<!--- do NOT create a track as one exist already --->

<cfelse>
	
	<cfquery name="AssignNo" 
	datasource="appsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		UPDATE Parameter 
		SET DocumentNo = DocumentNo+1
	</cfquery>
	
	<cfquery name="LastNo" 
	datasource="appsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM Parameter
	</cfquery>
	
	<!--- set the due date to the end of assignment date --->	
	<cfset Due = end>
	
	<cfquery name="Position" 
	datasource="appsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Position
		WHERE  PositionNo = '#Form.PositionNo#'
	</cfquery>
	
	<cfquery name="Org" 
	datasource="appsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Organization
		WHERE  OrgUnit = '#Position.OrgUnitOperational#'
	</cfquery>
		
	<cfquery name="InsertDocument" 
	datasource="appsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	INSERT INTO Document
	         (DocumentNo,			 
			 Status,
			 FunctionNo, 
			 FunctionalTitle, 
			 OrganizationUnit,
			 Mission,
			 Owner,
			 PostNumber,
			 PositionNo,
			 DueDate,
			 PostGrade,
			 GradeDeployment,
			 EntityClass,			
			 OfficerUserId,
			 OfficerUserLastName,
			 OfficerUserFirstName)
	  VALUES ('#LastNo.DocumentNo#',	         
	          '0',
			  '#Position.FunctionNo#',
	          '#Position.FunctionDescription#',
			  '#Org.OrgUnitName#',
			  '#Position.Mission#',
			  '#Form.EntityOwner#',
			  '#Position.SourcePostNumber#',
			  '#Form.PositionNo#',
			  #Due#,
			  '#Position.PostGrade#',
			  '#Position.PostGrade#',			  
			  '#Form.EntityClass#',			 
			  '#SESSION.acc#',
	    	  '#SESSION.last#',		  
		  	  '#SESSION.first#')
	  </cfquery> 
	    
	  <cfquery name="InsertDocumentPost" 
		datasource="appsVacancy" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		INSERT INTO DocumentPost
			         (DocumentNo,
					 PositionNo,
					 PostNumber,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
		VALUES   ('#LastNo.DocumentNo#',
		          '#Position.PositionNo#',
		          '#Position.SourcePostNumber#',
				  '#SESSION.acc#',
		    	  '#SESSION.last#',		  
			  	  '#SESSION.first#')
	  </cfquery>	   
			
   <cfquery name="Doc" 
	datasource="appsVacancy" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Document
		WHERE  DocumentNo = '#LastNo.DocumentNo#'
   </cfquery>
			
   <cfset link = "Vactrack/Application/Document/DocumentEdit.cfm?ID=#LastNo.DocumentNo#">
 
   <!--- --------------------------------------- --->	
   <!--- create workflow object for recruitment- --->
   <!--- --------------------------------------- --->
   					
   <cf_ActionListing 
    TableWidth       = "100%"
    EntityCode       = "VacDocument"
	EntityClass      = "#Doc.EntityClass#"
	EntityGroup      = "#Doc.Owner#"
	EntityStatus     = ""		
	Mission          = "#Doc.Mission#"
	OrgUnit          = "#Position.OrgUnitOperational#"
	ObjectReference  = "#Doc.FunctionalTitle#"
	ObjectReference2 = "#Doc.Mission# - #Doc.PostGrade#"
	ObjectKey1       = "#Doc.DocumentNo#"
	Show             = "No"	
  	ObjectURL        = "#link#"
	DocumentStatus   = "#Doc.Status#">
	
</cfif> 




