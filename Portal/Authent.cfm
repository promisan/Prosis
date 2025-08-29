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
<!--- we need to add some code to make sure setclient is authorised to run using ptoken principle --->
<!--- ------------------------------------------------------------------------------------------- --->

<!--- July 07, 2012:  This is to return a value instead of automatically redirect to pages, or show cf_message tags. --->
<cfparam name="url.returnValue"		default = "0">
<cfset prosisLoginResult = 0> <!--- 0 = not logged by default, 200 = no anonymous account, 201 = invalid account, 202 = out of service --->

<cfparam name="URL.ID" default="">
<cfparam name="Form.Account" default="">

<cfquery name="System" 
   datasource="AppsSystem">
      SELECT * 
	  FROM Parameter 
</cfquery>

<cfquery name="Parameter" 
		datasource="AppsInit">
		SELECT *
		FROM   Parameter
		WHERE  Hostname = '#CGI.HTTP_HOST#' 
</cfquery>		

<cfset appserver = "1">

<cfset SESSION.isAdministrator = "No">

<cfinvoke component="Service.Access" method="system" returnvariable="Access">

<cfif Parameter.Operational eq "0">				
								 		
	  <cfif Access neq "ALL">	 
	        <cfset appserver = "0">
	   		<cfif url.returnValue eq 1>								    
				<cfset prosisLoginResult = 203>																	
			</cfif>	  	   
	  </cfif>
	  			   
<cfelseif len(Parameter.DisableTimeStart) eq "5" and len(Parameter.DisableTimeEnd) eq "5">
			
	  <cfset ts = hour(now())*60+minute(now())>					
	  <cfset str = (left(Parameter.DisableTimeStart,2)*60)+mid(Parameter.DisableTimeStart,4,2)>
	  <cfset end = (left(Parameter.DisableTimeEnd,2)*60)+mid(Parameter.DisableTimeEnd,4,2)>
						
	  <cfif ts gte str and ts lte end>
									 		
		   <cfif Access neq "ALL">				   
			    <cfset appserver = "0">
				<cfset prosisLoginResult = 203>										
		  </cfif>	 	   			
			  	
	 </cfif>

</cfif>

<cfif Form.Account eq "">

	<cfif url.returnValue eq 1>
		<cfset prosisLoginResult = 0>
	<cfelse>
		<cflocation url="../Default.cfm" addtoken="No">
	</cfif>
 
<cfelseif Form.account eq System.AnonymousUserid>		

	<cfif url.returnValue eq 1>
		<cfset prosisLoginResult = 200>
	<cfelse>		
	    <cf_message message="You are not allowed to access with the ANONYMOUS account" return="../Default.cfm?id=#URL.ID#" header="yes">
		<cfabort>
	</cfif>
	
<cfelse>
	 
	<cfquery name="Update" 
	datasource="AppsInit">
		UPDATE Parameter 
		SET    SessionNo = SessionNo+1
		WHERE  Hostname = '#CGI.HTTP_HOST#' 
	</cfquery>
	
	<cfinclude template="AuthentProcess.cfm">
	
</cfif>	 