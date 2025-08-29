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
<cf_screentop jQuery="Yes" html="No" scroll="Yes">


<HTML><HEAD>
	
	<cfoutput>
	
	<script>
	
	function reloadForm(page) {
	    window.location="RecordListing.cfm?Page=" + page; 
	}
	
	function recordadd(grp) {
	    window.open("RecordAdd.cfm?idmenu=#url.idmenu#", "Add", "left=80, top=80, width=690, height=735 toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function collectionedit(id1) {
	    window.open("RecordEdit.cfm?idmenu=#url.idmenu#&ID1=" + id1, "Edit", "left=80, top=80, width=690, height=735, toolbar=no, status=yes, scrollbars=no, resizable=no");
	}
	
	function scheduleradd(id) {
		window.open("../../Scheduler/RecordEdit.cfm?collectionid=" + id, "Edit", "left=80, top=80, width=730, height=795, toolbar=no, status=yes, scrollbars=no, resizable=no");	   
	 }
	
	</script>	

	</cfoutput>
</HEAD>

<cfquery name="Param" 
	datasource="AppsInit">
		SELECT * 
		FROM Parameter
		WHERE HostName = '#CGI.HTTP_HOST#' 
</cfquery>

<!--- retrieve collections --->

<cftry>

   <cfcollection action="LIST" name="CollectionSOLR"   engine="solr">
      
   <cfcatch></cfcatch>

</cftry>

<cftry>

   <cfcollection action="LIST" name="CollectionVerity" engine="verity">
 
   <cfcatch></cfcatch>

</cftry>

<body>

<table width="100%" border="1" frame="hsides" cellspacing="0" cellpadding="0">
 
<cfset Page         = "0">
<cfset add          = "1">
<cfset Header       = "Award">

<cfinclude template="../../Parameter/HeaderParameter.cfm"> 
 
<tr><td colspan="2">

<table width="97%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

<cfquery name="CollectionList" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
   SELECT   *
   FROM     Collection  
   ORDER BY Created 
</cfquery>

<tr class="labelmedium line">   
    <td width="23"></td>
	<td>Status</td>	
    <td>Name</td>	
	<td>Server</td>
	<!---
	<td>Engine</td>
	--->
	<td>Module</td>
	<!---
	<td>Path</td>
	--->
	<td>Lang</td>
    <td>Cat</td>	
	<td>Docs</td>
	<td>Updated</td>
	<td>Limit</td>
	<td>Timestamp</td>
    <td align="left">Officer</td>
    <td align="left">Date</td>
</tr>

<cfoutput query="CollectionList">
	
        <!--- create a menu entry --->	   
			          
		<cf_ModuleInsertSubmit
		   SystemModule      = "#systemmodule#" 
		   FunctionClass     = "Search"
		   FunctionName      = "Collection #collectionname#" 
		   MenuClass         = "Collection"
		   MenuOrder         = "5"
		   MainMenuItem      = "1"
		   FunctionTarget    = "_new"
		   ApplicationServer = "#applicationserver#"
		   FunctionMemo      = "Extended data search"
		   FunctionDirectory = "System/Collection/"
		   FunctionPath      = "Search.cfm"
		   FunctionCondition = "id=#collectionid#"
		   FunctionIcon      = "Locate"
		   ScriptName        = ""
		   AccessUserGroup   = "1">     		   
	
		<tr><td class="linedotted" height="1" colspan="14"></td></tr>    
	    
		<tr class="labelmedium navigation_row">
		
			<td align="center">
				  <cf_img icon="edit" navigation="Yes" onclick="collectionedit('#CollectionName#');">
			</td>	
		
			<td id="#collectionid#_action">
			
			<cfif param.applicationserver eq applicationserver>
			
			    <!--- only allow for creation if action server is same as intended server --->
				
				<!--- check if collection exists --->
				
				 <cfset connection = "0">
				 
	    			<table cellspacing="0" cellpadding="0" width="100%">
					<tr>				 
				 			
					<cftry>
						
							<cfquery name="Exist" dbtype="query">
					    	   SELECT   *
							   FROM     Collection#searchengine#
							   WHERE    Name = '#lcase(collectionname)#'		   
							</cfquery>
							
							<cfset connection = "1">
							
							<cfif exist.recordcount eq "0">
							
							<td>
				    			<img src="#SESSION.root#/images/create.gif" 
					    		  name="img1_#currentrow#"
						 	      onMouseOver="document.img1_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
							      onMouseOut="document.img1_#currentrow#.src='#SESSION.root#/Images/create.gif'"
							      alt="Create Collection" 
							      border="0" 
							      onclick="ColdFusion.navigate('CollectionAction.cfm?currentrow=#currentrow#&action=create&collectionid=#collectionid#','#collectionid#_action')">
							  
							  </td>
							
							<cfelse>
							
							  <td>
							    <img src="#SESSION.root#/images/schedule.gif" 
								  name="img2_#currentrow#"
								  onMouseOver="document.img2_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
								  onMouseOut="document.img2_#currentrow#.src='#SESSION.root#/Images/schedule.gif'"
								  alt="Schedule" 
								  border="0" 
								  onclick="scheduleradd('#collectionid#')">
							  
							  </td>		
							  	
							  <td>
								  <img src="#SESSION.root#/images/optimize.png" 
								  name="img3_#currentrow#"
								  onMouseOver="document.img3_#currentrow#.src='#SESSION.root#/Images/button.jpg'" 
								  onMouseOut="document.img3_#currentrow#.src='#SESSION.root#/Images/optimize.png'"
								  alt="Optimize Collection" 
								  height="16"
								  border="0" 
								  onclick="ColdFusion.navigate('CollectionAction.cfm?currentrow=#currentrow#&action=optimize&collectionid=#collectionid#','#collectionid#_action')">
							  
							  </td>			  
							  
							</cfif>				   
					
					    <cfset connection = "1">
					
					<cfcatch>
					
					   <cfset connection = "0">
					
					</cfcatch>
					
				</cftry>
				
				 </tr>
				</table>
							
			</cfif>
			
			</td>		
			
			<td>#CollectionName#</td>	
			<td>#ApplicationServer#</td>
			<!---
			<td>#SearchEngine#</td>
			--->
			<td>#SystemModule#</td>
			<!---
			<td>#CollectionPath#</td>
			--->
			<td>#LanguageCode#</td>	
			<td><cfif CollectionCategories eq 1>Yes<cfelse>No</cfif></td>			
			<td align="right"><cfif param.applicationserver eq applicationserver and connection eq "1">#Exist.doccount#</cfif></td>
			<td><cfif param.applicationserver eq applicationserver and connection eq "1">#dateformat(Exist.LastModified,CLIENT.DateFormatShow)# #timeformat(exist.LastModified,"HH:MM")#</cfif></td>
			<td>#IndexAttachmentLimit#</td>
			<td>#dateformat(IndexTimestamp,CLIENT.DateFormatShow)#</td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#Dateformat(Created, "#CLIENT.DateFormatShow#")#</td>
	    </tr>	 
	
</CFOUTPUT>	

</table>

</td>

</table>

</BODY></HTML>
