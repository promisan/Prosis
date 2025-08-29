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
<cfset vMode = "issue">
<cfset vUoM  = #form.UoM#> <!---Liters --->
<cfset C_ACTION_CATEGORY = "Operations">

<cfquery name="WarehouseLocation" 
    datasource="AppsMaterials"  
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		   SELECT *
		   FROM   WarehouseLocation
		   WHERE  Warehouse = '#url.warehouse#'
		   AND    Location  = '#url.location#'
  </cfquery>   

<cfquery name = "getDirectory"
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
 SELECT DocumentFileServerRoot 
 FROM   Ref_Attachment
 WHERE  DocumentPathName = 'StockLogSheet'
</cfquery>
<cfif not DirectoryExists("#getDirectory.DocumentFileServerRoot#\StockLogSheet\history")>
 <cfdirectory action="CREATE" directory="#getDirectory.DocumentFileServerRoot#\StockLogSheet\history">
</cfif>

<cfif not DirectoryExists("#getDirectory.DocumentFileServerRoot#\StockLogSheet\history\#url.warehouse#")>
 <cfdirectory action="CREATE" directory="#getDirectory.DocumentFileServerRoot#\StockLogSheet\history\#url.warehouse#">
</cfif>
<cfpdfform source="#getDirectory.DocumentFileServerRoot#\StockLogSheet\#url.warehouse#\#url.pdfform#" action="read" Result="fields"/>
  
<cfset sHeader = Fields.form1.Transaction_LogSheet.Table0>
<cfset sDetails = Fields.form1.Transaction_LogSheet.Table1>    
<!---- HEADERS ---->
<cfset h = 1>
<cfset vHeaders = 4> 
<cfloop condition= "#h# lte vHeaders">
 
 <cfset vName = "HeaderRow#h#">
 <cfswitch expression="#h#">
  <cfcase value="1">
   <cfset vLocation = Evaluate("sHeader.#vName#.Location")>
   <cfset vMission = Evaluate("sHeader.#vName#.Mission")>
  </cfcase>
  <cfcase value="2">
   <cfset vItem = Evaluate("sHeader.#vName#.Item")>
   <cfset vOfficer = Evaluate("sHeader.#vName#.Officer")>
  </cfcase>
  <cfcase value="3">
   <cfset vLogDate = Evaluate("sHeader.#vName#.LogDate")>     
   <cfset vTransactionType = Evaluate("sHeader.#vName#.TransactionType")>        
  </cfcase>
  <cfcase value="4">
     <cfset vWarehouse = Evaluate("sHeader.#vName#.Warehouse")>
  </cfcase>
  
 </cfswitch>
 
 <cfset h = h + 1>
</cfloop>  

<!--- Getting financial information for the Upload --->
  <cfquery name="qItem" 
      datasource = "AppsMaterials"  
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	   SELECT ItemNo,ItemDescription,Category
	   FROM Item
	   WHERE ItemNo = '#vItem#'
  </cfquery>
  
  <cfset cCategory = qItem.Category>
  
  <cfquery name="ItemUoM"
   datasource="AppsMaterials" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
   SELECT  *
   FROM    ItemUoM
   WHERE   ItemNo = '#vItem#' 
   AND     UoM    = '#vUoM#'
  </cfquery>   
<!---------->  
  
<cfif URL.Warehouse neq vWarehouse or URL.Location neq vLocation>

	 <cfoutput>
	 <script>
	  alert('#url.pdfform# could not be uploaded as this file does not belong to the selected Warehouse/location #url.warehouse# -#vWarehouse#- #URL.Location# #vLocation#');
	  ColdFusion.navigate('../Transaction/TransactionLogSheetPDF.cfm?warehouse=#url.warehouse#&location=#url.location#','inputboxpdf');  
	 </script>
	  </cfoutput>
	 <cfabort>
	
	 
<cfelseif vItem neq Form.ItemNo>

 <cfoutput>
 
 <cfquery name="qItem"
     datasource = "AppsMaterials"  
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
	  SELECT ItemNo,ItemDescription,Category
	  FROM Item
	  WHERE ItemNo = '#Form.ItemNo#'
 </cfquery>
 
 <script>
  alert('#url.pdfform# could not be uploaded as this file does not belong to #qItem.ItemDescription# supply');
  ColdFusion.navigate('../Transaction/TransactionLogSheetPDF.cfm?warehouse=#url.warehouse#&location=#url.location#','inputboxpdf');  
 </script>
 <cfabort>
 </cfoutput>
 
<cfelse>
  <!---- DETAILS ---->
  <cfset d = 1>
  <cfset vDetails = 30>
  <cfloop condition= "#d# lte vDetails">
   <cfset vName = "Row#d#">
   
   <cfset vLogTime = Evaluate("sDetails.#vName#.LogTime")>
   <cfset vLogTime_Final = "">
   
   <cfloop from="1" to="6" index="i">
   
    <cfif i lte Len(vLogTime)>
     <cfset vCurrent = Mid(vLogTime,i,1)>
     <cfif vCurrent eq ":">
      <cfset vCurrent = "">
     </cfif>
    <cfelse>
     <cfset vCurrent = "0"> 
    </cfif> 
    
    <cfif i eq 3 or i eq 5>
     <cfset vLogTime_Final = vLogTime_Final & ":" & vCurrent >
    <cfelse> 
     <cfset vLogTime_Final = vLogTime_Final & vCurrent>    
    </cfif>     
   
   </cfloop>
   
   
  <cfinclude template="PDF\#vTransactionType#PDF.cfm">
  
  <cf_AssignId>
  <cfset Id = rowguid>
    
  
  <cfset tRecipient_Name  = Replace (vRecipient_Name," ","%")>
  
  	<cfquery name="qPerson" 
	       datasource = "AppsEmployee"  
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
		   SELECT TOP 1 * 
		   FROM  Person 
		   WHERE  1=1
		   <cfif vUNID neq "">
		   AND (IndexNo like '%#vUNID#%' OR Reference like '%#vUNID#%')
		   </cfif>
		   <cfif tRecipient_name neq "">
		   AND FullName like '%#tRecipient_name#%' 
		   </cfif>
    </cfquery>
  
  <cfif qPerson.recordcount neq 0>
     <cfset vPersonNo = qPerson.PersonNo>
  <cfelse>
     <cfset vPersonNo = ''>
  </cfif>
    
  <cfif vQTY neq "">
			   <cfquery name="Type"
			    datasource="AppsMaterials" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
				     SELECT *
				     FROM   Ref_TransactionType
			    	 WHERE  TransactionType = '#vType#'
			   </cfquery>   
			  
			    <cfquery name="AccountStock"
			    datasource="AppsMaterials" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			       SELECT   GLAccount
				    FROM    Ref_CategoryGLedger
				    WHERE   Category = '#qItem.Category#' 
				    AND     Area = 'Stock'
				    AND     GLAccount IN (SELECT GLAccount FROM Accounting.dbo.Ref_Account)
			   </cfquery> 
			     
			   <cfquery name="AccountTask"
			    datasource="AppsMaterials" 
			    username="#SESSION.login#" 
			    password="#SESSION.dbpw#">
			       SELECT   GLAccount
				    FROM    Ref_CategoryGLedger
				    WHERE   Category = '#qItem.Category#' 
				    AND     Area     = '#Type.Area#'
				    AND     GLAccount IN (SELECT GLAccount FROM Accounting.dbo.Ref_Account)
			   </cfquery>  
			   
			   <cftry>
			     <cfset _Time = TimeFormat(vLogTime_Final, "hh:mm:ss tt")>
			   <cfcatch>
			     <cfset vLogTime_Final = "00:00:00">
			   </cfcatch>
			   </cftry> 
			     
			   <cfif vTransactionType eq "Distribution">
				   <cfset debit   = "#AccountStock.GLAccount#">
				   <cfset credit  = "#AccountTask.GLAccount#">   
				<cfelse>
				   <cfset credit  = "#AccountStock.GLAccount#">
				   <cfset debit   = "#AccountTask.GLAccount#">   
				</cfif>  
			  
			   <cfset vQTY_Negative = -1 * vQTY>
			   <cfquery name="Line"
			   datasource="AppsQuery">
			   INSERT INTO StockTransaction#vWarehouse#_#vMode#  <!--- _#SESSION.acc# --->
			           ([TransactionId]
			           ,[TransactionType]
			           ,[TransactionDate]
			           ,[ItemNo]
			           ,[ItemDescription]
			           ,[ItemCategory]
			           ,[Mission]
			           ,[Warehouse]
					   ,[BillingMode]
			           ,[Location]
			           ,[LocationTransfer]
			           ,[TransactionReference]
			           ,[TransactionUoM]
			           ,[TransactionQuantity]
			           ,[TransactionUoMMultiplier]
			           ,[TransactionCostPrice]
			           ,[TransactionBatchNo]
			           ,[CustomerId]
			           ,[WorkorderId]
			           ,[WorkorderLine]
			           ,[BillingUnit]
			           ,[SalesPrice]
			           ,[AssetId]
					   ,[AssetMetric1]
					   ,[AssetMetricValue1]
			           ,[PersonNo]
			           ,[OrgUnit]
			           ,[OrgUnitCode]
			           ,[OrgUnitName]
			           ,[Remarks]
			           ,[GLAccountDebit]
			           ,[GLAccountCredit])
			    VALUES(
			      '#id#'
			         ,'#vType#'
			         ,'#vLogDate# #TimeFormat(vLogTime_Final, "hh:mm:ss tt")#'
			         ,'#vItem#'
			         ,'#qItem.ItemDescription#'
			         ,'#cCategory#'
			         ,'#vMission#' 
			         ,'#vWarehouse#' 
					 ,'#WarehouseLocation.BillingMode#'
			         ,'#vLocation#'
					 <cfif vTransactionType eq "Distribution">
				         ,NULL
					 <cfelse>
					 	 ,'#vDestination#'	 
					 </cfif>
			         ,'#vReference#'
			         ,'#vUoM#'
			         ,'#vQTY_Negative#'
			         ,1
			         ,'#ItemUom.StandardCost#'
			         ,NULL
			         ,NULL
			         ,NULL
			         ,NULL
			         ,NULL
			         ,0
			 	   <cfif vTransactionType eq "Distribution">
					      <cfif qAsset.recordcount neq 0>
					          ,'#qAsset.AssetId#'
					      <cfelse>
					       , NULL
					      </cfif> 
					      ,'#cMetric#'
					      ,'#vMetric#'
					      ,'#vPersonNo#'
				    	 <cfif qOrganization.recordcount neq 0>
					         ,'#vUnit#'
					         ,'#qOrganization.OrgUnitCode#'
					         ,'#qOrganization.OrgUnitName#'
					      <cfelseif vUnit neq "">
					         ,'#vUnit#'
					         ,'#qItemOrganization.OrgUnitCode#'
					         ,'#qItemOrganization.OrgUnitName#' 
					      <cfelse>
						      ,NULL
						      ,NULL
						      ,NULL     
					      </cfif>
					<cfelse>
					          ,NULL		
						      ,NULL
						      ,NULL
						      ,'#vPersonNo#'
						      ,NULL
						      ,NULL
						      ,NULL     			
					</cfif>  
			         ,''
			         ,'#debit#' 
			         ,'#credit#' 
			    )  
			   </cfquery>  
			   
			   <cfif vTransactionType eq "Transfer">
				   <cfquery name="Line"
				   datasource="AppsQuery">
				   INSERT INTO StockTransaction#vWarehouse#_#vMode# <!--- _#SESSION.acc# --->
			           ([TransactionId]
			           ,[TransactionType]
			           ,[TransactionDate]
			           ,[ItemNo]
			           ,[ItemDescription]
			           ,[ItemCategory]
			           ,[Mission]
			           ,[Warehouse]
					   ,[BillingMode]
			           ,[Location]
			           ,[LocationTransfer]
			           ,[TransactionReference]
			           ,[TransactionUoM]
			           ,[TransactionQuantity]
			           ,[TransactionUoMMultiplier]
			           ,[TransactionCostPrice]
			           ,[TransactionBatchNo]
			           ,[CustomerId]
			           ,[WorkorderId]
			           ,[WorkorderLine]
			           ,[BillingUnit]
			           ,[SalesPrice]
			           ,[AssetId]
					   ,[AssetMetric1]
					   ,[AssetMetricValue1]
			           ,[PersonNo]
			           ,[OrgUnit]
			           ,[OrgUnitCode]
			           ,[OrgUnitName]
			           ,[Remarks]
			           ,[GLAccountDebit]
			           ,[GLAccountCredit])
			    VALUES(
			      '#id#'
			         ,'#vType#'
			         ,'#vLogDate# #TimeFormat(vLogTime_Final, "hh:mm:ss tt")#'
			         ,'#vItem#'
			         ,'#qItem.ItemDescription#'
			         ,'#cCategory#'
			         ,'#vMission#' 
			         ,'#vWarehouse#' 
					 ,'#WarehouseLocation.BillingMode#'
			         ,'#vDestination#'
				 	 ,'#vLocation#'	 
			         ,'#vReference#'
			         ,'#vUoM#'
			         ,'#vQTY#'
			         ,1
			         ,'#ItemUom.StandardCost#'
			         ,NULL
			         ,NULL
			         ,NULL
			         ,NULL
			         ,NULL
			         ,0
			         ,NULL		
				     ,NULL
				     ,NULL
				     ,'#vPersonNo#'
				     ,NULL
				     ,NULL
				     ,NULL     			
			         ,''
			         ,'#debit#' 
			         ,'#credit#' 
			    )  
			   </cfquery>  
			   
			   
		   </cfif>
   
   
   </cfif>
   <cfset d = d + 1>
  </cfloop>
  
  <cfset vTimeStamp = dateFormat(now(),"yyyymmdd") & "-" & timeFormat(now(), "hhmmsslllt") & "_">
  <cffile action="MOVE" source="#getDirectory.DocumentFileServerRoot#\StockLogSheet\#url.warehouse#\#url.pdfform#" destination="#getDirectory.DocumentFileServerRoot#\StockLogSheet\history\#url.warehouse#\#vTimeStamp##url.pdfform#">
</cfif>
<cfoutput>
 <script>
  ColdFusion.navigate('../Transaction/TransactionLogSheetPDF.cfm?warehouse=#url.warehouse#&location=#url.location#','inputboxpdf');  
 </script>
</cfoutput> 
