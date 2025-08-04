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

<cfparam name="Form.Operational"       default="0">
<cfparam name="Form.JournalBatchNo"    default="">
<cfparam name="Form.BatchCategory"     default="">
<cfparam name="Form.Description"       default="">
<!---
<cfparam name="Form.ListDefault"    default="0">
--->

<cfif URL.ID2 neq "new">

	 <cfquery name="Update" 
		  datasource="#alias#" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE JournalBatch
		  SET    Operational         = '#Form.Operational#',
 		         BatchCategory       = '#Form.BatchCategory#',
				 JournalBatchNo      = '#url.id2#',
				 Description         = '#Form.Description#'
		  WHERE  JournalBatchNo = '#URL.ID2#'
		   AND   Journal        = '#URL.Journal#' 
	</cfquery>
	
	<!--- 
	<cfif Form.ListDefault eq "1">
	
		<cfquery name="Update" 
			  datasource="#alias#" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  UPDATE Ref_TopicList
			  SET    ListDefault = 0
			  WHERE  ListCode <> '#URL.ID2#'
			   AND   Code = '#URL.Code#' 
		</cfquery>
	
	</cfif>
	
	--->
	
	<cfset url.id2 = "">
				
<cfelse>
			
	<cfquery name="Exist" 
	    datasource="#alias#" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT  *
		FROM    JournalBatch
		 WHERE  JournalBatchNo = '#Form.JournalBatchNo#'
		   AND  Journal        = '#URL.Journal#' 
	</cfquery>
	
	<cfif Exist.recordCount eq "0">
		
			<cfquery name="Insert" 
			     datasource="#alias#" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO JournalBatch
			         (Journal,
					 JournalBatchNo,
					 BatchCategory,
					 Description,					
					 Operational)
			      VALUES ('#URL.Journal#',
				      '#Form.JournalBatchNo#',
					  '#Form.BatchCategory#',
					  '#Form.Description#',					
			      	  '#Form.Operational#')
			</cfquery>
			
	<cfelse>
			
		<script>
		<cfoutput>
		alert("Sorry, but #Form.JournalBatchNo# already exists")
		</cfoutput>
		</script>
				
	</cfif>		
	
	<cfset url.id2 = "new">
	
	<!---
	<cfif Form.ListDefault eq "1">
	
		<cfquery name="Update" 
			  datasource="#alias#" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  UPDATE Ref_TopicList
			  SET    ListDefault = 0
			  WHERE  ListCode <> '#Form.ListCode#'
			   AND   Code = '#URL.Code#' 
		</cfquery>
	
	</cfif>
	
	--->
		   	
</cfif>

<cfset url.id2 = "new">
<cfinclude template="BatchPeriodList.cfm">

<cfoutput>
<script>
 parent.batchrefresh('#URL.Journal#')
</script>
</cfoutput>

