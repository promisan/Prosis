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
<cftry>
 <cfquery name="Delete" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			DELETE FROM UserPivotTemp
			WHERE  Account   = '#SESSION.acc#' 
 </cfquery>
 
 <cfquery name="INSERT" 
			datasource="AppsSystem" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO UserPivotTemp
			(ControlId, 
			 Account, 
			 DataSource, 
			 TableName, 
			 Node,
			 Frame,
			 Filter, 
			 sAF, sAV, sAS, 
			 sBF, sBV, sBS, 
			 <!---  sCF, sCV, sCS, --->
			 <!---  sDF, sDV, sDS, --->
 			 sYF, sYV, sYS, 
			 sXF, sXV, sXS)
			VALUES
			('#URL.Controlid#',
			 '#SESSION.acc#',
			 '#URL.alias#',
			 '#URL.table#',
			 '#URL.node#',
			 'Pivot',
			 '#URL.condition#',
			 '#URL.AF#', '#URL.AV#', '#URL.AS#',
			 '#URL.BF#', '#URL.BV#', '#URL.BS#',
			 <!--- '#URL.CF', '#URL.CV#', '#URL.CS#', --->
			 <!--- '#URL.DF', '#URL.DV#', '#URL.DS#', --->
			 '#URL.FF#', '#URL.FV#', '#URL.FS#',
			 '#URL.XF#', '#URL.XV#', '#URL.XS#')
 </cfquery>
	 
	 <cfcatch>
	 		
			 <cf_message message="Problem, please reload your analysis set first">
	 		 <cfabort>
			 
	 </cfcatch>
 
 </cftry>

  
 <cfset url.av = replace(url.av," ","+")>
	 
 <cfset filter = "">
 
 <cfif URL.AF neq "" and URL.AV neq "">
    <cfset filter = "#filter# AND #URL.AF# = ^#URL.AV#^">
 </cfif>
	 
 <cfif URL.BF neq "" and URL.BV neq "">
    <cfset filter = "#filter# AND #URL.BF# = ^#URL.BV#^">
 </cfif>
 
 <!---
 <cfif URL.CF neq "" and URL.CV neq "">
    <cfset filter = "#filter# AND #URL.CF# = ^#URL.CV#^">
 </cfif>
 --->
	 
 <cfif URL.FF neq "" and URL.FV neq "">
    <cfset filter = "#filter# AND #URL.FF# = ^#URL.FV#^">
 </cfif>
	 
 <cfif URL.XF neq "" and URL.XF neq "">
    <cfset filter = "#filter# AND #URL.XF# = ^#URL.XV#^">
 </cfif>
 	 
 <!--- update pivot working set : I dont' think this is still needed anymore --->
 
 <cfquery name="Update" 
		datasource="AppsSystem" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		UPDATE UserPivot
		SET TableFilter = '#preserveSingleQuotes(filter)#' 
		WHERE ControlId = '#URL.Controlid#'
 </cfquery>

 
 <!--- content goes into a window dialog --->
 
 <cf_screentop height="100%" 
               html="Yes" 
			   scroll="No" 
			   band="No" 
			   bannerheight="45" 
			   label="Analysis" 
			   option="Slice and dice selected data"
			   layout="webapp" 
			   banner="gradient">
  
 <script language="JavaScript">
 function bck() {
     detail.location = "CrossTabDetail.cfm?id=2"   
	 document.getElementById("back").className = "hide" 
	 document.getElementById("back1").className = "hide" 
   }
  
 </script>
 
 <table width="100%" height="100%" cellspacing="0" cellpadding="0">
 <tr class="hide" id="back"><td height="26" align="center">
	 <input type="button" name="Back" id="Back" value="Back" onclick="bck()" class="button10g">
	 <input type="button" name="Close" id="Close" value="Close" onclick="window.close()" class="button10g">
 </td></tr>
 <tr class="hide" id="back1"><td height="1" bgcolor="silver"></td></tr>
 
 <tr><td height="100%">  	
  	 <cfinclude template="CrossTabDetail.cfm">	 
 </td></tr>
   
 </table>
 
 <cf_screenbottom layout="webapp">
	
	
	
	
	