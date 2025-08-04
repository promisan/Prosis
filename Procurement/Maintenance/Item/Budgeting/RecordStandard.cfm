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

<cfparam name="url.action" default="">

<cfif url.action eq "Insert">

	<cftry>
	
		<cfquery name="Insert" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO ItemMasterStandard
			    (ItemMaster,
				 StandardCode)
			VALUES
			  ('#URL.ItemMaster#',
				'#URL.StandardCode#') 
		</cfquery>
		
		<cfcatch></cfcatch>
		
	</cftry>
		
<cfelseif url.action eq "delete">	

	<cfquery name="Delete" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  DELETE FROM ItemMasterStandard
		  WHERE ItemMaster  = '#url.ItemMaster#'
		  AND   StandardCode   = '#URL.StandardCode#'
	</cfquery>
		
</cfif>

	<cfquery name="Object" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  SELECT M.*
		  FROM   ItemMasterStandard U, Ref_Standard M
		  WHERE  U.ItemMaster = '#URL.ItemMaster#' 
		  AND    U.StandardCode = M.Code
	</cfquery>
	
   <table width="99%" align="center" border="0" cellspacing="0" cellpadding="0" class="navigation_table">			
      
   <cfinvoke component="Service.Presentation.Presentation" 
     		   method="highlight"  returnvariable="stylescroll"/>	
		   
   <cfoutput query="Object">
   	   
	   <tr class="navigation_row line labelmedium">
	   
	   	  <td height="17" width="24">#currentrow#.</td>
	      <td width="80">#Code#</td>		  
		  <td width="60%">#Description#</td>	
		  <td width="90">#DateFormat(dateExpiration,CLIENT.DateFormatShow)#</td> 
		   
		  <td style="padding-top:4px;padding-right:4px" align="right">
			     <cf_img icon="delete" onclick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/Procurement/Maintenance/Item/Budgeting/RecordStandard.cfm?action=delete&ItemMaster=#URL.ItemMaster#&StandardCode=#Code#','l#url.ItemMaster#_standard');">
		  </td>
		  
	   </tr>  
           
   </CFOUTPUT> 
   
   </table>
   
<cfset AjaxOnLoad("doHighlight")>	   
      