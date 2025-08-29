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
<!--- id is passed, 
  then we define the last inventory transaction
  apply the loss table settings for all the N defined class with the effective date lte last transaction
  define the transactions that took place (transaction) and apply the percentage
  define the number of days and apply the month losses
  return the acceptable loss as a value in total and for each lossclass [array] --->
 
<cfparam name="Attributes.id"    default="00000000-0000-0000-0000-000000000000">
<cfparam name="Attributes.date"  default="#now()#">

<cfset returnValue = 0>

<cfquery name="getPossibleLosses" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">		 		 	  
	 	SELECT DISTINCT LL.Warehouse, 
				        LL.Location,
				        LL.ItemNo,
				        LL.UoM,
				        LL.LossClass
		FROM    ItemWarehouseLocation L	INNER JOIN ItemWarehouseLocationLoss LL
				ON	L.Warehouse = LL.Warehouse
				AND L.Location = LL.Location
				AND	L.ItemNo = LL.ItemNo
				AND	L.UoM = LL.UoM
		WHERE	L.ItemLocationId = '#Attributes.id#'
</cfquery>

<!--- determine the prior inventory record --->

<cfquery name="getLastInventory" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">		 		 	  
	 	SELECT   TOP 1 *
		FROM     ItemTransaction T
		WHERE 	 T.Warehouse       = '#getPossibleLosses.Warehouse#'
		AND	 	 T.Location        = '#getPossibleLosses.Location#'
		AND	 	 T.ItemNo          = '#getPossibleLosses.ItemNo#'
		AND	 	 T.TransactionUoM  = '#getPossibleLosses.UoM#'
		AND		 T.TransactionType = 5
		AND		 T.TransactionDate <= #Attributes.date#
		ORDER BY T.TransactionDate DESC
</cfquery>

<cfset lastInventoryDate = "">

<cfif getLastInventory.recordCount gt 0>

	<cfset lastInventoryDate = getLastInventory.TransactionDate>
	
<cfelse>
	
	<!--- if there is no last inventory, get the last transaction before the entered date --->
	
	<cfquery name="getLastTransaction" 
	    datasource="AppsMaterials" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">		 		 	  
		 	SELECT   TOP 1 *
			FROM     ItemTransaction T
			WHERE	 T.Warehouse      = '#getPossibleLosses.Warehouse#'
			AND		 T.Location       = '#getPossibleLosses.Location#'
			AND		 T.ItemNo         = '#getPossibleLosses.ItemNo#'
			AND		 T.TransactionUoM = '#getPossibleLosses.UoM#'
			AND		 T.TransactionDate <= #Attributes.date#
			ORDER BY T.TransactionDate ASC
	</cfquery>
	
	<cfset lastInventoryDate = getLastTransaction.TransactionDate>
	
</cfif>

<!--- Getting data subsets in advance to optimize performance to prevent running it 4 times --->

<cfquery name="TransactionsSubset" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">		 		 	  
		SELECT	TransactionDate,
		        TransactionType,
		        TransactionQuantity				
		FROM	ItemTransaction
		WHERE	Warehouse      = '#getPossibleLosses.Warehouse#'
		AND		Location       = '#getPossibleLosses.Location#'
		AND		ItemNo         = '#getPossibleLosses.ItemNo#'
		AND		TransactionUoM = '#getPossibleLosses.UoM#'
		<cfif lastInventoryDate neq "">
		AND		TransactionDate BETWEEN '#lastInventoryDate#' AND #Attributes.date#
		<cfelse>
		AND		TransactionDate <= #Attributes.date#
		</cfif>
</cfquery>

<!--- Warehouse, Location, ItemNo, UoM, LossClass, LossCalculation, TransactionClass, LossQuantity, AcceptedPointer, LossValue --->
<cfset appliableLosses = ArrayNew(2)>

<!--- loop thru all the possible losses --->

<cfloop query="getPossibleLosses">

	<!--- Get the appliable loss depending on the entered date (the first date before the entered date) --->
	<cfquery name="getLoss" 
	    datasource="AppsMaterials" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">		 		 	  
		 	SELECT   TOP 1 *
			FROM     ItemWarehouseLocationLoss
			WHERE	 Warehouse  = '#Warehouse#'
			AND 	 Location   = '#Location#'
			AND		 ItemNo     = '#ItemNo#'
			AND		 UoM        = '#UoM#'
			AND 	 LossClass  = '#LossClass#'
			AND		 DateEffective <= #Attributes.date#
			ORDER BY DateEffective DESC
	</cfquery>
	
	<!--- Warehouse, Location, ItemNo, UoM, LossClass, LossCalculation, TransactionClass, LossQuantity, AcceptedPointer, LossValue --->
	<cfset arrayToAppend = arrayNew(1)>
	<cfset arrayToAppend[1]  = getLoss.Warehouse>
	<cfset arrayToAppend[2]  = getLoss.Location>
	<cfset arrayToAppend[3]  = getLoss.ItemNo>
	<cfset arrayToAppend[4]  = getLoss.UoM>
	<cfset arrayToAppend[5]  = getLoss.LossClass>
	<cfset arrayToAppend[6]  = getLoss.LossCalculation>
	<cfset arrayToAppend[7]  = getLoss.TransactionClass>
	<cfset arrayToAppend[8]  = getLoss.LossQuantity>
	<cfset arrayToAppend[9]  = getLoss.AcceptedPointer>
	<cfset arrayToAppend[10] = 0>
	
	<cfset arrayAppend(appliableLosses, arrayToAppend)>
	
</cfloop>

<!--- Calculate values of each loss --->

<cfset cnt = 1>

<cfloop index="loss" array="#appliableLosses#">
	
	<!--- Loss type: MONTH --->
	<cfif lcase(loss[6]) eq "month">
	
		<cfset cummulatedLoss = 0>
		
		<cfif lastInventoryDate neq "">
		
			<!--- Loop thru all months in the difference to get each month loss --->
			<cfset monthDifference = datePart("m",Attributes.date) - datePart("m",lastInventoryDate)>
			
			<cfloop index="vMonth" from="0" to="#monthDifference#">
				
				<!--- Set the reference date for the month in the iteration --->
				<cfset referenceDate = createDate(datePart("yyyy", lastInventoryDate), datePart("m",dateAdd("m",vMonth,lastInventoryDate)), 1)>
				<!--- first month --->
				<cfif vMonth eq 0>
					<cfset referenceDate = lastInventoryDate>
				</cfif>
				<!--- last month --->
				<cfif vMonth eq monthDifference>
					<cfset referenceDate = Attributes.date>
				</cfif>
				
				<!--- Calculate the month proportion --->
				<cfset firstDayNextMonth = createDate(datePart("yyyy", dateAdd("m",1,referenceDate)), datePart("m", dateAdd("m",1,referenceDate)), 1)>
				
				<cfset lastDayOfMonth = dateAdd("d", -1, firstDayNextMonth)>
				<cfset monthProportion = (datePart("d", lastDayOfMonth) - datePart("d", referenceDate) + 1) / datePart("d", lastDayOfMonth)>				
				
				<!--- last month --->
				<cfif vMonth eq monthDifference>
					<cfset monthProportion = datePart("d", referenceDate) / datePart("d", lastDayOfMonth)>
				</cfif>
				<cfif monthDifference eq 0>
					<cfset monthProportion = (datePart("d", Attributes.date) - datePart("d", lastInventoryDate)) / datePart("d", lastDayOfMonth)>
				</cfif>
				
				<!--- Set the loss for this iteration --->
				<cfset cummulatedLoss = cummulatedLoss + (loss[8] * monthProportion)>
				
			</cfloop>
		
		</cfif>
		
		<cfset appliableLosses[cnt][10] = cummulatedLoss>		
	
	<cfelseif lcase(loss[6]) eq "transaction">
	
	    <!--- Loss type: TRANSACTION --->
	
		<cfset firstDayOfMonth = createDate(datePart("yyyy",#Attributes.date#),datePart("m",#Attributes.date#),1)>
	
		<!--- Get valid transaction types for the current iteration --->
							   
		<cfquery name="getTransactionTypes" 
		    datasource="AppsMaterials" 
		    username="#SESSION.login#" 
		    password="#SESSION.dbpw#">		 		 	  
				SELECT	* 
				FROM 	Ref_TransactionType
				WHERE   TransactionClass = '#loss[7]#'
		</cfquery>
		
		<cfset typeList = quotedValueList(getTransactionTypes.TransactionType)>	
				
		<!--- 	Get all transactions from the subset for the id entered, 
			    the transactionTypes defined by the transactionClass of the loss 
			    and from last inventory date to the date entered or all the transactions 
				before or equal the date entered --->
				
		<cfquery name="getTransactions" dbtype="query">	 		 	  
			SELECT	SUM(TransactionQuantity) AS Total 
			FROM	TransactionsSubset				
			WHERE	TransactionType IN (#preservesinglequotes(typeList)#)
			<cfif loss[7] is "Receipt">
			OR (TransactionType = '8' AND TransactionQuantity > 0)
			<cfelseif loss[7] is "Distribution">
			OR (TransactionType = '8' AND TransactionQuantity < 0)			
			</cfif>
			
		</cfquery>
		
		<cfset absolutValueLoss = 0>
		
		<cfif getTransactions.Total neq "">
			<cfset absolutValueLoss = getTransactions.Total>
		</cfif>
		
		<cfif absolutValueLoss lt 0>
			<cfset absolutValueLoss = absolutValueLoss * -1>
		</cfif>
		
		<cfset appliableLosses[cnt][10] = loss[8] * absolutValueLoss>
				
	</cfif>
	
	<cfset returnValue = returnValue + appliableLosses[cnt][10]>
	
	<cfset cnt = cnt + 1>
	
</cfloop>

<cfset caller.resultTotalLoss       = returnValue>
<cfset caller.resultAppliableLosses = appliableLosses>
