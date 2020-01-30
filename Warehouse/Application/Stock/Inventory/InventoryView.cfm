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

	<table width="100%" height="100%" align="center">
	
		<tr class="line">
		<td colspan="2" style="font-size:23px;min-width:400px;font-weight:bold">
					
			<cf_LanguageInput
				TableCode       = "Ref_ModuleControl" 
				Mode            = "get"
				Name            = "FunctionName"
				Key1Value       = "#url.SystemFunctionId#"
				Key2Value       = "#url.mission#"				
				Label           = "Yes">	
					 
				 <cfoutput>
					#lt_content#
					</cfoutput>	
		
		</td>
		</tr>
		
		<tr><td style="height:4px"></td></tr>
	
		<tr>
		
		  <cfquery name="LocationList"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			    SELECT    Location, 
				          WL.StorageCode+' '+WL.Description as Description, 
						  R.Description as Class
				FROM      WarehouseLocation WL LEFT OUTER JOIN Ref_WarehouseLocationClass R
				ON        WL.LocationClass = R.Code
				WHERE     WL.Warehouse = '#URL.Warehouse#'
				AND       Operational = 1
				ORDER BY  R.Description
			</cfquery>	
		
		<td height="100%" style="width:100px">
		
			<cfform name="inventoryform" id="inventoryform" style="height:99.5%">
		
			<input type="hidden" name="mission" id="mission"   value="#URL.mission#">	
								
					
				<!--- search option --->
					
				<cfselect id="location" name="location"
				     onchange="_cf_loadingtexthtml='';stockinventoryload('n','#url.systemfunctionid#')" 
					 query="LocationList" 
					 value="Location" 
					 queryposition="below"
					 display="Description" 
					 multiple="Yes"
					 style="background-color:ffffff;width:240px;height:100%;border:0px"
					 group="Class" 
					 class="regularxl">
														
					<option value=""><cf_tl id="View all locations"></option>
					 
					 
				</cfselect>	
				
			</cfform>	
																				
		</td>				
		
		<td>
			
			 <table height="100%" width="98%" align="center">		  
			 
			  <tr class="xhide"><td height="1" id="process"></td></tr>		  
			 		 			  
				  <tr>
				 	 				
				  <td height="20">
						
						<table width="100%">
						
						     <tr class="line">							
							 <td colspan="2">
							 
							 <table>
							 
								 <tr class="line">
								 
								 <cf_getWarehouseTime warehouse="#url.warehouse#">
								     <cfoutput>
								     <td class="labelmedium" style="font-size:16px"><b><cf_tl id="Present stock levels in the warehouse time"> (#tzcorrection#) :</td>
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
									 
									 <cfinvoke component = "Service.Presentation.TableFilter"  
									   method           = "tablefilterfield" 
									   filtermode       = "direct"
									   label            = "Quick find"
									   name             = "filtersearch"
									   style            = "font:14px;height:25;width:150px;"
									   rowclass         = "clsFilterRow"
									   rowfields        = "ccontent">
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
			
			<tr class="line"><td style="padding-left:62px">
			<table width="100%">
			    <tr class="labelmedium">
				   <td style="min-width:26px"></td>			  
				   <td style="min-width:110px"><cf_tl id="Roll"></td>	
				   <td style="min-width:200px"><cf_tl id="Earmarked"></td>   <!--- earmark --->			  		   		  			   
				   <td style="min-width:100px"><cf_tl id="Barcode"></td>
				   <td style="min-width:20px"></td>
				   <td style="min-width:100px"><cf_tl id="Mode"></td>  
				   <td style="min-width:100px"><cf_tl id="UoM"></td>   
				   <td style="min-width:100px" align="right"><cf_tl id="On Hand"><cf_space spaces="20"></td>
				   <td style="min-width:100px" align="right"><cf_tl id="Measurement"></td>
				   <td style="width:100%;padding-right:5px" align="right"><cf_tl id="Result"></td>
				   <td style="min-width:30px"></td>
				</tr>	
			</table>
			</td></tr>	
											
			<tr><td colspan="2" height="100%">		
			
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
	
