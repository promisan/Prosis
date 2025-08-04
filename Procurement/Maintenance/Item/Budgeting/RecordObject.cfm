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
			INSERT INTO ItemMasterObject
			    (ItemMaster,
				 ObjectCode)
			VALUES
			  ('#URL.ItemMaster#',
				'#URL.ObjectCode#') 
		</cfquery>
		
		<cfcatch></cfcatch>
		
	</cftry>
		
<cfelseif url.action eq "delete">	

	<cfquery name="Delete" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  DELETE FROM ItemMasterObject
		  WHERE ItemMaster  = '#url.ItemMaster#'
		  AND   ObjectCode   = '#URL.ObjectCode#'
	</cfquery>
		
</cfif>

<cfquery name="Clean" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	  DELETE FROM ItemMasterObject
	  WHERE  ObjectCode NOT IN (SELECT Code FROM Program.dbo.Ref_Object)
</cfquery>

<cfquery name="Object" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		  SELECT M.*,
		  		 U.BudgetEntryInstruction
		  FROM   ItemMasterObject U, Program.dbo.Ref_Object M
		  WHERE  U.ItemMaster = '#URL.ItemMaster#' 
		  AND    U.ObjectCode = M.Code
</cfquery>
	
   <table width="99%" align="center" border="0" cellspacing="0" cellpadding="0" class="navigation_table">			
    
   <cfoutput query="Object">  
   
	   <cfset vCodeId = replace(Code," ","","ALL")>
	   <cfset vCodeId = replace(vCodeId,"-","","ALL")>
	   
	   <tr class="navigation_row line labelmedium">	   	 
		 
	      <td height="17" width="20" style="padding-left:3px">#currentrow#.</td>
	      <td width="60">#CodeDisplay#</td>
		  <td width="90">#ObjectUsage#</td>
		  <td width="70%">#Description#</td>		
		  
		   <td width="12" align="right" style="padding-top:5px;padding-left:3px">
			<cf_img icon="edit" onclick="toggleInstructions('#vCodeId#');">
		  </td>
		   <td width="12" style="padding-top:5px;padding-left:3px">
			 <cf_img icon="delete" onclick="_cf_loadingtexthtml='';ptoken.navigate('#SESSION.root#/Procurement/Maintenance/Item/Budgeting/RecordObject.cfm?action=delete&ItemMaster=#URL.ItemMaster#&ObjectCode=#Code#','l#url.ItemMaster#_object');">
		  </td>	   
	   </tr>     
	   
	   <tr class="navigation_row clsInstructions_#vCodeId#" style="display:none;">	   		
			<td width="15" valign="top" align="right">
				<img src="#session.root#/images/join.gif">
			</td>
	   		<td colspan="5" class="labelit" style="padding-top:5px;padding-right:6px;padding-bottom:4px">
			
				<form name="formBudgetingObject_#code#"> 
				
					<cf_textarea name="BudgetEntryInstruction_#code#" 
						id="BudgetEntryInstruction_#code#"  								
						resize="yes"
						height="180"	
						color="ffffff"							
						toolbar="basic" 
						onchange="updateTextArea();submitInstruction('#url.itemmaster#','#code#');">#BudgetEntryInstruction#</cf_textarea>
								
				</form>
				
			</td>
	   </tr>
	   <tr class="clsInstructions_#code#" style="display:none;">
	   		<td colspan="6" align="center" id="process_#code#" style="color:##62ACE3; font-weight:bold;" class="labellarge"></td>
	   </tr>
           
   </cfoutput> 
   
   </table>
   
   <cfset AjaxOnLoad("initTextArea")>	     
   <cfset AjaxOnLoad("doHighlight")>	 
