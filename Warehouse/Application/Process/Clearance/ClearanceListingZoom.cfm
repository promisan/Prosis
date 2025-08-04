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




