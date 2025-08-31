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
<cf_screentop height="100%" scroll="Yes" label="Process Request" layout="webapp" banner="gradient" jquery="yes">

<cf_calendarscript>
<cf_dialogOrganization>
<cf_dialogAsset>
<cf_dialogPosition>

<script>
	function applyunit(org) {
		ptoken.navigate('applyUnit.cfm?orgunit='+org,'process');
	}
</script>


<cfquery name="Request" 
 datasource="appsMaterials" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT   *
	 FROM     Request 
	 WHERE    RequestId = '#URL.RequestID#'
</cfquery>

<cfquery name="Assigned" 
 datasource="appsMaterials" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT   count(*) as Count
	 FROM     AssetItemOrganization 
	 WHERE    RequestId = '#URL.RequestID#'
</cfquery>

<cfquery name="Item" 
 datasource="appsMaterials" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
	 SELECT   *
	 FROM     Item 
	 WHERE    ItemNo = '#Request.ItemNo#'
</cfquery>

<cfquery name="Org" 
 datasource="appsOrganization" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT   *
 FROM     Organization
 WHERE    OrgUnit = '#Request.OrgUnit#'
</cfquery>

<cfquery name="Mission" 
 datasource="appsOrganization" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
 SELECT   *
 FROM     Ref_Mandate 
 WHERE    Mission = '#Request.Mission#'
 AND      DateEffective < getDate()
 ORDER BY DateEffective DESC
</cfquery>

<cfoutput>

<cfform name="selected" id="selected">

	<table width="97%"
	       border="0"
		   class="formpadding formspacing"
		   align="center"	  
	       cellspacing="0"
	       cellpadding="0">
		   
		   <tr class="hide"><td height="100" width="100%" colspan="2" id="resultbox"></td></td></tr>
		   
		   <tr class="line"><td class="labelit" style="padding-left:5px;font-size:21px"><cf_tl id="Requisition">:</td></tr>
				   
		   <tr><td>
		   
				<table width="97%" align="center" cellspacing="0" cellpadding="0" class="formpadding">			
				<tr>
					<td width="100" style="padding-left:5px"><cf_tl id="Requester">:</td><td>#Request.OfficerFirstName# #Request.OfficerLastName#</td>
					<td style="padding-left:5px"><cf_tl id="Date">:</td><td>#DateFormat(Request.requestDate,CLIENT.DateFormatShow)#</td>
				</tr>
				<tr><td style="padding-left:5px"><cf_tl id="Unit">:</td><td>#Org.OrgUnitName#</td>
					<td style="padding-left:5px"><cf_tl id="Item">:</td><td>#Item.ItemNo# #Item.ItemDescription#</td>
				</tr>
				<tr>
					<td style="padding-left:5px"><cf_tl id="Quantity Orginal">:</td><td>#Request.RequestedQuantity#</td>
					<td style="padding-left:5px;min-width:200px"><cf_tl id="Quantity Pending">:</td><td>#Request.RequestedQuantity-Assigned.count#</td>
				</tr>
				<tr><td style="padding-left:5px"><cf_tl id="Remarks">:</td><td><cfif Request.Remarks eq "">--<cfelse>#Request.Remarks#</cfif></td><td>&nbsp;<cf_tl id="Selected">:</td><td id="counted">0</td></tr>
				</table>
			
		  </td></tr>
		  	  
			<cfquery name="Stock" 
			 datasource="appsMaterials" 
			 username="#SESSION.login#" 
			 password="#SESSION.dbpw#">
		     SELECT  *
			 FROM    AssetItemLocation B INNER JOIN
	                 AssetItem I ON B.AssetId = I.AssetId
			 WHERE   B.DateEffective IN
	                        (SELECT   MAX(A.DateEffective)
	                         FROM     AssetItemLocation A
	                         WHERE    A.AssetId = B.AssetId
	                         GROUP BY AssetId) 
	 		 AND      B.Location IN
	                       (SELECT  Location
	                        FROM    Location
	                        WHERE   StockLocation = 1)
	   		 AND      I.ItemNo = '#Request.ItemNo#'
			 </cfquery> 
			 
			<tr><td class="labelit" style="padding-left:5px;font-size:21px"><cf_tl id="Select Available item from stock location">:</td></tr>
			<tr><td height="1" class="line"></td></tr>
		    <tr><td>
		   
			<table width="96%" align="center" cellspacing="0" cellpadding="0" class="formpadding">
			
			<tr class="line">
			<td><cf_tl id="Make"></td>
			<td><cf_tl id="Model"></td>
			<td><cf_tl id="SerialNo"></td>
			<td><cf_tl id="Bar Code"></td>
			<td><cf_tl id="Receipt"></td>
			<td align="right"><cf_UIToolTip  tooltip="Depreciated value">Dep.Value</cf_UIToolTip></td>
			<td width="50"></td>
			</tr>
					
			
			<cfloop query="Stock">
				<tr>
				<td>#Make#</td>
				<td>#Model#</td>
				<td>#SerialNo#</td>
				<td>#AssetBarcode#</td>
				<td>#dateformat(ReceiptDate,CLIENT.DateFormatShow)#</td>
				<td align="right">#numberformat(AmountValue,",__.__")#</td>
				<td align="right" >
				<input type="checkbox" 
					name="assetid" 
					id="assetid"
					value="'#AssetId#'"
					onclick="ColdFusion.navigate('#SESSION.root#/warehouse/application/asset/Request/RequestCount.cfm','counted','','','POST','selected')">
				</td>
				</tr>			
			</cfloop>			
				
			</table>
			
		  </td></tr>
		  
		  <tr><td class="labelit" style="padding-left:5px;font-size:21px"><cf_tl id="Assign Items to">:</td></tr>					
		  <tr><td height="1" class="line"></td></tr>
		  
		  <tr><td>
			<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
									
				  <tr>
				  <td height="20" style="padding-left:30px"><cf_tl id="Effective date">:</td>
				  <td><cf_intelliCalendarDate9
						FieldName="DateEffective" 
						class="regularxl"
						Default="#dateformat(now(), CLIENT.DateFormatShow)#"
						AllowBlank="False">	
				  </td>
				  </tr> 				
									
				 <tr>
					  <td height="20" style="padding-left:30px"><cf_tl id="Location">:</td>
					  <td>
						   <cfoutput>					   		
					        <input type="button" style="width:30px;height:27px" class="button10g" name="search" id="search" value=" ... " onClick="selectloc('movement','location','locationcode','locationname','orgunit','orgunitname','personno','name',mission.value)"> 							
							<input type="text" name="locationname" id="locationname" value="" class="regularxl" size="60" maxlength="60" readonly style="text-align: left;">
							<input type="hidden" name="location" id="location" value=""> 
							<input type="hidden" name="locationcode" id="locationcode" value="">
							</cfoutput>
					 	
					 </td>
				  </tr> 
					    
				  <tr>
					 <td height="20" style="padding-left:30px">;<cf_tl id="Unit">:</td>
						 <td>
					        <cfoutput>
							
					        <input type="button" style="width:30px;height:27px" class="button10g" name="search" id="search" value=" ... " onClick="selectorgmis('webdialog','orgunit','orgunitcode','mission','orgunitname','orgunitclass',mission.value, mandateno.value)"> 						
							<input type="text"   name="orgunitname"   id="orgunitname" value="#Org.OrgUnitName#" class="regularxl" size="60" maxlength="60" readonly style="text-align: left;">
							<input type="hidden" name="orgunitclass"  id="orgunitclass" value="" class="disabled" size="15" maxlength="15" readonly style="text-align: left;"> 
							<input type="hidden" name="mandateno"     id="mandateno" value="#Mission.MandateNo#">
							<input type="hidden" name="orgunit"       id="orgunit" value="#Org.OrgUnit#"> 
							<input type="hidden" name="mission"       id="mission" value="#Request.Mission#">
							<input type="hidden" name="orgunitcode"   id="orgunitcode" value="">
							</cfoutput>
							
						 </td>
					</tr> 
					
					<tr>
					 <td height="20" style="padding-left:30px"><cf_tl id="Employee">:</td>
					 <td>									 				 	
						
						<cfquery name="User" 
						 datasource="appsSystem" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
							 SELECT   *
							 FROM     UserNames
							 WHERE    Account = '#Request.OfficerUserId#'
						</cfquery>
						
						<cfquery name="Employee" 
						 datasource="appsEmployee" 
						 username="#SESSION.login#" 
						 password="#SESSION.dbpw#">
							 SELECT   *
							 FROM     Person
							 WHERE    PersonNo = '#User.PersonNo#'
						</cfquery>
					 	
						<cfoutput>	
						<input type="button" style="width:30px;height:27px" class="button10g" name="search0" id="search0" value=" ... " onClick="selectperson('webdialog','personno','indexno','lastname','firstname','name','','#Request.Mission#')"> 
						<input type="text" name="name" id="name" value="#Employee.FirstName# #Employee.LastName#" class="regularxl" size="60" maxlength="60" readonly style="text-align: left;">
						<input type="hidden" name="indexno" id="indexno" value="#Employee.IndexNo#" class="disabled" size="10" maxlength="10" readonly style="text-align: center;">
						<input type="hidden" name="personno" id="personno" value="#Employee.PersonNo#">
					    <input type="hidden" name="lastname" id="lastname" value="#Employee.LastName#">
					    <input type="hidden" name="firstname" id="firstname" value="#Employee.FirstName#">
						</cfoutput>
						
					 
					 </td>
					</tr>
	
			</table>
			
			</td></tr>
			
			 <tr><td height="1" class="line"></td></tr>
					
			<tr><td colspan="2" align="center" height="30">
			
				<cf_tl id="Close" var="1">	
				<input type="button" name="Submit" id="Submit" value="#lt_text#" class="button10s" style="width:120;height:23" onclick="window.close()">
				<cf_tl id="Process" var="1">		
				<input type="button" name="Submit" id="Submit" value="#lt_text#" class="button10s" style="width:120;height:23"
				onclick="ptoken.navigate('RequestEntrySubmit.cfm?requestid=#request.requestid#','resultbox','','','POST','selected')">
			
			</td></tr>		

			<tr><td id="process"></td></tr>
					
	</table>

</cfform>

<cf_screenbottom layout="webapp">

</cfoutput>