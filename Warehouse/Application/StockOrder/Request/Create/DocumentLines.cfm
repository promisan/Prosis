<!--
    Copyright © 2025 Promisan

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

<cfparam name="Object.ObjectKeyValue4"  default="">
<cfparam name="Parameter.EnableQuantityChange"  default="0">
<cfparam name="url.workflow"            default="0">

<cfset url.sorting = "ItemDescription">


<cfquery name="RequestLines" 
	datasource="AppsOrganization" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT DISTINCT L.*, 
		       L.UoM as UnitOfMeasure, 
			   U.UoMDescription,
			   A.ItemPrecision, 
			   A.Category,
			   
			   (
			   SELECT SUM(TaskQuantity)
			   FROM   Materials.dbo.RequestTask
			   WHERE  RequestId = L.RequestId
			   AND    RecordStatus IN ('1','3')
			   ) AS TaskedQuantity, 			   
			   
			   A.ItemDescription, 
			   L.Warehouse,
			   W.WarehouseName,
			   H.ActionStatus,
			   H.DateDue,
			   Org.Mission, 
			   Org.OrgUnitName, 
			   Org.HierarchyCode
	FROM  	   Materials.dbo.RequestHeader H,
	           Materials.dbo.Request L, 
		 	   Materials.dbo.Item A,
		       Materials.dbo.ItemUoM U,
		       Organization Org,
			   Materials.dbo.Warehouse W		 
	WHERE      L.ItemNo          = A.ItemNo
	AND        H.Mission         = L.Mission
	AND        H.Reference       = L.Reference
	AND        H.RequestHeaderId = '#url.drillid#' 
	AND        L.Warehouse = W.Warehouse
	AND        L.OrgUnit         = Org.OrgUnit 
	AND        A.ItemNo          = U.ItemNo
	AND        L.UoM             = U.UoM	
	AND        L.RequestType != 'Pickticket'
	ORDER BY #url.sorting#
</cfquery>

<!--- set url.id values based on the context --->
<cfif Object.ObjectKeyValue4 neq "">

	<cfset url.drillid  = Object.ObjectKeyValue4>	
    <cfset url.workflow = "1">
		
	<cfquery name="Parameter" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM  Ref_ParameterMission
		WHERE Mission = '#Object.Mission#'
	</cfquery>
	
<cfelse>
	
<cfquery name="Parameter" 
	datasource="AppsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT * 
		FROM   Ref_ParameterMission
		WHERE  Mission = '#RequestLines.Mission#'
</cfquery>
	
    <cfparam name="URL.ID1" default="">
	
</cfif>

<cfinvoke component="Service.Presentation.Presentation"
    method="highlight"
    returnvariable="stylescroll"/>

	<cfset vTotal = 	RequestLines.recordCount>
	
<cfif vTotal eq "0">

	 <table width="99%" align="center" border="0" cellspacing="0" cellpadding="0" bordercolor="#E5E5E5" class="formpadding">  
		 <tr><td align="center" class="label">No Lines defined for this request</td></tr>
	 </table>

<cfelse>

	<cfif Object.ObjectKeyValue4 neq "">
	
	<table width="97%" align="center">
	
	<tr><td height="15"></td></tr>
	<tr><td class="labellarge">
		Click on <img src="<cfoutput>#SESSION.root#</cfoutput>/images/task1.gif" alt="Task" border="0"> to task a request
	    </td>
	</tr>
	
	<cfelse>
	
	<table width="100%" align="center">
	
	</cfif>	
		
	<tr><td height="0" id="requestbox"></td></tr>
	
	<tr><td>
	
    <table width="100%" border="0" align="center" cellspacing="0" cellpadding="0" class="formpadding">  
				
		<tr bgcolor="ffffff">
		    <TD height="15" width="1%"></TD>
			<TD width="1%"></TD>														
			<TD width="30%" class="labelit"><cf_tl id="Facility"></TD>
			<TD width="12%" class="labelit"><cf_tl id="Submitted"></TD>					
			<TD width="20%" class="labelit"><cf_tl id="Product"></TD>				
		    <TD width="8%" class="labelit"><cf_tl id="UoM"></TD>
			<TD width="8%" class="labelit" align="right"><cf_tl id="Requested"></TD>		   			
			<TD width="8%" class="labelit" align="right"><cf_tl id="Approved"></TD>
			<cfif Parameter.RequestEnablePrice eq "1">
				<td width="8%" class="labelit" align="right"><cf_tl id="Price"></td>
				<td width="8%" class="labelit" align="right"><cf_tl id="Total"></td>
			<cfelse>
				<td width="1%"></td>
				<td width="1%"></td>
			</cfif>
			<TD width="6%" align="right" class="labelit"><cf_tl id="Tasked"></TD>
		</TR>
		<tr><td colspan="11" style="border-top:1px dotted silver"></td></tr>
	
	  <cfset amtT    = 0>			
	
	  <cfoutput query="RequestLines" group="#URL.Sorting#">			
	
	   <cfset amt    = 0>
	  	     
	   <CFOUTPUT>
	
	    <TR bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('ffffff'))#">
		
			   <td align="center" style="cursor: pointer" width="20" onClick="requestdetail('#requestId#')">
		
					<img src="#SESSION.root#/Images/arrowright.gif" alt="More details" 
						id="#requestid#Exp" border="0" class="show" height="12"
						align="absmiddle" style="cursor: pointer">
					
					<img src="#SESSION.root#/Images/arrowdown.gif" height="12"
						id="#requestid#Min" alt="More details" border="0" 
						align="absmiddle" class="hide">
					
			   </td>		
			   
	           <td width="1%" align="center">		
			   
			        <cfif actionstatus gte "1" and status neq "9">					    
					     <cfset cl = "regular">
					<cfelse>
					     <cfset cl = "hide">					   
					</cfif>		       				   
			   
			       <table cellspacing="0" cellpadding="0">
				   <tr>
				   
				      <!--- header approved and the line not cancelled --->
					  
					  <!--- first gte 2 --->			  
				   	  	
				   
				   	  <td id="task_#requestId#" class="#cl#">					 
					 
					  <cfif url.workflow eq "1">
					  					 
						  <img src="#SESSION.root#/images/task1.gif" 
						      alt="Task" 
							  border="0" 
							  style="cursor:pointer" 
							  onclick="task('#requestId#')">		
						  
					  </cfif>	  
											 
					 </td>	
					 
					 <td style="padding-left:3px"></td>		
					 
				     <td id="status_#requestId#" style="padding-left:3px;padding-right:3px">
					 
					 <cfif status eq "9">					 
					 	  <cfset cl = "blocked">							   
					 <cfelse>					 
						  <cfset cl = "regular">					  
					 </cfif>    
					 
					<!--- allow only cancellation of the line if the header status is pending approval --->

					<cfif actionstatus eq "1" and vTotal neq "1">	 
					
					    <!--- line status --->
						<cfif status eq "9">	  	
						 
						 	 <img src="#SESSION.root#/images/light_red3.gif" 
						      	  alt="Activate" 
								  border="0" 
								  onclick="ColdFusion.navigate('RequestEdit.cfm?id=#requestId#&action=revert','status_#requestid#')">		
							  									 
						 <cfelseif status eq "1"> 
	
							 <img src="#SESSION.root#/images/light_green2.gif" 
							      alt="Cancel" 
								  border="0" 
								  onclick="docancel('#requestId#','#url.drillid#')">	
								  				 
							  <cfset cl = "regular">
							  
						 </cfif>
						 
					</cfif>	 
						  
					 </td>					
					 	   
				   </tr>
				   </table>
				   	             		  
		       </td>					  
			   
			   <TD class="#cl# labelit" id="#requestid#_des">
			   
			   	   <cfif actionstatus lt "2" and url.workflow eq "0">
			  			   			   
					   <cfquery name="WarehouseList" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT * 
							FROM   Warehouse W
							WHERE  Mission      = '#Mission#'
							AND    Warehouse IN (SELECT Warehouse 
							                     FROM   WarehouseCategory 
												 WHERE  Warehouse = W.Warehouse
												 AND    Category = '#Category#')
							AND    Operational  = 1
							AND    Distribution = 1
					   </cfquery>
				   
					   <select name="warehouse" id="warehouse" class="regularxl"					     
					      onchange="ColdFusion.navigate('#SESSION.root#/warehouse/application/stockorder/Request/Create/RequestUpdate.cfm?requestid=#requestid#&field=warehouse&value='+this.value,'requestbox')">
					   
						   <cfloop query="WarehouseList">
						     	<option value="#warehouse#" <cfif warehouse eq requestlines.warehouse>selected</cfif>>#WarehouseName#</option>
						   </cfloop>
					   
					   </select>
				   
				   <cfelse>
				   
				       <cfquery name="WarehouseList" 
						datasource="AppsMaterials" 
						username="#SESSION.login#" 
						password="#SESSION.dbpw#">
							SELECT * 
							FROM   Warehouse
							WHERE  Warehouse    = '#RequestLines.warehouse#'						
					   </cfquery>
					   
					   #warehouseList.WarehouseName#
				   
				   
				   </cfif>
			   
			   </TD>	
			   
			    <td class="#cl# labelit">
			   
			   		<cf_getWarehouseTime Warehouse="#RequestLines.warehouse#" 
			                        TransactionDate="#dateformat(requestdate,CLIENT.DateFormatShow)#" 
									TransactionTime="#timeformat(requestdate,'HH:MM')#">			   

				   #dateformat(localtime,CLIENT.DateFormatShow)# 
				   
			   </td>
			  			  
			   <TD class="#cl# labelit" id="#requestid#_itm">#ItemDescription#</td>			   	     
	           <TD class="#cl# labelit" id="#requestid#_uom">#UoMDescription#</TD>
			   <TD class="#cl# labelit" align="right">#OriginalQuantity#</TD>
			   
			   <TD class="#cl# labelit" align="right">
			   
			   <cfif actionstatus lt "2" and Object.ObjectKeyValue4 eq "">
			  
				   <cfif (status eq "i" or status lte "2") and Parameter.EnableQuantityChange eq "1">
					
						   <input type="text" name="quantity" id="quantity" value="#RequestedQuantity#"
					       size="2" class="regularxl" maxlength="5" style="text-align: center;"
					       onchange="reqedit('#requestId#',this.value)">		 
						   
				   <cfelse>
				   
		   				<b>#RequestedQuantity#    
						
				   </cfif>		
				   
			   <cfelse>
			   
			   	  <b>#RequestedQuantity# 
			   
			   </cfif>	   	   
			   
	         </TD>
			 
			 <cfif Parameter.RequestEnablePrice eq "1">
	         
				 <td align="right" class="#cl# labelit" id="#requestid#_amt">#NumberFormat(StandardCost,'_____,__.__')#</td>	
			     <td align="right" class="#cl# labelit" id="amount_#requestId#">#NumberFormat(RequestedAmount,'_____,__.__')#</td>	
			   	 <cfset Amt  = Amt + RequestedAmount>
		         <cfset AmtT = AmtT + RequestedAmount>    	
			 
			 <cfelse>
			 
				 <td id="#requestid#_amt"></td>
				 <td id="amount_#requestId#"></td>
			 
			 </cfif>		
			 
			 <TD class="#cl#" align="right"><cfif TaskedQuantity eq "">--<cfelse>#TaskedQuantity#</cfif></TD>	 	
					
	    </TR>
				
		<!--- container to hold the taskorders --->
		<tr id="b#RequestId#">
		   <td></td>	
		   <td></td>	  
		   <td colspan="8" id="i#RequestId#"></td>
		</tr>		
		
		<!--- check if detail lines exist --->
						
		<cfquery name="getDetail" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT    RD.*, L.*
			FROM      Request R INNER JOIN
		              RequestDetail RD ON R.RequestId = RD.RequestId INNER JOIN
		              WarehouseLocation WL ON RD.ShipToWarehouse = WL.Warehouse AND RD.ShipToLocation = WL.Location INNER JOIN
		              Location L ON WL.LocationId = L.Location	
			WHERE     RD.RequestId = '#requestid#'
		</cfquery>	
			
				
		<cfloop query="getdetail">
		
		<tr><td></td><td></td><td colspan="6" class="linedotted"></td></tr>
		<tr>
		  <td></td>
		  <td></td>		   
		  <td class="#cl# labelit" style="padding-left:6px">For: #LocationName#</td>
		  <td class="#cl# labelit" colspan="3">#Remarks#</td>
		  <td class="#cl# labelit" align="right">#RequestedQuantity#</td>
		  <td></td>
   	    </tr>
				
		</cfloop>	
		
		<cfif status neq "9">
						
			<tr><td height="4"></td></tr>
			
			<!--- task details --->
			<tr id="t#RequestId#">
				<td></td>		   
				<td width="1%" valign="top" align="right"></td>
			    <td colspan="9" id="tc#RequestId#" style="border:0px dotted silver;padding:1px;spacing:3px">			
				    <cfset url.requestid = requestid>					
					<cfinclude template="DocumentLinesTask.cfm">		
				</td>			
			</tr>	
		
		</cfif>
		
		<tr><td height="4"></td></tr>			
	
	    </CFOUTPUT>
		
	  	</CFOUTPUT> 
		
		<cfif Parameter.RequestEnablePrice eq "1">
		 
			<cfoutput>
				     
			    <TR>
			       <td colspan="10" height="20" align="right">&nbsp;<cf_tl id="Total">:&nbsp;</b>		          
				   <td align="right" bgcolor="BBE6F2" id="boxoverall">#NumberFormat(AmtT,'_____,__.__')#</b></td>	
			    </TR>
			
			</cfoutput>
		
		</cfif>
		 		
		</table>
		
		</td></tr>
		
		</table>
	
</cfif>

