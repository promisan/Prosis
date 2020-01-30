
<!--- ---------------------------------------------------------------- --->
<!--- ---- this template is to CONVERT task lines into a Taskorder --- --->
<!--- ---------------------------------------------------------------- --->

<cfajaximport tags="cfinput-datefield,cfform">

<cf_dialogProcurement>

<script language="JavaScript">

  function taskedit(id,ser,act,val,whs) {       
      _cf_loadingtexthtml='';			 
      ptoken.navigate('setTaskRecord.cfm?id='+id+'&serialno='+ser+'&action='+act+'&val='+val+'&warehouse='+whs,'processbox')		  	 
  }
    
  function taskselect(id,ser,tot,mode) {  
  
      Prosis.busy('yes')
	  cnt = 1	
	 
	  while (cnt <= tot+6) {   		      		 
	      try { document.getElementById('taskbox_'+cnt).className = "regular" } catch(e) {}
	      cnt++ 			
		  } 
		  
	  try {	  
	  document.getElementById('taskbox_'+ser).className = "highlight"   	 
	  } catch(e) {}	  
	  
	  if (document.getElementById('purchase')) {
	     _cf_loadingtexthtml='';	
	     ptoken.navigate('TaskViewPurchase.cfm?requestid='+id+'&serialno='+ser,'purchase')	  	       
	  }	
	   
	  if (mode == 'enforce') {
	      _cf_loadingtexthtml='';	
		  ptoken.navigate('TaskViewInternal.cfm?requestid='+id+'&serialno='+ser,'internal')	
	  }
	  
  }
  
</script>

<cfparam name="url.requestid" default="">

<cfquery name="Request" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  	SELECT   R.*, U.UoMDescription AS UoMDescription, I.ItemDescription AS ItemDescription
	FROM     Request R INNER JOIN
             Item I ON R.ItemNo = I.ItemNo INNER JOIN
             ItemUoM U ON R.ItemNo = U.ItemNo AND R.UoM = U.UoM
    WHERE    RequestId = '#URL.RequestId#'
</cfquery>

<cfquery name="Header" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
  	SELECT   *
	FROM     RequestHeader
    WHERE    Mission   = '#Request.Mission#'
	AND      Reference = '#Request.Reference#'
</cfquery>

<cfquery name="Tasked" 
  datasource="AppsMaterials" 
  username="#SESSION.login#" 
  password="#SESSION.dbpw#">
    SELECT  MIN(TaskSerialNo) as First,
	        MAX(TaskSerialNo) as Last, 
	        SUM(TaskQuantity) as Quantity
    FROM    RequestTask
	WHERE   RequestId = '#URL.RequestId#'
</cfquery>

<cfparam name="url.mode" default="dialog">

<cfparam name="url.serialno" default="#tasked.first#">

<cfif url.mode eq "embed">
   <cfset html = "No">
<cfelse>
   <cfset html = "Yes">
</cfif>

<cf_screentop label="Taskorder Preparation"    
	   height="100%" 
	   scroll="Yes" 
	   layout="webapp" 
	   jquery="Yes"
	   close="parent.ColdFusion.Window.destroy('mytask',true)"
	   banner="gray" 
	   html="#html#">

	<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
		
		<tr><td height="15"></td></tr>
		
		<tr><td colspan="8" class="linedotted"></td></tr>
		
		<tr class="linedotted">
		    <td width="15%" class="labelmedium"><cf_tl id="Requester"></td>
			<td class="labelmedium"><cf_tl id="Product"></td>
			<td class="labelmedium"><cf_tl id="Description"></td>
			<td class="labelmedium"><cf_tl id="Usage"></td>
			<td class="labelmedium"><cf_tl id="UoM"></td>
			<td class="labelmedium" align="right"><cf_tl id="Requested"></td>
			<td class="labelmedium" align="right"><cf_tl id="Approved"></td>		
			<td class="labelmedium" align="right"><cf_tl id="Amount"></td>	
		</tr>		
				
		<cfoutput>
		<tr class="labelmedium">
		    <td>#Request.OfficerLastName#</td>
			<td>#Request.ItemNo#</td>
			<td>#Request.ItemDescription#</td>		
			<td>#Header.Category#</td>
			<td>#Request.UoMDescription#</td>
			<td align="right">#Request.OriginalQuantity#</td>
			<td align="right">#Request.RequestedQuantity#</td>		
			<td align="right">#numberformat(Request.RequestedAmount,"__,__.__")#</td>
		</tr>	
		
		<!--- check if detail lines exist --->
			
			<cfquery name="GetDetail" 
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT * 
				FROM  RequestDetail D, WarehouseLocation L
				WHERE D.ShipToWarehouse = L.Warehouse
				AND   D.ShipToLocation  = L.Location
				AND   D.RequestId       = '#requestid#'
			</cfquery>
			
			<cfloop query="getdetail">
			
			<tr><td></td><td colspan="8" class="linedotted"></td></tr>
			<tr>		 
			  <td></td>		   
			  <td colspan="2" style="padding-left:6px"><font color="808080">#Description#</td>
			  <td colspan="3"><font color="808080">#Remarks#</td>
			  <td align="right"><font color="808080">#RequestedQuantity#</td>
			  <td></td>
	   	    </tr>		
			
			</cfloop>	
		
		
		</cfoutput>
		
		<tr><td colspan="8" class="linedotted"></td></tr>		
		
		<!--- show in this template the stock for the warehouse to which the person has access, then the option to open the
		warehouse to process --->
		
		<cfquery name="getTaskWarehouse" 
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			  SELECT * 
			  FROM   Warehouse W		  
			  WHERE  W.Mission = '#Request.Mission#'
			  AND    W.Operational = 1
			 
			  		 
			  AND    (
			  
			          Warehouse = '#Request.Warehouse#' <!--- itself --->
			  		  
				      OR SupplyWarehouse = '#Request.Warehouse#' <!--- children --->
					  
					  OR SupplyWarehouse IN (SELECT Warehouse 
					                         FROM   Warehouse 
											 WHERE  Mission = '#Request.Mission#'
											 AND    SupplyWarehouse = '#Request.Warehouse#') <!--- children of the children --->								 
					)
					
																	 
	           <!--- has the requested item --->
			   		  
			   AND    Warehouse IN (   SELECT WL.Warehouse 
				                       FROM   WarehouseLocation WL, ItemWarehouseLocation IWL 
									   WHERE  WL.Warehouse    = W.Warehouse 
									   AND    WL.Warehouse    = IWL.Warehouse
									   AND    WL.Location     = IWL.Location
									   AND    IWL.ItemNo      = '#Request.itemno#'	
								       AND    IWL.UoM         = '#Request.uom#'	
									   AND    WL.Operational  = 1						   
									   AND    Distribution    = '1' 
								   )							   
							
								   
		      ORDER BY WarehouseDefault DESC 						   
		</cfquery>
			
		<!--- default source location to be assigned directly --->
			
		<cfquery name="getLocation" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		
			SELECT   WL.Location
				   
			FROM     WarehouseLocation WL, 
				     ItemWarehouseLocation I
				   
			WHERE    WL.Warehouse      = I.Warehouse
			AND      WL.Warehouse      = '#getTaskWarehouse.Warehouse#' 
			AND      WL.Location       = I.Location
			AND      WL.Operational    = 1			
			AND      WL.Distribution IN ('1')
			AND      I.ItemNo          = '#Request.itemno#'	
			AND      I.UoM             = '#Request.uom#'			
			ORDER BY WL.Location				
		</cfquery>
			
		<cfif getTaskWarehouse.recordcount eq "0">
		
			<tr><td colspan="8" class="labelmedium" align="center" height="50">
				<font color="FF0000">Attention : No valid facilities were determined for this request. Please contact your administrator</font>
			</td></tr>
		
		<cfelse>
		
			<cfparam name="url.taskedwarehouse" default="#getTaskWarehouse.Warehouse#">
		
			<!--- proceed creating an initial record --->
			
			<cfif Tasked.Quantity lt Request.RequestedQuantity>
				
				<cfif tasked.last eq "">			  
				    <cfset ser = "1">
					<cfset qty = Request.RequestedQuantity>
					<cfset url.serialno = ser>
				<cfelse>			   
					<cfset ser = tasked.last + 1> 
					<cfset qty = Request.RequestedQuantity-Tasked.Quantity>
					 <cfset url.serialno = ser>
				</cfif>
				
				<cfquery name="Warehouse" 
				  datasource="AppsMaterials" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				      SELECT *
				      FROM   Warehouse
					  WHERE  Mission   = '#Request.Mission#'
					  AND    Operational = 1							 						
				</cfquery>
					
				<cfif Request.ShipToWarehouse neq "">
				
					<cfset destination = Request.ShipToWarehouse>		
					
					<cfquery name="DestinationWarehouse" 
					  datasource="AppsMaterials" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					      SELECT TOP 1 *
					      FROM   RequestDetail D, WarehouseLocation L
						  WHERE  D.ShipToWarehouse = L.Warehouse
						  AND    D.ShipToLocation = L.Location
						  AND    D.RequestId = '#Request.RequestId#'
						  ORDER BY L.ListingOrder		
					</cfquery>
					
					
					<cfset deslocation = DestinationWarehouse.ShipToLocation>
				
				<cfelse>		
				
					<cfquery name="DestinationWarehouse" 
					  datasource="AppsMaterials" 
					  username="#SESSION.login#" 
					  password="#SESSION.dbpw#">
					      SELECT *
					      FROM   Warehouse
						  WHERE  MissionOrgUnitId IN (SELECT MissionOrgUnitId 
						                              FROM   Organization.dbo.Organization
													  WHERE  OrgUnit = '#Request.OrgUnit#')
						  AND    Operational = 1							 						
					</cfquery>
					
					<cfset destination = destinationWarehouse.Warehouse>
					<cfset deslocation = destinationWarehouse.LocationReceipt>
					
				</cfif>	
									
				<cfquery name="AddLine" 
				  datasource="AppsMaterials" 
				  username="#SESSION.login#" 
				  password="#SESSION.dbpw#">
				  
				    INSERT INTO RequestTask
				     
					   (RequestId,
					    TaskType,
						TaskSerialNo,
						TaskQuantity,
						TaskUoM,
						TaskUoMQuantity,
						TaskPrice,
						SourceWarehouse,
						SourceLocation,
						<cfif destination neq "">
							ShipToWarehouse,
							ShipToLocation,
						</cfif>
						ShipToDate,
						RecordStatus,
						OfficerUserId,
						OfficerLastName,
						OfficerFirstName)
						
				    VALUES
					
					  ('#URL.RequestId#',
					   'Internal',
					   '#ser#',
					   '#qty#',
					   '#Request.UoM#',
					   '#qty#',
					   '#Request.StandardCost#',   <!--- to be manually updated per mission : new table --->
					   '#url.taskedwarehouse#',
					   '#getLocation.Location#',
					   <cfif destination neq "">				  
						   '#destination#',
						   '#deslocation#',
					   </cfif>
					   '#header.DateDue#',
					   '1',
					   '#SESSION.acc#',
					   '#SESSION.last#',
					   '#SESSION.first#')   
					   					    
				</cfquery>
					
			</cfif>
									
			<tr class="hide"><td height="40" id="processbox"></td></tr>
			<tr><td height="5"></td></tr>
				
			<tr><td colspan="8" id="taskorder">					
				<cfinclude template="TaskViewItem.cfm">		
			</td></tr>
			
			<!--- dependent on the type either the warehouse location stock is shown or
			the pending workorders are shown --->
			
			<tr><td height="5" colspan="8" id="listings"></td></tr>	
						
			<tr><td id="purchase" colspan="8" style="padding:5px"  onMouseOver="document.getElementById('listings').focus()">	
			   	<cfinclude template="TaskViewPurchase.cfm"> 
				</td>
			</tr>
				
			<tr><td id="internal" colspan="8" style="padding:5px">
			   	<cfinclude template="TaskViewInternal.cfm"> 
				</td>
			</tr>
	
		</cfif>		
	
	</table>

<cf_screenbottom layout="webapp">