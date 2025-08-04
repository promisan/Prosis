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
<cfparam name="url.location" default="">

<cfquery name="Class" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">		 
		 SELECT    *
		 FROM      Ref_TransactionClass		
		 ORDER BY  ListingOrder	 
</cfquery>
<!--- opening balance as for the start day --->

<cfquery name="Opening" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">		 		 	  
		 SELECT    SUM(I.TransactionQuantityBase) as Opening						   
		 FROM      ItemTransaction I
		 WHERE     I.Warehouse        = '#url.warehouse#'
		 <cfif url.location neq "">
		 AND       I.Location         = '#url.location#'	
		 </cfif>	
		 AND       I.ItemNo           = '#url.itemno#'
		 AND       TransactionUoM     = '#url.UoM#'			 				
		 AND       TransactionDate < #dte#		
</cfquery>

<cfset cols = class.recordcount>

<cfset diff = datediff("D",now(),dte)>

<cfquery name="Results" 
     datasource="AppsMaterials" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">	
	 
	 SELECT  TransactionDate, 
	         DATEDIFF(dd,#now#,TransactionDate) as IntegerDay,
		     Warehouse, 
			   <cfif url.location neq "">
		     Location,
			 </cfif>
		     ItemNo, 
		     ItemPrecision,
		     TransactionUoM,
		     <cfloop query="Class">
		     SUM(#code#) as #Code#,
		     </cfloop>
		     Created
			 
	 FROM 
	 
	 (			 
	 
	 <cfloop query="Class">
	 	  
		 <cfset row = currentrow>
	 	  
		 SELECT    CONVERT(VARCHAR(10),I.TransactionDate,126) as TransactionDate,
		           I.Warehouse, 
		           I.Location, 
				   I.ItemNo, 
				   I.TransactionUoM, 
				   S.ItemPrecision,
				   <cfloop query="Class">
					   <cfif currentrow eq row>
					   		SUM(I.TransactionQuantityBase) as '#code#',
					   <cfelse>
						   '0' as '#Code#',
					   </cfif>				   
				   </cfloop>
				   getDate() as Created
				   
		 FROM      ItemTransaction I,
		           Ref_TransactionType R, 
				   Item S
		 WHERE     I.Warehouse        = '#url.warehouse#'
		  <cfif url.location neq "">
		 AND       I.Location         = '#url.location#'
		 </cfif>
		 AND       S.ItemNo           = I.ItemNo
		 AND       I.ItemNo           = '#url.itemno#'
		 AND       TransactionUoM     = '#url.UoM#'			 
		 AND       R.TransactionType  = I.TransactionType
		 AND       R.TransactionClass = '#code#'	
		 AND       TransactionDate   >= #dte#
		 <!--- total by date --->
		 GROUP BY CONVERT(VARCHAR(10),I.TransactionDate,126),
		           I.Warehouse, 
		           I.Location, 
				   I.ItemNo, 
				   S.ItemPrecision,
				   I.TransactionUoM 	 
		 <cfif currentrow neq recordcount>
		 UNION	 
		 </cfif>
		 
	</cfloop>	
	) as DerrivedTable
	
	GROUP BY TransactionDate, 
		     Warehouse, 
			 <cfif url.location neq "">
		     Location,
			 </cfif>
		     ItemNo, 
		     ItemPrecision,
		     TransactionUoM,
		     Created		
	
	ORDER BY TransactionDate 
		 
</cfquery>

<!---
<cfdump var="#Results#" output="browser">
--->

<cfif results.ItemPrecision eq "">
	<cfset pr = "0">
<cfelse>
    <cfset pr = "#results.ItemPrecision#">
</cfif>	

<cfset suf = "">
<cfloop index="itm" from="1" to="#pr#">
      <cfif suf eq "">
  	      <cfset suf = "._">
	  <cfelse>
		  <cfset suf = "#suf#_">
	  </cfif>
</cfloop>	 

<table width="99%" cellspacing="0" cellpadding="0" align="center" class="navigation_table">

	<tr>
		<td width="10%" class="labelit"><cf_tl id="Date"></td>
		<td width="10%" class="labelit"><cf_tl id="Code"></td>
		<td width="10%" class="labelit" align="right"><cf_tl id="Opening"></td>
		<cfoutput query="Class">
		<td width="10%" class="labelit" align="right">#Description#</td>
		</cfoutput>
		<td width="10%" class="labelit" align="right"><cf_tl id="Closing"></td>
		<td width="10%" class="labelit" align="right"><cf_tl id="Physical"></td>
		<td width="10%" class="labelit" align="right"><cf_tl id="Difference"></td>
	</tr>
	
	
	<cfoutput>
	<tr><td colspan="#class.recordcount+6#" class="line"></td></tr>
	</cfoutput>
	
	<cfset ope = opening.opening>
	<cfif ope eq "">
	     <cfset ope = "0">
	</cfif>
	
	<cfoutput>
			
	<cfloop index="day" from="#diff#" to="0">
		
		<cfset dte = dateAdd("D","#day#",now())>
		<CF_DateConvert Value="#DateFormat(dte,CLIENT.DateFormatShow)#">
		<cfset dte = dateValue>		
									
		<cfquery name="get" dbtype="query">
			SELECT   *
			FROM     Results
			WHERE    IntegerDay = #day# 
			<!--- AND TransactionDate = '#dateformat(dte,"#client.datesql#")#' 			 --->
		</cfquery>					
					
		<tr class="navigation_row">
		
			<td class="labelit">#Dateformat(dte,CLIENT.DateFormatShow)#</td>
			
			<cfif get.recordcount eq "0">
			
			<td><!--- #Location# ---></td>	
			<td align="right" class="labelit">
			<cfif ope lt "0"><font color="FF0000"></cfif>
			#numberformat(ope,'__,__#suf#')#</td>
			
				<cfloop query="Class">
				
				 <td align="right">			
					 --				 
				 </td>	 	 
				 
				</cfloop>
			
			<cfelse>
			
				<td><!--- #Location# ---></td>	
				<td align="right" class="labelit">#numberformat(ope,'__,__#suf#')#</td>
											
				<cfloop query="Class">
				
				 <td align="right" class="labelit">
			
					 <cfset val = evaluate("get.#code#")>	
					 
					 <cfif val eq "0">					 
					 --					 
					 <cfelse>
						 
						 <cfset ope = ope + val>								 
						 <cfif QuantityNegative eq "0">	 
						 	   #numberformat(val,'__,__#suf#')#
						 <cfelse>
							   #numberformat(-val,'__,__#suf#')#
						 </cfif>
					 			 
					 </cfif>
				 
				 </td>	 	 
				 
				</cfloop>
			
			</cfif>
			
			<td align="right" class="labelit" style="padding-right:3px">
			<cfif ope lt "0"><font color="FF0000"></cfif>
			<b>#numberformat(ope,'__,__#suf#')#
			</td>
			
			
			<cfquery name="Inventory" 
		     datasource="AppsMaterials" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">				 
				SELECT    TOP 1  QuantityCounted
				FROM      ItemWarehouseLocationInventory
				WHERE     Warehouse = '#url.warehouse#' 
				AND       Location = '#url.location#' 
				AND       ItemNo = '#url.itemno#' 
				AND       UoM = '#url.uom#'
				AND       CONVERT(VARCHAR(10),DateInventory,101) = '#dateformat(dte,client.datesql)#' 
				ORDER BY  DateInventory DESC 
			</cfquery>	
									  			
			<td align="right" class="labelit" style="padding-right:3px">
			<cfif ope lt "0"><font color="FF0000"></cfif>
			<cfif Inventory.QuantityCounted eq "">--
			<cfelse><b>#numberformat(Inventory.QuantityCounted,'__,__#suf#')#
			</cfif>
			</td>
			
			<td align="right" class="labelit" style="padding-right:3px">
			<cfif ope lt "0"><font color="FF0000"></cfif>
			<b>
			<cfif Inventory.QuantityCounted eq "">--<cfelse>

				<cfset diff = Inventory.QuantityCounted-ope>
				<cfif diff gte "0"><font color="008000"><cfelse><font color="FF0000"></cfif>
				#diff#
				</font>
			
			</cfif>
			</td>
		</tr>
		
		<tr><td colspan="#class.recordcount+6#" style="border-top:1px dotted d4d4d4"></td></tr>
	
		</cfloop>
	
	</cfoutput>

</table>

<cfset AjaxOnLoad("doHighlight")>