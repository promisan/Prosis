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

<cf_screentop height="100%" scroll="No" html="No" jquery="Yes" title="Miscellaneous entry" menuaccess="context">

<cfquery name="vwObject" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">	
    	SELECT *
	    FROM   OrganizationObject
		WHERE  ObjectKeyValue4 = '#URL.id1#'
		AND    ObjectKeyValue1 = '#url.id#'		
		AND    Operational = 1
</cfquery>
	
<cf_layoutscript>

<cfif vwObject.recordcount eq "1">
	<cf_textareascript>
</cfif>

<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">

	<cf_layoutarea 
          position="header"
		  size="50"
          name="controltop">	
		  
		<cf_ViewTopMenu label="Miscellaneous Cost" menuaccess="context" background="blue">
				
	</cf_layoutarea>		 

	<cf_layoutarea  position="center" name="box">
					
	     <cf_divscroll style="height:98%">		
		 		<cfset url.header = "0"> 
			     <cfinclude template="MiscellaneousEdit.cfm">	
		 </cf_divscroll>

	</cf_layoutarea>	
	
	<cfif vwObject.recordcount eq "1">
		
		<cf_layoutarea 
		    position="right" name="commentbox" minsize="20%" maxsize="30%" size="380" initcollapsed="Yes" overflow="yes" collapsible="true" splitter="true">
		
			<cf_divscroll style="height:100%">
				<cf_commentlisting objectid="#vwObject.ObjectId#"  ajax="No">		
			</cf_divscroll>
			
		</cf_layoutarea>	
	
	</cfif>	
		
</cf_layout>			  