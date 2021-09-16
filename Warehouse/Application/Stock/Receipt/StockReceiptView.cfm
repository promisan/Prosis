	
 <cf_LanguageInput
	TableCode       = "Ref_ModuleControl" 
	Mode            = "get"
	Name            = "FunctionName"
	Key1Value       = "#url.SystemFunctionId#"
	Key2Value       = "#url.mission#"				
	Label           = "Yes">

<cfset url.Fnd = "">
<!--- create table if it does not exist --->
<cfinclude template="StockReceiptInit.cfm">

<table width="100%" height="100%" align="center">
	
	  
		<!---
		
		<tr>
			<td height="67">
				<cfoutput>
					<table height="67px" cellpadding="0" cellspacing="0" border="0" style="overflow-x:hidden" >												
						<tr>
							<td style="z-index:5; position:absolute; top:15px; left:35px; ">
								<img src="#SESSION.root#/images/logos/warehouse/distribution.png" height="50">
							</td>
						</tr>							
						<tr>
							<td style="z-index:3; position:absolute; top:27px; left:90px; color:45617d; font-family:calibri,trebuchet MS; font-size:25px; font-weight:bold;">
								<cfoutput>#lt_content#</cfoutput>
							</td>
						</tr>
						<tr>
							<td style="position:absolute; top:14px; left:90px; color:e9f4ff; font-family:calibri,trebuchet MS; font-size:40px; font-weight:bold; z-index:2">
								<cfoutput>#lt_content#</cfoutput>
							</td>
						</tr>							
					</table>
				</cfoutput>
			</td>
		</tr>
		
		--->
				
		<tr><td height="30">
	
		<table width="96%" border="0" align="center">		  		
						
			<cfset ht = "42">
			<cfset wd = "42">
					
			<tr>	
			
			<cfoutput>
			
			<!---
			<td style="width:1%;border:0px solid silver">
				<img src="#SESSION.root#/images/logos/warehouse/distribution.png" height="75">
			</td>
			--->			
							
			</cfoutput>				
			
					<cf_tl id="Pending Receipts" var="1">	
					<cf_menutab item       = "1" 
				        iconsrc    = "Logos/Warehouse/Pending-Receipts.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 	
						padding    = "0"								
						class      = "highlight"
						name       = "#lt_text#"
						source     = "../Receipt/StockReceiptViewPending.cfm?systemfunctionid=#url.systemfunctionid#&mission=#URL.Mission#&warehouse=#url.warehouse#">			
						
					<cf_tl id="Process Selected Receipts" var="1">												
					<cf_menutab item       = "2" 
				        iconsrc    = "Logos/Warehouse/Process-Receipts.png" 
					    iconwidth  = "#wd#" 
						iconheight = "#ht#" 
						padding    = "0"	
						targetitem = "1"
						name       = "#lt_text#"
						source     = "../Receipt/StockReceiptProcessView.cfm?systemfunctionid=#url.systemfunctionid#&mission=#URL.Mission#&warehouse=#url.warehouse#">
					
					<cf_tl id="Submitted Receipt Transfers" var="1">	
					<cf_menutab item       = "3" 
				        iconsrc    = "Logos/Warehouse/Submited-Receipts.png" 
					    iconwidth  = "#wd#" 
						iconheight = "#ht#" 
						padding    = "0"	
						targetitem = "1"
						name       = "#lt_text#"
						source     = "../Receipt/StockReceiptBatchListing.cfm?systemfunctionid=#url.systemfunctionid#&mission=#URL.Mission#&warehouse=#url.warehouse#">	
					
						<td width="20%"></td>
																	 		
				</tr>
				
			</table>
			
		</td>
		
	</tr>			
		 
	 <tr><td height="100%">
	 
	 <table width="100%" 
	      border="0"
		  height="100%"
		  align="center">
		  	 					
			<cf_menucontainer item="1" class="regular">		
				<cf_securediv style="height:100%" id="divMainMenuContainer" bind="url:../Receipt/StockReceiptViewPending.cfm?systemfunctionid=#url.systemfunctionid#&mission=#URL.Mission#&warehouse=#url.warehouse#">
			<cf_menucontainer>		
					
	 </table>	
						  	 
	 </td></tr>		
	 		
</table>


