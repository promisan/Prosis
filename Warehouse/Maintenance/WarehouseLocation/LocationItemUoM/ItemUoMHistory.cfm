
<!--- show the recent history for this item --->

<!--- stock levels per history --->

<cfparam name="url.location" default="">

<cfquery name="first" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">		 		 	  
		 SELECT    MIN(I.TransactionDate) as TransactionDate					   
		 FROM      ItemTransaction I
		 WHERE     I.Warehouse        = '#url.warehouse#'
		 <cfif url.location neq "">
		 AND       I.Location         = '#url.location#'	
		 </cfif>	
		 AND       I.ItemNo           = '#url.itemno#'
		 AND       TransactionUoM     = '#url.UoM#'			 						
</cfquery>

<CF_DateConvert Value="#DateFormat(now(),CLIENT.DateFormatShow)#">
<cfset now = dateValue> 

<cfset dte = dateAdd("D","-30",now())>

<cfif first.TransactionDate gt dte>
    <CF_DateConvert Value="#DateFormat(first.TransactionDate,CLIENT.DateFormatShow)#">
    <cfset dte = dateValue>
<cfelse>
	<cfset dte = dateAdd("D","-1",now())>
</cfif>

<cfinclude template="ItemUoMHistoryLines.cfm">
