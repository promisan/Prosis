
<cfparam name="url.init"             default="1">
<cfparam name="url.scope"            default="standard">
<cfparam name="url.id"               default="2">
<cfparam name="url.warehouse"        default="">
<cfparam name="url.mission"          default="">
<cfparam name="url.systemfunctionid" default="00000000-1E4F-1220-FC87-6F3E83E54C33">


<cfif url.warehouse neq "">
	<cfset selectwarehouse = "No">
<cfelse>
    <cfset selectwarehouse = "Yes">
</cfif>	

<cfset url.tratpe  = url.id>

<!---presetted warehouse --->


<cfif url.warehouse neq "">	
		
	<cfquery name="check" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     WarehouseLocation
			WHERE    Warehouse = '#url.warehouse#'		
			AND      Location IN (SELECT Location 
			                      FROM   ItemWarehouseLocation 
								  WHERE  Warehouse = '#url.warehouse#')
			ORDER BY LocationClass
	</cfquery>
	
		
	<cfif check.recordcount eq "0">
		
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			<tr><td align="center" height="100"><font face="Calibri" size="2" color="0080C0"><cf_tl id="This warehouse has no stock items recorded"></font></td></tr>
		</table>
		<cfabort>
	
	</cfif>
	
		
    <cfquery name="whs" 
	   datasource="AppsMaterials" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
			SELECT   *
			FROM     Warehouse
			WHERE    Warehouse = '#url.warehouse#'		
    </cfquery>		
			
	<!--- called from warehouse --->
				
	<cfinvoke component  = "Service.Access"  
	   method            = "RoleAccess" 
	   mission           = "#whs.mission#" 
	   missionorgunitid  = "#whs.missionorgunitid#" 
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
			
<cfelse>	

	<!--- this is the mode if this screen is loaded isolate in a portal individually --->

	<cf_screentop html="No" scroll="Yes">
		
	<cfajaximport tags="cfform,cfwindow,cfdiv">
	<cfinclude template="../StockControl/StockScript.cfm">
	<cf_dialogAsset>
			
	<cfquery name="Parameter" 
	 datasource="AppsPurchase" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.Mission#' 
	</cfquery>	
	
	<cfquery name="Param" 
	 datasource="AppsMaterials" 
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_ParameterMission
		WHERE  Mission = '#URL.Mission#' 
	</cfquery>
	
	<cfquery name="whs" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT   *
			FROM     Warehouse
			WHERE    Mission = '#url.mission#'		
	</cfquery>	
	
	<cfif Whs.recordcount eq "0">
	
		<cf_message message="Problem. No warehouse has been defined for this entity.">
		<cfabort>
		
	</cfif>
					
</cfif>		

<cfoutput>

<table height="100%" width="100%" style="border:0px solid black" cellspacing="0" cellpadding="0" align="center">

<tr>

<td valign="top" height="100%"> 	 

  <cfform name="transactionform" method="post" style="height:100%">	

	  <table width="98%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" align="center">		  
					  	
		<cfif url.mode eq "issue">
					
			<tr>
			  <td colspan="2" align="left" valign="bottom">	 
			 		  
				  <table cellspacing="0" width="100%" cellpadding="0">
				  
				  <tr><td align="left" valign="middle" style="padding-left:2px">
				  
				    <cfif selectwarehouse eq "No">	 
					
						<!--- presetted warehouse --->								
										
						 <cf_LanguageInput
							TableCode       = "Ref_ModuleControl" 
							Mode            = "get"
							Name            = "FunctionName"
							Key1Value       = "#url.SystemFunctionId#"
							Key2Value       = "#url.mission#"				
							Label           = "Yes"> 
					
						<input type="hidden" name="warehouse" id="warehouse" value="#URL.warehouse#">	
					  	
						<!---
							  
					  	<table height="57px" cellpadding="0" cellspacing="0" border="0" style="overflow-x:hidden" >												
							<tr>
								<td style="z-index:5; position:absolute; top:5px; left:15px; ">
									<img src="<cfoutput>#SESSION.root#</cfoutput>/images/logos/warehouse/fuel1.png" height="46px">
								</td>
							</tr>							
							<tr>
								<td style="z-index:3; position:absolute; top:18px; left:70px; color:45617d; font-family:calibri,trebuchet MS; font-size:25px; font-weight:bold;">
									<cfoutput>#lt_content#</cfoutput>
								</td>
							</tr>
							<tr>
								<td style="position:absolute; top:2px; left:75px; color:e9f4ff; font-family:calibri,trebuchet MS; font-size:30px; font-weight:bold; z-index:2">
									<cfoutput>#lt_content#</cfoutput>
								</td>
							</tr>							
												
						</table>
						
						--->
					
					<cfelse>
					
						<table cellpadding="0" cellspacing="0" border="0">		
						<tr><td style="padding-top:5px">
						
						<cf_StockViewWarehouse style="font-size:22px;font-family:calibri;padding-left:4px;padding-top:1px;padding-bottom:1px;padding-right:1px;border:1px solid silver;background-color:f4f4f4;height:31" 
						      grouping         = "None" 
							  mission          = "#url.mission#"				 
							  systemfunctionid = "#url.systemfunctionid#"
							  accesslevel      = "'1','2'"
							  onchange="ColdFusion.navigate('../Transaction/getLocationSelect.cfm?mode=#url.mode#&tratpe=#url.tratpe#&warehouse='+this.value,'locationbox')">	
							  
							  <cfset access = "ALL">
							  <cfset url.warehouse = selWarehouse>
							 
						</td></tr>
						</table>	  
								
					</cfif>
		
				  </td>
				  
				  <td>
				  
				  <table cellspacing="0" cellpadding="0" width="100%">
				  		
				    <cf_getWarehouseTime warehouse="#whs.warehouse#">					  		   
			        <cfset hr = "#timeformat(localtime,'HH')#">			
				    <cfset mn = "#timeformat(localtime,'MM')#">
				 
				  <tr class="line">
				  
				  <td>
				  <table cellspacing="0" class="formpadding">
				  
				  <tr>
				  
				  <cfif selectwarehouse eq "No">
				  
				   		<td align="left" width="100%" height="100%"  
						  onClick="stockfullview()" 
						  style="font-size:20px;color:0080C0;cursor:pointer;font-weight:200" 
						  id="fullview" 
						  class="labelmedium">[<cf_tl id="Full view">]</td>	
				 				   
				   </cfif>
				  
				  <td align="right" width="20" style="padding-left:5px;padding-right:5px;" class="label"> 
				     <table>
					 <tr>					 
					  <td style="padding-left:3px"><input class="enterastab" type="checkbox" name="arefresh" id="arefresh" checked onclick = "datetimemode('#URL.warehouse#')"></td>
					 </tr>
					 </table>
				  </td>	  
		
				  <td width="60%" style="padding-left:5px;padding-right:5px;">
				  
					<input type="hidden" name="itoday" id="itoday" value="#dateformat(now(),CLIENT.DateFormatShow)#">
					
					<div id="dtoday" style="font-size:19px;height:25;padding-top:3px">
						#dateformat(localtime,CLIENT.DateFormatShow)#
					</div>
					
					<cf_getWarehouseTime warehouse="#whs.warehouse#">
											
					<div id="dTransactionDate" class="hide" style="padding-top:3px">
					
					 <cf_setCalendarDate
				      name     = "transaction"   
					  id       = "transaction"     
					  edit     = "Yes"    
				      timeZone = "#tzcorrection#"     
				      font     = "15"
				      mode     = "date"> 
								
					</div>		
										
			      </td>				 		 		
				 				  		
				  <td width="4%" style="padding-top:7px"><div id="dhour" style="font-size:19px" align="right">#hr#</div>					
			
					<select name="Transaction_hour" id="Transaction_hour"  style="padding-top:1px;font-size:17px;height:26" class="hide">
					
						<cfloop index="it" from="0" to="23" step="1">
						
						<cfif it lte "9">
						  <cfset it = "0#it#">
						</cfif>				 
						
						<option value="#it#" <cfif hr eq it>selected</cfif>>#it#</option>
						
						</cfloop>	
						
					</select>
					
		
				  </td>
				  
				  <td>:</td>
				
				  <td width="4%" style="padding-top:7px"><div id="dminute" style="font-size:19px">#mn#&nbsp;</div>		
				    
					<select name="Transaction_minute" id="Transaction_minute"  style="padding-top:1px;font-size:17px;height:26" class="hide">
						
							<cfloop index="it" from="0" to="59" step="1">
							
							<cfif it lte "9">
							  <cfset it = "0#it#">
							</cfif>				 
							
							<option value="#it#" <cfif mn eq it>selected</cfif>>#it#</option>
							
							</cfloop>	
										
					</select>			
					
					</td>
					
					<!--- hidden for now
					<td align="right" class="label" style="padding-right:4px;padding-left:2px">UTC#timezone#</td>
					--->
				  
				  </tr>
				  
				 </table>
				 </td> </tr>
				  
				  </table>		  
				  
				  </td>		  
				  
				  </tr>
				  </table>	 
			     
			  </td>
			</tr>	
								
		</cfif>			
			
		<input type="hidden" name="mission"          id="mission"           value="#URL.mission#">	
		<input type="hidden" name="systemfunctionid" id="systemfunctionid"  value="#URL.systemfunctionid#">				
			
		<!--- selection of fuel portion --->
			
		<tr>
			
			<td height="20">
			
				<table width="100%">
				
				<tr>				   
				    <td style="height:30;padding-left:7px" class="labelmedium"><cf_tl id="Issue from">:<cf_space spaces="48"></td>						
					<td colspan="1" style="padding-left:0px" class="label" id="locationbox"><cfinclude template="getLocationSelect.cfm"></td>				
													
					<td style="height:30;padding-left:10px"  class="labelmedium"><cf_tl id="Product">:</td>			
					<td id="itembox" style="padding-left:6px"><cfinclude template="getItemSelect.cfm"></td>				
					<!---
					<td height="25" style="padding-left:5px;padding-right:5px"><cf_tl id="UoM">:</td>
					--->
					<td id="uombox" style="padding-left:3px"><cfinclude template="getUoMSelect.cfm"></td>	
								
					<td style="padding-left:8px">
					
						<table width="100%" cellspacing="0" cellpadding="0">
					
						  <!--- Query returning search results --->
						   <cfquery name="Check"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT *
								FROM   WarehouseLocation
								WHERE  Warehouse = '#url.warehouse#'
								ORDER BY LocationClass
							</cfquery>	
							
						<cfif check.recordcount gte "2">
						
							<!--- Query returning search results --->
						    <cfquery name="Location"
							datasource="AppsMaterials" 
							username="#SESSION.login#" 
							password="#SESSION.dbpw#">
							    SELECT *
								FROM   WarehouseLocation
								WHERE  Warehouse = '#url.warehouse#'
								AND    Location  = '#url.location#'
							</cfquery>	
						
							<tr>  
							
					          <td style="padding-left:0px">
												
								<!--- Query returning search results --->
								<cfquery name="TransactionType"
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								    SELECT  *
									FROM    Ref_TransactionType
									WHERE   TransactionType = '2'
									<cfif Location.TransferAsIssue eq "1">
									OR     TransactionType = '8'   
									</cfif>						
								</cfquery>	
								
								<cfif Location.TransferAsIssue eq "0">
								
								<input type="hidden" name="tratpe" id="tratpe" value="2">
								
								<cfelse>
								
								<select name="tratpe" id="tratpe" class="regularxl" 
								  onchange="ColdFusion.navigate('../Transaction/setTransactionType.cfm?warehouse='+document.getElementById('warehouse').value+'&location='+document.getElementById('location').value+'&transactiontype='+this.value,'transactionbox')">
									<cfloop query="TransactionType">
										<option value="#TransactionType#">#Description# to</option>
									</cfloop>
								</select>		
								
								</cfif>
											
							  </td>
							  
							  <td class="hide" id="transactionbox"></td>
						  	   
					        </TR>					
						
						<cfelse>
						
							<tr>  
							
					          <td style="padding-left:3px">
												
								<!--- Query returning search results --->
								<cfquery name="TransactionType"
								datasource="AppsMaterials" 
								username="#SESSION.login#" 
								password="#SESSION.dbpw#">
								    SELECT *
									FROM   Ref_TransactionType
									WHERE  TransactionType = '2'   
								</cfquery>	
								
								#TransactionType.Description#
								
								<input type="hidden" name="TraTpe" id="TraTpe" value="2">
											
							  </td>
							  
							  <td class="hide" id="transactionbox"></td>
						  	   
					        </TR>					
										
						</cfif>
					
					   </table>
							
					</td>										
										
					<cfquery name="sourcemode" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
						SELECT *
						FROM   ItemWarehouseLocationTransaction
						WHERE  Warehouse = '#url.warehouse#'	
						AND    Location  = '#url.location#'	
						AND    ItemNo    = '#url.itemno#'
						AND    UoM       = '#url.UoM#' 	
						AND    TransactionType = '#url.tratpe#'			
					</cfquery>					
															
					<td width="80%" align="right" style="height:10;padding-left:4px;padding-right:8px">	
					
					    <table class="formpadding" style="height:10">
						<tr>
						<td id="entrymode1">	
						<input type="radio" name="entrymode" id="entrymode" class="enterastab" value="Direct Entry" checked onclick="javascript:transactiontoggle('manual')"> <font face="Verdana" size="2"><cf_tl id="Manual">
						</td>
						<td id="entrymode2" class="<cfif sourcemode.source neq '2' and sourcemode.source neq '9'>hide</cfif>">	
						<input type="radio" name="entrymode" id="entrymode" class="enterastab" value="Device" onclick="javascript:transactiontoggle('device')"> <font face="Verdana" size="2"><cf_tl id="Device">				
						</td>
						<td id="entrymode3" class="<cfif sourcemode.source neq '3' and sourcemode.source neq '9'>hide</cfif>">
						<input type="radio" name="entrymode" id="entrymode" class="enterastab" value="Upload" onclick="javascript:transactiontoggle('pdf')"> <font face="Verdana" size="2"> <cf_tl id="PDF form">
						</td>
						
						</tr>
						</table>
						
						<cf_space spaces="56">
						
					</td>		
					
					<td>
					            <img src="#SESSION.root#/images/up6.png" 
		                          	id="formdataMin"	
		                       		height="22"
		                           	width="23"
		                           	align="absmiddle"
		                         	onclick="maximize('formdata')"								
		        	               	class="regular">
		                                              
		      			        <img src="#SESSION.root#/images/down6.png" 		    
		                           	id="formdataExp"
		        		         	height="22"
		                           	width="23"
		        	            	align="absmiddle"
		    	                   	onclick="maximize('formdata')" 								
		                         	class="hide">
					
					</td>				
					
				</tr>
				</table>			
		</tr>	
		
		<!--- main container --->
			
		<tr><td height="100%" colspan="2">
				
				<cfif url.scope eq "pdf">
				    <cfset cl = "regular">
					<cfset ma = "hide">
				<cfelse>
				    <cfset ma = "regular">
					<cfset cl = "hide">	
				</cfif>	
				
				<table width="100%" height="100%" align="center">	 
				    
					<tr>
					<td height="30" id="formdata" name="formdata" class="regular">
					
					<table cellspacing="0" cellpadding="0"  width="100%">

						<tr id="boxmanual" class="#ma#">
							<td id="inputboxmanual">
								<cfinclude template="TransactionLogSheetManual.cfm">
							</td>
						</tr>

						<tr id="boxdevice" class="#cl#">
							<td id="inputboxdevice">
								<cfinclude template="TransactionLogSheetDevice.cfm">
							</td>
						</tr>

						<tr id="boxpdf" class="#cl#">
							<td id="inputboxpdf">
								<cfinclude template="TransactionLogSheetPDF.cfm">
							</td>
						</tr>

					</table>
					</td>
					</tr> 							
							
					<tr><td colspan="2" height="100%">

						<table width="100%" height="100%" align="center" cellspacing="0" cellpadding="0">

							<tr><td height="3"></td></tr>

							<tr id="meter0" height="20" class="line">
								<td width="90%" id="readingbox" style="padding:0px">
								 	<cfinclude template="LogReading/TransactionLogReading.cfm">
								</td>
							</tr>

							 <cfif url.height lte "900">

								 	<tr>
									<td colspan="2" width="100%" style="padding:6px" id="detail">

									<cfset url.tratpe = url.id>
									<cfinclude template="TransactionDetailLines.cfm">

									</td>
									</tr>

							 <cfelse>

								 	<tr>
									<td colspan="2" height="100%"  width="100%" style="padding:6px">

									   <cf_divscroll id="detail">
										<cfset url.tratpe = url.id>
										<cfinclude template="TransactionDetailLines.cfm">
									   </cf_divscroll>

									 </td>
									</tr>

							  </cfif>

							<tr><td class="linedotted"></td></tr>
							<tr>
								<td style="height:35" class="top4n" bgcolor="eaeaea" id="logtotals">
								<cfinclude template="TransactionLogSheetTotal.cfm">
								</td>
							</tr>

						</table>

					</td></tr>

				 </table>
				 
				 </td>
		 </tr>
		 	 
	 </table>
  
 </cfform>
	
</td>
</tr>

</table>

</cfoutput>		

