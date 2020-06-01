<!--- Query returning detail information for selected item --->

<cfinvoke component = "Service.Access"  
     method             = "function"  
	 role               = "'WhsPick'"
	 mission            = "#url.mission#"
	 warehouse          = "#url.warehouse#"
	 SystemFunctionId   = "#url.SystemFunctionId#" 
	 returnvariable     = "access">	 	

<cfif access eq "DENIED">	 

	<table width="100%" height="100%" 
	       border="0" 
		   cellspacing="0" 			  
		   cellpadding="0" 
		   align="center">
		   <tr><td align="center" height="40">
		   
			<cf_tl id="Detected a Problem with your access"  class="Message">
			
			</td></tr>
	</table>	
	<cfabort>	
		
</cfif>		

<!--- Query returning search results --->
<cfquery name="Warehouse"
datasource="AppsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
	FROM   Warehouse
	WHERE  Warehouse = '#URL.warehouse#'
</cfquery>		

<!--- called from warehouse --->
				
<cfinvoke component  = "Service.Access"  
	   method            = "RoleAccess" 
	   mission           = "#warehouse.mission#"
	   missionorgunitid  = "#warehouse.missionorgunitid#" 
	   role              = "'WhsPick'"
	   parameter         = "#url.systemfunctionid#"
	   accesslevel       = "'1','2'"
	   returnvariable    = "accessright">	
	   
<cfif accessright eq "DENIED">
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="silver">
			<tr><td align="center" height="100" class="labelmedium"><cf_tl id="You have been granted only read rights. Option not available"></td></tr>
	</table>
	<cfabort>
	
</cfif>   

<cfset client.stmenu = "stockinventory()">

	<table width="99%" height="100%" align="center">
	
		<tr class="line">
		<td colspan="2" style="padding-left:4px;height:40px;font-size:23px;min-width:400px">
					
			<cf_LanguageInput
				TableCode       = "Ref_ModuleControl" 
				Mode            = "get"
				Name            = "FunctionName"
				Key1Value       = "#url.SystemFunctionId#"
				Key2Value       = "#url.mission#"				
				Label           = "Yes">	
					 
				 <cfoutput>#lt_content#</cfoutput>	
		
		</td>
		</tr>
			
		<tr>
						
		<td height="100%" style="min-width:200px;border:1px solid silver;padding-top:2px">

			<cfoutput>
			<input type="hidden" name="mission" id="mission"   value="#URL.mission#">	
			<cf_UIToolTip  tooltip="Filter by location or Item">
			
				<table>
				<tr>
				<td>
				
					<cf_tl id="contains" var="1">
					<cfset vcontains=#lt_text#>
					<cf_tl id="begins with" var="1">
					<cfset vbegins=#lt_text#>
					<cf_tl id="ends with" var="1">
					<cfset vends=#lt_text#>
					<cf_tl id="is" var="1">
					<cfset vis=#lt_text#>
					<cf_tl id="is not" var="1">
					<cfset visnot=#lt_text#>
					<cf_tl id="before" var="1">
					<cfset vbefore=#lt_text#>
					<cf_tl id="after" var="1">
					<cfset vafter=#lt_text#>
					
					<select id="fltOperator" name="fltOperator" style="border:0px;border-right:1px solid silver;border-bottom:1px solid silver" class="regularxl" onchange="ptoken.navigate('../Inventory/LocationList.cfm?warehouse=#url.warehouse#&systemfunctionid=#url.systemfunctionid#&filteroperator='+this.value+'&item='+document.getElementById('fltItem').value,'divLocationList');">
				
						<OPTION value="CONTAINS"><cfoutput>#vcontains#</cfoutput>
						<OPTION value="BEGINS_WITH" selected><cfoutput>#vbegins#</cfoutput>
						<OPTION value="ENDS_WITH"><cfoutput>#vends#</cfoutput>
						<OPTION value="EQUAL"><cfoutput>#vis#</cfoutput>
												
					
					</SELECT>
					
				</td>
				<td>
				
				<input type="textbox" 
					class="regularxl" 
					style="background-color:fafafa;width:100%;border:0px;border-bottom:1px solid silver" 
					name="fltItem" id="fltItem" value="" 
					onkeyup="ptoken.navigate('../Inventory/LocationList.cfm?warehouse=#url.warehouse#&systemfunctionid=#url.systemfunctionid#&item='+this.value+'&filteroperator='+document.getElementById('fltOperator').value,'divLocationList');">
					
				</td>
				</tr>
				</table>	
			
			</cf_UItooltip>
			</cfoutput>
			
			<cf_securediv id="divLocationList" 
			    style="height:97%; padding-top:5px;min-width:200px" 
				bind="url:../Inventory/LocationList.cfm?warehouse=#url.warehouse#&systemfunctionid=#url.systemfunctionid#&item=&filteroperator=">
																				
		</td>				
		
		<td style="width:100%">
			
			 <table height="100%" width="98%" align="center">		  
			 
			  <tr class="hide"><td height="1" id="process"></td></tr>		  
			 		 			  
				  <tr>
				 	 				
				  <td height="20">
						
						<table width="100%">
						
						     <tr class="line">							
							 <td colspan="2">
							 
							 <table>
							 
								 <tr class="line">
								 
								 <cf_getWarehouseTime warehouse="#url.warehouse#">
								     <cfoutput>
								     <td class="labelmedium" style="padding-left:5px;font-size:16px"><cf_tl id="Present stock levels in GMT time"> (#tzcorrection#) :</td>
									 <td style="padding-left:5px">
													
									 <cf_setCalendarDate
									      name     = "transaction"        
										  id       = "transaction"
									      timeZone = "#tzcorrection#"     
									      font     = "13"
										  edit     = "Yes"							  
										  class    = "regularxl"				  
									      mode     = "datetime"> 
									  
									  </td>
									  
									  <cf_tl id="Apply" var="label">							  
								      <td style="padding-left:3px">
									  <input onclick="stockinventorydate('#url.systemfunctionid#',document.getElementById('transaction_date').value,document.getElementById('transaction_hour').value,document.getElementById('transaction_minute').value)" type="button" name="Apply" class="button10g" value="#label#">
									  </td>
									  </cfoutput>
									  
								  </tr>
								  
								  <tr>
								  
								 	<td style="padding-right:20px" class="labelmedium" colspan="1">

									 <table>
										<tr>
											<td style="width:25px;">
												<cf_tl id="Open/close all" var="1">
												<i class="clsLocToggler fas fa-folder" 
													style="cursor:pointer; color:#CE4A19; font-size:20px;" 
													title="<cfoutput>#lt_text#</cfoutput>"
													onclick="toggleLocations();"></i>
											</td>
											<td>
												<cfinvoke component = "Service.Presentation.TableFilter"  
													method           = "tablefilterfield" 
													filtermode       = "direct"
													label            = "Quick find"
													name             = "filtersearch"
													style            = "font:14px;height:25;width:150px;"
													rowclass         = "clsFilterRow"
													rowfields        = "ccontent">
											</td>
										</tr>
									 </table>
									 
									 


									</td> 
									  
									 <td style="padding-left:3px;" class="labelmedium"><cf_tl id="Suppress 0 (ZERO) stock">:</td>
									 <td style="padding-left:6px;padding-right:5px">
									 <input class="radiol" type="checkbox" id="hidezero" value="1" onclick="zerotoggle(this.checked)">
									 </td>	
																 				 
								 </tr>				 					 
							 							  
							 </table>
							 
							 </td>
							 </tr>
							
						</table>				
						
			     </td>
			 </tr>	
								
			<tr class="hide"><td height="4" id="logging"></td></tr>		
														
			<tr><td colspan="2" style="height:99%" valign="top">					
				<cf_divscroll id="content">							
					 <cfinclude template="InventoryViewContent.cfm">					 
				</cf_divscroll>	 													  
				</td>
			</tr>
					
			</table>	
						
		</td>
	</tr>
	
	</table>

<cfset AjaxOnLoad("doHighlight")>
	
