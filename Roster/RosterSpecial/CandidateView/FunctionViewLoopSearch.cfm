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
<cfquery name="Nationality"
   datasource="AppsSelection"
   username="#SESSION.login#"
   password="#SESSION.dbpw#">
   SELECT DISTINCT Applicant.Nationality, SNation.Name
   FROM      Applicant INNER JOIN
             System.dbo.Ref_Nation SNation ON Applicant.Nationality = SNation.Code
   WHERE     (Applicant.PersonNo IN
             (SELECT DISTINCT PersonNo
              FROM userQuery.dbo.#SESSION.acc#CandidateTmp#FileNo# A))
</cfquery>	 
	               
<table width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">
     	 		  	  
	  <tr id="more" class="regular">
	  
	      <td height="40">
		  
		  <table width="98%" border="0" cellspacing="0" cellpadding="0" bordercolor="silver" class="formpadding">
		  
		    <tr><td height="100%">
		  
				<table width="100%" height="100%"  border="0" bgcolor="ffffff">
				
				<tr><td height="8"></td></tr> 
				<tr><td class="labelmedium" style="padding-right:4px">Search criteria:&nbsp;</b></td>
				  <td><input type="text" name="search" class="regularxl" id="search" size="40" maxlength="40"></td>
				  <td colspan="2" rowspan="2" align="right">
				</tr>
				
				<tr><td height="4"></td></tr> 
				<tr><td class="labelmedium" style="padding-right:4px">Nationality:&nbsp;</b></td>
				  <td>
				  <select name="nation" id="nation" class="regularxl">
				   <option value="all" selected></option>
				   <cfoutput query="Nationality">
				     <option value="#Nationality#">#Name#</option>
				   </cfoutput>
				  </select>
				</tr>
				<tr><td height="4"></td></tr> 
				
				<tr>
				<td class="labelmedium" style="padding-right:4px">Advanced:&nbsp;</b></td>
				<td class="labelmedium"><input type="checkbox" id="option" name="option" value="1" checked> Use word variants</td>
				
				<tr><td height="4"></td></tr> 						
				<tr><td height="30"></td>
				  <td>
				    <input type="button" name="name"    value="Name"    class="button10g" style="width:130px;height:24" onClick="search('name','#total#')">
					<input type="button" name="indexno" value="IndexNo" class="button10g" style="width:130px;height:24" onClick="search('indexno','#total#')">
				  </td>
				</tr>
							  	 
				</table>
				  
		      </td></tr>	
				  
		  </table>		  
		
		  </td>
	 </tr>
	   
	 <tr id="dmore">
	  	<td style="height:90%" id="imore" align="center"></td>
	 </tr>
   
  </table>
	