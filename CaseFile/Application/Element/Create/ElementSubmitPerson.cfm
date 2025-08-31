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
<cfquery name="Parameter" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    Ref_ParameterMission
	 WHERE   Mission  = '#Case.Mission#'	
</cfquery>

    <cfset url.applicantno    = form.applicantno>
	<cfset url.applicantclass = parameter.applicantclass>
	<cfset url.scope          = "casefile">		
				
	<cfinclude template="../../../../Roster/PHP/PHPEntry/GeneralSubmit.cfm">	
	
	<!--- include logging --->
			
	<cfquery name="GetTopic" 
		datasource="appsCaseFile" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT *
		  FROM   Ref_Topic
		  WHERE  TopicClass = 'Person'			  			  
	</cfquery>		
	
	<cfloop query="GetTopic">
	
	    <cfparam name="get.#TopicLabel#" default="">
	    <cfparam name="Form.#TopicLabel#" default="">
		
		<cfif evaluate("get.#topicLabel#") neq evaluate("form.#topicLabel#")>
		
		    <cfset old = evaluate("get.#topicLabel#")>
			<cfset val = evaluate("form.#topicLabel#")>
			
			 <cfquery name="LogOldRecord" 
			  datasource="appsCaseFile" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">		
			  INSERT INTO ElementTopicLog
				   (  #tfield1#,
					  #tfield2#,
					  Topic,
					  ExpirationDate,					    
				      TopicValue,
					  ToTopicValue,
					  ActionId,
					  OfficerUserId,
					  OfficerLastName,
					  OfficerFirstName)						
			  VALUES ('#elementid#',
					   '0',
					   '#Code#',
					   getdate(),					     
				       '#old#',
					   '#val#',
					   '#url.actionid#',
					   '#SESSION.acc#',
					   '#SESSION.last#',
					   '#SESSION.first#')					 
			</cfquery>  			
		
		</cfif>
			
	</cfloop>		
	
	<cftry>
	   <cfdirectory action="CREATE" 
            directory="#SESSION.rootDocumentPath#/applicant/#personNo#/">
		<cfcatch></cfcatch>
	</cftry>
	
	<!--- copying file --->
	<cfif FileExists("#SESSION.rootDocumentPath#/CaseFileElement/#elementid#/Picture_#elementid#.jpg")>	
	
		   <cffile action="COPY" source="#SESSION.rootDocumentPath#/CaseFileElement/#elementid#/Picture_#elementid#.jpg" 
		   destination="#SESSION.rootDocumentPath#/applicant/#personNo#/Picture_#personno#.jpg">
		   
		   <cffile action="DELETE" file="#SESSION.rootDocumentPath#/CaseFileElement/#elementid#/Picture_#elementid#.jpg">
		   
	</cfif>				
	
	<cfquery name="AssociateToElement" 
	datasource="AppsCaseFile" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		 UPDATE Element
		 SET    PersonNo = '#personno#'
		 WHERE  ElementId = '#elementid#'			 
	</cfquery>