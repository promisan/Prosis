
<cfquery name="Item" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Item
	WHERE ItemNo = '#URL.ID#'
</cfquery>

<table width="100%" border="0" height="99%" align="center"  
   cellspacing="0" cellpadding="0" bordercolor="C0C0C0" class="formpadding">
  
  <tr>
    <td>
	
	<cfform>
  
    <table border="0" align="center" cellpadding="0" cellspacing="0" width="100%">
			
	 <cfoutput query="Item"> 
	  <tr class="line">
        <td width="15%" class="labelmedium"><cf_tl id="No">:</td>
        <td width="35%" class="labelmedium">#ItemNo#</td>
		<td width="15%" class="labelmedium"><cf_tl id="Category">:</td>
        <td width="35%" class="labelmedium">#Category#</td>
	 </tr>		
	 	 	
	 <tr class="line">
        <td class="labelmedium"><cf_tl id="Description">:</b></td>
        <td class="labelmedium">#ItemDescription#</td>
		<td class="labelmedium">Classification:</td>
        <td class="labelmedium">#Classification#</td>
      </tr>
	  	  
	  <tr class="line">
	  
	  	<td class="labelmedium" valign="top" style="padding-top:3px"><cf_tl id="External">:</b></td>
        <td class="labelmedium" valign="top" style="padding-top:3px">#ItemDescriptionExternal#</td>
       
		<td class="labelmedium" valign="top" style="padding-top:3px"><cf_tl id="Standard cost">#APPLICATION.BaseCurrency#</td>
        <td>
		
		<cfquery name="UoMSelect" 
		datasource="appsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   ItemUoM
			WHERE  ItemNo = '#URL.ID#'
			ORDER BY UoMMultiplier
		</cfquery>
		
		<cfif UOMSelect.recordcount lte "4">
		
			<table cellspacing="0" cellpadding="0">
			<cfloop query = "UoMSelect">
			<tr class="labelit line">		  
				<td style="padding-left:10px">#UoMDescription#</td>
				<td style="padding-left:10px">#UoMMultiplier#</td>		
				<td style="padding-left:10px">#ItemBarCode#</td>				   
			    <td style="padding-left:10px" align="right">#numberFormat(StandardCost,",.__")#</td>
			</tr>
			</cfloop>
			</table>
				
		</cfif>
				
		</td>
			
      </tr>
	  
	  <cfif UOMSelect.recordcount gt "4">
	  
		  <tr>
		  <td colspan="4" style="border-top:1px solid gray;padding-left:16px;padding-right:16px">
		  		 
		  <table width="100%" cellspacing="0" cellpadding="0">
		  
				<cfset ln = 0>
				<cfloop query = "UoMSelect">
				
					<cfset ln = ln+1>
				
					<cfif ln eq "1">
					<tr class="labelit line">		  
					</cfif>
						<td style="padding-left:20px">#UoMDescription#</td>
						<td style="padding-left:10px">#UoMMultiplier#</td>		
						<td style="padding-left:10px">#ItemBarCode#</td>				   
					    <td style="padding-left:10px;padding-right:10px;" align="right">#numberFormat(StandardCost,",.__")#</td>
					<cfif ln eq "3"></tr><cfset ln = 0></cfif>	
					
				</cfloop>
				
		  </table>
		  	  
		  </td>
		  </tr>	  
		  
		  <tr><td colspan="4" style="height:4px;border-bottom:1px solid gray;"></td></tr>
	  
	  </cfif>	  	  
	  
	  <cfif ItemNoExternal neq "">
	  <tr><td colspan="4" class="line"></td></tr>
	  
	  <tr>
        <td class="labelmedium"><cf_tl id="External code">:</b></td>
        <td class="labelmedium"><b>#ItemNoExternal#</td>		
      </tr>
	  
	  </cfif>
	    
	  <tr><td colspan="4" class="line"></td></tr>
	  
	  <cfparam name="URL.Warehouse" default="">
	  <cfparam name="URL.UoM" default="#UoMSelect.UoM#">
	  
	  <input type="hidden" name="topic" id="topic">	  
	 	  
	  <tr id="filter" class="hide line">
	  
	    <td colspan="4">
	  
	  	<table width="100%" border="0" align="center" cellspacing="0" cellpadding="0" class="formpadding">
			<tr>
			   
			<cfquery name="Warehouse"
			  datasource="AppsMaterials" 
			  username="#SESSION.login#" 
			  password="#SESSION.dbpw#">
			    SELECT *
				FROM  Warehouse W
				WHERE Mission = '#URL.Mission#'
				AND   Warehouse IN (SELECT Warehouse 
				                    FROM Purchase.dbo.RequisitionLine 
									WHERE Warehouse = W.Warehouse)
			</cfquery>	
  			
			<TD height="26" width="80" class="labelmedium"><cf_tl id="Warehouse">:</td>
			<TD height="26" width="100" style="padding-left:2px">
				<select name="warehouse" id="warehouse" onChange="itmonorder()" style="width:190">
				    <option value=""><cf_tl id="Any"></option>
		            <cfloop query="Warehouse">
		                <option value="#Warehouse#" <cfif url.warehouse eq warehouse>selected</cfif>>#Warehouse# #WarehouseName#</option>
		            </cfloop>
				</select>
			</td>			
						
			<TD height="26" width="40" style="padding-left:6px" class="labelmedium"><cf_tl id="UoM">:</td>
			<TD height="26" width="120">
		        <select name="unitofmeasure" id="unitofmeasure" onChange="itmonorder()">
		            <cfloop query="UoMSelect">
		                <option value="#UoM#" <cfif url.uom eq uom>selected</cfif>>#UoMDescription#</option>
		            </cfloop>
				</select>
			</td>
						
			<TD height="26" align="right">
				
				<table cellspacing="0" align="right" cellpadding="0">
				
				<TD height="26" width="50"><cf_tl id="Period">:</td>
				
					<td style="padding-right:5px;z-index:1">
				
					<cf_intelliCalendarDate9
					   FieldName="datestart" 
					   Default=""
					   Class="regularh"
					   AllowBlank="True">					
					   
					</td>
					<td style="padding-right:5px;z-index:1">
					
					 <cf_intelliCalendarDate9
					 	FieldName="dateend" 
					    Default=""
					    Class="regularh"
					    AllowBlank="True">	
						
			        </td>
					</tr>
				</table>			
			</td>
						
			</tr>			
			
			 <!--- trigger a script to be run from the date picker  		
			 <cfajaxproxy bind="javascript:itmonorder('',{datestart})">		
			 <cfajaxproxy bind="javascript:itmonorder('',{dateend})">		
			 --->					
			
		</table>
		</td>
	  </tr>		
	  	 
	  </table>
	 </cfoutput>
	 
 	 </cfform>
	 
	 </td>
	 </tr>   	 	 
	 
	 <tr>
	  <td colspan="1" height="100%" valign="top" id="detail" style="z-index:99">
	   <cfset url.itemNo = item.ItemNo>
	   <cfinclude template="Transaction/TransactionListing.cfm">	  
	  <!--- ajax box for showing result values --->
	  </td>
	 </tr>
	 	  	  	
	</table>	  