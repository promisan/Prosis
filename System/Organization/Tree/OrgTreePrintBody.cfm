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
<cftry>
	<cfquery name="qDetails" 
	 dataSource="appsquery">
	  SELECT * 
	  FROM   dbo.#SESSION.acc#_MissionAssignment
	</cfquery>
<cfcatch>
		Please select a unit to print
	<cfabort>
</cfcatch>
</cftry>


<cfif url.OrgUnitCode eq "0">

	Print is not supported 
	<cfabort>

</cfif>

<cfparam name="URL.OrgUnitCode" default="0">
<cfparam name="URL.PostClass" default="0">
<cfparam name="URL.Fund" default="0">
<cfparam name="URL.SelectionDate" default="">

<cf_dialogOrganization>
<cf_dialogStaffing>
<cfinclude template="../../../Vactrack/Application/Document/Dialog.cfm">

<script>

function details(id) {
     
     icM  = document.getElementById(id+"Min");
     icE  = document.getElementById(id+"Exp");
     se   = document.getElementById(id);
  		 		 
	if (se.className=) {
	   	 icM.className = "regular";
	     icE.className = "hide";
         se.className  = "regular";		 
	 } else {
	 	 icM.className = "hide";
	     icE.className = "regular";
     	 se.className  = "hide";
	 }
		 		
  }  
	
ie = document.all?1:0
ns4 = document.layers?1:0
				
function hlnode(itm,fld) {		
								 	 	
	 if (fld != "normal"){
		 itm.className = "top4n";		
	 } else {
	     
	     if (itm.className != "topn") {
	         itm.className = "";		
		 }
	 }
 }		 

</script>

<style type="text/css"> 

.RegularTitle { 
	font-family : tahoma; 
	font-size : 22pt; 	
}

.RegularSubTitle { 
	font-family : tahoma; 
	font-size : 14pt; 
}


.RegularSubSubTitle { 
	font-family : tahoma; 
	font-size : 11pt; 
}
</style>

<cfinvoke component="Service.Access"  
          method="StaffingTable" 
		  mission="#URL.Mission#" 
		  returnvariable="maintain">

<!---
<cfif maintain neq "NONE">		
--->
		
	<cfquery name="qOrganization" 
	    dataSource="AppsOrganization">
		SELECT * 
		FROM   userquery.dbo.#SESSION.acc#_MissionOrganization
		WHERE  
		<cfif url.OrgUnitCode eq "0" or url.OrgUnitCode eq "">
			ParentOrgUnit is NULL or ParentOrgUnit=''
		<cfelse>
			OrgUnitCode='#url.OrgUnitCode#'
		</cfif> 	
		ORDER BY TreeOrder 
	</cfquery>
<cfoutput>	
<html xmlns="http://www.w3.org/1999/xhtml">

<head>
	<title>#SESSION.welcome# : #qOrganization.MissionName# / #qOrganization.OrgUnitName#</title>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />		
	<link rel="stylesheet" type="text/css"  href="#SESSION.root#/#client.style#"> 			
	<link rel="stylesheet" type="text/css" href="#SESSION.root#/print.css" media="print">
</head>

<body>

<cfoutput>
<table width="100%">
	<tr class="noprint"><td align="left">
	&nbsp;&nbsp;
	<img src="#SESSION.root#/images/print.gif" alt="" align="absmiddle" border="0" onclick="javascript:print()">
	<a href="javascript:print()"><font size="3" color="808080">Print</a></td></tr>
	<tr class="noprint"><td align="center"><hr style="color: Silver;"></td></tr>
	
</table>
</cfoutput>

<table width="100%">
<tr class="noprint"><td width="100%" align="left">
	<cfif URL.PostClass neq "0">#URL.PostClass# </cfif> 
</td></tr>
<tr class="noprint"><td width="100%" align="left">
	<cfif URL.Fund neq "0">#URL.Fund#</cfif>
</td></tr>
</table>

<cfloop query="qOrganization">

	<table width="100%">
		<tr><td align="center"><div class="RegularTitle">#qOrganization.OrgUnitName#</div></td></tr>
		<tr><td align="center"><div class="RegularSubTitle">#qOrganization.MissionName#</div></td></tr>
		<tr><td align="center"><div class="RegularSubSubTitle">#url.selectiondate#</div></td></tr>
		<tr><td align="center"><hr style="color: Silver;"></td></tr>
	</table>	

	<table width="100%" border="0" cellpadding="0" cellspacing="0">
	
	<tr><td height="5"></td></tr>
	<tr>	
		<cfset url.Parent="#OrgUnitCode#">
		
		<cf_OrgTreeLevel 
			nme          = "#OrgUnitName#" 
			Unit	     = "#OrgUnit#"
			Parent       = "#OrgUnitCode#" 
			Direction    = "Horizontal"
			Mode	     = "Print"
			PostClass    = "#URL.PostClass#"
			Fund         = "#URL.Fund#"
			SelectionDate = "#URL.SelectionDate#"
			ShowColumns   = "#URL.ShowColumns#">
					
	</tr>
	<tr><td height="5"></td></tr>
	<tr><td height="1" bgcolor="silver"></td></tr>
	</table>
	
	<!--- 	
	<table style="page-break-after: always;">
	   <tr><td></td></tr>
	</table>	
	--->
	
	
	<!--- print the details --->
	
	<cfif url.printDetails eq "Show">
		
		<cfif url.tree eq "Operational">

			<cfset URL.ID1 = "#OrgUnitCode#">			
			
			<cfparam name="URL.ID"               default="ORG">	
			<cfparam name="URL.ID4"               default="">    
			<cfparam name="URL.header"            default="no">
			<cfparam name="URL.act"               default="0">
				
			<cfparam name="url.locationcode"      default="">
			<cfparam name="url.orgunit1"          default="">
			<cfparam name="url.orgunitcode"       default="">
			<cfparam name="url.occgroup"          default="">
			<cfparam name="url.parent"            default="">
			<cfparam name="url.sourcepostnumber"  default="">
			<cfparam name="url.vacant"            default="">
			<cfparam name="url.name"              default="">
			<cfparam name="url.pdf"               default="1">
			<cfparam name="url.postclass"         default="">		
			<cfparam name="url.lay"               default="listing">				
			
			<cfinclude template="../../../Staffing/Application/Position/MandateView/MandateViewList.cfm">
			
		</cfif>
	
	</cfif>
		
	<table style="page-break-after: always;">
	   <tr><td></td></tr>
	</table>	

</cfloop>

</body>
</html>
</cfoutput>