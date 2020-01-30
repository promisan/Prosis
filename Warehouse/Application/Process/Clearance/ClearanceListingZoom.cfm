
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 

<cf_tl id="Please wait while I am retrieving your actions" var="1">

<cf_wait text="#lt_text#">

<cfparam name="URL.act" default="add">
<cfparam name="URL.Sorting" default=""> 

<cfif URL.Act eq "del">
   <script language="JavaScript1.2">
      window.location = "Listing.cfm" 
   </script>
</cfif>

<cfif URL.Act eq "add">
  <cfset CLIENT.Review = replace(CLIENT.Review,"-"&URL.ID, '',"All")> 
  <cfset CLIENT.Review = "#CLIENT.Review#-#URL.ID#"> 
  
  <cfoutput>   
  <script language="JavaScript1.2">
       window.open("Listing.cfm?idmenu=#url.idmenu#&ts="+new Date().getTime()+"&mission=#URL.Mission#&ID=#URL.ID#","portalright")
  </script>
  </cfoutput>   
  
</cfif>




