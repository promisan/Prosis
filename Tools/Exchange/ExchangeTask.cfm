
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

