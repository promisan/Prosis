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

<cfquery name="Get" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_ParameterMission
	WHERE Mission = '#URL.Mission#' 
</cfquery>

<!-- <cfform> -->
<table width="95%" cellspacing="0" cellpadding="0" align="center">

		<tr>
		
    	<td class="labelmedium" style="padding-left:5px">Prefix: <font color="FF0000">*</font></b></td>
	    <TD>
		
	  	   <cfinput type="Text"
	       name="MissionPrefix"
	       value="#get.MissionPrefix#"
	       message="Please enter a mission prefix"
	       required="Yes"
	       visible="Yes"
		   onchange="ColdFusion.navigate('ParameterSubmit.cfm?mission=#url.mission#','save','','','POST','general')"
	       enabled="Yes"
	       size="4"
	       maxlength="4"
	       class="regularxl"
	       style="text-align: center;">
		 
	   </TD>
		
	   <td class="labelmedium" style="padding-left:5px">Default EMail:</b></td>
	   <TD>
	   
	  	   <cfinput type="Text"
	       name="DefaultEMailAddress"
	       value="#get.DefaultEMailAddress#"
	       message="Please enter a default eMail Account"
	       validate="email"
		   onchange="ColdFusion.navigate('ParameterSubmit.cfm?mission=#url.mission#','save','','','POST','general')"
	       required="Yes"
	       size="30"
	       maxlength="40"
	       class="regularxl"
	       style="text-align: center;">
		 
		</TD>
		</tr>
			
</table>		

<!-- </cfform> -->	