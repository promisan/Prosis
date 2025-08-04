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

<cfparam name="url.objectId" default="B8B31331-1018-0668-4387-3047F5235DDE">
<cfparam name="url.mode"     default="standard">

<cfquery name="Object" 
	   datasource="AppsOrganization" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		SELECT   *
		FROM     OrganizationObject
		WHERE    ObjectId = '#url.ObjectId#'	
	</cfquery>
	
<cf_screentop height="100%" busy="busy10.gif" html="No" band="No" label="#Object.ObjectReference#" jQuery="Yes">	

<cf_notescript>

<cfquery name="Entity" 
	   datasource="AppsOrganization" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_Entity
		WHERE    EntityCode = '#Object.EntityCode#'	
	</cfquery>	

<cfoutput>

	   <table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
	   
	   	<tr>				
			<td width="100%" align="right" colspan="2" style="height:50px;padding:0px">			
				<cf_viewtopmenu background="gray" label="#SESSION.welcome# Collaborator"> 			 
			</td>	 						
		</tr>
		
		<tr>
		
			<td height="26" class="labelit" style="padding-left:5px">
			
			<cfoutput>
					
				<cfif url.mode eq "embed">					
					<a href="javascript:history.go(-1)"><cf_tl id="Back"></a>	
				<cfelse>				
					<cf_tl id="Expenses/Activity sheet" var="1">
			    	<cfset tExpenses = "#Lt_text#">	 
					<font color="silver">Go to:
					 <a href="javascript:details('#url.objectid#','cost')"><font face="Verdana" size="2" color="6688aa">#tExpenses#</a>	
				</cfif>		
			
			</cfoutput>		  
			
			</td>
			
			<td align="right" style="padding-right:6px" class="labelit">
			  <font color="808080">#Entity.EntityDescription#:</font> #Object.ObjectReference# #Object.ObjectReference2#
			</td>
		
		</tr>
		
		<tr>
				
			<td height="100%" colspan="2" style="border-top:1px dotted silver;padding-left:0px;padding-right:0px;padding-bottom:0px">
			
					<iframe src="Notes/NoteViewTabs.cfm?objectid=#url.objectid#" border="0"
					   width="100%" height="100%" marginwidth="0" marginheight="0" frameborder="0">
					</iframe>
						
			</td>
		
		</tr>
		
	</table>	

</cfoutput>
