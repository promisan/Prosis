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
<cfquery name="Invent"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   userTransaction.dbo.StockInventory#URL.Warehouse#_#SESSION.acc#
	WHERE  TransactionId = '#URL.Id#'
</cfquery>


<cfquery name="Item"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT  * 
	FROM    Item
	WHERE   ItemNo = '#Invent.ItemNo#'
</cfquery>

<cfif Invent.ItemLocationId eq "">
	<font color="FF0000">Problem</font>
	<cfabort>
</cfif>	

<cfquery name="get"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     ItemWarehouseLocation
	WHERE    ItemLocationId = '#Invent.ItemLocationId#'
</cfquery>	

<!--- reset of the workflow --->

<cfparam name="init" default="0">

<cfquery name="Reset"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	UPDATE  userTransaction.dbo.StockInventory#URL.Warehouse#_#SESSION.acc#				
	SET     EntityClass    = NULL 
	WHERE   TransactionId = '#URL.Id#'
</cfquery>

<cfif invent.ActualStock eq "" or Invent.Onhand eq ""> 

	<cfif init eq "0">
		<cfoutput>
		<script>		
			document.getElementById('f#url.id#_log').className = 'hide'
		</script>
		</cfoutput>
	</cfif>
	
<cfelse>

	<cfoutput>
	<cfif init eq "0">
		<script>
			document.getElementById('f#url.id#_log').className = 'regular'
		</script>
	</cfif>
	
	
	<cfset diff = invent.ActualStock - invent.onhand>
		
	</cfoutput>	
	
	<cfset resulttotalloss = "">
	
	<!--- adjust for the decimals --->
	
	<cfif item.ItemPrecision eq "0">	
		<cfset diff  = Int(diff)> 		
	<cfelseif item.ItemPrecision eq "1">	
	   <cfset diff = int(diff*10)/10>	   
	<cfelseif item.ItemPrecision eq "2">	
	   <cfset diff = int(diff*100)/100> 	   
	<cfelseif item.ItemPrecision eq "3">	
	   <cfset diff = int(diff*1000)/1000>    	
	</cfif>	
	
	<cfif diff gt 0 and Invent.requirementId eq "00000000-0000-0000-0000-000000000000">
		
		    <!--- obtain the acceptable loss for this item/warehouse/location 
			this was driven by fuel but it can be used for other stuff as well to ensure
			a workflow is done --->
	
	   		<cf_getLossValue
				id="#Invent.ItemLocationId#"
				date="#now()#">		
			
			<cfif get.HighestStock lt invent.ActualStock and get.HighestStock neq "0">
			
				<cfset ft    = "white">
				<cfset color = "red">
									
			<cfelseif abs(diff) gt resultTotalLoss>
			
				<cfset ft    = "black">
				<cfset color = "yellow">
												
				<!--- check if a worflow is enabled --->
				
				<cfquery name="workflow"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT * 
						FROM   ItemWarehouseLocationTransaction
						WHERE  Warehouse   = '#url.warehouse#'
						AND    Location    = '#Invent.location#'
						AND    ItemNo      = '#Invent.itemno#'
						AND    UoM         = '#Invent.UoM#'
						AND    Operational = 1
						AND    TransactionType = '5'
				</cfquery>
								
				<cfif Workflow.EntityClass neq "">
																
					<cfquery name="setFlow"
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						UPDATE userTransaction.dbo.StockInventory#URL.Warehouse#_#SESSION.acc#				
						SET    EntityClass   = '#Workflow.EntityClass#' 
						WHERE  TransactionId = '#URL.Id#'
					</cfquery>				
								
				</cfif>					
			
			<cfelse>			
			
				<cfquery name="setFlow"
					datasource="AppsMaterials" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
					UPDATE userTransaction.dbo.StockInventory#URL.Warehouse#_#SESSION.acc#				
					SET    EntityClass   = NULL
					WHERE  TransactionId = '#URL.Id#'
				</cfquery>						
							
				<cfset ft = "black">
				<cfset color = "yellow">				
			
			</cfif>		
							
	<cfelseif diff gt 0 and Invent.requirementId neq "00000000-0000-0000-0000-000000000000">	 
	
		<cfset ft    = "white">
		<cfset color = "red">
	  	  
		<cfquery name="setFlow"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE userTransaction.dbo.StockInventory#URL.Warehouse#_#SESSION.acc#				
			SET    EntityClass   = NULL
			WHERE  TransactionId = '#URL.Id#'
		</cfquery>	
	 	  
	<cfelse>
	
	  <cfset ft    = "white">
	  <cfset color = "green">
	  	  
	  <cfquery name="setFlow"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			UPDATE userTransaction.dbo.StockInventory#URL.Warehouse#_#SESSION.acc#				
			SET    EntityClass   = NULL
			WHERE  TransactionId = '#URL.Id#'
		</cfquery>
		
	</cfif>  
	
	<cfoutput>
	
			
	<table height="100%" width="100%">
		
		<tr style="height:100%">
		
			<cf_precision number="#item.ItemPrecision#">
				
			<cfif mode eq "strapping">
						
				<td bgcolor="#color#" height="100%" align="center">
				
					<table height="100%" width="100%">
						<tr class="labelmedium">
						<td style="padding-right:5px"><font color="#ft#">#vMeasured#:&nbsp;&nbsp;</td>
						<td width="60" align="right">
						<font color="#ft#">
							 #numberformat(invent.ActualStock,"#pformat#")#
						 </font>				
						</td>
						</tr>
						<tr class="labelmedium">
						<td style="padding-right:5px"><font color="#ft#">#vVariance#:</td>
						<td width="60" align="right">
						
						 <font color="#ft#">
							 #numberformat(diff,"#pformat#")#
						 </font>				
						</td>
						<td style="padding-right:5px">
						<cfif resultTotalLoss gte "0">
						<font color="#ft#">
						[#numberformat(resultTotalLoss,',#pformat#')#]
						</font>
						</cfif>
						</td>
						</tr>					
						
					</table>
				</td>
			
			<cfelse>
			
				<td bgcolor="#color#" align="center"				  							
					style="height:100%;padding-left:4px;padding-right:4px" class="labelmedium2">		
															
					<font color="#ft#">
					<cfif get.HighestStock lt invent.ActualStock and get.HighestStock neq "0">
					<font color="FFFFFF">
						Exceeds highest #get.HighestStock#					
					<cfelse>
															
						<cfif abs(diff) gt resultTotalLoss>
							<font size="1">Variance:</font> #abs(diff)#
						<cfelse>
							<font size="1">Accepted:</font> #abs(diff)#					
						</cfif>					
						
					</cfif>	
					
					</font>
							
				</td>
			
			</cfif>
									
		</tr>
	
	</table>
	
	</cfoutput>  
	
</cfif>	