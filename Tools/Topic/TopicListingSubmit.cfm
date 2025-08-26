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

<cfparam name="Form.Operational"        default="0">
<cfparam name="Form.Attachment"         default="0">
<cfparam name="Form.ListingOrder"       default="0">
<cfparam name="Form.ValueObligatory"    default="0">
<cfparam name="Form.ValueMultiple"      default="0">
<cfparam name="Form.ValueLength"        default="10">
<cfparam name="Form.Code"               default="0">
<cfparam name="Form.Description"        default="">
<cfparam name="Form.ListPK"             default="">
<cfparam name="Form.Mission"            default="">
<cfparam name="Form.TopicClass"         default="">
<cfparam name="Form.topicclassValues"   default="">

<cfif URL.ID2 neq "new">

	 <cfquery name="Update" 
		  datasource="#url.alias#" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE Ref_Topic
		  SET    Operational         = '#Form.Operational#',
		  		<cfif systemmodule eq "Roster"> 
					Parent  = '#Form.TopicClass#',
					Source  = '#Form.Source#',
				<cfelse>
					TopicClass = '#Form.TopicClass#',
					<cfif Form.Mission eq "">
						 Mission             = NULL,
					 <cfelse>
					 	Mission             = '#form.mission#',
				 	 </cfif>
				 </cfif> 
				 ListingOrder        = '#Form.ListingOrder#',
		         ValueClass          = '#Form.ValueClass#',
				 ValueLength         = '#Form.ValueLength#',
				 ValueMultiple       = '#Form.ValueMultiple#',
				 ValueObligatory     = '#Form.ValueObligatory#',
				 <cfif Form.valueclass eq "Lookup" and Form.ListPK neq "">
				 ListDataSource      = '#Form.ListDataSource#',
				 ListTable           = '#Form.ListTable#',
				 ListPK              = '#Form.ListPK#',
				 ListOrder           = '#Form.ListOrder#',
				 ListGroup           = '#Form.ListGroup#',
				 ListDisplay         = '#Form.ListDisplay#',
				 ListCondition       = '#Form.ListCondition#',
				 </cfif>
				 Attachment          = '#Form.Attachment#',
				 TopicLabel          = '#Form.TopicLabel#',
 		         Description         = '#Form.Description#',
				 Tooltip			 = '#Form.Tooltip#'
				 
		  <cfif systemmodule eq "Roster">
		  		WHERE  Topic = '#URL.ID2#' 
		  <cfelse>
		  		WHERE  Code = '#URL.ID2#' 
		  </cfif>
		  
	</cfquery>
	
	<cfif systemmodule eq "Roster">
		
		<cfset tablecode = "Ref_Topic">
		
	<cfelse>
		
		<cfset tablecode = "topic#systemmodule#">
		
	</cfif>
					
	<cf_LanguageInput
					TableCode       = "#tablecode#" 
					Mode            = "Save"
					DataSource      = "#url.alias#"
					Key1Value       = "#URL.ID2#"
					Name1           = "TopicLabel">	

	<cf_LanguageInput
					TableCode       = "#tablecode#" 
					Mode            = "Save"
					DataSource      = "#url.alias#"
					Key1Value       = "#URL.ID2#"
					Name1           = "Description">
					
	<cf_LanguageInput
					TableCode       = "#tablecode#" 
					Mode            = "Save"
					DataSource      = "#url.alias#"
					Key1Value       = "#URL.ID2#"
					Name1           = "Tooltip">								
					
	<!--- dev: To be adjusted 
	<cfif form.classform eq "Pending">				
	
			<cf_TopicListingsubmitclass alias="#alias#" 
		           code="#url.id2#" 
				   topicclass="#form.topicclass#" 
				   topicscopetable="#topicscopetable#"
			       topicscopefield="#topicscopefield#"		
				   topicfield="#topicfield#"
				   values="#Form.TopicClassValues#">
				   
	</cfif>		
	---->
	
	<script>
		window.close();
		opener.location.reload();
	</script>
				
<cfelse>		

			
	<cfquery name="Exist" 
	    datasource="#url.alias#" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
		FROM   Ref_Topic
		  <cfif systemmodule eq "Roster">
		  		WHERE  Topic = '#Form.Code#' 
		  <cfelse>
		  		WHERE  Code = '#Form.Code#' 
		  </cfif>
	</cfquery>
		
	<cfif Exist.recordCount eq "0">
		
			<cfquery name="Insert" 
			     datasource="#url.alias#" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Ref_Topic
			         (
					 <cfif systemmodule eq "Roster"> 
					 	Topic,
						Parent,
						Source,
					 <cfelse>
						 Code,
 						 TopicClass,
	 					 Mission,
					 </cfif>
 					 TopicLabel,
				     Description,
					 Tooltip,
					 ValueClass,
					 ValueLength,
					 ValueObligatory,
					 ValueMultiple,
					 <cfif form.valueclass eq "Lookup" and Form.ListPK neq "">
						 ListDataSource,
						 ListTable,  
						 ListPK,     
						 ListOrder,  
						 ListDisplay,
						 ListCondition,
						 ListGroup,
					 </cfif>
					 Operational,
					 Attachment,
					 ListingOrder,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
			      VALUES ('#Form.Code#',
  					  '#Form.TopicClass#',
					  <cfif systemmodule eq "Roster"> 
					  	'#Form.Source#',
					  <cfelse> 
						  <cfif Form.Mission eq "">
					       NULL,
						  <cfelse>
						   '#form.mission#',
						  </cfif> 
					  </cfif>
					  '#form.TopicLabel#',
  					  '#Form.Description#',
					  '#Form.Tooltip#',
					  '#Form.ValueClass#',
					  '#Form.ValueLength#',
					  '#Form.ValueObligatory#',
					  '#Form.ValueMultiple#',
					  <cfif form.valueclass eq "Lookup" and Form.ListPK neq "">
					     '#Form.ListDataSource#',
						 '#Form.ListTable#',
						 '#Form.ListPK#',
				 		 '#Form.ListOrder#',
				 		 '#Form.ListDisplay#', 
						 '#form.ListCondition#',
						 '#form.ListGroup#',
					  </cfif>
			      	  '#Form.Operational#',
					  '#Form.Attachment#',
					  '#Form.ListingOrder#',
					  '#SESSION.acc#',
					  '#SESSION.last#',
					  '#SESSION.first#')
			</cfquery>
			
			<cf_LanguageInput
					TableCode       = "topic#systemmodule#" 
					Mode            = "Save"
					DataSource      = "#url.alias#"
					Key1Value       = "#Form.Code#"
					Name1           = "TopicLabel">		
					
			<cf_LanguageInput
					TableCode       = "topic#systemmodule#" 
					Mode            = "Save"
					DataSource      = "#url.alias#"
					Key1Value       = "#Form.Code#"
					Name1           = "Description">

			<cf_LanguageInput
					TableCode       = "topic#systemmodule#" 
					Mode            = "Save"
					DataSource      = "#url.alias#"
					Key1Value       = "#Form.Code#"
					Name1           = "Tooltip">		
			
			<!--- dev: To be adjusted 
			<cfif form.topicclassValues neq "" and form.classform eq "Pending">
			
				<cf_TopicListingsubmitclass 
				   alias="#alias#" 
				   code="#form.code#" 
				   topicclass="#form.topicclass#" 
				   topicscopetable="#topicscopetable#"
				   topicscopefield="#topicscopefield#"	
				   topicfield="#topicfield#"			   
				   values="#Form.TopicClassValues#">
										 
			</cfif>			
			---->
			
			<script>
				/*
				 document.getElementById('code').value = "";
				 document.getElementById('topiclabel').value = "";
				 document.getElementById('description').value = "";	*/
   
			     window.close();
				 opener.location.reload();
				 
			</script>					 
			
	<cfelse>
			
		<script>
			<cfoutput>
				alert("Sorry, but #Form.Code# already exists")
				window.close();
			</cfoutput>
		</script>
				
	</cfif>		
		   	
</cfif>
