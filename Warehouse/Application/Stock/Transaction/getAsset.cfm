<!--- retrieve the item --->

<cfparam name="url.assetid"       default="">
<cfparam name="url.search"        default="">
<cfparam name="url.mission" 	  default="">
<cfparam name="url.transactionid" default="">
<cfparam name="url.table" 		  default="">

<script>
 try { 
 document.getElementById('assetselectbox').className = "hide" 
 } catch(e) {}
</script>

<cfif url.assetid neq "">

	<cfquery name="Get" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   A.*, C.Category
			FROM     AssetItem A INNER JOIN Item I ON A.ItemNo = I.ItemNo 
				INNER JOIN Ref_Category C ON C.Category = I.Category  
			<cfif url.assetid eq "">
			WHERE 1=0
			<cfelse>
			WHERE    AssetId = '#url.AssetId#'		
			</cfif>
			<!--- limit to items enabled for warehouse only 	
							 
			<cfif Category.DistributionFilter eq "1">
			
				AND        A.AssetId IN (
				                         SELECT AssetId 
				                         FROM   AssetItemSupplyWarehouse 
										 WHERE  AssetId      = A.Assetid
										 AND    SupplyItemNo = '#url.itemno#'
										 AND    Warehouse    = '#url.warehouse#' 
										 ) 
			</cfif>		
			--->					
			
			
	</cfquery>

<cfelse>

	<cfif url.search eq "">
	
		<cfquery name="Get" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   A.*, C.Category
			FROM     AssetItem A INNER JOIN Item I ON A.ItemNo = I.ItemNo 
				INNER JOIN Ref_Category C ON C.Category = I.Category  			
			WHERE 1=0			
	     </cfquery>
		 
	<cfelse>
		
		<cfquery name="Get" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   A.*, C.Category
			FROM     AssetItem A INNER JOIN Item I ON A.ItemNo = I.ItemNo 
				INNER JOIN Ref_Category C ON C.Category = I.Category  			
			WHERE   AssetBarCode LIKE '%#url.search#%'		
			AND     A.Mission = '#url.mission#'			
	     </cfquery>
		 
		 <cfset url.assetid = get.AssetId>
		 
		 <cfif get.recordcount eq "0">
		 		 
			 <cfquery name="Get" 
				datasource="AppsMaterials" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
				SELECT   A.*, C.Category
				FROM     AssetItem A INNER JOIN Item I ON A.ItemNo = I.ItemNo 
					INNER JOIN Ref_Category C ON C.Category = I.Category  			
				WHERE    SerialNo LIKE '%#url.search#%'	
				AND     A.Mission = '#url.mission#'				
		     </cfquery>
			 
			 <cfset url.assetid = get.AssetId>		 
		 
		 </cfif>
		
	</cfif>	 

</cfif>

<cfif get.Mission eq "">
	<cfset vMission = URL.Mission>
<cfelse>
	<cfset vMission = get.Mission>
</cfif>

<cfquery name="Organization" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   TOP 1 *
		FROM     AssetItemOrganization
		<cfif url.assetid eq "">
		WHERE 1=0
		<cfelse>
		WHERE    AssetId = '#url.AssetId#'		
		</cfif>		
		ORDER BY DateEffective DESC
</cfquery>

<cfquery name="Unit" 
		datasource="AppsOrganization" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT   *
		FROM     Organization
		WHERE    OrgUnit = '#Organization.OrgUnit#'				
</cfquery>

<cfif url.assetid eq "" and url.search neq "">

	<cfoutput>
		<cf_tl id = "Not found." var = "1">
		<script>
			alert("#lt_text#")	
		</script>
	</cfoutput>

<cfelse>
		
	<cfoutput>	
				
		<script language="JavaScript">				   
			$("##assetbox").css({'background-color' : '##fafafa'});							
			$("##assetid").val("#URL.assetid#");												
			adate = $("##transaction_date").val();						
			whs   = $("##warehouse").val();
								
			if (adate) {
			// alert('#SESSION.root#/Warehouse/Application/Stock/Transaction/getAssetDetails.cfm?assetid=#url.assetid#&adate='+adate+'&transactionid=#url.transactionid#&table=#url.table#&whs='+whs)
			ColdFusion.navigate('#SESSION.root#/Warehouse/Application/Stock/Transaction/getAssetDetails.cfm?assetid=#url.assetid#&adate='+adate+'&transactionid=#url.transactionid#&table=#url.table#&whs='+whs,'assetbox')
			} else {			
			ColdFusion.navigate('#SESSION.root#/Warehouse/Application/Stock/Transaction/getAssetDetails.cfm?assetid=#url.assetid#&transactionid=#url.transactionid#&table=#url.table#&whs='+whs,'assetbox')			
			}			
			ColdFusion.navigate('#SESSION.root#/Warehouse/Application/Stock/Transaction/getUnit.cfm?orgunit=<cfif unit.orgunit eq ''>0<cfelse>#unit.orgunit#</cfif>&mission=#vmission#','unitbox')			
			// 2/1/2012 disabled in order not to overwrite specifically set person, do not enable again 
			// ColdFusion.navigate('#SESSION.root#/Warehouse/Application/Stock/Transaction/getPerson.cfm?personno=0&mission=#vmission#','personbox')
		</script>		
	
	</cfoutput>

</cfif>



