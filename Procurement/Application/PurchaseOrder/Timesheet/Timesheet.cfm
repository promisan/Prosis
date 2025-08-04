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

<cf_screentop height="100%" 
              scroll="Yes" 
			  html="Yes" 
			  jquery="Yes" 
			  layout="webapp"
			  user="Yes"
			  menuClose="No"
			  menuPrint="Yes"
			  label="Timesheet">

<!--- template top open the timesheet for the fooks in the purchase --->

<cfparam name="URL.startyear"   default="#Year(now())#">
<cfparam name="URL.startmonth"  default="#Month(now())#">
<cfparam name="URL.day"         default="1">
<cfset dateob=CreateDate(URL.startyear,URL.startmonth,1)>

<!--- ideally we take the date of the requisition --->

<!---

 <cfquery name="getTimesheet" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		  SELECT    PL.PurchaseNo, R.RequisitionNo, R.PersonNo, PL.Created, F.PositionParentId, F.DateExpiration
		  FROM      PurchaseLine AS PL INNER JOIN
		            RequisitionLine AS R ON PL.RequisitionNo = R.RequisitionNo INNER JOIN
		            Employee.dbo.PositionParentFunding AS F ON R.RequisitionNo = F.RequisitionNo
		  WHERE     PL.PurchaseNo = '#url.purchaseno#'
		  ORDER BY  PL.PurchaseNo DESC		 
  </cfquery>
			 
--->			 

<table width="100%">
  <tr class="line">
  <td style="height:30px" align="center">  
  
	  <cfquery name="getPurchase" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   Purchase 
			WHERE PurchaseNo = '#url.purchaseno#'
	  </cfquery>
	  
	   <cfquery name="getOrg" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * 
			FROM   Organization.dbo.Organization 
			WHERE OrgUnit = '#getPurchase.OrgUnitVendor#'
	  </cfquery>
	  	  
	<cfquery name="Parameter" 
		datasource="AppsPurchase" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	    SELECT *
	    FROM   Ref_ParameterMission
		WHERE  Mission = '#getPurchase.Mission#' 
	</cfquery>
	  
	  <cfoutput>
	  <table style="width:90%">
	      <tr>
	        <td class="labelit"><cf_tl id="PurchaseNo">:</td>
			<td class="labelmedium">#getPurchase.PurchaseNo#/#getPurchase.ModificationNo#</td>
			
			<cfif Parameter.PurchaseCustomField neq "">
			<td class="labelit"><cf_tl id="Reference">:</td>
			<td class="labelmedium">#evaluate("getPurchase.Userdefined#Parameter.PurchaseCustomField#")#</td>
			</cfif>
			<td class="labelit"><cf_tl id="Order date">:</td>
			<td class="labelmedium">#dateFormat(getPurchase.OrderDate,client.dateformatshow)#</td>
			<td class="labelit"><cf_tl id="Vendor">:</td>
			<td class="labelmedium">#getOrg.OrgUnitName#</td>
			<td></td>		
		  </tr>
	 </table>  
	 </cfoutput>
  
  </td>
  </tr>
  
  <tr><td style="padding-top:20px">
  
  <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">		
		<tr><td width="100%" height="0" align="center" style="padding-left:25px;padding-right:25px">		
		
		<cf_TimeSheetView label="Persons covered in purchase" selectiondate="#dateob#" object="Purchase" objectkeyvalue1="#url.purchaseno#">					
		
		</td></tr>		
		</table>	
		
  </td></tr>


</table>



