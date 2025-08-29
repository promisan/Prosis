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
<cfparam name="attributes.alias"     default="AppsSystem">

<cfquery name="System" 
	 datasource="#attributes.alias#"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	 SELECT   *
	 FROM     System.dbo.Parameter	
</cfquery>  
 
<cfparam name="attributes.account"     default="">
<cfparam name="attributes.mailboxname" default="">
<cfparam name="attributes.password"    default="">

<cfset account = attributes.account>

<cfif attributes.mailboxname eq "">

		<cfquery name="User" 
			 datasource="#attributes.alias#"
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
			 SELECT   *
			 FROM     System.dbo.UserNames
			 WHERE    Account = '#Account#' 
 		</cfquery>	
	
	<cfset account  = user.MailServerAccount>	
	<cfset name     = user.MailServerAccount>
	<cfset pass     = user.MailServerPassword>		
			
<cfelse>

	<cfset account = attributes.mailboxname>	
	<cfset name    = attributes.mailboxname>
	<cfset pass    = attributes.Password>		
		
	
</cfif>

<!--- check if account exists --->


<cfif System.ExchangeServer neq "" and name neq ""> 

<cftry>
  	 	 
	  <cfexchangeconnection action="OPEN"
	           connection    = "ConExch"
	           server        = "#System.ExchangeServer#"
	           username      = "#Account#"
	           mailboxname   = "#Name#"
	           password      = "#Pass#"
	           protocol      = "https"
			   serverversion = "#System.ExchangeServerVersion#">
	 
	  <cfif attributes.action eq "create">
	    
	   <cfexchangetask action="create" 
	      	   connection = "ConExch" 
		       task       = "#attributes.task#"
		       result     = "exchangeid"> 
	    
	   <CFSET Caller.exchangeid = exchangeid>
	      
	  <cfelseif attributes.action eq "modify">
	  
	  	    <cftry>
	           
		   	  <cfexchangetask action="modify" 
	          connection="ConExch" 
	          task="#attributes.task#"
	          uid="#attributes.uid#"> 	
			  
			   <cfcatch></cfcatch>  		   
			   
		   </cftry>	     
	        
	  <cfelse>
	  
	        <cftry>	  
	   		<cfexchangetask action="delete" connection="ConExch" uid="#attributes.uid#"> 	    
		    <cfcatch></cfcatch> 	   			
		    </cftry>	  
	     
	  </cfif> 
	  
	  <cfexchangeconnection action="close" connection="ConExch">    
	  
 <cfcatch>
 	 
     <CFSET Caller.exchangeid = "">
		 
 </cfcatch>
	  
 </cftry>
  
</cfif>

