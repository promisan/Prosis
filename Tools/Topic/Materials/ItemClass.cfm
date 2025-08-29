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
<cfparam name="url.action" default="">

<cfif url.action eq "Insert">

	<cfquery name="check" datasource="AppsMaterials">
		SELECT  * 
		FROM    ItemTopic
		WHERE   ItemNo = '#url.ItemNo#'
		AND     Topic  = '#url.Topic#'
	</cfquery>
	
	<cfif check.recordcount eq "0">
	
			<cfquery name="Insert" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				INSERT INTO ItemTopic
				    (ItemNo,
					 Topic,
					 OfficerUserId,
					 OfficerLastName,
					 OfficerFirstName)
				VALUES
				  ('#URL.ItemNo#',
					'#URL.Topic#',			
					'#SESSION.acc#',
					'#SESSION.last#',
					'#SESSION.first#') 
			</cfquery>
	
	</cfif>
	
<cfelseif url.action eq "delete">	

	<cfquery name="Delete" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  DELETE FROM ItemTopic
	  WHERE  ItemNo = '#url.ItemNo#'
	  AND    Topic   = '#URL.Topic#'
	</cfquery>
		
</cfif>

<cfquery name="Items" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  SELECT M.*
	  FROM   ItemTopic U, Item M
	  WHERE  U.Topic= '#URL.Topic#' 
	  AND    U.ItemNo = M.ItemNo
	</cfquery>
	
   <table width="99%" align="center" class="navigation_table">			
     		   
   <cfoutput query="Items">
  
   <tr class="labelmedium navigation_row">
   	  <td height="17" width="20" style="padding-left:4px">#currentrow#.</td>
      <td width="60">#ItemNo#</td>
	  <td width="80%">#ItemDescription#</td>	 
	   
	  <td><A href="javascript:ptoken.navigate('#SESSION.root#/Tools/Topic/Materials/ItemClass.cfm?action=delete&Topic=#URL.Topic#&ItemNo=#ItemNo#','l#url.Topic#_item')">
		   <img src="#SESSION.root#/images/delete5.gif" height="11" width="11" alt="delete" border="0" align="absmiddle">
		  </a>
	  </td>
   </tr>          
   </CFOUTPUT> 
   
   </table>
   
   <cfset ajaxonload("doHighlight")>
      