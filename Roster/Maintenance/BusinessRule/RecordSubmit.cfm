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
<cfparam name="Form.Operational" default="0">
<cfparam name="Form.StatusTo" default="">
<cfparam name="Form.Color" default="">
<cfparam name="Form.ValidationPath" default="">
<cfparam name="Form.ValidationTemplate" default="">
<cfparam name="url.action" default="">

<cfif ParameterExists(Form.Insert)> 

	<cfquery name="Check" 
			 datasource="AppsSelection" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 
			 SELECT *
			 FROM   Ref_Rule
			 WHERE  Code = '#Form.Code#'
			 
	</cfquery>
	
	<cfif Check.recordcount gt 0>
		
		<script>
			alert('A rule with this code already exists. Operation aborted.');
		</script>
	
	<cfelse>
	
		<cfquery name="Insert" 
		 datasource="AppsSelection" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 
		 
		  INSERT INTO Applicant.dbo.Ref_Rule
           (Code
		   ,Owner
           ,TriggerGroup
		   <cfif Form.Description neq "">
           ,Description
		   </cfif>
  		   <cfif Form.MessagePerson neq "">
           ,MessagePerson
		   </cfif>
   		   <cfif Form.ValidationPath neq "">
           ,ValidationPath
		   </cfif>
   		   <cfif Form.ValidationTemplate neq "">
           ,ValidationTemplate
		   </cfif>
   		   <cfif Form.Color neq "">
           ,Color
		   </cfif>
		   <cfif Form.StatusTo neq "">
           ,StatusTo
		   </cfif>
           ,Source
           ,Operational
           ,OfficerUserId
           ,OfficerLastName
           ,OfficerFirstName
           ,Created)
    	 VALUES
           ('#Form.Code#'
		   ,'#Form.Owner#'
           ,'#Form.TriggerGroup#'
  		   <cfif Form.Description neq "">
           ,'#Form.Description#'
		   </cfif>
   		   <cfif Form.MessagePerson neq "">
           ,'#Form.MessagePerson#'
		   </cfif>
   		   <cfif Form.ValidationPath neq "">
           ,'#Form.ValidationPath#'
		   </cfif>
   		   <cfif Form.ValidationTemplate neq "">
           ,'#Form.ValidationTemplate#'
		   </cfif>
   		   <cfif Form.Color neq "">
           ,'#Form.Color#'
		   </cfif>
		   <cfif Form.StatusTo neq "">
           ,'#Form.StatusTo#'
		   </cfif>
           ,'#Form.Source#'
           ,'#Form.Operational#'
           ,'#SESSION.acc#'
           ,'#SESSION.Last#'
           ,'#SESSION.First#'
           ,getdate())
		 
		 </cfquery>
	
	</cfif>
	

<cfelseif ParameterExists(Form.Update)> 

	<cfquery name="Insert" 
		 datasource="AppsSelection" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 
		 
		 UPDATE Applicant.dbo.Ref_Rule
  		 SET 
		  Owner = '#Form.Owner#'
	      ,TriggerGroup = '#Form.TriggerGroup#'
   		   <cfif Form.Description neq "">
	      ,Description = '#Form.Description#'
		  <cfelse>
		  ,Description = NULL
		  </cfif>
   		   <cfif Form.MessagePerson neq "">
	      ,MessagePerson = '#Form.MessagePerson#'
		  <cfelse>
	      ,MessagePerson = NULL
		  </cfif>
   		   <cfif Form.ValidationPath neq "">
	      ,ValidationPath = '#Form.ValidationPath#'
		  <cfelse>
	      ,ValidationPath = NULL
		  </cfif>
   		  <cfif Form.ValidationTemplate neq "">
	      ,ValidationTemplate = '#Form.ValidationTemplate#'
		  <cfelse>
		  ,ValidationTemplate = NULL
		  </cfif>
  		  <cfif Form.Color neq "">
	      ,Color = '#Form.Color#'
		  <cfelse>
	      ,Color = NULL
		  </cfif>
		   <cfif Form.StatusTo neq "">
	      ,StatusTo = '#Form.StatusTo#'
		  <cfelse>
	      ,StatusTo = NULL
		  </cfif>
	      ,Source = '#Form.Source#'
	      ,Operational = '#Form.Operational#'
		 WHERE Code = '#Form.Code#'
		 
		 </cfquery>

<cfelseif url.action eq "Delete"> 

		<cfquery name="Delete" 
		 datasource="AppsSelection" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
		 	DELETE 
			FROM   Ref_Rule
			WHERE  Code = '#URL.ID1#'
		 </cfquery>
		
</cfif>	

<cfif url.action neq "Delete">
	
	<script language="JavaScript">
	   
	     window.close()
		 opener.location.reload()
	        
	</script>  

<cfelse>
	<cfinclude template="RecordListing.cfm">
</cfif>
