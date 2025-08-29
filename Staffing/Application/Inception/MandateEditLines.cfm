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
<cfparam name="URL.mode" default="">

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">

<cfquery name="SearchResult" 
     datasource="AppsEmployee" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
	     SELECT   A.*, R.Description
	     FROM     EmployeeAction A, Ref_Action R
		 WHERE    A.Mission   = '#Get.Mission#'
		 AND      A.MandateNo   = '#Get.MandateNo#'
		 AND      A.ActionPersonNo is null
		 AND      R.ActionCode = A.ActionCode
		 AND      A.ActionDocumentNo IN (SELECT ActionDocumentNo FROM EmployeeActionSource)
	  	 AND      R.ActionSource != 'Assignment'
		 ORDER BY PostType
    </cfquery>
     
    <tr class="labelmedium line">
	    <td></td>
		<td></td>
	    <td class="labelit">Action</TD>
		<td></td>
		<td class="labelit">Action date</TD>
	    <td class="labelit">Requested by</TD>
		<td class="labelit">BatchNo</TD>
    </tr>
	
	<cfif searchresult.recordcount eq "0">
	
	<tr class="labelmedium"><td colspan="7" align="center"><cf_tl id="No records to show in this view"></td></tr>
	
	</cfif>
	 
   <cfoutput query="SearchResult" group="Posttype">
   
   <cfif posttype neq "">
	   <tr><td colspan="6" style="padding-left:10px" class="labelmedium">#Posttype#</td></tr>
   </cfif>
   
   <cfoutput>
         
   <tr bgcolor="F6F6F6">
   <TD style="padding-left:5px">
   
   	   <cfif url.mode neq "pdf">
	   
	     <cf_img icon="open" onclick="transform('#actiondocumentno#')">
		 
      </cfif>
	  
	</td>	
   <td>
   
     <!---
   
     <img src="#SESSION.root#/Images/pdf_small.gif"
		   alt="" 
		   onclick="PrintCustom('#actiondocumentno#')"
		   name="img3_#actiondocumentno#"
		   onMouseOver="document.img3_#actiondocumentno#.src='#SESSION.root#/Images/button.jpg'" 
		   onMouseOut="document.img3_#actiondocumentno#.src='#SESSION.root#/Images/pdf_small.gif'" 
		   width="13" 
		   height="13" 
		   border="0" 
		   align="absmiddle">
		   
		   --->
      
   </td>	
   <TD class="labelit">#Description#</TD>
   <TD class="labelit">#ActionCode# #ActionDescription#</TD>
   <TD class="labelit">#DateFormat(ActionDate, CLIENT.DateFormatShow)#</TD>
   <TD class="labelit">#OfficerFirstName# #OfficerLastName#</TD>
   <TD class="labelit">#actiondocumentno#</TD>   
   </TR>
   
   <tr><td height="1" colspan="7" class="line"></td></tr>
      
   </cfoutput>
   
   </cfoutput>
     
   </td></tr>
   
   </table>
  