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
<cfset tableName = "StockTransaction#URL.Warehouse#_#url.mode#"> 
<cf_getPreparationTable warehouse="#url.warehouse#" mode="#url.mode#"> <!--- adjusts #tableName# i.e. preparation can be per user or per warehouse --->

<!--- template to allow for editing of the recorded line --->

<cfquery name="getLine"
datasource="AppsTransaction" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     #tableName# T 
	WHERE    TransactionId      = '#url.id#'	
</cfquery>		

<cfif getLine.recordcount eq "0">
	<script language="JavaScript">
		alert("Transaction is no longer present. It might have been submitted already.")
	</script>
	<cfabort>
</cfif>

<cfquery name="allLines"
datasource="AppsTransaction" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   *
	FROM     #tableName#
</cfquery>		

<cfquery name="getasset"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   AssetDecalNo, AssetBarCode, ItemNo
	FROM     AssetItem
	<cfif getLine.AssetId neq "">
	WHERE    AssetId = '#getLine.AssetId#'	
	<cfelse>
	WHERE     1 = 0
	</cfif>
</cfquery>		

<cfif getAsset.AssetDecalNo neq "">
   <cfset ass = getAsset.AssetDecalNo>
<cfelse>
   <cfset ass = getAsset.AssetBarCode>
</cfif>   

<cfquery name="getCategory"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   Category
	FROM     Item
	WHERE    ItemNo = '#getAsset.ItemNo#'	
</cfquery>		

<cfquery name="getperson"
datasource="AppsEmployee" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT   Reference, IndexNo
	FROM     Person
	WHERE    PersonNo = '#getLine.PersonNo#'	
</cfquery>		

<cfif getPerson.Reference neq "">
   <cfset per = getPerson.Reference>
<cfelse>
   <cfset per = getPerson.IndexNo>
</cfif>   

<!--- update the values in the form --->

 <cf_tl id="Save Line" var="1">

<cfoutput>

<script language="JavaScript">

   // reference   
        
   try {

   document.getElementById('transactionreference').value = '#getLine.TransactionReference#'
   
   } catch(e) {}
         
   // category equipment population

   ColdFusion.navigate('#SESSION.root#/warehouse/application/stock/Transaction/getCategorySelect.cfm?warehouse=#getLine.warehouse#&itemno=#getLine.itemno#&uom=#getLine.TransactionUoM#&selected=#getCategory.Category#','categoryboxcontent')
  
   // equipment population
   document.getElementById('assetselect').value         = '#ass#'
   document.getElementById('assetidselect').value       = '#getLine.AssetId#'  
	
    // uom population  
   ColdFusion.navigate('../Transaction/getTransactionUoMSelect.cfm?warehouse=#getLine.warehouse#&location=#getLine.location#&itemNo=#getLine.itemNo#&UoM=#getLine.TransactionUoM#&selected=#getLine.MovementUoM#','uomtransaction')			
			
   ColdFusion.navigate('#SESSION.root#/warehouse/application/stock/Transaction/getAsset.cfm?mission=#getLine.mission#&assetid=#getLine.AssetId#&transactionid=#URL.Id#&table=#tableName#','assetbox') 
   
   // person population
   document.getElementById('personselect').value         = '#per#'
   document.getElementById('personidselect').value       = '#getLine.PersonNo#'  
     
   ColdFusion.navigate('#SESSION.root#/warehouse/application/stock/Transaction/getPerson.cfm?mission=#getLine.mission#&personno=#getLine.PersonNo#','personbox')
   
   // project selecion

   project = document.getElementById('projectboxcontent');
   
   if (project)
      ColdFusion.navigate('#SESSION.root#/warehouse/application/stock/Transaction/getProject.cfm?warehouse=#getline.warehouse#&selected=#getline.ProgramCode#','projectboxcontent')
         	 
   <cfif getLine.MovementQuantity eq "">
	   document.getElementById('transactionquantity').value  = '#-getLine.TransactionQuantity#'
   <cfelse>
   	   document.getElementById('transactionquantity').value  = '#-getLine.MovementQuantity#'
   </cfif>
   
   try {
   document.getElementById('remarks').value              = '#getLine.remarks#'
   } catch(e) {} 
   
   // buttom
   
   document.getElementById('transactionid').value         = '#getLine.transactionid#'
   document.getElementById('addbutton').value = '#lt_text#'
   
   <cfloop query="alllines">
    try {
    document.getElementById('line_#transactionid#').className = "regular" 
	} catch(e) {}
   </cfloop>
   
   document.getElementById('line_#getLine.transactionid#').className = "highlight2"   
   
</script>

</cfoutput>

