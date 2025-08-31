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
<cfsilent>
	<proUsr>dev</proUsr>
	<proOwn>dev dev</proOwn>
	<proDes>Translated</proDes>
	<proCom></proCom>
</cfsilent>


<cfparam name="URL.ID1" default="0">
<cfparam name="URL.Mode" default="View">

<!--- End Prosis template framework --->

<cfinclude template="POViewClassHeaderDefault.cfm">

<!--- provision to make a correction if this went wrong in the past --->


<cfquery name="Check" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT     PL.RequisitionNo, 
	           PL.OrderAmount, 
			   SUM(PLC.AmountPurchase) AS ClassAmount, 
			   PL.OrderAmount - SUM(PLC.AmountPurchase) AS Diff
	FROM       PurchaseLine PL LEFT OUTER JOIN
	           PurchaseLineClass PLC ON PL.RequisitionNo = PLC.RequisitionNo 
			   AND PLC.PurchaseClass IN  (SELECT     Code
	                            FROM       Ref_PurchaseClass
	                            WHERE      SetAsDefault = 0)
								
	WHERE      PurchaseNo = '#URL.ID1#'							
	GROUP BY   PL.RequisitionNo, PL.OrderAmount	
</cfquery>

<cfloop query="Check">

	<cfif diff eq "0">
		
	<cfquery name="Select" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   Code
	FROM     Ref_PurchaseClass
	WHERE    SetAsDefault = 1
	</cfquery>
	
	<cfif Diff eq "">
	 <cfset val = OrderAmount>
	<cfelse>
	 <cfset val = diff> 
	</cfif>
	
	<cfif val neq "" and select.recordcount eq "1">
	
	<cfquery name="Check" 
	datasource="AppsPurchase" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * FROM PurchaseLineClass
	WHERE   RequisitionNo = '#RequisitionNo#'
	AND     PurchaseClass IN
	                          (SELECT   Code
	                           FROM     Ref_PurchaseClass
	                           WHERE    SetAsDefault = 1)
	</cfquery>
	
		<cfif check.recordcount eq "0">
		
			<cfquery name="Insert" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			INSERT INTO PurchaseLineClass 
			(RequisitionNo,PurchaseClass,AmountPurchase,OfficerUserId,OfficerLastName,OfficerFirstName)
			VALUES
			('#RequisitionNo#','#select.code#','#val#','#SESSION.acc#','#SESSION.last#','#SESSION.first#')
			</cfquery>
		
		<cfelse>
		
			<cfquery name="Update" 
			datasource="AppsPurchase" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE PurchaseLineClass 
			SET AmountPurchase = '#val#'
			WHERE RequisitionNo = '#RequisitionNo#'
			AND   PurchaseClass = '#select.code#'
			</cfquery>	
		
		</cfif>
	
	</cfif>
	
	</cfif>

</cfloop>


<cfquery name="PurchaseClass" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  R.Code, 
	        R.Description, 
			sum(PC.AmountPurchase) as AmountPurchase
	FROM    PurchaseLineClass PC RIGHT OUTER JOIN
            Ref_PurchaseClass R ON PC.PurchaseClass = R.Code AND PC.RequisitionNo IN (SELECT RequisitionNo
			                                                                          FROM   PurchaseLine
																					  WHERE PurchaseNo = '#URL.ID1#')
	GROUP BY R.Code, 
	         R.Description 																				  
	ORDER BY Code		
</cfquery>

<cfquery name="Checkin" 
datasource="AppsPurchase" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT  sum(AmountPurchase) as Total
	FROM    PurchaseLineClass 
	WHERE   RequisitionNo IN (SELECT RequisitionNo
	                          FROM   PurchaseLine
							  WHERE PurchaseNo = '#URL.ID1#')
</cfquery>

<cfquery name="Total" 
   datasource="AppsPurchase" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
      	 SELECT    Currency, SUM(OrderAmount) AS Total
   	     FROM      PurchaseLine 
         WHERE     PurchaseNo = '#URL.ID1#'
         GROUP BY Currency
</cfquery>

<cfif total.recordcount gte "2">
     <cfabort>
</cfif>

<table width="100%" border="0" cellspacing="0" cellpadding="0">

<cfoutput>

<tr>
	<td width="40%">Total</td>
	<td width="200" height="21"><b>
	<cfif checkin.total neq total.total>
	    <img src="#SESSION.root#/Images/finger.gif" alt="" border="0" align="absmiddle">
		<a href="##" title="Purchase Amount has not been specified correctly">
		<font color="FF0000">
		</cfif>
	#Total.Currency# #NumberFormat(Total.Total,"_,_.__")#</b>	
	</td>
	<td></td>
</tr>	

</cfoutput>

<cfoutput query="PurchaseClass">
	
	<tr>
	<td width="40%" align="right">#Description#:&nbsp;&nbsp;&nbsp;</td>
	<td width="90" align="right">
	#NumberFormat(AmountPurchase,"_,_.__")#	
	</td>
	<td></td>
	</tr>

</cfoutput>	

</table>	
