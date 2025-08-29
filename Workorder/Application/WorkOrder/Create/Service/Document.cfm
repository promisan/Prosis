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
<!--- ---------------------------------------- --->
<!--- --Contract service for OICT data entry-- --->
<!--- ---------------------------------------- --->
<!--- ---------------------------------------- --->

<cfform name="orderform" onsubmit="return false">

<!--- there can be different rates basedon the topic + unit combinations --->

<table width="100%" cellspacing="0" cellpadding="0" class="formpadding formspacing">

<tr>	
	<td height="34" class="labelmedium" width="15%"><cf_space spaces="46"><cf_tl id="Reference">:</td>
	<td>
	<table>
		 <tr><td>
		    <cfoutput>
			<input type="text" class="regularxl"
			 onchange="ptoken.navigate('#session.root#/WorkOrder/Application/WorkOrder/Create/Service/validateReference.cfm?mission=#url.mission#&serviceitem=#url.serviceitem#&reference='+this.value,'validate')" name="Reference" id="Reference" maxlength="20" style="width:100">	
			 </cfoutput>
			</td>
			<td id="validate" class="labelmedium" style="padding-left:10px"></td>
		</tr>	
	</table>
	</td>	
</tr>

<cfquery name="getPrior" 
	 datasource="AppsWorkOrder" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT TOP 1 *
		FROM  WorkOrder
		WHERE CustomerId = '#url.customerid#'
		AND   OrgUnitOwner > '0'
		ORDER BY Created DESC						  
</cfquery>		

<cfif getPrior.recordcount eq "0">
	
	<cfquery name="getPrior" 
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT TOP 1 *
			FROM  WorkOrder
			WHERE Mission = '#url.Mission#'		
			AND   OrgUnitOwner > '0'				  
			ORDER BY Created DESC
	</cfquery>		

</cfif>

<cfif getPrior.recordcount eq "1">
	
	<cfquery name="Owner" 
		 datasource="AppsOrganization" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			SELECT *
			FROM  Organization
			WHERE OrgUnit = '#getPrior.OrgUnitOwner#'						  
	</cfquery>	
		
	
	<cfparam name="OrgUnitOwner"     default="#getPrior.OrgUnitOwner#">
	<cfparam name="OrgUnitOwnerName" default="#Owner.OrgUnitName#">
		
<cfelse>

	<cfparam name="OrgUnitOwner"     default="">
	<cfparam name="OrgUnitOwnerName" default="">

</cfif>

<tr class="hide"><td id="process"></td></tr>	

<tr>
	<td  height="34" class="labelmedium2" width="15%"><cf_tl id="Owner">:</td>
	<td class="labelmedium2">
	
	 		<table>
				 <tr><td>
				       
					 <cfinput type="text" name="orgunitname1" id="orgunitname1" value="#OrgUnitOwnerName#" message="No unit selected" required="No" class="regularxxl" size="40" maxlength="80" readonly>					  
					 
					 </td>
					 
					 <td style="padding-left:2px">
					 
					 <cfoutput>		 
					 
					     <img src="#SESSION.root#/Images/search.png" alt="Select authorised unit" name="img0" 
						   onMouseOver="document.img0.src='#SESSION.root#/Images/contract.gif'" 
						   onMouseOut="document.img0.src='#SESSION.root#/Images/search.png'"
						   style="cursor: pointer;" alt="" width="25" height="25" border="0" align="absmiddle" 
						   onClick="selectorgN('#url.mission#','administrative','orgunit','applyorgunit','1','1','modal')">
					  	     
							 <input type="hidden" name="orgunit1"      id="orgunit1" value="#OrgUnitOwner#"> 
							 <input type="hidden" name="mission1"      id="mission1"> 
							 <input type="hidden" name="orgunit1code"  id="orgunit1code">
						   	 <input type="hidden" name="orgunit1class" id="orgunit1class"> 
					 
					 </cfoutput>
					 
					 </td>
					 
					 
				  </tr>			 
          </table>
		
	</td>
</tr>

<tr>
	<td  height="34" class="labelmedium2" width="15%"><cf_tl id="Date">:</td>
	<td class="labelmedium2">
		
			<cfset st = Dateformat(now(), CLIENT.DateFormatShow)>
		
		     <cf_intelliCalendarDate9
				FieldName="DateEffective" 
				Manual="True"		
				class="regularxxl"								
				Default="#st#"
				AllowBlank="False">		
		
		</td>
</tr>	

<tr>
	<td  height="34" class="labelmedium2" width="15%"><cf_tl id="Currency">:</td>
	<td>
			
		<cfquery name="Currency" 
		 datasource="AppsLedger" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">		 
			 SELECT    *
			 FROM      Currency				  
			 WHERE      Operational = 1			
		</cfquery>
				
		<select name="Currency" class="regularxxl">
		<cfoutput query="Currency">
		    <option value="#currency#" <cfif application.basecurrency eq currency>selected</cfif>>#Currency#</option>
		</cfoutput>
		</select>
		
	
	</td>
</tr>

<tr>
	<td  height="34" class="labelmedium2" width="15%"><cf_tl id="Memo">:</td>
	<td>
	<input type="text" class="regularxxl" name="OrderMemo" id="OrderMemo" style="width:80%">
	</td>
</tr>
</table>

</cfform>

<cfset ajaxonload("doCalendar")>


