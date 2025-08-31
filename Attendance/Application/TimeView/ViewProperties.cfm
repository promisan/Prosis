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
<cfquery name="class" 
  datasource="AppsEmployee" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
	SELECT   *
	FROM     Ref_TimeClass
	WHERE    ShowInAttendance = 1
	ORDER BY ListingOrder
</cfquery>		

<table width="100%" border="0" align="center">
<tr><td style="padding:10px">	
									
	<table width="100%" border="0" align="center">
	
	<tr class="line"><td><cf_tl id="Legend"></td></tr>
		
		<cfoutput query="class">
		<tr class="labelit" style="height:25px">
		   <td align="center" style="width:80%" bgcolor="#viewcolor#">#DescriptionShort# [#left(Description,1)#]</td>
		</tr>   
		</cfoutput>		
		</tr>
	</table>

</td></tr>	
</table>
				
				