
<cfparam name="URL.ID2" default="SAT">

<!--- Search form --->
<table width="100%" style="padding-bottom:2px;padding:0px" class="formpadding">

<tr><td>

<cfform method="POST" name="filterform" onsubmit="return false">

<table width="100%" align="left">

	<tr>
	
	<!--- select only categories enabled for this warehouse --->
	
	<cfquery name="CategoryList" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM  Ref_Category
		WHERE Category  IN (SELECT Category 
		                    FROM   WarehouseCategory
							WHERE  Warehouse = '#url.warehouse#'
							AND    Operational = 1)	
		ORDER BY Description				
						
	</cfquery>
	
	<cfquery name="PriceSchedule" 
	datasource="appsMaterials" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT * 
		FROM  Ref_PriceSchedule
		WHERE Code  IN (SELECT PriceSchedule 
		                FROM   ItemUoMPrice
						WHERE  Mission = '#url.mission#')							
	</cfquery>	
	
	<cfquery name="Tax" 
		datasource="appsLedger" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT * 
			FROM  Ref_Tax		
			WHERE TaxCode  IN (SELECT TaxCode 
		                FROM   Materials.dbo.ItemUoMPrice
						WHERE  Mission = '#url.mission#')							
		</cfquery>
	
	 <cfquery name="Program" 
		datasource="AppsMaterials" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		   SELECT * 
		   FROM   Program.dbo.Program P
		   WHERE  ProgramClass = 'Project'
		   AND     EXISTS (SELECT 'X'
						   FROM   ItemTransaction AS T INNER JOIN Item AS I ON T.ItemNo = I.ItemNo
						   WHERE  T.Mission   = P.Mission 
						   AND    T.Warehouse = '#url.warehouse#'
						   AND    I.ProgramCode = P.ProgramCode
						   AND    T.TransactionType = '1')						   		  
		   ORDER BY Created DESC	   
		</cfquery>		
					
	<td>		
	
	<table width="98%" class="formspacing"  align="center">
	
		<tr>
			<td height="5"></td>
		</tr>
		
		<tr class="labelmedium fixlengthlist">
			<TD><cf_tl id="Program">:</TD>
	        <td align="left" style="padding-left:6px">
			   			
			    <select name="programcode" id="programcode" class="regularxxl" style="width:240px">
					<option value=""><cf_tl id="Any"></option>
					<cfoutput query="Program">
					<option value="#ProgramCode#">#ProgramName#</option>
					</cfoutput>
				</select>
		  	</td>	
			<TD><cf_tl id="Price schedule">:</TD>
			<td style="padding-left:6px">
			 <select name="priceSchedule" id="priceSchedule" class="regularxxl">
					<option value=""><cf_tl id="Any"></option>
					<cfoutput query="PriceSchedule">
					<option value="#Code#">#Description#</option>
					</cfoutput>
				</select>
				</td>
			
			</td>
		</tr>	
		
	    <tr class="labelmedium fixlengthlist">
			<td><cf_tl id="Category">:</td>
			<td style="padding-left:6px">	
			    <select name="category" id="category" size="1" class="regularxxl">	
					<option value=""><cf_tl id="Any"></option>			
				    <cfoutput query="CategoryList">
						<option value="#Category#">#Description#</option>
					</cfoutput>
			    </select>								
			</td>	
			
			<td><cf_tl id="In Stock">:</td>
			<td>
			<table>
			<tr class="labelmedium fixlengthlist">
			<td style="padding-left:3px">
			 <select name="InStock" id="InStock" size="1" class="regularxxl">	
					<option value=""><cf_tl id="N/A"></option>	
					<option value="1"><cf_tl id="Has stock"></option>				
					<option value="0"><cf_tl id="Zero stock"></option>		
					<option value="9"><cf_tl id="No movement"></option>				   
			    </select>		
			</td>
			<td><cf_tl id="Has a Price">:</td>
			<td>
			    <select name="Hasprice" id="HasPrice" size="1" class="regularxxl">						
					<option value="1" selected><cf_tl id="Yes"></option>				
					<option value="0"><cf_tl id="No"></option>						   
			    </select>				
			</td></tr></table>
			
		</tr>
		
		<tr class="labelmedium fixlengthlist">
			<td><cf_tl id="Sale Currency">:</td>
			<td style="padding-left:6px">	
			  	<cf_securediv id="divPriceCurrency" bind="url:../../SalesOrder/Pricing/Currency.cfm?warehouse=#url.warehouse#&category={category}">			
			</td>
			<TD style="padding-left:3px"><cf_tl id="Tax code">:</TD>
			<td style="padding-left:6px">
			<select name="taxcode" id="taxcode" class="regularxxl">
					<option value=""><cf_tl id="Any"></option>
					<cfoutput query="Tax">
					<option value="#TaxCode#">#Description#</option>
					</cfoutput>
				</select>
			</td>
		</tr>
		
		<tr class="labelmedium fixlengthlist">
			<td><cf_tl id="Price Effective date">:</td>
			<td>	
				 <cf_intelliCalendarDate9
					FieldName="selectiondate" 
					class="regularxxl"					
					Default="#dateformat(dateadd('m',-1,now()),CLIENT.DateFormatShow)#"
					AllowBlank="False">	
			</td>
			
			<td><cf_tl id="Receipt after">:</td>
			<td>	
			
				 <cf_intelliCalendarDate9
					FieldName="receiptdate" 
					class="regularxxl"					
					Default="#dateformat(dateadd('m',-6,now()),CLIENT.DateFormatShow)#"
					AllowBlank="True">	
					
			</td>
		</tr>		
			
				
		<tr><td height="3"></td></tr>
				
			
	</TABLE>
	
	</td></tr>
	
	<cfoutput>
	
		<tr class="line">
		<td style="height:35px;padding-left:17px;padding-top:4px" align="center">
			
		<cf_tl id="Filter" var="1">
					
		<input type   = "button" 
		       name   = "Submit" 
			   id     = "Submit"
			   value  = "#lt_text#" 
			   class  = "button10g" 
			   style  = "width:190px;height:27px" 
			   onclick= "pricefiltermain('#URL.Mission#','#URL.Warehouse#','#url.systemfunctionid#')">
	
		</td>
		</tr>
		
	</cfoutput>
	
</table>

</cfform>

</td></tr>

</table>

<cfset ajaxonload("doCalendar")>
