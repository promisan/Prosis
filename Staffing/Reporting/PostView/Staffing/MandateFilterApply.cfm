<cfquery name="Filter" 
    datasource="AppsTransaction">
	SELECT     *
	FROM       stCacheFilter
	WHERE      DocumentId = '#URL.FilterId#' 
	ORDER BY   FilterField
</cfquery>
  
<cfset cat = "">
<cfset occ = ""> 
<cfset cls = ""> 
<cfset pte = ""> 
<cfset aut = ""> 
  
<cfloop query="Filter">
  
   <cfif FilterField eq "Cat">
   
     <cfif cat eq "">
	      <cfset cat = "'#FilterValue#'">
	 <cfelse>
	      <cfset cat = "#cat#,'#FilterValue#'">
	 </cfif>	  
	 
   <cfelseif FilterField eq "Occ">
   
     <cfif occ eq "">
	     <cfset occ = "'#FilterValue#'"> 
	 <cfelse>
	     <cfset occ = "#occ#,'#FilterValue#'"> 
	 </cfif>
	 
   <cfelseif FilterField eq "Cls">
   
     <cfif cls eq "">
	     <cfset cls = "'#FilterValue#'"> 
	 <cfelse>
	     <cfset cls = "#cls#,'#FilterValue#'"> 
	 </cfif> 
	 
   <cfelseif FilterField eq "Pte">
   
     <cfif Pte eq "">
	     <cfset Pte = "'#FilterValue#'"> 
	 <cfelse>
	     <cfset Pte = "#Pte#,'#FilterValue#'"> 
	 </cfif> 
	
   <cfelseif FilterField eq "Aut">
   
     <cfif aut eq "">
	     <cfset aut = "'#FilterValue#'"> 
	 <cfelse>
	     <cfset aut = "#aut#,'#FilterValue#'"> 
	 </cfif> 	 
  	 
   </cfif>
      
</cfloop>