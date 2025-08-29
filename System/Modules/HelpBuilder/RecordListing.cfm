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
<cfparam name="URL.ID"               default="">
<cfparam name="URL.SystemFunctionId" default="">

<cfif url.systemfunctionid neq "">

	<cfquery name="get"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  * 
	    FROM    Ref_ModuleControl 
		WHERE   SystemFunctionId   = '#URL.SystemFunctionId#'		
	</cfquery>	
	
	<cfquery name="Project"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *
	    FROM    HelpProject 
		WHERE   SystemModule = '#get.SystemModule#'		
	</cfquery>	
	
	<cfif Project.recordcount eq "0">
	
		<cfquery name="Add"
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    INSERT INTO HelpProject
			(ProjectCode, ProjectName, SystemModule, OfficerUserId, OfficerLastName, OfficerFirstName)
			VALUES ('#get.SystemModule#','#get.SystemModule#','#get.SystemModule#','#session.acc#','#session.last#','#session.first#')		
		</cfquery>
	
		<cfquery name="Project"
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT  *
		    FROM    HelpProject 
			WHERE   SystemModule = '#get.SystemModule#'		
		</cfquery>	
	
	</cfif>
	
	<cfquery name="SearchResult"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
		FROM     HelpProjectTopic
		WHERE    SystemFunctionId  = '#url.systemfunctionid#'	
		ORDER BY TopicCode,
		         LanguageCode,
				 ListingOrder
	</cfquery>
	
	<cfset url.class = "General">
	
<cfelse>
	
	<cfquery name="Project"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT  *
	    FROM    HelpProject 
		WHERE   SystemModule = '#URL.module#'
	</cfquery>	
	
	<cfquery name="SearchResult"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
		FROM     HelpProjectTopic
		WHERE    ProjectCode  IN (SELECT ProjectCode 
		                          FROM   HelpProject 
					 		      WHERE  SystemModule = '#URL.module#')
		AND      TopicClass  = '#URL.Class#' 
		ORDER BY TopicCode,
		         LanguageCode,
				 ListingOrder
	</cfquery>

</cfif>


<!--- refresh button to be called from outside removed hasnno 22/9
<cfoutput>
	<input type="hidden" id="refreshbutton" 
	  onClick="javascript:ColdFusion.navigate('../HelpBuilder/RecordListing.cfm?systemfunctionid=#url.systemfunctionid#','contentbox1')">
</cfoutput>
--->

<table width="96%" align="center">

	<tr class="labelmedium2"><td colspan="2" style="padding-left:7px">
		
		<cfif Searchresult.recordcount eq "0">
				
		    <cfoutput>		
			    <cfif project.recordcount gte "1">
			    <a href="javascript:helpedit('#Project.SystemModule#','#Project.ProjectCode#','#url.class#','','#url.systemfunctionid#')">Add Help topic</a>
				</cfif>
			</cfoutput>
			
		<cfelse>
			
			<table width="100%" align="center" class="navigation_table">
			
				<tr><td colspan="7" style="height:40px;font-weight:200;font-size:21px" class="labelmedium">
								
					<cfoutput>
						<cfif project.recordcount gte "1"><a href="javascript:helpedit('#Project.SystemModule#','#Project.ProjectCode#','#url.class#','','#url.systemfunctionid#','#systemfunctionid#')">Add Help Topic</cfif>
					</cfoutput>
						
				</td></tr>
				
				<tr class="labelmedium2 line">
					<td></td>
					<td></td>
					<td><cf_tl id="Name"></td>
					<td><cf_tl id="Code"></td>
					<td><cf_tl id="Label"></td>
					<td><cf_tl id="Language"></td>
					<td><cf_tl id="Status"></td>
				</tr>
				
				<cfoutput query="SearchResult">	
				  	   			  
				  	<tr class="navigation_row labelmedium2 line">			   		   
					    <td width="10"></td>
						<td width="3%" style="padding-left:4px;padding-top:1px">			
							<cf_img icon="open" navigation="yes" onClick="helpedit('#Project.Systemmodule#','#ProjectCode#','#url.class#','#TopicId#','#systemfunctionid#')">			
						</td>	
						<td width="30%"><cfif len(TopicName) gt "50">#left(TopicName,50)#..<cfelse>#TopicName#</cfif></TD>
						<td width="8%">#TopicCode#</TD>
						<td width="40%">#UITextHeader#</TD>
						<td width="10%">#LanguageCode#</TD>
						<td style="padding-right:4px" width="8%"><cfif len(UITextAnswer) lt 20><font color="FF0000">Pending</font></cfif></td>						
					</tr>			
										
				</cfoutput>
		
			</table>
		
		</cfif> 
	
		</td>
	</tr>

</TABLE>

<cfset ajaxonload("doHighlight")>
