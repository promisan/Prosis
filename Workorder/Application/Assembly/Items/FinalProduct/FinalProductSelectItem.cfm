
<cfform method="POST" name="selectionform" id="selectionform">

<table>

<cfparam name="url.uom" default="">

<cf_verifyOperational 
         datasource= "AppsMaterials"
         module    = "Accounting" 
		 Warning   = "No">
		 
	<cfquery name="getItemMaster" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Item
		WHERE   ItemNo = '#url.ItemNo#'		
	</cfquery>	 
	
	<cfquery name="getItemUoM" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    ItemUoM
		WHERE   ItemNo = '#url.ItemNo#'		
	</cfquery>	 
			
	<cfif getItemMaster.recordcount eq 0>
		
		<cfabort>
	
	</cfif>			
			
	<cfquery name="Cat" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT  *
		FROM    Ref_Category R	
		WHERE 	Category IN (SELECT Category 
		                     FROM   Warehouse W, WarehouseCategory WC
		                     WHERE  W.Warehouse = W.Warehouse
							 AND    W.Mission   = '#url.mission#')
		<cfif Operational eq "1">
		<!--- has a valid GL account --->
		AND 	R.Category IN (SELECT Category 
		                       FROM   Ref_CategoryGLedger R
						       WHERE  Area = 'Stock'
						       AND    GLAccount IN (SELECT GLAccount 
						                            FROM   Accounting.dbo.Ref_Account A
												    WHERE  A.GLAccount = R.GLAccount)
						   )
		</cfif>
		<!--- has subitems defined --->
		AND		R.Category IN (SELECT Category 
		                       FROM   Ref_CategoryItem 
							   WHERE  Category = R.Category)  
	</cfquery>
	
	<cfif getItemMaster.recordcount eq "0">
		<cfset cl = "regular">
	<cfelse>
	    <cfset cl = "hide">
	</cfif>
		
	<cfquery name="getTopics" 
	      datasource="AppsMaterials"
		  username="#SESSION.login#" 
		  password="#SESSION.dbpw#">
		  SELECT   *
		  FROM     Ref_Topic T, Ref_TopicEntryClass C
		  WHERE    T.Code = C.Code
		  AND      EntryClass IN (SELECT EntryClass 
		                          FROM   Purchase.dbo.ItemMaster 
								  WHERE  Code = '#url.itemmaster#')
		  AND      T.Operational = 1
		  AND      ValueClass IN ('List','Lookup')
		  ORDER BY ListingOrder
	</cfquery>
			
	<cfset row = 0>
	
	<cfset cont = 0>
	
	<cfoutput>
	<tr class="line"><td colspan="4" class="labelmedium">#getItemMaster.ItemDescription#</td></tr>	
	</cfoutput>
	
	<cfoutput query="getTopics">		
		
	    <cfif ValueClass eq "List" or ValueClass eq "Lookup">
				
			<cfset cont = cont +1>
		
			<cfset row = row+1>
			<cfset ip  = itempointer>
			
			<cfif row eq "1">
			<tr>
			</cfif>
						
			    <td style="padding-right:5px">					
					
					<cfset lastSelected = "">
					
					<table cellspacing="0" cellpadding="0" style="border:1px solid silver">
					
						<tr><td valign="top" bgcolor="black" class="labelit" style="padding-left:4px;"><font color="FFFFFF">#TopicLabel#:</td></tr>
						
						<tr><td class="line"></td></tr>
					
						<tr><td style="padding:4px" bgcolor="f4f4f4">
							<input type="text" 
							onkeyup="_cf_loadingtexthtml='';ptoken.navigate('getTopic.cfm?ip=#ip#&workorderid=#url.workorderid#&workorderline=#url.workorderline#&code=#code#&itemno=#url.itemno#&uom=#url.UoM#&find='+this.value,'box_#GetTopics.Code#')"
							class="regularxl" 
							style="padding-left:3px;border:1px solid silver;width:100%" name="Filter_#GetTopics.Code#">
						</td></tr>
						
						<tr><td class="line"></td></tr>
						
						<tr>
						<td id="box_#GetTopics.Code#">		
						     <!--- show the selectable content for the topic --->		
							 <cfset url.ip = ip>		
							<cfinclude template="getTopic.cfm">						
						</td>
						</tr>
						
					</table>			
				
				</td>				
	
			<cfif row eq "4">	
			</tr>
			<cfset row=0>
			</cfif>
				
		</cfif>
		
	</cfoutput> 

</table>

</cfform>