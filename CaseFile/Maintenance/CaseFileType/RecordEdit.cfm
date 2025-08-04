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
<cfparam name="url.idmenu" default="">

<cf_screentop height="100%" 
			  label="Maintain Case File Item" 
			  scroll="Yes" 
			  layout="webapp" 
			  banner="gradient" 
			  menuAccess="Yes" 
			  jquery="yes"
			  systemfunctionid="#url.idmenu#">

<cfajaximport tags="cfform">

<cfquery name="Get" 
datasource="AppsCaseFile" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ClaimType
	WHERE  Code = '#URL.ID1#'
</cfquery>


<!--- edit form --->

<table width="94%" cellspacing="0" cellpadding="0" align="center">
	
	 <cfoutput>
	 <TR>
		 <TD width="100%" colspan="2">
		 	<cfdiv id="editheader" bind="url:RecordEditHeader.cfm?id1=#Get.Code#">
		 </TD>  
	 </TR>
	
	<tr><td colspan="2" class="line"></td></tr>
	<tr><td colspan="2" id="mainEdit">
		<cfinclude template="RecordEditTab.cfm">
	</td></tr>
		
    </cfoutput>
    	
</TABLE>
