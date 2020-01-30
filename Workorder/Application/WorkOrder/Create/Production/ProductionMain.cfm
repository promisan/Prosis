xxxxx
<!--- --------CUSTOM FORM DATA ENTRY --------- --->
<!--- ---------------------------------------- --->
<!--- ----- Internal Production order -------- --->
<!--- ---------------------------------------- --->
<!--- ---------------------------------------- --->

<script>

 function toggle(node) {
    se = document.getElementById
 
 }

</script>

<cfform name="orderform" onsubmit="return false">

<!--- there can be different rates basedon the topic + unit combinations --->

<table width="100%" cellspacing="0" cellpadding="0" class="formpadding">
	
	<tr>	
		<td height="34" class="labelmedium" width="15%"><cf_space spaces="46"><cf_tl id="Reference">:</td>
		<td><input type="text" class="regularxl" name="Reference" id="Reference" maxlength="20" style="width:100"></td>
	</tr>
	
	<tr class="hide"><td id="process"></td></tr>
	
	<cfparam name="OrgUnitOwner"     default="">
	<cfparam name="OrgUnitOwnerName" default="">
	
	<tr>
		<td  height="34" class="labelmedium" width="15%"><cf_tl id="Owner">:</td>
		<td class="labelmedium">
		
		 		<table>
					 <tr><td>
					       
						 <cfinput type="text" name="orgunitname1" id="orgunitname1" value="#OrgUnitOwnerName#" message="No unit selected" required="No" class="regularxl" size="40" maxlength="80" readonly>					  
						 
						 </td>
						 
						 <td style="padding-left:2px">
						 
						 <cfoutput>		 
						 
						     <img src="#SESSION.root#/Images/search.png" alt="Select authorised unit" name="img0" 
							   onMouseOver="document.img0.src='#SESSION.root#/Images/contract.gif'" 
							   onMouseOut="document.img0.src='#SESSION.root#/Images/search.png'"
							   style="cursor: pointer;" alt="" width="25" height="25" border="0" align="absmiddle" 
							   onClick="selectorgN('#url.mission#','administrative','orgunit','applyorgunit','1','1','modal')">
						  	     
								 <input type="hidden" name="orgunit1"      id="orgunit1" value="#OrgUnitOwner#"> 
								 <input type="hidden" name="mission1"      id="mission1"> 
								 <input type="hidden" name="orgunit1code"  id="orgunit1code">
							   	 <input type="hidden" name="orgunit1class" id="orgunit1class"> 
						 
						 </cfoutput>
						 
						 </td>
					  </tr>			 
	          </table>
			
		</td>
	</tr>
	
	<tr>
		<td  height="34" class="labelmedium" width="15%"><cf_tl id="Date">:</td>
		<td class="labelmedium">
		
			<cfset st = Dateformat(now(), CLIENT.DateFormatShow)>
		
		     <cf_intelliCalendarDate9
				FieldName="DateEffective" 
				Manual="True"		
				class="regularxl"								
				Default="#st#"
				AllowBlank="False">		
		
		</td>
	</tr>
	
	<tr><td></td></tr>
		
	<cfquery name="ServiceItem" 
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">		 
		 SELECT    *
		 FROM      ServiceItem
		 WHERE     Code = '#url.serviceitem#'				  
	</cfquery>
	
	<cfinvoke component     = "Service.Access"  
		   method           = "WorkOrderProcessor" 
		   mission          = "#url.mission#"  
		   serviceitem      = "#url.serviceitem#"
		   returnvariable   = "accessunit">

	<cfinvoke component     = "Service.Access"  
		   method           = "WorkOrderProcessorUnit" 
		   mission          = "#url.mission#"  
		   serviceitem      = "#url.serviceitem#"
		   returnvariable   = "accessorgunit">	
		
	<cfquery name="Phase" 
		 datasource="AppsWorkOrder" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">		 
		 SELECT    *, (SELECT OrgUnitImplementer
                       FROM   WorkOrderServiceMission  
				       WHERE  ServiceDomain = W.ServiceDomain
					   AND    Reference     = W.Reference
				       AND    Mission       = '#url.mission#') as OrgUnitImplementer
		 FROM      WorkOrderService W
		 WHERE     ServiceDomain = '#serviceitem.serviceDomain#'
		 <cfif getAdministrator(url.mission) eq "1" or accessunit eq "ALL" or accessunit eq "EDIT">			 
		 AND       1=1
		 <cfelseif accessunit eq "0" or accessorgunit eq ""  or accessorgunit eq ",">
		 AND       1=0
		 <cfelse>
		 AND       EXISTS (SELECT 'X'
		                   FROM    WorkOrderServiceMission  
						   WHERE   ServiceDomain = W.ServiceDomain						   
						   AND     Mission = '#url.mission#'
						   AND     OrgUnit IN (#accessorgunit#) )
		 </cfif>				   
		 ORDER BY  ListingOrder				  
	</cfquery>
		
	<tr><td colspan="4" class="line"></td></tr>
			
	<cfoutput query="Phase">	
	
	<cfparam name="OrgUnitP#currentrow#"   default="">
	<cfparam name="OrgUnitP#currentrow#Name" default="">
	
	<tr class="line">
				
		<td colspan="4">
		 <cfinvoke component = "Service.Presentation.TableFilter"  
			   method           = "tablefilterfield" 
			   filtermode       = "direct"		
			   label            = "<span style='font-size:20px'><b>#description#</b>&nbsp;&nbsp;&nbsp;</span>"	   
			   name             = "filtersearch#currentrow#"
			   style            = "font:14px;height:25;width:120"
			   rowclass         = "cls#currentrow#"
			   rowfields        = "ccontent#currentrow#">	  
			   
		</td>
		
		<!---
		<td colspan="4" class="labelmedium">
		<input type="checkbox" class="radiol" name="Reference" value="#Reference#" onclick="toggle('#currentrow#')">
		</td>
		--->
	</tr>	
	
	<tr>
		<td style="padding-left:3px" class="labelmedium"><cf_tl id="Operated by">:</td>
		<td colspan="4" class="labelmedium">
		
		           <table>
					 <tr><td>
					 										 
					 	<cfquery name="getOrgUnit" 
							 datasource="AppsOrganization" 
							 username="#SESSION.login#" 
							 password="#SESSION.dbpw#">		 
								 SELECT    *
								 FROM      Organization
								 <cfif orgunitimplementer neq "">
								 WHERE     OrgUnit = '#orgunitimplementer#'
								 <cfelse>
								 WHERE     1=0
								 </cfif>
						</cfquery>
					       
						 <cfinput type="text" name="orgunitnameP#currentrow#" value="#getOrgUnit.OrgUnitName#"
							 id="orgunitnameP#currentrow#" message="No unit selected" required="Yes" class="regularxl" 
							 size="40" maxlength="80" readonly>					  
						 
						 </td>
						 
						 <td style="padding-left:2px">
						 					 
						     <img src="#SESSION.root#/Images/search.png" alt="Select authorised unit" name="img0" 
								  onMouseOver="document.img0.src='#SESSION.root#/Images/contract.gif'" 
								  onMouseOut="document.img0.src='#SESSION.root#/Images/search.png'"
								  style="cursor: pointer;" width="25" height="25" border="0" align="absmiddle" 
								  onClick="selectorgN('#url.mission#','operational','orgunit','applyorgunit','P#currentrow#','1','modal')">
						  	     
							 <input type="hidden" name="orgunitP#currentrow#" id="orgunitP#currentrow#" value="#getOrgUnit.OrgUnit#"> 
							 <input type="hidden" id="missionP#currentrow#"> 
							 <input type="hidden" id="orgunitP#currentrow#code">
						   	 <input type="hidden" id="orgunitP#currentrow#class"> 
						 					 
						 </td>
					  </tr>			 
	          </table>
		
		
		</td>
	</tr>
	
	<tr>
		<td style="padding-left:3px" class="labelmedium"><cf_tl id="Destination">:</td>
		<td colpsan="4" class="labelmedium">
		
		<cfquery name="qWarehouse" 
		 datasource="AppsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">		 
			 SELECT    *
			 FROM      Warehouse
			 WHERE     Mission = '#url.mission#'		 		  
			 AND       Operational = 1
			 AND       SaleMode = '0'
			 AND       Distribution = '1'
		</cfquery>
		
		<cfif qWarehouse.recordcount eq "0">
		
		<cfquery name="qWarehouse" 
		 datasource="AppsMaterials" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">		 
			 SELECT    *
			 FROM      Warehouse
			 WHERE     Mission = '#url.mission#'		 		  
			 AND       Operational = 1			
		</cfquery>
		
		</cfif>
		
		<select name="Warehouse#currentrow#" class="regularxl">
		<cfloop query="qWarehouse">
		    <option value="#warehouse#">#WarehouseName#</option>
		</cfloop>
		</select>
		
		</td>
	</tr>
	
	<tr>
		<td style="padding-left:3px" class="labelmedium"><cf_tl id="Lot">:</td>
		<td colpsan="4" class="labelmedium">
		<input type="text" name="TransactionLot#currentrow#" id="TransactionLot#currentrow#" size="20" maxlength="20" class="regularxl">	
		</td>
	</tr>
	
	<tr><td height="5"></td></tr>
		
	<cfset row = currentrow>
	
	<tr class="xhide" id="main#row#">
			
	    <td colspan="4" width="70%" id="box#row#" style="padding-left:20px;background-color:eaeaea;border:1px solid silver">				   
		    <cfinclude template="ProductionItem.cfm">		
		</td>	
		<!---	
		<td colspan="2" valign="top" width="50%">		
		<table class="formpadding" width="100%">		
			<tr><td>BOM of selected items</td></tr>		
		</table>			
		</td>
		--->
	</tr>
	
	<tr><td colspan="5" class="line"></td></tr>
	
	<tr><td style="height:10px"></td></tr>
	
	</cfoutput>		
	
	<tr>
		<td  height="34" class="labelmedium" width="15%"><cf_tl id="Memo">:</td>
		<td colpsan="4"><input type="text" class="regularxl" name="OrderMemo" id="OrderMemo" style="width:80%"></td>
	</tr>
	
</table>

</cfform>

<cfset ajaxonload("doCalendar")>


