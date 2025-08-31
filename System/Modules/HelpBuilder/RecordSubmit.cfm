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
<cf_screentop html="no" jquery="Yes">

<cfparam name="URL.ID"                   default="">
<cfparam name="URL.IDMenu"               default="">
<cfparam name="Form.Source"              default="Local">
<cfparam name="Form.ListingOrder"        default="1">
<cfparam name="form.UITextProjectFileId" default="0">

<cfif ParameterExists(Form.Submit)> 

	<cfif not IsNumeric(form.ListingOrder)>
		    
		<cf_alert message="You entered an invalid order" return="back">
		<cfabort>
		
	</cfif>
	
	<cfif not IsNumeric(form.UITextProjectFileId) and Form.Source neq "Local">
			
		<cf_alert message="You entered an invalid Robohelp File Id" return="back">
	    <cfabort>
		
	</cfif>
			
	<cfquery name="Verify" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT *
		FROM HelpProjectTopic
		<cfif URL.ID neq "">
		WHERE TopicId     = '#URL.ID#'
		<cfelse>
		WHERE 1=0
		</cfif>
	</cfquery>
	
	<cfif Verify.recordCount is 0>
	
			   
	   <cfquery name="Insert" 
		datasource="AppsSystem"
		username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
		INSERT INTO HelpProjectTopic 
			(ProjectCode, 
			 TopicClass, 
			 TopicCode, 
			 LanguageCode, 
			 TopicPresentation,
			 TopicName, 
			 SystemFunctionId,
			 <!---
			 ListingOrder,
			 --->
			 UITextHeader,
			 UITextHeaderIcon,
			 UITextSource, 
			 <cfif Form.Source neq "Local">
			 UITextProjectFileId,
			 </cfif>
			 UITextQuestion,
			 UITextAnswer,
			 OfficerUserId,
			 OfficerLastName,
			 OfficerFirstName)
		VALUES
			('#URL.Code#',
			 '#URL.Class#',
			 '#Form.TopicCode#',
			 '#Client.LanguageId#',
			 '#Form.TopicPresentation#',
			 '#Form.TopicName#',
			 <cfif url.idmenu neq "">
			 '#url.idmenu#',
			 <cfelse>
			 NULL,
			 </cfif>
			 <!---
			 '#Form.ListingOrder#',
			 --->
			 '#Form.UITextHeader#',
			 '#Form.UITextHeaderIcon#',
			 '#Form.Source#',
			 <cfif Form.Source neq "Local">		
			 '#Form.UITextProjectFileId#',
			 </cfif>
			 '#Form.Question#',
			 '#Form.Answer#',
			 '#SESSION.acc#', 
			 '#SESSION.last#',
			 '#SESSION.first#')
		 </cfquery>
		 
		 
	<cfelse>	 
	
	  <cf_assignId>
	  
	  <cfquery name="Update" 
		datasource="AppsSystem"
		username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
			UPDATE  HelpProjectTopic
			SET 	TopicCode            = '#Form.TopicCode#', 
		  		    LanguageCode         = '#Form.LanguageCode#', 
				    TopicPresentation    = '#Form.TopicPresentation#',
					TopicName            = '#Form.TopicName#', 
					<!---
					ListingOrder         = '#Form.ListingOrder#',
					--->
					<cfif url.idmenu neq "">
					SystemFunctionId     = '#url.idmenu#',
					</cfif>
					UITextHeader         = '#Form.UITextHeader#',
				    UITextHeaderIcon     = '#Form.UITextHeaderIcon#',
					UITextSource         = '#Form.Source#',
					<cfif Form.Source neq "Local">
				    UITextProjectFileId  = '#Form.UITextProjectFileId#',
					<cfelse>
					UITextProjectFileId  = NULL,
					</cfif>
				    UITextQuestion       = '#Form.Question#',
				    UITextAnswer         = '#Form.Answer#'
		    WHERE   TopicId = '#URL.Id#'
		</cfquery>
		 
		<cfset URL.ID = rowguid>
	
	</cfif>

<cfelseif ParameterExists(Form.Delete)> 
   		
	<cfquery name="Delete" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		DELETE FROM HelpProjectTopic
		WHERE  TopicId = '#URL.id#'
    </cfquery>
	
</cfif>

<cfparam name="Verify.Recordcount" default="1">
	
<cfoutput>
<script language="JavaScript">        
	
	 try {			 
	 parent.opener.help('#url.module#','#url.class#') } catch(e) {}
	 parent.window.close()
	 
</script> 
</cfoutput>	

