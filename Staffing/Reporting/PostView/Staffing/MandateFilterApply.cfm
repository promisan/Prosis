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