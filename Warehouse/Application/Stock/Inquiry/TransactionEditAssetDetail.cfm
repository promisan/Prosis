
<!--- --------- --->
<!--- edit mode --->
<!--- --------- --->

<cfparam name="entrymode" default="standard">
	
<cfif get.Assetid neq "">				

	<cfquery name="ass" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
			FROM     AssetItem
			WHERE    AssetId = '#get.AssetId#'				
	</cfquery>
	
	<cfquery name="item" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
			FROM     Item
			WHERE    ItemNo = '#ass.ItemNo#'				
	</cfquery>
		
	<!--- to complete further on sunday or monday  --->
	
	<tr>
	   <td class="labelit" valign="top" style="padding-top:1px;height:30;padding-left:10px">
	   
		   <table>
		   <tr>
		   <td width="30">
	  				
		       <cfset link = "#SESSION.root#/warehouse/application/stock/Transaction/getAsset.cfm?transactionid=#get.transactionid#">								   
				
			   <cf_selectlookup
					    box          = "assetbox"
						link         = "#link#"
						title        = "Item Selection"
						icon         = "find1.png"
						button       = "No"
						close        = "Yes"					
						filter1      = "mission"
						filter1value = "#get.mission#"		
						filter2      = "warehouse"
						filter2value = "#get.warehouse#"		
						filter3      = "category"
						filter3value = "#Item.Category#"		
						filter4      = "supply"
						filter4value = "#get.ItemNo#"		
						class        = "Asset"
						des1         = "AssetId">							
									
			</td>	
			<cfif entrymode neq "hidelabel">			   
		    <td class="labelit"><b><cf_tl id="Equipment"></td>		   
			</cfif>
			<td><input type="hidden" id="assetid" name="assetid" value="#get.AssetId#"></td>
		   </tr>		   
		   </table>
	   </td>
	   
	   <td colspan="3">		  
	   
	   <cfdiv id="assetbox" 
	      bind="url:#SESSION.root#/warehouse/application/stock/Transaction/getAsset.cfm?assetid=#get.assetid#&transactionid=#get.transactionid#">
	   		   
	   </td>
	   
	</tr>
	<tr><td colspan="4" style="border-top:1px dotted silver"></td></tr>

</cfif>			

<tr>
   <td class="labelit" valign="top" style="padding-top:1px;height:30;padding-left:10px">
     <table>
		<tr>
		   <td width="30">

			    <cfset link = "#SESSION.root#/warehouse/application/stock/Transaction/getUnit.cfm?mission=#get.mission#">	
						   
			   	  <cf_selectlookup
				    box          = "unitbox"
					link         = "#link#"
					title        = ""
					icon         = "find1.png"
					button       = "No"
					close        = "Yes"	
					filter1      = "mission"
					filter1value = "#get.mission#"					
					class        = "organization"
					des1         = "OrgUnit">	
		   </td>
		   <cfif entrymode neq "hidelabel">	
   		   <td class="labelit"><b><cf_tl id="Unit">					
		   </cfif>
		   </td>	
     	   <td><input type="hidden" id="orgunit" name="orgunit" value="#get.Orgunit#"></td>
		</tr>   
	 </table>		
   </td>
   <td colspan="3">
   <cfdiv id="unitbox" 
	      bind="url:#SESSION.root#/warehouse/application/stock/Transaction/getUnit.cfm?mission=#get.mission#&orgunit=#get.OrgUnit#">
	  
   </td>
</tr>
<tr><td colspan="4" style="border-top:1px dotted silver"></td></tr>		
<tr>
   <td class="labelit" valign="top" style="padding-top:3px;height:30;padding-left:10px">
     <table>
		<tr>
		   <td width="30">
		   
		     <cfset link = "#SESSION.root#/warehouse/application/stock/Transaction/getPerson.cfm?">	
						   
			   	  <cf_selectlookup
				    box          = "personbox"
					link         = "#link#"
					title        = ""
					icon         = "find1.png"
					button       = "No"
					close        = "Yes"	
					filter1      = "mission"
					filter1value = "#get.mission#"					
					class        = "employee"
					des1         = "PersonNo">	
		   
		   
		   </td>
		   <cfif entrymode neq "hidelabel">	
   		   <td class="labelit"><b><cf_tl id="Receiver">
		   </cfif>
		   </td>	
     	   <td><input type="hidden" id="personno" name="personno" value="#get.PersonNo#"></td>
		</tr>   
	 </table>		   
   </td>
   <td colspan="3">
   <cfdiv id="personbox" 
	      bind="url:#SESSION.root#/warehouse/application/stock/Transaction/getPerson.cfm?personno=#get.PersonNo#">
   </td>
</tr>