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
<cfparam name="Form.Code"               default="0">
<cfparam name="Form.Protocol"           default="0">
<cfparam name="Form.Description"        default="">
<cfparam name="Form.Mission"            default="">
<cfparam name="Form.ListingOrder"       default="">
<cfparam name="Form.ActionFulfillment"  default="Standard">
<cfparam name="Form.EntryMode"          default="Manual">
<cfparam name="Form.DateValidation"     default="0">

<cfif URL.ID neq "">

	 <cfquery name="Update" 
		  datasource="#url.alias#" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  UPDATE Ref_Action
		  SET    Description         = '#Form.Description#', 
				 Listingorder        = '#Form.ListingOrder#',
				 EntryMode           = '#Form.EntryMode#',		
				 <cfif Form.ActionNotification neq "">
				 ActionNotification = '#Form.ActionNotification#',
				 <cfelse>
				 ActionNotification = NULL,
				 </cfif>
				 BatchDaysSpan 		 = '#Form.BatchDaysSpan#',
				 ActionFulfillment   = '#Form.ActionFulfillment#',
				 DateValidation      = '#Form.DateValidation#', 
				 ActionRequestMode   = '#Form.ActionRequestMode#',
				 Operational         = '#Form.Operational#', 
				 <cfif Form.Mission eq "">
				 Mission             = NULL
				 <cfelse>
				 Mission             = '#form.mission#'
				 </cfif> 
		  WHERE  Code = '#Form.CodeOld#'
	</cfquery>
	
	 <cfquery name="delete" 
		  datasource="#url.alias#" 
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  DELETE FROM Ref_ActionNotification	
		  WHERE  Code = '#Form.CodeOld#'
	</cfquery>
	
	<cfif Form.ActionFulfillment eq "Message">
	
	<cfloop index="itm" list="#form.Protocol#">
			
		<cfquery name="insert" 
			  datasource="#url.alias#" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  INSERT INTO Ref_ActionNotification
			  (Code,Protocol)
			  VALUES
			  ('#Form.CodeOld#','#itm#')
		</cfquery>	
		
	</cfloop>
	
	</cfif>
					
<cfelse>
			
	<cfquery name="Exist" 
	    datasource="#url.alias#" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT *
		FROM   Ref_Action
		WHERE  Code = '#Form.Code#'  
	</cfquery>
		
	<cfif Exist.recordCount eq "0">
		
			<cfquery name="Insert" 
			     datasource="#url.alias#" 
			     username="#SESSION.login#" 
			     password="#SESSION.dbpw#">
			     INSERT INTO Ref_Action
				         (Code,
					     Description,
						 Listingorder,
						 Mission,
						 EntryMode,
						 BatchDaysSpan,		
						 ActionFulfillment,
						 ActionNotification,
						 DateValidation,	
						 ActionRequestMode,
						 Operational,
						 OfficerUserId,
						 OfficerLastName,
						 OfficerFirstName)
			      VALUES ('#Form.Code#',
					      '#Form.Description#',
					      '#Form.ListingOrder#',
					      '#form.mission#',					      
					      '#Form.EntryMode#',	
					      '#Form.BatchDaysSpan#',		
					      '#Form.ActionFulfillment#',							  
						  
						  <cfif Form.ActionNotification neq "">
						  	'#Form.ActionNotification#',
						  <cfelse>
							NULL,
				          </cfif>
						  
					      '#Form.DateValidation#', 
					      '#Form.ActionRequestMode#',	
			      	      '#Form.Operational#',
					      '#SESSION.acc#',
					      '#SESSION.last#',
					      '#SESSION.first#'
						  )
			</cfquery>
			
			<cfif Form.ActionFulfillment eq "Message">
			
				<cfloop index="itm" list="#form.Protocol#">
				
					<cfquery name="insert" 
						  datasource="#url.alias#" 
						  username="#SESSION.login#" 
						  password="#SESSION.dbpw#">
						  INSERT INTO Ref_ActionNotification
								  (Code,Protocol)
						  VALUES  ('#Form.Code#','#itm#')
					</cfquery>	
					
				</cfloop>
			
			</cfif>
						
			
	<cfelse>
			
		<script>
			<cfoutput>
				alert("Sorry, but #Form.Code# already exists")
			</cfoutput>
		</script>
				
	</cfif>		
		   	
</cfif>

<cfif ParameterExists(Form.Delete)> 

	<cfquery name="CountRec" 
      datasource="AppsWorkOrder" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
      SELECT TOP 1 *
      FROM  WorkOrderLineAction
      WHERE ActionClass = '#Form.Code#' 
    </cfquery>
	
    <cfif CountRec.recordCount gt 0>
		 
	     <script language="JavaScript">    
		   alert("Action isin use. Operation aborted.")     
	     </script>  
	 
    <cfelse>
			
		<cfquery name="Delete" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			DELETE FROM Ref_Action
			WHERE Code = '#FORM.Code#'
		</cfquery>
	
	</cfif>	
	
</cfif>


<script>
	window.close();
	opener.location.reload();
</script>
