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

<cfparam name="url.id" default="6F656C64-0717-423D-AFB3-CDE8268918A9">

<cf_tl id="Financial Event" var="1">

<cfparam name="url.ajaxid" default="">
<cfparam name="url.id" default="#url.ajaxid#">

<cfquery name="Get" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
    	SELECT *
	    FROM   Event E, Organization.dbo.Organization O
		WHERE  E.OrgUnit = O.OrgUnit
		AND   EventId = '#URL.id#'
</cfquery>

<cf_screenTop jQuery="Yes" height="100%" border="0" html="No" title="#lt_text#  #get.Mission#" scroll="no" MenuAccess="Context"> 

<cfoutput>

<cf_textareascript>
<cfajaximport tags="cfdiv,cfform">
<cf_ActionListingScript>
<cf_FileLibraryScript>
<cf_DialogLedger>
<cf_PresentationScript>

<cfquery name="Object" 
datasource="AppsOrganization" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT * 
	FROM   OrganizationObject
	WHERE  ObjectKeyValue4 = '#url.id#'
	AND    Operational = 1
</cfquery>

<cf_layoutscript>

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">

	<cf_layoutarea 
          position="header"
		  size="80"
          name="controltop">	
		  
		<cf_ViewTopMenu label="Financial Event" menuaccess="context" background="blue" systemModule="Accounting">
				
	</cf_layoutarea>	
	
	<cfif Object.recordcount eq "1">	 

		<cf_layoutarea 
		    position="right" name="commentbox" minsize="30%" maxsize="30%" size="30%" overflow="yes" collapsible="true" splitter="true">
		
			<cf_divscroll style="height:99%">
				<cf_commentlisting objectid="#url.id#"  ajax="No">		
			</cf_divscroll>
			
		</cf_layoutarea>
	
	</cfif>

	<cf_layoutarea  position="center" name="box">
	
			<cfset url.ajaxid = url.id>	
			
			<cfset wflnk = "#session.root#/gledger/application/Event/EventWorkflow.cfm">
   
 			   <input type="hidden" 
		          id="workflowlink_#url.id#" 
        		  value="#wflnk#">  
			
			<table width="97%" align="center">
				<tr><td style="padding:10px"><cfinclude template="EventEdit.cfm"></td></tr>
				<tr><td style="padding:10px" id="#url.id#"><cfinclude template="EventWorkFlow.cfm"></td></tr>			
			</table>
		
	</cf_layoutarea>			
		
</cf_layout>
	
</cfoutput>
