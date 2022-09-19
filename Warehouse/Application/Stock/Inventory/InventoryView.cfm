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
		   align="center">
		   <tr><td align="center" height="40">		   
			<cf_tl id="Detected a Problem with your access"  class="Message">			
			   </td>
		   </tr>
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

<cfquery name="parameter" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
	FROM   Ref_ParameterMission
	WHERE  Mission = '#warehouse.Mission#'	
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
	
	<table width="100%" align="center" bordercolor="silver">
			<tr><td align="center" height="100" class="labelmedium">
			<cf_tl id="You have been granted only read rights. Option not available">
			</td></tr>
	</table>
	<cfabort>
	
</cfif>   

<cfset client.stmenu = "stockinventory()">

	<table style="border:1px solid silver;height:100%;width:100%;background-color:e4e4e4;padding:4px">
	
	    <!---
		
		<tr class="line">
		<td colspan="2" style="padding:4px;;height:40px;font-size:23px;min-width:400px">
					
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
		
		--->
			
		<tr>
						
		<td height="100%" align="center" style="min-width:200px;border:1px solid silver;padding-left:5px;padding-top:3px" title="Filter by location or Item">

			<cfoutput>
			<input type="hidden" name="mission" id="mission"   value="#URL.mission#">	
						
				<table style="height:100%;width:100%;" border="0">
				<tr class="line">
				<td valign="top">
				
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
					
					<select id="fltOperator" name="fltOperator" style="border:0px;border-right:1px solid silver;" class="regularxl" onchange="ptoken.navigate('../Inventory/LocationList.cfm?warehouse=#url.warehouse#&systemfunctionid=#url.systemfunctionid#&filteroperator='+this.value+'&item='+document.getElementById('fltItem').value,'divLocationList');">
				
						<OPTION value="CONTAINS"><cfoutput>#vcontains#</cfoutput>
						<OPTION value="BEGINS_WITH" selected><cfoutput>#vbegins#</cfoutput>
						<OPTION value="ENDS_WITH"><cfoutput>#vends#</cfoutput>
						<OPTION value="EQUAL"><cfoutput>#vis#</cfoutput>
												
					
					</SELECT>
					
				</td>
				
				<td valign="top">
				
				<input type="textbox" 
					class="regularxl" 
					style="background-color:fafafa;width:100%;border:0px;" 
					name="fltItem" id="fltItem" value="" 
					onkeyup="ptoken.navigate('../Inventory/LocationList.cfm?warehouse=#url.warehouse#&systemfunctionid=#url.systemfunctionid#&item='+this.value+'&filteroperator='+document.getElementById('fltOperator').value,'divLocationList');">
					
				</td>				
				</tr>
				
				<tr><td style="height:99%" colspan="2" valign="top">
					<cf_securediv id="divLocationList" 
				    style="height:100%;min-width:200px;" 
					bind="url:../Inventory/LocationList.cfm?warehouse=#url.warehouse#&systemfunctionid=#url.systemfunctionid#&item=&filteroperator=">
				</td></tr>
				</table>	
						
			</cfoutput>
																				
		</td>				
		
		<td style="width:100%;">
			
			 <table height="100%" width="98%" align="center">		  
			 
			  <tr class="hide"><td height="1" id="process"></td></tr>		  
			 		 			  
				  <tr class="line">
				 	 				
				  <td height="20" width="100%">
						
						<table width="100%">
						
						     <tr>							
							 <td colspan="2">
							 
							 <table style="width:100%">
							 
								 <tr class="line" style="background-color:e1e1e1;height:40px">
								 
								 <cf_getWarehouseTime warehouse="#url.warehouse#">
								 								 
								     <cfoutput>
									 
									  <td align="right" style="padding-left:5px;cursor:pointer" title="Show list based on parent item" class="fixlength labelmedium2"><cf_tl id="Group List by item">:</td>
									 <td><input class="radiol" onclick="document.getElementById('apply').click()" type="checkbox" id="parentshow" value="0"></td>	
									
									
								     <td class="labelmedium2 fixlength" style="padding-left:9px;font-size:14px"><cf_tl id="Stock levels GMT"> (#tzcorrection#) :</td>
									 <td style="padding-left:5px">
													
									 <cf_setCalendarDate
									      name     = "transaction"        
										  id       = "transaction"
									      timeZone = "#tzcorrection#"     
									      font     = "14"
										  edit     = "Yes"							  
										  class    = "regularxl"				  
									      mode     = "datetime"> 
									  
									  </td>
									 
									 <cfif Parameter.LotManagement neq "0"> 
									 <td align="right" 
									     style="padding-left:5px;cursor:pointer" 
										 title="Show only this lot regardless if there is stock or no stock" class="fixlength labelmedium2"><cf_tl id="Show only lot">:</td>
									 <td>
									     <input type="text"  style="text-align:center;width:100px" onchange="document.getElementById('apply').click()" name="lot" id="lot" value="" class="regularxxl">
									 </td>	 
									 <cfelse>
									     <input type="hidden" style="text-align:center;width:100px" name="lot" id="lot" value="" class="regularxxl">
									 </cfif>
									  
									  
									  <cf_tl id="Apply" var="label">							  
								      <td style="padding-left:3px;padding-right:9px" align="right">
									  <input onclick="stockinventorydate('#url.systemfunctionid#',document.getElementById('transaction_date').value,document.getElementById('transaction_hour').value,document.getElementById('transaction_minute').value,document.getElementById('parentshow').checked,document.getElementById('lot').value)" 
									   type="button" style="height:28px" id="apply" name="Apply" class="button10g" value="#label#">
									  </td>
									  </cfoutput>
									  
								  </tr>
								  
								  <tr style="background-color:efefef">
								  
								 	<td style="border-top:1px solid silver;padding-right:20px" colspan="7">

									 <table style="width:100%">
										<tr class="fixlengthlist">
											<td style="padding-left:10px">
												<cf_tl id="Open/close all" var="1">
												<i class="clsLocToggler fas fa-folder" 
													style="cursor:pointer; color:#CE4A19; font-size:20px;" 
													title="<cfoutput>#lt_text#</cfoutput>"
													onclick="toggleLocations();"></i>
											</td>
											<td>
											
											  <!--- filtercondition  = "equals" --->
												<cfinvoke component = "Service.Presentation.TableFilter"  
													method           = "tablefilterfield" 
													filtermode       = "enter"
													filtercondition  = "contains"													
													label            = "Quick find"
													name             = "filtersearch"
													style            = "font:14px;height:25px;width:120px;"
													rowclass         = "clsFilterRow"
													rowfields        = "ccontent">
											</td>
											
											 <td align="right" class="labelmedium2"><cf_tl id="Suppress ZERO stock">:</td>
											 <td>
											 <input class="radiol" type="checkbox" id="hidezero" value="1" onclick="zerotoggle(this.checked)">
											 </td>	
										</tr>
									 </table>
									
									</td> 
														 				 
								 </tr>				 					 
							 							  
							 </table>
							 
							 </td>
							 </tr>
							
						</table>				
						
			     </td>
			 </tr>	
								
			<tr class="hide"><td height="4" id="logging"></td></tr>		
														
			<tr><td colspan="2" style="border-top:1px solid silver;border-bottom:0px;background-color:ffffff;padding:5px;height:100%" valign="top">	
							
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
	
