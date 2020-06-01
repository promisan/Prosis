
<cf_screentop height="100%" html="No" scroll="Yes" jquery="Yes">

<cfparam name="URL.act" default="add">
<cfparam name="URL.Sorting" default=""> 

<cfif URL.Act eq "del">
   <script language="JavaScript1.2">
      ptoken.location('Listing.cfm') 
   </script>
</cfif>

<cfif URL.Act eq "add">

  <cfset CLIENT.Review = replace(CLIENT.Review,"-"&URL.ID, '',"All")> 
  <cfset CLIENT.Review = "#CLIENT.Review#-#URL.ID#"> 
  
  <cfoutput>   
 
  <script>  
       ptoken.location('Listing.cfm?idmenu=#url.idmenu#&ts='+new Date().getTime()+'&mission=#URL.Mission#&ID=#URL.ID#')
	  
  </script>
  </cfoutput>   
  
</cfif>




