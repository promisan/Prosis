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
			INSERT INTO ItemMasterFunction
			    (ItemMaster,
				 FunctionNo)
			VALUES
			  ('#URL.ItemMaster#',
				'#URL.FunctionNo#') 
		</cfquery>
		
		<cfcatch></cfcatch>
		
	</cftry>
		
<cfelseif url.action eq "delete">	

	<cfquery name="Delete" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  DELETE FROM ItemMasterFunction
		  WHERE ItemMaster  = '#url.ItemMaster#'
		  AND   FunctionNo  = '#URL.FunctionNo#'
	</cfquery>
		
</cfif>

	<cfquery name="Object" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  SELECT M.*
		  FROM   ItemMasterFunction U, Applicant.dbo.FunctionTitle M
		  WHERE  U.ItemMaster = '#URL.ItemMaster#' 
		  AND    U.FunctionNo = M.FunctionNo
	</cfquery>
	
   <table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">			
      
   <cfinvoke component="Service.Presentation.Presentation" 
     		   method="highlight"  returnvariable="stylescroll"/>	
		   
   <cfoutput query="Object">
   
	   
	   <tr #stylescroll#>
	   
	   	  <td height="17" width="24">#currentrow#.</td>
	      <td width="60">#FunctionNo#</td>		  
		  <td width="70%">#FunctionDescription#</td>	
		  <td width="90">#OccupationalGroup#</td> 
		   
		  <td><A href="javascript:ptoken.navigate('#SESSION.root#/Procurement/Maintenance/Item/RecordFunction.cfm?action=delete&ItemMaster=#URL.ItemMaster#&FunctionNo=#FunctionNo#','l#url.ItemMaster#_standard')">
			      <img src="#SESSION.root#/images/delete5.gif" 
				     height="11" 
					 width="11" 
					 alt="delete" 
					 border="0" 
					 align="absmiddle">
			  </a>
		  </td>
		  
	   </tr>  
           
   </CFOUTPUT> 
   
   </table>
      