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
