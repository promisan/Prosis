
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 
<cf_wait text="Please wait while I am retrieving your actions">

<cfparam name="URL.Sorting" default=""> 

<cfif URL.Act eq "del">
   <script language="JavaScript1.2">
      window.location = "ClearanceListing.cfm" 
   </script>
</cfif>

<cfif URL.Act eq "add">
  <cfset #CLIENT.Review# = #Replace(CLIENT.Review,"-"&URL.ID, '',"All")#> 
  <cfset #CLIENT.Review# = #CLIENT.Review#&"-"&#URL.ID#> 
  
  <cfoutput>   
  <script language="JavaScript1.2">
       window.open("ClearanceListing.cfm?ID=#URL.ID#","right")
  </script>
  </cfoutput>   
  
</cfif>




