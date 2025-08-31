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
<cfoutput>
<script>

 function back() {  
  window.location = "#SESSION.root#/Roster/RosterGeneric/RosterSearch/Search4.cfm?mode=#url.mode#&docno=#url.docno#&ID=#URL.ID1#"  
  }
  
</script>
</cfoutput>

<cf_screentop height="100%" scroll="Yes" html="No" jquery="yes">

    <cfquery name="SearchAction" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT *
	  FROM RosterSearch
	  WHERE SearchId = '#URL.ID1#'
	</cfquery>
	
    <cfquery name="SearchResult" 
	datasource="AppsSelection" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT count(*) as Total
	  FROM  RosterSearchResult R
	  WHERE R.SearchId = #URL.ID1#
    </cfquery>	
	
<cfset vColorlist = "##5DB7E8,##E8875D,##E8BC5D,##E85DA2,##5DE8D8,##CCCA6A,##339AFA,##66AC6A,##999A9A,##FFFA9A,##996AFA">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">

   <tr>
    <td height="20" style="padding-left:5px;" class="labelmedium" id="printTitle">
	
    	<cfoutput>
		<cf_tl id="Search">: <b>#SearchAction.OfficerFirstName# #SearchAction.OfficerLastName#</b> &nbsp;<cf_tl id="Date">: <b>#DateFormat(SearchAction.Created)#</b>
    	</cfoutput>
				
		<cfoutput><cf_tl id="#SearchAction.Description#"> &nbsp;<cf_tl id="Matching candidates">: <b>#SearchResult.total#</b> </cfoutput>
      	   		
	</td>
	
	 <td height="24" align="right" bgcolor="#ffffff">
		<table>
			<tr>
				<td style="padding-top:6px;">
					<button name="Prior" class="button10g" style="width:100px;" value="Next" type="button" onClick="back()">
     					<cf_tl id="Edit criteria">
				    </button>
				</td>
				<td style="padding-left:5px; padding-right:10px;" valign="top">
					<cf_tl id="Print" var="1">
					<cf_button2 
						mode		= "icon"
						type		= "Print"
						title       = "#lt_text#" 
						id          = "Print"					
						height		= "28px"
						width		= "30px"
						printTitle	= "##printTitle"
						printContent = ".clsPrintContent">
				</td>
			</tr>
		</table>
  </td>
  
  </tr>	
   
  <tr>
  
  <td colspan="2" class="clsPrintContent">

	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	   <td valign="top">
	  	    <cfinclude template="PieGender.cfm">
	   </td>
	   <td valign="top">
	  	    <cfinclude template="PieClass.cfm">
	   </td>
	</tr>
	<tr><td height="10"></td></tr>
	<tr><td class="linedotted" colspan="2"></td></tr>
	<tr><td height="10"></td></tr>
	<tr>   
	   <td align="center" valign="top">
	     	<cfinclude template="PieContinent.cfm">
	   </td>	
	   <td  align="center" valign="top">
	     	<cfinclude template="PieAge.cfm">
	   </td>
	</tr>
	</table>
	
	</td>
	
	</tr>
	
</table>	

</td></tr>

</table>
