
<cfquery name="Item" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Item
	WHERE ItemNo = '#URL.ID#'
</cfquery>

<cfquery name="Cat" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_Category
	WHERE Category = '#Item.Category#'
</cfquery>

<cfquery name="Sub" 
datasource="appsMaterials" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT *
	FROM Ref_CategoryItem
	WHERE Category = '#Item.Category#'
	AND   CategoryItem = '#Item.CategoryItem#'
</cfquery>

<table width="100%" height="100%">
  
  <tr style="height:20px">
    <td style="padding-left:6px;background-color:f1f1f1">
	
	<cfform>
  
    <table border="0" align="center" width="100%">
			
	 <cfoutput query="Item"> 
	 
	  <tr class="labelmedium2 fixlengthlist">
        <td width="15%"><cf_tl id="No">:</td>
        <td width="35%">#ItemNo#</td>
		<td width="15%"><cf_tl id="Category">:</td>
        <td width="35%">#Category# #Cat.Description# #sub.CategoryItemName#</td>
	 </tr>		
	 	 	
	 <tr class="labelmedium2 fixlengthlist">
        <td><cf_tl id="Description">:</b></td>
        <td>#ItemDescription#</td>
		<td><cf_tl Id="External">:</td>
        <td>#ItemNoExternal#</td>
      </tr>
	  	  
	  <tr class="labelmedium2 fixlengthlist">
	  
	  	<td><cf_tl id="Generic name">:</td>
        <td>#ItemDescriptionExternal#</td>       
		<td><cf_tl id="UoM">:</td>
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
		
			<table>
			<cfloop query = "UoMSelect">
			<tr class="labelmedium2 fixlengthlist">		  
				<td>#UoMDescription#</td>
				<td style="padding-left:5px">#UoMMultiplier#</td>		
				<td title="Barcode" style="padding-left:5px">#ItemBarCode#</td>				   
			    <td style="padding-left:5px" align="right">#APPLICATION.BaseCurrency# #numberFormat(StandardCost,",.__")#</td>
			</tr>
			</cfloop>
			</table>
				
		</cfif>
				
		</td>
			
      </tr>
	  
	  <cfif UOMSelect.recordcount gt "4">
	  
		  <tr>
		  <td colspan="4">
		  		 
		  <table width="100%">
		  
				<cfset ln = 0>
				<cfloop query = "UoMSelect">
				
					<cfset ln = ln+1>
				
					<cfif ln eq "1">
					<tr class="labelmedium line">		  
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
		  	  
	  </cfif>	  	  
	  
	  <cfparam name="URL.Warehouse" default="">
	  <cfparam name="URL.UoM" default="#UoMSelect.UoM#">
	  
	  <input type="hidden" name="topic" id="topic">	  
	 	  
	  <tr id="filter" class="hide line">
	  
	    <td colspan="4">
	  
	  	<table width="100%" border="0" align="center" class="formpadding">
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
	  
	   </cfoutput>
	  	 
	  </table>
	 	 
 	 </cfform>
	 	 
	 </td>
	 </tr>   	 	 
	 
	 <tr>
	  <td id="detail" valign="top">	  
	  	 
	   <cftry>
	   <cfset url.itemNo = item.ItemNo>
	   <cfinclude template="Transaction/TransactionListing.cfm">	
	   <cfcatch></cfcatch>	  
	   </cftry>
	 
	   
	  <!--- ajax box for showing result values --->
	  </td>
	 </tr>
	 	  	  	
	</table>	  