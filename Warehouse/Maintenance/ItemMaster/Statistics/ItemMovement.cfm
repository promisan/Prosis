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
<cftransaction isolation="READ_UNCOMMITTED">

	<cfquery name="Movement"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	      SELECT    IT.Warehouse, 
		            W.WarehouseName, 
					IT.TransactionUoM,
					Year(IT.TransactionDate)         as tYear,
					<cfif url.period eq "week">
					DATEPART(wk, TransactionDate)    AS tStart, 
		            CONVERT(varchar, DATEPART(yy, TransactionDate)) + '/' + CONVERT(varchar, DATEPART(wk, TransactionDate))    AS Period, 
					<cfelseif url.period eq "month">
					DATEPART(month, TransactionDate) AS tStart, 
					CONVERT(varchar, DATEPART(yy, TransactionDate)) + '/' + CONVERT(varchar, DATEPART(month, TransactionDate)) as Period,
					<cfelseif url.period eq "Year">				
					Year(IT.TransactionDate)         as tStart,
					Year(IT.TransactionDate)         as Period,
					</cfif>
					SUM(IT.TransactionQuantity) AS Quantity,
					SUM(IT.TransactionValue) as Amount,
					C.Description, 
	                C.ListingOrder
		  FROM      ItemTransaction AS IT INNER JOIN
	                Ref_TransactionType AS R ON IT.TransactionType = R.TransactionType INNER JOIN
	                Warehouse AS W ON IT.Warehouse = W.Warehouse INNER JOIN
	                Ref_TransactionClass AS C ON R.TransactionClass = C.Code
	       WHERE    IT.Mission = '#url.mission#'
		   AND      IT.ItemNo  = '#url.itemno#' 	  
		   <cfif url.period eq "week"> 
		   AND      IT.TransactionDate >= GETDATE() - 93
		   <cfelseif url.period eq "month">
		   AND      IT.TransactionDate >= GETDATE() - 365
		   <cfelseif url.period eq "Year">	
		   <!--- no filter --->	   
		   </cfif>
		   GROUP BY IT.Warehouse, 
		   		    Year(IT.TransactionDate),
				    <cfif url.period eq "week">
					DATEPART(wk, TransactionDate), 
		            CONVERT(varchar, DATEPART(yy, TransactionDate)) + '/' + CONVERT(varchar, DATEPART(wk, TransactionDate)), 
					<cfelseif url.period eq "month">
					DATEPART(month, TransactionDate), 
					CONVERT(varchar, DATEPART(yy, TransactionDate)) + '/' + CONVERT(varchar, DATEPART(month, TransactionDate)),
					<cfelseif url.period eq "Year">				
					Year(IT.TransactionDate),
					</cfif>  	   	   			
					W.WarehouseName, 
				    IT.TransactionUoM,	 
					C.Description, 
					C.ListingOrder		
	</cfquery>	

	<cfoutput>
	
	<cfif Movement.recordcount gte "1">	
		
		  <cfquery name="Period" maxrows=1 dbtype="query">
				SELECT   *
				FROM     Movement
				ORDER BY tYear,tStart</cfquery>		
		
			<cfset periodlist = "">
			
			<cfset tyear     = "#left(Period.Period,4)#">	    
			<cfset cstart    = "#Period.tStart#">
			<cfset curr      = "">
					
			<cfset cnt = 1>
			
			<cfif url.period eq "week">
			
				<cfset mfinal  = "#year(now())#/#week(now())#">
			
				<cfset cweek = cstart>
			
				<cfloop condition="#curr# neq #mfinal#">
								
					<cfset curr = "#tyear#/#cweek#">
				
					<cfif periodList neq "">						
						<cfset periodlist = "#PeriodList#,#curr#">
					<cfelse>
					    <cfset periodlist = "#curr#"> 
					</cfif>
					
				    <cfset cnt=cnt+1>												
					<cfif cnt eq "50">
							
						<cfabort>
						
					</cfif>
					
					<cfif cweek lte "52">				
						<cfset cweek = cweek+1>
					<cfelse>						
						<cfset cweek = 1>	 
						<cfset tyear = tyear+1>
					</cfif>
					
				</cfloop>				 
			
			<cfelseif url.period eq "month">
			
				<cfset mfinal  = "#year(now())#/#month(now())#">
			
				<cfset cmonth = cstart>
					
				<cfloop condition="#curr# neq #mfinal#">					
																
					<cfset curr = "#tyear#/#cmonth#">
				
					<cfif periodList neq "">						
						<cfset periodlist = "#PeriodList#,#curr#">
					<cfelse>
					    <cfset periodlist = "#curr#"> 
					</cfif>
					
					<cfset cnt=cnt+1>												
					<cfif cnt eq "50">						
						<cfabort>					
					</cfif>
					
					<cfif cmonth lte "12">				
						<cfset cmonth = cmonth+1>
					<cfelse>						
						<cfset cmonth = 1>	 
						<cfset tyear = tyear+1>
					</cfif>
					
				</cfloop>		
					
			<cfelseif url.period eq "year">	
			
				<cfset cyear = cstart>
				<cfset mfinal  = "#year(now())#">
			
				<cfloop condition="#curr# neq #mfinal#">					
																
					<cfset curr = "#cyear#">
				
					<cfif periodList neq "">						
						<cfset periodlist = "#PeriodList#,#curr#">
					<cfelse>
					    <cfset periodlist = "#curr#"> 
					</cfif>
					
					<cfset cnt=cnt+1>												
					<cfif cnt eq "50">						
						<cfabort>					
					</cfif>
												
					<cfset cyear = cyear+1>
									
				</cfloop>			
			
			</cfif>				
		
		<cfquery name="Warehouse"       
		       dbtype="query">
				SELECT   DISTINCT WarehouseName
				FROM     Movement
		</cfquery>	
		
		<cfquery name="Transaction"       
		       dbtype="query">
				SELECT   DISTINCT Description, ListingOrder
				FROM     Movement
				ORDER BY ListingOrder
		</cfquery>
		
		<cfquery name="UoM"       
		       dbtype="query">
				SELECT   DISTINCT TransactionUoM
				FROM     Movement
		</cfquery>			
		
		<table>
		<tr class="labelmedium line fixrow">
			<td style="padding-left:4px;width:100px;border:1px solid silver"><cf_tl id="Class"></td>		
			<cfloop index="pe" list="#PeriodList#">
			<td colspan="2" style="min-width:160px;width:160px;border:1px solid silver" align="center">#pe#</td>
			</cfloop>
		</tr>
		
		<cfloop index="uom" list="#valueList(UoM.TransactionUoM)#">
		
		<tr class="labelmedium">
			    <td style="padding-left:4px;border:1px solid silver">#uom#</td>	
				<cfloop index="pe" list="#PeriodList#">
			<td style="border:1px solid silver" align="center"><cf_tl id="Quantity"></td>
			<td style="border:1px solid silver" align="center"><cf_tl id="Value"></td>
			</cfloop>	
			</tr>
		
		<cfloop index="itm" list="#valueList(Transaction.Description)#">
			
			<tr class="labelmedium">
			    <td style="padding-left:4px;border:1px solid silver;font-weight:bold;padding-right:5px">#itm#</td>
				
				<cfloop index="per" list="#PeriodList#">
							
					<cfquery name="get" dbtype="query">
						SELECT   sum(Quantity) as Total, sum(Amount) as TotalValue
						FROM     Movement
						WHERE    TransactionUoM = '#uom#'
						AND      Description = '#itm#'
						AND      Period = '#per#' 
					</cfquery>
				
					<td align="right" style="border:1px solid silver;padding-right:3px">
					<cfif get.Total neq "0">#get.Total#</cfif>
					</td>
					
					<td align="right" style="border:1px solid silver;background-color:f1f1f1;padding-right:3px">			
					<cfif get.TotalValue neq "">#numberformat(get.TotalValue,",")#</cfif>				
					</td>
					
				</cfloop>
			</tr>
			
			<cfloop index="whs" list="#valueList(warehouse.WarehouseName)#">
			<tr class="labelmedium navigation_row">
			    <td style="min-width:250px;padding-left:4px;border:1px solid silver;padding-right:5px">#whs#</td>
				
				<cfloop index="per" list="#PeriodList#">
							
					<cfquery name="get" dbtype="query">
						SELECT   sum(Quantity) as Total, sum(Amount) as TotalValue
						FROM     Movement
						WHERE    TransactionUoM   = '#uom#'
						AND      Description      = '#itm#'
						AND      WarehouseName    = '#whs#'
						AND      Period           = '#per#' 
					</cfquery>
					
					<td align="right" style="min-width:50px;border:1px solid silver;background-color:ffffff;padding-right:3px">			
					<cfif get.Total neq "0">#get.Total#</cfif>				
					</td>
					
					<td align="right" style="min-width:50px;border:1px solid silver;background-color:ffffaf;padding-right:3px">			
					<cfif get.TotalValue neq "">#numberformat(get.TotalValue,",")#</cfif>				
					</td>
				
				</cfloop>
			</tr>
			</cfloop>
			
		</cfloop>
		
		</cfloop>
		
	<cfelse>
	
		No movement	
		
	</cfif>	
	
	</table>
	</cfoutput>

</cftransaction>

