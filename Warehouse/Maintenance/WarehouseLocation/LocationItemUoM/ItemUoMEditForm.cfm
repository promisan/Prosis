<cfoutput>

<cfquery name="getItem" 
     datasource="AppsMaterials" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">		 
	 SELECT    *
	 FROM      ItemWarehouseLocation 
	 <cfif url.drillid eq "">
	 WHERE     1 = 0
	 <cfelse>
	 WHERE     ItemLocationId = '#url.drillid#'
	 </cfif>	 
</cfquery>

<cfif url.drillid neq "">
	<cfset url.warehouse = getItem.Warehouse>
	<cfset url.location  = getItem.Location>
</cfif>

<cfquery name="Warehouse" 
	     datasource="AppsMaterials" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">		 
		 SELECT    *
		 FROM      Warehouse
		 WHERE Warehouse = '#url.Warehouse#'		 
</cfquery>

<cfquery name="Location" 
	     datasource="AppsMaterials" 
	     username="#SESSION.login#" 
	     password="#SESSION.dbpw#">		 
		 SELECT    *
		 FROM      WarehouseLocation
		 WHERE     Warehouse = '#url.Warehouse#'		 
		 AND       Location  = '#url.location#'
</cfquery>

<cfquery name="OnHand" 
    datasource="AppsMaterials" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
		SELECT   ISNULL(SUM(TransactionQuantityBase),0) as Stock
        FROM     ItemTransaction
        WHERE    Warehouse = '#getItem.warehouse#'
		AND      Location = '#getItem.location#'
		AND      ItemNo = '#getItem.itemNo#'
		AND      TransactionUoM = '#getItem.UoM#'
</cfquery>

<cfif url.drillid neq "">

	<cf_tl id="Strapping Table Edit" var="vTitle1"> 
	<cfwindow 
		name="StrappingEdit" 
		title="#vTitle1#"
	 	source="../LocationItemStrapping/StrappingListEdit.cfm?warehouse=#URL.warehouse#&location=#url.location#&itemNo=#getItem.ItemNo#&uoM=#getItem.UoM#&height=#Location.StorageHeight#" 
		height="700" 
		width="850" 
		modal="True" 
		closable="True" 
		draggable="False" 
		resizable="True" 
		initshow="False" 
		minheight="200" 
		minwidth="200"  
		center="True"
		refreshonshow="True">
		
	</cfwindow>
	
	<cf_tl id="Strapping Table Copy" var="vTitle2"> 
	<cfwindow 
		name="StrappingCopy" 
		title="#vTitle2#"
	 	source="../LocationItemStrapping/StrappingListCopy.cfm?warehouse=#URL.warehouse#&location=#url.location#&itemNo=#getItem.ItemNo#&uoM=#getItem.UoM#&height=#Location.StorageHeight#" 
		height="400" 
		width="500" 
		modal="True" 
		closable="True" 
		draggable="False" 
		resizable="True" 
		initshow="False" 
		minheight="200" 
		minwidth="200"  
		center="True"
		refreshonshow="True">
		
	</cfwindow>
	
	<cf_tl id="Loss Variance Definition Copy" var="vTitle3"> 
	
	<cfwindow 
		name="LossesCopy" 
		title="#vTitle3#"
	 	source="../LocationItemLosses/AcceptableLossesCopy.cfm?warehouse=#URL.warehouse#&location=#url.location#&itemNo=#getItem.ItemNo#&uoM=#getItem.UoM#&locationclass=#location.locationClass#" 
		height="500" 
		width="650" 
		modal="True" 
		closable="True" 
		draggable="False" 
		resizable="True" 
		initshow="False" 
		minheight="200" 
		minwidth="200"  
		center="True"
		refreshonshow="True">
		
	</cfwindow>

</cfif>

<table class="hide"><tr><td><iframe id="saveform" name="saveform"></iframe></td></tr></table>

<cfform  width="100%" name="itemuomform" onsubmit="return false">

<table width="100%" style="min-width:1000px" align="center" class="formpadding">

	<tr><td>

	<table width="99%" align="center" class="formpadding">
		
	<tr class="labelmedium line">
						
		<cfparam name="url.mode" default="standard">
		<cfoutput>
			<input type="hidden" name="drillid" id="drillid" value="#url.drillid#">	
		</cfoutput>
		
		<cfif url.drillid eq "">
		
			<td height="22" width="100" style="height:60px;font-size:20px;padding:1px" ><cf_tl id="Product">:</td>
			<TD width="100%" colspan="6" style="padding:1px">
		
			<table width="100%">
			
				<tr><td width="20">				
					      
						   <cfset link = "#SESSION.root#/warehouse/application/stock/Transaction/getItem.cfm?mode=#url.mode#&warehouse=#url.warehouse#">	
										      		
						   <cf_tl id="Item Supplies Selection" var="vTitle4"> 							   
						   <cf_selectlookup
								    box          = "itembox"
									link         = "#link#"
									title        = "#vTitle4#"
									icon         = "contract.gif"
									iconheight   = "25px"
									iconwidth    = "25px"
									button       = "Yes"
									close        = "Yes"	
									filter1      = "warehouse"
									filter1value = "#url.warehouse#"						
									filter2      = "itemclass"
									filter2value = "Supply"
									class        = "Item"
									des1         = "ItemNo">	
								
							<!--- also filter for location --->							
							<input type="hidden" name="itemno" id="itemno" size="4" value="" class="regular" readonly style="text-align: center;">	
				
				</td>
				
				<td id="itembox" style="width:700px;padding-left:6px"></td>
				<td id="uombox" style="padding-left:3px"> 
				<td id="process" style="width:20px;padding-left:3px"> 
 	   			</tr>
			
			</table>	
		
		<cfelse>
					
		    <TD width="100%" colspan="5" style="padding:1px">
		
			<cfquery name="Item" 
		     datasource="AppsMaterials" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">		 
			 SELECT    *
			 FROM      Item
			 WHERE     ItemNo = '#getItem.ItemNo#'			
			</cfquery>
			
			<font face="Calibri" size="5"><b>#Item.ItemDescription#</font>
			
			<cfquery name="UoM" 
		     datasource="AppsMaterials" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">		 
			 SELECT    *
			 FROM      ItemUoM
			 WHERE     ItemNo = '#getItem.ItemNo#'			
			 AND       UoM    = '#getItem.UoM#'
			</cfquery>
			
			<font face="Calibri" size="4">
			 in #UoM.UoMDescription#
			</font>
						
			</TD>		
				
			<td id="process" colspan="1" align="right" style="width:200">
		
				<table align="right" width="200">
				
					<tr class="hide"><td id="saveform"></td></tr>
					
					<tr  style="height:20px" class="labelmedium">
						<td style="width:130px;padding-left:10px" ><cf_tl id="On Hand">:</td>
						<td align="right" style="width:70;padding-left:10px"><cfif OnHand.stock lt 0><font color="FF0000"><b></cfif>#lsNumberFormat(OnHand.Stock,",")#</td>
					</tr>
					
					<tr style="height:20px" class="labelmedium">
					
						<td style="padding-left:10px"><cf_tl id="Acceptable Loss">:</td>
						<td align="right" style="padding-left:10px">
						
							<cf_getLossValue
								id="#getItem.ItemLocationId#"
								date="#now()#">		
											
								 <a title="View loss detail"
								   href="javascript: viewLossDetail('#getItem.ItemLocationId#');" 
								   style="color:0080FF;"><u>#lsNumberFormat(resultTotalLoss,",.__")#</a>
						
						</td>
											
					</tr>
					
				</table>
				
		    </td>
		
		</cfif>
		
	</tr> 
			
	<!---	
	<tr>		
	<td height="25" colspan="6" width="25%" class="labellarge" style="padding-left:2px;font-size:17px;height:29px;padding-top:5px"><cf_UIToolTip  tooltip="Item Capacity Levels in storage">
	    <font color="0080C0"><cf_tl id="Item Stock Capacity Levels in location"></cf_UIToolTip>
	</td>
	--->
	
	<tr><td style="height:5px"></td></tr>
				
	<tr>
		<td style="padding-left:2px" class="labelmedium"><cf_tl id="Technical Capacity">: <cf_space spaces="50"></td>
		
		<td style="padding:1px">
		
		<cfif getItem.recordcount eq "1">
		    <cfset val = getItem.HighestStock>
		<cfelse>
		 	<cfset val = "0">		 
		</cfif>
		
		<cfinput type="text" 
		        class="regularxl" 
				name="HighestStock" 
				validate="integer"
				message="Invalid higest stock"
				size="8"
				value="#val#" 
				style="text-align:right;padding-right:2px">
		
		<input type="Hidden" name="HighestStockOld" id="HighestStockOld" value="#val#">
		
		</td>
					
		<td height="15" style="padding-left:20px" class="labelmedium"><cf_space spaces="30"><cf_tl id="Authorised">:</td>
		
		<td style="padding:1px">
			 
			<cfif getItem.recordcount eq "1">
			    <cfset val = getItem.MaximumStock>
			 <cfelse>
			 	<cfset val = "0">		 
			 </cfif>
			 
			 <cfinput type="text" 
			        class="regularxl" 
					name="MaximumStock" 
					size="8"
					validate="integer"
					message="Invalid maximum stock"
					value="#val#" 
					style="text-align:right;padding-right:2px">
					
			<input type="Hidden" name="MaximumStockOld" id="MaximumStockOld" value="#val#">
					
				</td>	
			
				<td style="padding-left:10px" height="15" style="padding:1px" class="labelmedium"><cf_tl id="Unusable">:&nbsp;</td>
		
			    <td  style="padding:1px" width="40%">
				
				<table><tr><td>
				
				<cfinput type="text" 
				       class="regularxl" 
					   name="LowestStock" 
					   size="6"
					   validate="integer"
					   message="Invalid lowest stock"
					   value="#getItem.LowestStock#" 
					   style="text-align:right;padding-right:2px">
					   
				</td>
				
				<td height="18" style="padding-left:20px" class="labelmedium">
				<cf_space spaces="40">
				<cf_tl id="Pickticket Order">:</td>
					<td style="padding:1px">
					
					<cfif getItem.recordcount eq "1">
					    <cfset val = getItem.PickingOrder>
					<cfelse>
					 	<cfset val = "0">		 
					</cfif>
					
					<cfinput type="text" 
					        class="regularxl" 
							name="PickingOrder" 
							size="1"
							validate="integer"
							message="Invalid order"
							value="#val#" 
							style="text-align:center">
					</td>
				
				</tr></table>
					   
				</td>
				
				</tr>
			
		
		</td>	    		
	</tr>
		
	<!--- ---------------------------------- --->
	<!--- Stock level for product / location --->
	<!--- ---------------------------------- --->
			
	<tr>	
	
	<td class="labellarge" colspan="6" width="25%" style="padding-left:2px;font-size:17px;height:35px;">
	    <cf_tl id="Location Stock Safety Levels">
		
		<!---
	    <cf_UIToolTip  tooltip="Record the number of days over which the average distribution will be calculated">
		</cf_UIToolTip>
		--->
		<font size="2" color="808080">(Items that are kept and distributed out of bulk, like Water, Petrol, Grain)</font>
		
	</td>
	
	</tr>
					
	<tr style="height:22px">
	     <td height="15" style="padding-left:2px;" width="20%" class="labelmedium"><cf_tl id="Minimum DoS">:</td>
	    
		 <td style="padding-left:2px;width:100" class="labelmedium">
		 
		 <cfif getItem.recordcount eq "1">
		    <cfset days = getItem.DistributionDays>
		 <cfelse>
		 	<cfset days = "15">		 
		 </cfif>
		 
		 <cfif url.drillid eq "">
		 
		 <cfinput type="text" 
		        class="regularxl" 
				name="distributiondays" 
				size="8"
				validate="integer"
				message="Invalid days"
				value="#days#" 
				style="width:30;text-align:right;padding-right:2px">	
				
		 <cfelse>
				 
		  <cfinput type="text" 
		        class="regularxl" 
				name="distributiondays" 
				size="8"
				validate="integer"
				message="Invalid days"
				value="#days#" 
				onchange="ColdFusion.navigate('ItemUoMMinimum.cfm?days='+this.value+'&quantity='+document.getElementById('distributionaverage').value,'minimum')"
				style="width:30;text-align:right;padding-right:2px">			 
		 
		 </cfif>	
		 
		 <cf_tl id="days">		
		 
		 </td>
		 		 
		 <td style="padding-left:19px;min-width:100;" class="labelmedium"><cf_tl id="Reserved DoS">:</td>
		 
		 <td style="padding-left:2px;width:80px" class="labelmedium">
		 
			 <cfif getItem.recordcount eq "1">
			    <cfset days = getItem.SafetyDays>
			 <cfelse>
			 	<cfset days = "15">		 
			 </cfif>
			 
			 <cfif url.drillid eq "">
			 
			 	<cfinput type="text" 
			        class="regularxl" 
					name="safetydays" 
					size="8"
					validate="integer"
					message="Invalid days"
					value="#days#" 
					style="width:30;text-align:right;padding-right:2px">	
					
			 <cfelse>
			 
			  	<cfinput type="text" 
			        class="regularxl" 
					name="safetydays" 
					size="8"
					validate="integer"
					message="Invalid days"
					value="#days#" 
					onchange="ColdFusion.navigate('ItemUoMSafety.cfm?days='+this.value+'&quantity='+document.getElementById('distributionaverage').value,'safety')"
					style="width:30;text-align:right;padding-right:2px">			 
			 
			 </cfif>	
			 
			 <cf_tl id="days">	
		 
		
		 </td>
		 
		 
		 <cfif url.drillid eq "">
		 
			<td style="min-width:200px" colspAN="2" width="20%" class="labelmedium" height="15">
			 			 					
				 <table width="100%">
				 
					 <tr>
					 
					 <td class="labelit">
					        <cf_tl id="Calculated Avg Daily distribution">
							<!---
							<cf_UIToolTip tooltip="Record the number of days over which the average distribution will be calculated">
						    <cf_tl id="over">:
							</cf_UIToolTip>
							--->
			   		 </td>	
					 
					 <td class="labelmedium">
							
							<cfset avg = "0">
															
							<input type="text" 
							   class="regularxl" 
							   name="AveragePeriod" 
							   id="AveragePeriod"
							   size="2"
							   value="#getItem.AveragePeriod#" 
							   style="width:30;text-align:right">
							   
						</td>
						<td> <cf_tl id="days">		</td>		    
											   
					 </td>
					 
					 </tr>
				 
				 </table> 	
				 
			</td>
		 
		 <cfelse>
		 
		 <td width="20%" class="labelmedium" bgcolor="f4f4f4" height="15" style="border-left:0px dotted silver; padding:1px">
		 
		 <cf_space spaces="80">
		 
		 <table width="100%" cellspacing="0" cellpadding="0">
		 
		    <tr>
			<td class="labelit" style="padding-left:15px">
				<cf_UIToolTip  tooltip="Record the number of days over which the average distribution will be calculated">
		        <cf_tl id="Calculated Avg Daily distribution">:				    
				</cf_UIToolTip>
   		    </td>	
				
			<td class="labelit">
				
				<cfset avg = "0">
				
				<cfif url.drillid eq "">
				
					<input type="text" 
					   class="regularxl" 
					   name="AveragePeriod" 
					   id="AveragePeriod"
					   size="2"
					   value="#getItem.AveragePeriod#" 
					   style="width:30;text-align:right"> <cf_tl id="days">				    
				   
				<cfelse>   
						
					<input type="text" 
					   class="regularxl" 
					   name="AveragePeriod" 
					   id="AveragePeriod"
					   size="2"
					   onchange="ColdFusion.navigate('ItemUoMAverage.cfm?warehouse=#url.warehouse#&location=#url.location#&itemno=#getitem.itemno#&uom=#getItem.uom#&period='+this.value,'average')"
					   value="#getItem.AveragePeriod#" 
					   style="width:30;text-align:right"> <cf_tl id="days">	&nbsp;==	
				   
				</cfif>  	
				   
			</td>
						
			</tr>	
		 
		 </table>	 
		 		
		 </td>
		 
		 <td id="average" class="labelmedium" bgcolor="f4f4f4" style="padding-left:10px">
		 							
				<!---
				
				   <cfquery name="Average" 
				    datasource="AppsMaterials" 
				    username="#SESSION.login#" 
				    password="#SESSION.dbpw#">		 		 	  
						 SELECT    SUM(I.TransactionQuantityBase) as Total						   
						 FROM      ItemTransaction I
						 WHERE     I.Warehouse        = '#url.warehouse#'
						 AND       I.Location         = '#url.location#'		
						 AND       I.ItemNo           = '#getItem.itemno#'
						 AND       TransactionUoM     = '#getItem.UoM#'	
						 AND       I.TransactionType  = '2'		 				
						 AND       TransactionDate > getDate() - #getItem.AveragePeriod#	
				</cfquery>
				
				<cfif getItem.AveragePeriod eq "0" or getItem.AveragePeriod eq "">
				
					<font face="Verdana">n/a</font>
					<input type  = "hidden" 
					       class = "regular" 
						   name  = "distributionaverage" 
						   id    = "distributionaverage"
						   size  = "8"
						   readonly
						   value = "0" 
						   style = "text-align:right">		
				
				<cfelse>
				
					<cfif average.total eq "">
					   <cfset avg = "0">
					<cfelse>
					   <cfset avg = average.total>
					</cfif>   
					
					<cfset avg = -1*avg/getItem.AveragePeriod>
								
					<cfif avg eq "">					
						<font face="Verdana"><cf_tl id="not available"></font>
					</cfif>		
					
						
					<cfoutput>
					<font face="Verdana">
					<b>#numberformat(avg,"__,__._")# 
					</font>
					
					<input type  = "hidden" 
					       class = "regular" 
						   name  = "distributionaverage" 
						   id    = "distributionaverage"
						   size  = "8"
						   readonly
						   value = "#numberformat(avg,'__,__._')#" 
						   style = "text-align:right">		
						   
					</cfoutput>	 
					
				</cfif>
				
				--->	 
								
				
				<cfif getItem.AveragePeriod eq "0" or getItem.AveragePeriod eq "">
				
					Not available
						<input type  = "hidden" 
					       class = "regular" 
						   name  = "distributionaverage" 
						   id    = "distributionaverage"
						   size  = "8"
						   readonly
						   value = "0" 
						   style = "text-align:right">		
				
				<cfelse>
				
					<cfoutput>
					
					#numberformat(getItem.distributionAverage,"__,__._")#</b> 
										
					<input type  = "hidden" 
					       class = "regular" 
						   name  = "distributionaverage" 
						   id    = "distributionaverage"
						   size  = "8"
						   readonly
						   value = "#numberformat(avg,'__,__._')#" 
						   style = "text-align:right">		
						   
					</cfoutput>
					
				</cfif>
				
		</td>	
		 		 
		 </cfif>
		 
	</tr>	
		
	<tr>	 
	    		
	     <td height="15" style="padding-left:2px;" class="labelmedium"><cf_tl id="Minimum Official Stock"> :</td>
		 		
			 <td style="width:100px;padding:1px">   
			 
			 <cfif getItem.recordcount eq "1">
			    <cfset val = getItem.MinimumStock>
			 <cfelse>
			 	<cfset val = "0">		 
			 </cfif>
			  
			 <cfinput type="text" 
			        class="regularxl" 
					name="MinimumStock" 
					size="8"
					validate="float"
					message="Invalid minimum stock"
					value="#val#" 
					style="text-align:right;padding-right:2px">	
					
			<input type="Hidden" name="MinimumStockOld" id="MinimumStockOld" value="#val#">
			
			 </td>	
						 
			 <td style="padding-left:19px" class="labelmedium"><cf_tl id="Reserved Stock">:</td>
			 
			 <td style="padding:1px">
			 
			 <cfif getItem.recordcount eq "1">
			    <cfset val = getItem.SafetyStock>
			 <cfelse>
			 	<cfset val = "0">		 
			 </cfif>
			  
			 <cfinput type="text" 
			        class="regularxl" 
					name="SafetyStock" 
					size="8"
					validate="float"
					message="Invalid safety stock"
					value="#val#" 
					style="text-align:right;padding-right:2px">
					
			<input type="Hidden" name="SafetyStockOld" id="SafetyStockOld" value="#val#">
			 
			
		 </td>
		 		 
		 <cfif url.drillid neq "">		 
		 
		 <td colspan="2" height="15" bgcolor="f4f4f4" style="padding-left:10px">
		 
		 <table cellspacing="0" cellpadding="0">
			 <tr>
			 <td style="padding-left:5px;padding-right:4px" class="labelit"><cf_tl id="Calculated"></td>
			 <td class="labelit"><cf_tl id="Minimum">:</td>
			 <td id="minimum" class="labelmedium" style="padding-right:10px" width="100" align="right">
			
				 <cfset calc = avg*getItem.DistributionDays>
				  <cfoutput>#numberformat(calc,"__,__._")#</cfoutput>	   
			 
			 </td>
			
			 <td style="padding-left:7px;padding:1px" class="labelit"><cf_tl id="Safety">:</td>
			 <td id="safety" class="labelmedium" width="100" align="right">
			
				 <cfset calc = avg*getItem.SafetyDays>
				  <cfoutput>#numberformat(calc,"__,__._")#</cfoutput>	   
			 
			 </td>
			 </tr>
		 </table>
		 
		 </td>
		 
		 </cfif>
		 
	</tr>
		
	<tr>
		
		<td height="18" valign="top" style="padding-top:3px;padding-left:2px" class="labelmedium"><cf_tl id="Memo">:</td>
		<td colspan="5" style="padding:1px">
		
		<textarea style="font-size:13px;padding:3px;width:100%;height:24" class="regular" name="ItemLocationMemo">#getItem.ItemLocationMemo#</textarea>
		
		</td>
		
	</tr>	
	
	<cfif url.drillid neq "">
		
	<tr>	   
		<td height="22" style="padding-left:2px" class="labelmedium"><cf_tl id="Meter Entry validation">:</td>
		<td style="padding:1px" class="labelmedium">
		
			<input type="checkbox" class="radiol" onclick="togglebox('measure',this.checked)" name="ReadingEnabled" id="ReadingEnabled" value="1" <cfif getItem.ReadingEnabled eq "1">checked</cfif>>
			
		</td>
		
		<cfif getItem.ReadingEnabled eq "1">
			<cfset cl = "labelmedium">			
		<cfelse>
			<cfset cl = "hide">			
		</cfif>
				
		<td name="measure" class="#cl#" height="18" style="padding-left:7px;border-left:1px dotted silver;padding:1px" class="#cl#" class="labelmedium"><cf_tl id="Last Reading">:</td>
		<td name="measure" style="padding:1px" class="#cl#" class="labelmedium"><cfif getItem.ReadingClosing neq "">#numberformat(getItem.ReadingClosing,'__,__._')#<cfelse>n/a</cfif></td>
		<td name="measure" class="#cl#" height="18" style="padding:1px" class="#cl#"><cf_tl id="Last updated">:<cf_space spaces="40"></td>
		<td name="measure" style="padding:1px" class="#cl#" class="labelmedium"><cfif getItem.ReadingDate neq "">#dateformat(getItem.ReadingDate,CLIENT.DateFormatShow)#<cfelse>n/a</cfif></td>
	</tr>	
	
	</cfif>
			
	<cfif url.drillid eq "">
	  <cfset cl = "hide">
	<cfelse>
	  <cfset cl = "regular">	  
	</cfif>
	
	<tr><td colspan="6" class="line"></td></tr>
	
	<tr><td colspan="6" align="center" style="height:30px;padding-left:2px" id="submitbox0" class="#cl#">	
					
	<cfquery name="Location" 
		     datasource="AppsMaterials" 
		     username="#SESSION.login#" 
		     password="#SESSION.dbpw#">		 
			 SELECT    SUM(TransactionQuantity) as OnHand
			 FROM      ItemTransaction
			 WHERE     Warehouse      = '#url.Warehouse#'		 
			 AND       Location       = '#url.location#'
			 AND       ItemNo         = '#getItem.itemno#'  
			 AND       TransactionUoM = '#getItem.UoM#'			 
	</cfquery>
	
	<table height="34"><tr>
		
	<cfif  ((location.Onhand eq "0" or location.recordcount eq "0") and url.drillid neq "")>		
	
			<cf_tl id="Remove Storage location / Product settings" var="1">	
			<td height="24">
			
			<input  type        = "button" 
			        value       = "#lt_text#" 
					onClick     = "if (confirm('Do you want to remove this item settings ?')) { itempurge('#url.drillid#'); }"					
					id          = "remove"
					class       = "button10g"
					style       = "width:500px;height:28px;font-size:13px">     	
					
			</td>
				   
	</cfif>
	
	      <cf_tl id="Save Storage location / Product settings" var="1">
		
		  <td height="24" style="padding-left:3px">
	      
		  		<input mode     = "silver" type="button" 
					value       = "#lt_text#" 
					onClick     = "validate('#url.drillid#')"					
					id          = "submit"
					class       = "button10g"
					style       = "width:500px;height:28px;font-size:13px">    
					
					
	      </td>
		  
		   <td colspan="1" id="submitbox1"></td>
		  
		  </tr>
		  
	  </table>			
		
	  </td>
    </tr>
	
	</table>
	
	</td></tr>
	
	</table>
	
</cfform>

</cfoutput>