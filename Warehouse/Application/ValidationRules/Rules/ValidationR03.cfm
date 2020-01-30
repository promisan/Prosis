
<!--- ----------------------------------------------------------------------------- --->
<!--- -----Rule Issuances :
      ---  Ensure the tanksize is equal or larger than issuance ------------------- --->
<!--- ----------------------------------------------------------------------------- --->


SELECT   S.AssetId, S.SupplyItemNo, S.SupplyItemUoM, S.SupplyCapacity
FROM     AssetItem A INNER JOIN AssetItemSupply S ON A.AssetId = S.AssetId
WHERE    A.AssetId = '{164371FB-1018-0668-43F7-0B06992E7C87}' 
AND      S.SupplyItemNo = '1309' 
AND      S.SupplyItemUoM = '11'

<!---

<cfquery name="get"
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT   *
		FROM     ItemWarehouseLocation 	
		WHERE    ItemLocationId  = '#attributes.sourceid#'				
</cfquery>	

<cfif get.readingClosing eq "" or get.ReadingOpening eq "">

<cfelse>
				
	<cfset actual = get.readingClosing - get.ReadingOpening>	
			
	<cfif actual neq "">
				
			<cfset diff = actual-abs(attributes.sourcevalue)>
			
			<cfif abs(diff) gte 0.5>
			
				 <cf_ApplyBusinessRuleResult
				    ValidationId     = "#rowguid#"
				    Datasource       = "#attributes.datasource#"
					Source           = "#TriggerGroup#"
					SourceId         = "#attributes.sourceid#"
					BusinessRule     = "#Code#"	
					Result           = "9"			
					ValidationMemo   = "The increment of the meter (closing-opening) does not match the quatity of the batch transactions : [#actual#] versus [#attributes.sourcevalue#]">
					
			</cfif>
						
	</cfif>

</cfif>

<!--- ------------------------------ --->
<!--- --------- end of query-------- --->
<!--- ------------------------------ --->

--->
