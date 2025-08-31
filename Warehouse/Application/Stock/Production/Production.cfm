<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
		<tr><td align="center" height="100" class="labelmedium" style="padding-top:40px">
		
		    <cf_tl id="This function deprecated, production of half- and final product now handled through workorder module">
		
		</td></tr>
</table>

<!---


<cfquery name="param" 
	   datasource="AppsMaterials" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		   SELECT   *
		   FROM     Ref_ParameterMission
		   WHERE    Mission = '#mission#' 
	</cfquery>
					
<cfif Param.LotManagement eq "0">
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="silver">
		<tr><td align="center" height="100" class="labelmedium">
	    <cf_tl id="You need to have LOT management enabled for this function. Option not available"></td></tr>
	</table>
	<cfabort>
		
</cfif>	

<cfquery name="Param" 
	   datasource="AppsMaterials" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		SELECT   *
		FROM     Ref_ParameterMission
		WHERE    Mission = '#url.Mission#'		
</cfquery>		

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
				<tr><td align="center" height="100" class="labelmedium">
				    <cf_tl id="You have been granted only read rights. Option not available"></td></tr>
		</table>
		<cfabort>
	
	</cfif>   
	
<form method="post" style="height:100%" name="productionform" id="productionform">

 <table width="94%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="silver" align="center">		
	 
 <cfparam name="url.systemfunctionid" default="00000000-0000-0000-0000-000000000000">
		
 <cf_LanguageInput
	TableCode       = "Ref_ModuleControl" 
	Mode            = "get"
	Name            = "FunctionName"
	Key1Value       = "#url.SystemFunctionId#"
	Key2Value       = "#url.mission#"				
	Label           = "Yes">
	
	<cfoutput>
		
		<tr><td height="5px"></td></tr>
		<tr>
		  <td style="border:0px solid silver" colspan="2" height="57" style="padding:6px">	 
		  	 
			 <table height="67px" cellpadding="0" cellspacing="0" border="0" style="overflow-x:hidden" >												
				<tr>
					<td style="z-index:5; position:absolute; top:15px; left:35px; ">
					
						<img src="#session.root#/images/Logos/Warehouse/industry.png" alt="" border="0">
					</td>
				</tr>							
				<tr>
					<td style="z-index:3; position:absolute; top:17px; left:123px; color:45617d; font-family:calibri,trebuchet MS; font-size:25px; font-weight:bold;">
						<cfoutput>#lt_content#</cfoutput>
					</td>
				</tr>
				<tr>
					<td style="position:absolute; top:4px; left:130px; color:e9f4ff; font-family:calibri,trebuchet MS; font-size:40px; font-weight:bold; z-index:2">
						<cfoutput>#lt_content#</cfoutput>
					</td>
				</tr>							
				<tr>
					<td style="position:absolute; top:45px; left:130px; color:45617d; font-family:calibri,trebuchet MS; font-size:12px; font-weight:bold; z-index:4">
											
					 <cf_LanguageInput
						TableCode       = "Ref_ModuleControl" 
						Mode            = "get"
						Name            = "FunctionMemo"
						Key1Value       = "#url.SystemFunctionId#"
						Key2Value       = "#url.mission#"				
						Label           = "Yes">
							
						<cfoutput>#lt_content#</cfoutput>
						
					</td>
				</tr>							
			</table>
			  
		  </td>
		</tr>	
		
		</cfoutput>
		
		<tr><td colspan="2" class="linedotted"></td></tr>
			
	<cfoutput>
				
	<tr><td height="15"></td></tr>
	 	
	<tr>
	  <td style="height:30" class="labelit"><cf_tl id="Facility">:</td>
	  <td class="labelmedium">
	  
  		  <cfquery name="whs" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
				FROM     Warehouse
				WHERE    Warehouse = '#URL.Warehouse#'		 
		  </cfquery>
			  
		  #whs.WarehouseName# #whs.City# [#URL.Warehouse#]
					
	  </td> 
	</tr>	
	
	
	<tr><td style="height:30" class="labelit"><cf_tl id="Date">:</td>
	<td>
	
		<table width="100%" cellspacing="0" cellpadding="0">
		<tr><td>
								
		 <cf_getWarehouseTime warehouse="#url.warehouse#">
				
		 <cf_setCalendarDate
		      name     = "transactionDate"        		       
		      font     = "16"
			  timezone = "0"
			  edit     = "Yes"
			  class    = "enterastab regularxl"				  
		      mode     = "datetime"> 		
			  
		</td>
		<td align="right" style="padding-right:10px;height:30" class="labelit"><cf_tl id="Transaction No">:</td>
		<td align="right" style="width:80px;padding-right:20px">
		   <input maxlength="20" type="text" class="regularxl enterastab" name="BatchReference">
		</td>		
		</tr>
		</table>	  			  
				
	</td>
	</tr>
	
	<tr><td style="height:30" class="labelit"><cf_tl id="Production Lot">:</td>
	<td>
	
		 <table cellspacing="0" cellpadding="0">
		
		 <tr>
		 <td>
		
			<input type="text" 
			    maxlength="20"
				size="10"
		    	class="regularxl enterastab"  
				onchange="ColdFusion.navigate('#session.root#/tools/process/stock/getLot.cfm?mission=#url.mission#&transactionlot='+this.value,'TransactionLot_content')"										     
				name="TransactionLot">
		
		 <td id="TransactionLot_content" class="labelit" style="padding-left:3px;width:20"></td>
		 
		 </tr>
		 
		 </table>
		
		</td>
	</tr>		
		
	<tr>
	   <td style="height:30;padding-top:6px" valign="top" width="100" class="labelit"><cf_tl id="Workorder">:</td>
	   <td style="padding-top:3px" valign="top">   
	  
			    <table width="100%" cellspacing="0" cellpadding="0">
				<tr>
				   <td style="padding-right:3px" valign="top" class="labelmedium"><i>
				   	
			       <cfset link = "#SESSION.root#/Warehouse/Application/Stock/Production/getWorkorderItems.cfm?warehouse=#url.warehouse#">
				   
				   		<cf_tl id="Select workorder" var="vSelect">
						
						<!--- only workorder that are in production status = 1 --->
												
					    <cf_selectlookup
						    box          = "itemcontent"
							link         = "#link#"
							id           = "workorderselect"
							title        = "#vSelect#"
							icon         = "contract.gif"
							button       = "No"
							close        = "Yes"	
							filter1      = "w.mission"
							filter1value = "#url.mission#"		
							filter2      = "finishedproduct"	
							filter3      = "w.actionstatus"
							filter3value = "1"																	
							class        = "WorkOrder"
							des1         = "WorkorderId">	
							
					<input type="hidden" name="workorderid" id="workorderid" size="4" value="" class="regular" readonly style="text-align: center;">	
				
				   </td>			
				   
				</tr>
				
				</table>  
		</td>			  	   
	</TR>
	
	<tr><td colspan="2" class="linedotted"></td></tr>
		
	<tr><td height="4"></td></tr>
				
	<tr><td colspan="2" height="100%" style="border:0px solid silver;height:100%;padding:1px">
		<cf_divscroll style="padding:7px;height:100%" overflowy="auto" id="itemcontent"></cf_divscroll>
	</td></tr>	
	
	<tr><td height="4"></td></tr>
	
	<tr><td colspan="2" class="linedotted"></td></tr>
	
	<tr><td style="height:30" class="labelit"><cf_tl id="Memo">:</td>
		<td><input type="text" class="regularxl enterastab" name="BatchMemo" style="width:100%"></td>		
	</tr>
	
	<tr><td style="height:30" class="labelit"><cf_tl id="Attachments">:</td>
		<td>
		
			<cf_assignid>
				
			  <cf_filelibraryN 
				DocumentPath  = "WhsBatch" 
				SubDirectory  = "#rowguid#" 			
				Filter        = ""	
				Insert        = "yes" 
				Remove        = "yes" 
				LoadScript    = "false" 
				rowHeader     = "no" 
				ShowSize      = "yes"> 
		
		</td>		
	</tr>
		
	<tr><td colspan="2" class="linedotted"></td></tr>	
		
		<TR style="height:40px"> 
		          <TD id="submitbox" class="hide" colspan="2" align="center">
				  <cf_tl id="Submit Production" var="1">			  
				  <input type="button" 
				      class="button10s" style="height:29;width:220;font-size:13px" 
					  value="#lt_text#" 
					  onclick="ColdFusion.navigate('../Production/ProductionSubmit.cfm?mission=#url.mission#&receiptmode='+document.getElementById('receiptmodeselected').value+'&systemfunctionid=#url.systemfunctionid#&warehouse=#url.warehouse#&batchid=#rowguid#','itemcontent','','','POST','productionform')" 
					  name="addline" id="addline">
				  </TD>
		        </TR>
	
	</td></tr>
	
	</cfoutput>	

</table>

</form>	

--->