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

<CFOUTPUT>	

<cfparam name="URL.source" default="Manual">

<script language="JavaScript">

function selectall(chk) {

var count=1
while (count < 30) {
	se = document.getElementById("selected_"+count)
	if (se)	{
	ln = document.getElementById("line"+count)    
	if (chk == true) {
	     ln.className = "highLight2";
		 se.checked = true;
	} else {      
	   ln.className = "regular";
	   se.checked = false; 
	}		   
	}
    count++;
   }	
}

ie = document.all?1:0
ns4 = document.layers?1:0

function hl(itm,fld){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 
	 	 		 	
	 if (fld != false){		
	 itm.className = "highLight2";
	 }else{		
     itm.className = "regular";		
	 }
  }  
 
</script>

</CFOUTPUT>

<cfquery name="SearchResult" 
datasource="AppsSelection" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
 SELECT   A.Source, B.*, '' as CurrentAssigned
 FROM     ApplicantSubmission A INNER JOIN
          ApplicantBackground B ON A.ApplicantNo = B.ApplicantNo
		  <!---  LEFT OUTER JOIN
          Vacancy.dbo.stApplicantBackground C ON B.ExperienceId = C.ExperienceId 
     AND  C.DocumentNo = '#Object.ObjectKeyValue1#'
     AND  C.PersonNo   = '#Object.ObjectKeyValue2#' --->
 WHERE    A.PersonNo = '#url.id#' 
 AND      (B.Status <> '9') 
 AND      A.Source = '#URL.source#'
 AND      (B.ExperienceCategory NOT IN ('Miscellaneous'))
 ORDER BY B.ExperienceCategory, B.ExperienceStart DESC 
</cfquery>

<div id="dresult"></div>

<cfform action="BackgroundRelevant/BackGroundSummary.cfm?id=#url.id#&source=#url.source#" method="post" target="dresult">
  
<table width="99%" border="0" cellspacing="0" cellpadding="0"  align="center">
  
    <td width="100%" colspan="2">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
	
	<tr><td></td></tr>
    <TR>
       <td width="5%" align="center">
		   <input type="checkbox" name="selected_all" id="selected_all" value="All" onClick="selectall(this.checked);">
		   </td>
       <TD>Organization</TD>
       <TD>Function</TD>
	   <TD>From</TD>
	   <TD>To</TD>
   </TR>
   <tr><td height="1" colspan="5" class="linedotted"></td></tr>
   
   <tr><td colspan="5" height="25" align="center" style="padding:6px">
      <input type="submit" class="button10s" style="font-size:15;height:28;width:380" value="Generate Comparative Evaluation Document" name="Summary"></td></tr> 
   <tr>
  
  <tr><td height="1" colspan="5" class="linedotted"></td></tr>
   
   <cfset module = "">

   <cfoutput query="SearchResult" group="ExperienceCategory">
   
   <tr><td colspan="5" class="labelmedium"><b>#ExperienceCategory#</b></td></tr>
   <cfoutput>
   
   <cfif CurrentAssigned is ''>
      <tr bgcolor="f4f4f4" id="line#currentrow#">
   <cfelse>
      <tr class="highLight2" id="line#currentrow#">
   </cfif>   
   <td width="5%" align="center">
      <cfif CurrentAssigned is ''>
	    <input type="checkbox" id="selected_#currentrow#" name="selected" value="'#ExperienceId#'" onClick="hl(this,this.checked)">
   	  <cfelse>
        <input type="checkbox" id="selected_#currentrow#"  name="selected" value="'#ExperienceId#'" checked onClick="hl(this,this.checked)">
	  </cfif>
	  
      </TD>
      <TD class="labelit">#OrganizationName#</TD>
	  <TD class="labelit">#ExperienceDescription#</TD>
      <TD class="labelit" style="padding-right:4px">#DateFormat(ExperienceStart, CLIENT.DateFormatShow)#</td>
	  <TD class="labelit" style="padding-right:4px">#DateFormat(ExperienceEnd, CLIENT.DateFormatShow)#</TD>
   </TR>
   
   <cfif ExperienceCategory eq "Employment">
   
	<cfquery name="Detail" 
		datasource="AppsSelection" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT D.TopicValue
		FROM   ApplicantBackgroundDetail D
		WHERE  D.ApplicantNo  = '#ApplicantNo#'
		AND    D.ExperienceId = '#ExperienceId#'
		AND    D.Topic = 'BACK_01'    <!--- KRW hard coded for the moment --->
		</cfquery>					
	
		<tr><td></td><td colspan="4">#Detail.TopicValue#</td></tr>
   
   </cfif>
      
   </cfoutput>

   </CFOUTPUT>

</table>

</cfform>