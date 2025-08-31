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
<HTML><HEAD>
	<TITLE>Function Roster - Entry Form</TITLE>
</HEAD>
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">

<cf_PreventCache>

<cfinclude template="FunctionViewHeader.cfm">

<body onload="javascript: window.focus();">

<cfquery name="Edition" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT DISTINCT O.*, S.SubmissionEdition as Edition, S.EditionDescription, S.ExerciseClass
   FROM FunctionOrganization O, Ref_SubmissionEdition S
   WHERE S.SubmissionEdition  = O.SubmissionEdition
   AND   O.FunctionNo = '#URL.ID#'
   ORDER BY S.EditionDescription
</cfquery>

<!--- Entry form --->
<cfform action="FunctionRosterEntry.cfm?ID=#URL.ID#" method="POST" enablecab="No" name="action">

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" style="border-collapse: collapse;">
  <tr>
  	<td height="30" valign="middle" class="BannerN">&nbsp;
	<b>Roster edition</b></td>
		
	<td class="BannerN" align="right">

<INPUT class="button1" type="submit" value="&nbsp;Edit&nbsp;">&nbsp;</td>
  </tr>
  
  <tr>
    <td width="100%" colspan="2">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="#111111" style="border-collapse: collapse">
	
    <TR bgcolor="6688aa">

       <td height="20" colspan="1" class="topN">&nbsp;Edition</td>
	   <td height="20" colspan="1" class="topN">Code</td>
	   <td height="20" colspan="1" class="topN">Class</td>
	   <td height="20" colspan="1" class="topN">App#</td>
	   	   <TD height="20" class="topN">&nbsp;Organization element</TD>
	  
   </TR>

   <cfset CLIENT.recordNo = 0>
   
   <cfoutput>
   <input type="hidden" name="FunctionNo" value="#URL.ID#">
    </cfoutput>
   
   <cfoutput query="Edition">
   
   <cfquery name="Check" 
    datasource="AppsSelection" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT count(functionId) as Counted
      FROM ApplicantFunction 
	  WHERE FunctionId = '#FunctionId#'
   </cfquery>
         
    <TR class="regular">
      <td class="regular">&nbsp;&nbsp;&nbsp;#EditionDescription#</td>
	  <td class="regular">&nbsp;&nbsp;&nbsp;#Edition#</td>
	  <td class="regular">&nbsp;&nbsp;&nbsp;#ExerciseClass#</td>
	  <td class="regular">
             <cfif #Check.counted# gt 0>
                 #Check.counted#
			</cfif>
      </td>
	  <td class="regular">&nbsp;
		
	 	  	  
	  <cfquery name="OrganizationSelect" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT DISTINCT *
   FROM Ref_Organization 
   WHERE OrganizationCode = '#OrganizationCode#'
</cfquery>
	  
	  #OrganizationSelect.OrganizationDescription#
	 
	</td>
	
	 </tr> 	  
  
  <tr><td colspan="6" class="top"></td></tr>
   
   </CFOUTPUT>
     

</TABLE>
</td>
</table>

	
</CFFORM>

</BODY></HTML>