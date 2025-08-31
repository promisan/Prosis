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
<TITLE>Observation entry</TITLE>
</HEAD>

<body leftmargin="0" bgcolor="f9f9f9" topmargin="0" rightmargin="0" bottommargin="0" onLoad="window.focus()">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>"> 


<!--- headers and necessary Params for recommendations --->
<cfparam name="URL.Verbose" default="#CLIENT.Verbose#">
<cfparam name="URL.AuditId" default="">
<cfparam name="URL.ObservationId" default="">
<cfset #CLIENT.Verbose# = #URL.Verbose#>


<cf_assignId>
<cfset KeyRecommendationId=#RowGuid#>
<cfset cnt = "40">

<cfoutput>
	<form action="Recommendation/RecommendationEntry.cfm?AuditId=#URL.AuditId#&ObservationId=#URL.ObservationId#&RecommendationId=#KeyRecommendationId#" method="POST" name="recommendationentry">
</cfoutput>



<table><tr><td height="1"></td></tr>

<cfquery name="GetRecommendations" 
datasource="AppsProgram" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT *
   FROM ProgramAudit.dbo.AuditObservationRecommendation
   WHERE 	
   AuditId='#URL.AuditId#'
   and
   ObservationId='#URL.ObservationId#'
</cfquery>

<table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="silver" rules="rows">
  <tr>
  	<td height="24" valign="middle" class="top3nd">&nbsp;
	<b>Recommendations </b></td>
		
	<td class="top3nd" align="right">
		<input type="submit" name="Submit" value="   Add   " class="button7">&nbsp;
		<input class="button10p" type="reset"  name="Reset" value="  Reset  ">&nbsp;
	</td>
	
  </tr>
  
  <tr>
    <td width="100%" colspan="2">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="#111111" style="border-collapse: collapse">
	
    <TR>

       <td class="top3N">&nbsp;</td>
	   <TD height="15" class="top3N">&nbsp;Description</TD>
   	   <TD height="15" class="top3N">&nbsp;Target Date</TD>

     
   </TR>

 
   <cfoutput query="GetRecommendations">
   <cfset cnt = #cnt#+19>
   <tr>
      <td height="15" class="regular">&nbsp;&nbsp;
     	 <A HREF ="RecommendationEdit.cfm?RecommendationId=#RecommendationId#
     		 onMouseOver="document.img0_#RecommendationId#.src='#SESSION.root#/Images/button.jpg'" 
		     onMouseOut="document.img0_#RecommendationId#.src='#SESSION.root#/Images/view.jpg'">
         <img src="#SESSION.root#/Images/view.jpg" alt="" name="img0_#RecommendationId#"  width="14" height="14" border="0" align="middle">
        </a></td>
	  <td class="regular">&nbsp;<a href="javascript:EditPerson('#RecommendationId#')">#Description#</a> </td>
	  <td class="regular">&nbsp;#DateFormat(TargetDate,CLIENT.DateFormatShow)#</td>
   </tr> 	  
   <tr><td height="1" colspan="7" class="header"></td></tr>
   
   </CFOUTPUT>
   
</TABLE>
</td>
</table>

</form>




</body>

</html>