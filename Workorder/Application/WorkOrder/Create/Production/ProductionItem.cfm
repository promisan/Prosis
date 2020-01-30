<table class="formpadding" width="98%" align="center">
	
	<cfquery name="PhaseItems" 
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">				 
			 SELECT    Wi.ServiceDomain,
			           Wi.Reference, 
					   Wi.ItemNo, 
					   Wi.UoM, 
					   Wi.Operational,
					   I.ItemDescription, 
					   U.UoMDescription, 
					   U.ItemBarCode,
					   (SELECT count(*) FROM Materials.dbo.ItemUoM WHERE ItemNo = Wi.ItemNo) as Items,
					   U.ItemUoMId
			 FROM      WorkOrderServiceItem AS Wi INNER JOIN
	                   Materials.dbo.Item AS I ON Wi.ItemNo = I.ItemNo INNER JOIN
	                   Materials.dbo.ItemUoM AS U ON Wi.ItemNo = U.ItemNo AND Wi.UoM = U.UoM INNER JOIN
					   Materials.dbo.ItemUoMMission M ON U.ItemNo = M.ItemNo AND U.UoM = M.UoM AND M.Mission = '#url.mission#'
			 WHERE     Wi.Operational    = 1  
			 AND       I.Operational     = 1
			 AND       U.Operational     = 1		      
			 AND       Wi.ServiceDomain  = '#serviceitem.serviceDomain#'
			 AND       Wi.Reference      = '#Reference#'		
			 ORDER BY I.ItemDescription, Wi.ItemNo
	</cfquery>	
			
	<cfoutput query="PhaseItems" group="ItemDescription">
		
			<tr class="cls#row# line">											
				<td colspan="3" style="height:30px;padding-bottom:0px" class="ccontent#row# labelmedium">#ItemDescription#</td>				
			</tr>
			
			<tr><td height="4"></td></tr>
	
		<cfset ln = 0>
		
		<cfoutput>
		
			<cfif ln eq "0">
			<tr class="cls#row#">	
			  <td class="hide ccontent#row#">#ItemDescription#</td>					
			</cfif>
										
				<td>
					<table>
					<tr>					
					<td style="width:80px;padding-left:10px" class="labelit ccontent#row#">#ItemBarCode#</td>
					<td style="width:120px;padding-left:6px" class="ccontent#row# labelit">#UoMDescription#</td>
					<td class="labelit" style="width:80px;padding-left:8px">		
					 <input type="text" class="regularh enterastab" 
					    onchange="document.getElementById('item#row#_#left(itemuomid,8)#').value='#itemuomid#'" 
					    style="width:40;text-align:right"
						name="value#row#_#left(itemuomid,8)#" value="">
						
					 <!--- contains the items --->	
					 <input type="hidden" name="item#row#" id="item#row#_#left(itemuomid,8)#" value="">					 
					</td>					
					</tr>
					</table>
					
				</td>				
				
			<cfset ln = ln+1>
			
			<cfif ln eq "3">	
				</tr>
				<cfset ln = "0">
			</cfif>
			
		</cfoutput>	
		
		
	
	</cfoutput>
		
</table>