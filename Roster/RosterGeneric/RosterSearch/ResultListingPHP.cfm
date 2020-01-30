   
<HTML><HEAD>
    <TITLE>PHP Generation</TITLE>
    <link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
</HEAD>
   
    <cfquery name="Search" 
      datasource="AppsSelection" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
	  SELECT *
	  FROM RosterSearch 
	  WHERE  SearchId = '#URL.ID1#'	 
	 </cfquery>	
	 
	 <cfquery name="Identify" 
      datasource="AppsSelection" 
      username="#SESSION.login#" 
      password="#SESSION.dbpw#">
	  SELECT *
	  FROM RosterSearchResult 
	  WHERE  SearchId = '#URL.ID1#'
	  AND Status = '1'
	 </cfquery>	
	 
	  <cfif Identify.recordcount gt "10">
      <cf_message message = "You are not allowed to prepare more than 10 PHP's at the same time. Operation aborted."
       return = "close">
       <cfabort>
     </cfif>
 
     <cf_wait1>
	 
	 <cfflush>
 	
	<cfoutput>	  
		
	<cfquery name="Owner" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  *
	FROM   Ref_ParameterOwner
	WHERE Owner = '#Search.Owner#'
	</cfquery>
	
	<cfset FileNo = round(Rand()*100)>	
	
	<cfset url.RosterQueryId = URL.ID1>

	<cfif Owner.PathHistoryProfile eq "">	
	    <cfinclude template="../../PHP/PDF/PHP_Combined_List.cfm">						
	<cfelse>	
	    <cfinclude template="../../../Custom/#Owner.PathHistoryProfile#">		    			
	</cfif>
	
	<script>
		window.location = "#SESSION.root#/cfrstage/user/#SESSION.acc#/php_#fileno#.pdf?ts="+new Date().getTime()
	</script>

</cfoutput>