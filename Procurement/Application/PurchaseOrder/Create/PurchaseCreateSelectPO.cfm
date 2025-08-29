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
<cfquery name="Parameter" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
      SELECT *
      FROM Ref_ParameterMission
	  WHERE Mission = '#URL.Mission#'
</cfquery>

<cfif Parameter.PurchaseCustomField lt "1" and Parameter.PurchaseCustomField gt "4" and Parameter.PurchaseCustomField neq "">

    <table width="100%" cellspacing="0" cellpadding="0" align="center">
   	<tr><td><cf_tl id="Please check with your administrator" class="message">&nbsp;<cf_tl id="as Custom parameter values were not defined" class="message">.</td></tr>
    </table>
    <cfabort>

</cfif>

<cfif url.contractor eq "">

	<table width="100%" cellspacing="0" cellpadding="0" align="center">
   	<tr><td><cf_tl id="Please select a contractor"></td></tr>
    </table>
    <cfabort>

</cfif>

<!--- generate the variables --->

<cfset cnt = 0>
<!--- default --->
<cfset vclass = "vendor">

<cfloop index="itm" list="#url.contractor#" delimiters=",">
 
  <cfset cnt = cnt+1>
  <cfif cnt eq "1">
     <cfset vendor = itm>
  <cfelse>
     <cfset vclass = itm>	 
  </cfif>  

</cfloop>

<cfquery name="Active" 
  datasource="AppsPurchase" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  SELECT     DISTINCT PL.PurchaseNo, 
             <cfif Parameter.PurchaseCustomField neq "">H.UserDefined#Parameter.PurchaseCustomField# as Reference<cfelse>'n/a' as Reference</cfif>,
			 H.OrderClass,
			 H.OrderDate,
			 H.OfficerFirstName, 
			 H.OfficerLastName,
			 MIN(PL.Currency) as Currency,
			 SUM(PL.OrderAmount) as Amount			 
  FROM       PurchaseLine PL INNER JOIN
             RequisitionLineQuote Q ON PL.QuotationId = Q.QuotationId INNER JOIN
             JobActor A ON Q.JobNo = A.JobNo INNER JOIN
             Purchase H ON PL.PurchaseNo = H.PurchaseNo
  WHERE      PL.Currency = Q.Currency
  <cfif Parameter.AddToPurchaseAlways eq "0">
   AND      H.ActionStatus <= '3' 
  <cfelse>
   AND      H.ActionStatus < '9'    
  </cfif> 
  <cfif Parameter.AddToPurchaseMode eq "1">
  
	 <cfif getAdministrator(url.mission) eq "1">
	
		<!--- no filtering --->
		
	 <cfelse>
	 	
		  AND      ( A.ActorUserId = '#SESSION.acc#'
		  			     OR
				     H.Mission IN (SELECT  Mission 
				                    FROM   Organization.dbo.OrganizationAuthorization					
								    WHERE  Role = 'ProcApprover'
							        AND    UserAccount = '#SESSION.acc#')
					)	
		  	  
	  </cfif>
	  
  </cfif>
   
  <cfif Parameter.InvoiceRequisition eq "1">
  		<!--- no condition --->
  <cfelseif Parameter.AddToPurchasePeriod eq "0">
        AND H.Period = '#URL.Period#'
  <cfelse>
	    <!--- no condition --->
  </cfif>
  
  AND        H.Mission       = '#URL.Mission#'   
  <cfif vclass eq "vendor">
  AND        H.OrgUnitVendor = '#vendor#'
  <cfelseif vclass eq "employee">
  AND        H.PersonNo = '#vendor#'
  <cfelse>
  AND        1=0 <!--- nada --->
  </cfif>
  GROUP BY PL.PurchaseNo,
           <cfif Parameter.PurchaseCustomField neq "">
           H.UserDefined#Parameter.PurchaseCustomField#,
		   </cfif>
		   H.OrderClass,
		   H.OrderDate,
		   H.OfficerFirstName, 
		   H.OfficerLastName
		   
 UNION		   
 
 SELECT     DISTINCT H.PurchaseNo, 
             <cfif Parameter.PurchaseCustomField neq "">H.UserDefined#Parameter.PurchaseCustomField# as Reference<cfelse>'n/a' as Reference</cfif>,
			 H.OrderClass,
			 H.OrderDate,
			 H.OfficerFirstName, 
			 H.OfficerLastName,
			 Currency,
			 0 as Amount			 
  FROM       Purchase H 
  WHERE      PurchaseNo IN (SELECT PurchaseNo 
                            FROM   PurchaseLine
							WHERE  PurchaseNo = H.PurchaseNo)
  <cfif Parameter.InvoiceRequisition eq "1">
  		<!--- no condition --->
  <cfelseif Parameter.AddToPurchasePeriod eq "0">
        AND H.Period = '#URL.Period#'
  <cfelse>
	    <!--- no condition --->
  </cfif>
  AND        H.Mission       = '#URL.Mission#'   
  <cfif vclass eq "vendor">
  AND        H.OrgUnitVendor = '#vendor#'
  <cfelseif vclass eq "employee">
  AND        H.PersonNo = '#vendor#'
  <cfelse>
  AND        1=0 <!--- nada --->
  </cfif>
   
</cfquery>

<cfif Active.recordcount eq "0">

   <table><tr><td class="labelmedium">
   <cf_tl id="No records to show in this view">
   </td></tr></table>
   
<cfelse>
	
	<table>
	<tr class="line labelmedium">
	<td colspan="7">
		<font color="808080">
			<cf_tl id="The following Purchase Orders were issued " class="message">
			<cf_tl id="for this vendor/contractor. Select one to add your lines to" class="message">:
		</font>
	</td></tr>	
	
	<tr class="line labelmedium">
	<td width="30"></td>
	<td width="100"><cf_tl id="Number"></td>
	<td width="100"><cf_tl id="Reference"></td>
	<td width="100"><cf_tl id="Issued"></td>
	<td width="150"><cf_tl id="Created by"></td>
	<td width="100"><cf_tl id="Currency"></td>
	<td width="100" align="right"><cf_tl id="Amount"></td>
	</tr>
	
	<cfoutput query="Active">
		<tr class="line labelmedium">
		    <td width="20"><input type="radio" name="PurchaseNo" id="PurchaseNo" value="#Purchaseno#"></td>
			
			<td><a href="javascript:ProcPOEdit('#PurchaseNo#','view')">#PurchaseNo#</a></td>
			<td>#Reference#</td>
			<td>#DateFormat(OrderDate,CLIENT.DateFormatShow)#</td>
			<td>#OfficerFirstName# #OfficerLastName#</td>
			<td>#Currency#</td>
			<td align="right">#numberFormat(Amount,',.__')#</td>			
		</tr>		
	</cfoutput>
	</table>

</cfif>
