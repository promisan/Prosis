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

<cfparam name="url.accessmode" default="view">
<cfparam name="url.scope"      default="backoffice"> 

<cfif url.accessmode eq "hide">
     <!--- do not show anything --->
     <cfabort>	 
	 <cf_compression>
</cfif>

<cfquery name="Request" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Request
		<cfif url.requestid eq "">		
		WHERE 1=0
		<cfelse>
		WHERE  Requestid = '#url.requestid#'
		</cfif>		
</cfquery>


<cfparam name="accessmode" default="#url.accessmode#">

<cfset status = request.actionStatus>

<cfif request.recordcount eq "0">
    <!--- new entry --->
  	<cfset accessmode = "Edit">	
	<cfset status = "0">
<cfelseif request.actionstatus eq "0">	
    <cfset accessmode = "Edit">
<cfelseif request.actionstatus eq "1">	
    <cfset accessmode = "Edit">
<cfelseif request.actionstatus eq "2">	
    <cfset accessmode = "View">		
<cfelseif request.actionstatus eq "3">
    <!--- never allow for edit --->	 
	<cfset accessmode = "View">
</cfif>

<cfoutput>

<cfif accessmode eq "Edit">

												
	   <cfif Request.ActionStatus lte "1" and Request.recordcount eq "1">
	  	   					  
		   <cf_tl id="Delete" var="1">
		      
		   <input type="button"
		      name="delete" id="delete"
			  value="#lt_text#" 
			  style="width:130px;height:25" 
			  class="button10g" 
			  onClick="return ask('#url.requestid#')">
			  
	    <cfelse>
		
		
		  <cf_tl id="Close" var="1">
	 
		   <input type="button" 
			    name="close"  id="close"
				value="#lt_text#" 
				style="width:130px;height:25" 
				class="button10g" 
				onClick="window.close()">					  
		
	   </cfif>   
	   
	   <cfif Request.recordcount eq "1">
	   
	   	 <cf_tl id="Save" var="1">
	   
	   <cfelse>
	   
	   	 <cf_tl id="Submit" var="1">
	   
	   </cfif>	  	   
	  	  	   	  						   
	   <input class="button10g"
		     type="button" 
			 name="save" id="save"
			 style="width:130px;height:25" 
			 value="#lt_text#"
			 onclick="ColdFusion.navigate('DocumentSubmit.cfm?scope=#url.scope#&action=submit&domain=#url.domain#&mission=#url.mission#&status=#status#&requestid=#url.requestid#','submitbox','','','POST','requestform')">
		 
<cfelseif Request.ActionStatus eq "0">
	
	 <cf_tl id="Close" var="1">
	 
	   <input type="button" 
		    name="close" id="close"
			value="#lt_text#" 
			style="width:130px;height:25" 
			class="button10g" 
			onClick="returnValue=1;window.close()">			
			
	   <cfif url.requestid neq "">	
	   			 			   						  
		   <cf_tl id="Delete" var="1">
		   <input type="button" 
		      name="delete" id="delete" 
			  value="#lt_text#" 
			  style="width:130px;height:25" 
			  class="button10g" 
		      onclick="return ask('#url.requestid#');">
		  
	   </cfif>	  
						   
	   <cf_tl id="Edit" var="1">	
	   											   
	   <input class="button10g"
		     type="button" 
			 name="save" id="save"
			 style="width:130px;height:25" 
			 value="#lt_text#"
			 onclick="ColdFusion.navigate('DocumentSubmit.cfm?scope=#url.scope#&mode=edit&domain=#url.domain#&mission=#url.mission#&status=#status#&requestid=#url.requestid#','submitbox','','','POST','requestform')">
			 
<cfelseif getAdministrator(url.mission) eq "1" and request.ActionStatus neq "3">
			 			   						  
	   <cf_tl id="Delete" var="1">
	   
	   <input type="button" 
	      name="delete" id="delete"
		  value="#lt_text#" 
		  style="width:130px;height:25" 
		  class="button10g" 
	      onclick="return ask('#url.requestid#');">
		  
<cfelse>
	
	<cf_compression>		  
	 						
</cfif>	 


</cfoutput>