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
<!--- template to be shown as part of the workflow listing --->
<!--- ---------------------------------------------------- --->

<cfquery name="get"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	SELECT  *
	FROM    Taskorder 
	WHERE   StockOrderid = '#object.ObjectKeyvalue4#'	
</cfquery>

<cfquery name="OnHand"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	SELECT     I.ItemDescription,
	           U.UoMDescription, 
			   SUM(T.TransactionQuantity) AS OnHand 
	FROM       ItemTransaction AS T INNER JOIN
	                      Item I ON T.ItemNo = I.ItemNo INNER JOIN
	                      ItemUoM U ON T.ItemNo = U.ItemNo AND T.TransactionUoM = U.UoM
	WHERE      Warehouse = '#get.Warehouse#'
	AND        Location  = '#get.Location#'
	AND        T.ItemNo IN (SELECT R.ItemNo 
	                        FROM   RequestTask RT, Request R
							WHERE  R.RequestId =  RT.RequestId
							AND    RT.StockOrderId = '#object.ObjectKeyvalue4#'
							AND    R.ItemNo = T.ItemNo)
	GROUP BY I.ItemDescription, U.UoMDescription
</cfquery>

<cfquery name="getLocation"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		
	SELECT    *
	FROM      WarehouseLocation
	WHERE     Warehouse = '#get.Warehouse#'
	AND       Location  = '#get.Location#'	
</cfquery>

<cfquery name="Prior" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	   SELECT    P.*
	   FROM      WarehouseBatch P
	   WHERE     P.StockOrderId = '#object.ObjectKeyvalue4#'  
	   AND       BatchNo IN (SELECT TransactionBatchNo FROM ItemTransaction WHERE TransactionBatchNo = P.BatchNo)					  
</cfquery>

	<table width="100%" cellspacing="0" cellpadding="0" align="center" bgcolor="ffffff" class="formpadding">
	
	<tr>
		<td align="center" bgcolor="ffffcf" height="22" colspan="2">
		<cfoutput>
		<font face="Verdana" size="2">#getLocation.Description# (#getLocation.StorageCode#) <cf_tl id="Information"><font>
		</cfoutput>
		</td>
	</tr>
	
	<tr><td colspan="2" class="line"></td></tr>
	
	<tr><td height="5"></td></tr>
	
	<tr><td>
	
	<table width="97%" align="center">
	
	<tr>
	
		<td colspan="2">
			<table cellspacing="0" width="100%" cellpadding="0" class="formpadding">
			
			<cfoutput query="OnHand">
				<tr class="labelit">
				<td style="padding-left:5px">#Itemdescription# on hand </td>
				<td bgcolor="f4f4f4" style="padding-right:4px;border:1px dotted silver" align="right">
				<font size="3" color="black">#numberformat(OnHand,"__,__")#</font>
				<font color="gray">#uomdescription#</font>
				</td>
				</tr>
			</cfoutput>
			</table>
		
		</td>
		
	</tr>	
	
	<cfif prior.recordcount gte "1"> 
	 
		<tr><td colspan="4" class="linedotted"></td></tr>
		
		<tr><td height="2"></td></tr>
		
		<!--- show the prior transactions for this flow --->
						   
		<cfloop query="prior">
		   <tr><td colspan="2">
		   <!--- show this batch --->
		   <cfdiv bind="url:#SESSION.root#/warehouse/application/stock/batch/batchviewtransaction.cfm?stockorderid=#object.objectkeyvalue4#&batchno=#batchno#">				  
		   </td></tr>		
		</cfloop>	
		
		<tr><td height="4"></td></tr>
		
	</cfif>	
		
	</table>
		
	</td></tr>
		
	<tr><td height="5"></td></tr>
		
	</table>
