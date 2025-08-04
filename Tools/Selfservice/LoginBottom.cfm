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

<cfparam name="Attributes.graphic" default="Yes">
<cfoutput>

<cfset image = "#SESSION.root#/tools/selfservice/LoginImages">
  
  </td>
   <td bgcolor="FFFFFF">&nbsp;</td>
   <td><img src="#image#/spacer.gif" width="1" height="10" border="0" alt="" /></td>
  </tr>    
  
   <tr>
	    <td colspan="7" height="16" align="center" bgcolor="FFFFFF">	  
		</td>
	    <td><img src="#image#/spacer.gif" width="1" height="2" border="0" alt="" /></td>
   </tr>
     
  <cfquery name="Link"
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
		FROM PortalLinks L,Ref_ModuleControl R
		WHERE L.SystemFunctionId = R.SystemFunctionId	
		AND R.SystemModule   = 'SelfService'
	    AND R.FunctionClass  = 'SelfService'
		AND R.FunctionName = '#Attributes.FunctionName#'
		ORDER BY ListingOrder
	</cfquery>
  
  <tr>
   <td colspan="7" background="#image#/promisan1.jpg" align="right" style="color:white; height:25">
   
    <cfif link.FunctionMemo neq "">
   	#Link.FunctionMemo#
	<cfelse>
	#SESSION.author#
	</cfif>
	&nbsp;
	</td>
   <td><img src="#image#/spacer.gif" width="1" height="21" border="0" alt="" /></td>
  </tr>
  <!---
  <tr>
   <td colspan="9" bgcolor="d0d0d0"></td>
   <td><img src="#image#/spacer.gif" width="1" height="10" border="0" alt="" /></td>
  </tr> 
   --->
</table>
</cfoutput>
 
</center>
</body>
</html>