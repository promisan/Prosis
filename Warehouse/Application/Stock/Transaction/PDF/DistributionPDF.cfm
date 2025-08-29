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
  <cfset vMetric = Evaluate("sDetails.#vName#.Metric")>
  <cfset vQty = Evaluate("sDetails.#vName#.QTY")>
  <cfset vRecipient_name = Evaluate("sDetails.#vName#.Recipient_Name")>
  <cfset vBarCode        = Evaluate("sDetails.#vName#.Barcode")>
  <cfset vReference      = Evaluate("sDetails.#vName#.Reference")>   
  <cfset vUnit           = Evaluate("sDetails.#vName#.Unit")>
  <cfset vUNID           = Evaluate("sDetails.#vName#.UNID")>
  <cfset vPlate          = Evaluate("sDetails.#vName#.Plate")>	
  <cfset vType = 2>

<!---- ASSET CHECKING ---->
  
  <cfquery name="qAsset" 
      datasource = "AppsMaterials"  
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
		SELECT *
		FROM   AssetItem
		WHERE 1=1
		<cfif vBarcode neq ""> 
			AND AssetBarCode = '#vBarcode#'
		</cfif>
		<cfif vPlate neq "">
			AND AssetDecalNo = '#vPlate#' 
		</cfif> 
	   AND   Mission = '#vMission#'
  </cfquery> 
  
   <cfif qAsset.recordcount neq 0>
   
     <cfquery name="qItemChecking" 
	    datasource = "AppsMaterials"  
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
    	  SELECT ItemNo,ItemDescription,Category
	      FROM Item
	      WHERE ItemNo = '#qAsset.ItemNo#'
     </cfquery>
   
     <cfquery name = "qCategoryChecking" 
	    datasource= "AppsMaterials"  
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
    	  SELECT  * 
	      FROM Ref_AssetActionCategory
	      WHERE Category     = '#qItemChecking.Category#'
    	  AND ActionCategory = '#C_ACTION_CATEGORY#'   
     </cfquery>
     
     <cfif qCategoryChecking.EnableTransaction eq 0 or qCategoryChecking.recordcount eq 0>
      <!---- Both metric and value are ignored --->
        <cfset cMetric = "">
        <cfset vMetric = "">        
     <cfelse> 
       
	   <!---- We should be able to determine the metric for the PDF load--->
       
	   <cfquery name = "qMetricChecking" 
	        datasource= "AppsMaterials"  
			username="#SESSION.login#" 
			password="#SESSION.dbpw#"> 
           SELECT Metric
           FROM   Ref_AssetActionMetric        
           WHERE  FieldDefault = '1'
           AND    ActionCategory = '#C_ACTION_CATEGORY#'   
           AND    Category = '#qItemChecking.Category#'
       </cfquery>   
	     
       <cfif qMetricChecking.recordcount neq 0>
        <cfset cMetric = "#C_ACTION_CATEGORY#.#qMetricChecking.Metric#">      
       <cfelse>
        <cfset cMetric = ""> 
       </cfif>
     </cfif>

   <cfelse> 
        <cfset cMetric = "">    
   </cfif>


<!---- ORGANIZATIONAL CHECKING --->  
  
  
  
  <cfquery name="qOrganization" datasource="AppsOrganization"  
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   SELECT OrgUnit,OrgUnitCode,OrgUnitName 
		   FROM   Organization
		   WHERE  Mission = '#vMission#'
		   AND   OrgUnit = '#vUnit#'
  </cfquery>  
  
  <cfif qOrganization.recordcount eq 0 >
    <cfif qAsset.recordcount neq 0>
     <!--- Organization did not come in the PDF, so we will try to get it from the location --->
	 
     <cfquery name="qAssetOrganization" 
	        datasource = "AppsMaterials"  
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
		      SELECT   TOP 1 *
		      FROM     AssetItemOrganization
		      WHERE    AssetId = '#qAsset.AssetId#'
		      ORDER BY Created DESC
     </cfquery>  
    
     <cfset vUnit = qAssetOrganization.OrgUnit > 
 
	     <cfquery name="qItemOrganization" 
		        datasource="AppsOrganization"  
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
			      SELECT OrgUnit,OrgUnitCode,OrgUnitName 
		    	  FROM   Organization
			      WHERE  Mission = '#vMission#'
		    	  AND    OrgUnit = '#vUnit#'
	     </cfquery>  
	  
    <cfelse>
	
     <cfset vUnit = "">
    
    </cfif>  
  
  </cfif>

  
  
  