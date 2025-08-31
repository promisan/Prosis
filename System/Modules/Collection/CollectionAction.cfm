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
<cfset url.currentrow = "1">

<cfquery name="Collection" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT   *
   FROM     Collection  
   WHERE    CollectionId = '#url.collectionid#'   
</cfquery>

<cfif collection.collectioncategories eq "1">
    <cfset cat = "yes">
<cfelse>
	<cfset cat = "no">
</cfif>

<cfif url.action eq "Create">
	
	<cfcollection action="#url.action#" 
	       engine="#collection.searchengine#"
		   path="#collection.collectionpath#"
		   categories="#cat#"
	       collection="#collection.collectionname#">
		   
<cfelse>

	<cfcollection action="#url.action#" 	      
	       collection="#collection.collectionname#">
		
</cfif>		

<cfoutput>	  

	  
	 <img src="#client.virtualdir#/images/schedule.gif" 
	  name="img2_#url.currentrow#"
	  onMouseOver="document.img2_#url.currentrow#.src='#SESSION.root#/Images/button.jpg'" 
	  onMouseOut="document.img2_#url.currentrow#.src='#SESSION.root#/Images/schedule.gif'"
	  alt="Index Collection" 
	  border="0" 
	  onclick="scheduleradd('#collectionid#')">
	  
	<img src="#client.virtualdir#/images/check_icon.gif" alt="Optimized">	   

</cfoutput>
	
		