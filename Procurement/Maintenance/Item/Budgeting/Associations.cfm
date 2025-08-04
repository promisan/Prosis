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
	FROM   ItemMaster
	WHERE  Code = '#URL.ID1#'
</cfquery>

<cfoutput>
	
	<table width="100%" align="center">
		
		<tr><td>
		
		<table width="95%" align="center" class="formpadding">
		
		<tr><td class="labelmedium">#get.Code# #get.Description#</td></tr>
		
		<tr><td colspan="2" class="line"></td></tr>
		
		<tr><td colspan="2" style="height:39px;font-size:23px" class="labellarge"><cf_tl id="Procurement Request"></td></tr>
		
		<TR>		
		
			<td style="padding-left:4px" class="labelmedium"><cf_tl id="Selectable Procurement Standard"></td>										 		
			<td height="25" align="right" id="associate" class="labelit">
			
			     <cfset url.entryclass = get.entryclass>
				 <cfset url.initial = "yes">
				 
				 <cfinclude template="EntryClassSelect.cfm">
				 						
			</td>
			
		</tr>	
		
		<tr><td colspan="2" class="line"></td></tr>
			
		<tr>	
			
		    <td colspan="2">
				<cf_securediv bind="url:#link#" id="l#url.id1#_standard">
			</td>
					
		</TR>
			
		<tr><td height="4"></td></tr>
		
		<tr><td colspan="2" style="height:39px;font-size:23px" class="labellarge"><cf_tl id="Budget Requirement Definition"></td></tr>
		
		<TR>										
		 
			<cfset link = "#SESSION.root#/Procurement/Maintenance/Item/Budgeting/RecordObject.cfm?itemmaster=#URL.ID1#">
			
			<td class="labelmedium" style="padding-left:5px">a.<cf_tl id="Selectable under Object of Expenditure"></b></td>
			
			<td height="25" align="right" class="labelit">
				
				   <cf_tl id="Object of Expenditure" var="vObjectTitle">
				
				   <cf_selectlookup
				    class    = "Object"
				    box      = "l#URL.ID1#_object"
					title    = "#vObjectTitle#"
					icon     = "insert.gif"
					link     = "#link#"								
					dbtable  = "Procurement.dbo.ItemMasterObject"
					des1     = "ObjectCode">
							
			</td>
			
		</tr>
		
		<tr><td colspan="2" class="line"></td></tr>
		
		<tr>				
	    <td colspan="2" style="padding-left:5px"><cf_securediv bind="url:#link#" id="l#url.id1#_object"></td>					
		</TR>
		
				<tr><td height="4"></td></tr>
		
		<cfif get.BudgetTopic eq "Standard">
			
			<tr><td colspan="2" style="padding-left:5px" class="labelmedium">b.<cf_tl id="Requirement detail/matrix list">:</u> 
		      	  <A href="javascript:ptoken.navigate('Budgeting/List.cfm?Code=#get.code#&ID2=','list')">
						 [<cf_tl id="add new">]</a>
				 </td>
			</tr>
		
			<tr><td colspan="2" class="line"></td></tr>		
			<tr><td colspan="2" style="padding-left:5px"><cf_securediv id="list" bind="url:Budgeting/List.cfm?code=#get.code#"/></td></tr>		
						
		<cfelse>
		
			<tr><td colspan="2" style="padding-left:5px" class="labelmedium"><cf_tl id="Requirement detail item list">: <b>#get.BudgetTopic#</b> </td></tr>
			
		</cfif>
		
		<tr><td height="4"></td></tr>
				
		<tr><td colspan="2" style="padding-left:5px" class="labelmedium">c.<cf_tl id="Item Master Ripple effect">:</u> 
		      	  <A href="javascript:ptoken.navigate('Budgeting/RecordRipple.cfm?Code=#get.code#&ID2=&mode=add','ripple')">[<cf_tl id="add new">]</a>
			 </td>
		</tr>
		
		<tr><td colspan="2" class="line"></td></tr>
		
		<tr>	 
		    <td colspan="2" style="padding-left:5px"><cf_securediv id="ripple" bind="url:Budgeting/RecordRipple.cfm?code=#get.code#"></td>
		</tr>
					
		</table>
		
		</td></tr>
	
	</table>

</cfoutput>