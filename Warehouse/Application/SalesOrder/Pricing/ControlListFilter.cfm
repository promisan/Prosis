
<cfparam name="URL.ID2" default="SAT">

<!--- Search form --->
<table width="100%" cellspacing="0" cellpadding="0" style="padding-bottom:2px;padding:0px" class="formpadding">

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
	
	<table width="95%" class="formspacing" cellspacing="0" cellpadding="0" align="center">
	
		<tr>
			<td height="5"></td>
		</tr>
		
		<tr class="labelmedium">
			<TD style="width:190px"><cf_tl id="Program">:</TD>
	        <td align="left" style="padding-top:3px">
			   			
			    <select name="programcode" id="programcode" style="width:300px;" class="regularxl">
					<option value=""><cf_tl id="Any"></option>
					<cfoutput query="Program">
					<option value="#ProgramCode#">#ProgramName#</option>
					</cfoutput>
				</select>
		  	</td>		
		</tr>	
		
	    <tr class="labelmedium">
			<td width="15%"><cf_tl id="Category">:</td>
			<td>	
			    <select name="category" id="category" size="1" class="regularxl">	
					<option value=""><cf_tl id="Any"></option>			
				    <cfoutput query="CategoryList">
						<option value="#Category#">#Description#</option>
					</cfoutput>
			    </select>								
			</td>	
		</tr>
		
		<tr class="labelmedium">
			<td><cf_tl id="Sale Currency">:</td>
			<td>	
			  	<cfdiv id="divPriceCurrency" bind="url:../../SalesOrder/Pricing/Currency.cfm?warehouse=#url.warehouse#&category={category}">			
			</td>
		</tr>
		
		<tr class="labelmedium">
			<td><cf_tl id="Price Effective date">:</td>
			<td>	
				 <cf_intelliCalendarDate9
					FieldName="selectiondate" 
					class="regularxl"					
					Default="#dateformat(dateadd('m',-1,now()),CLIENT.DateFormatShow)#"
					AllowBlank="False">	
			</td>
		</tr>		
			
				
		<tr><td height="3"></td></tr>
		
		<tr><td height="1" colspan="6" style="border-top:1px dotted silver"></td></tr>
			
	</TABLE>
	
	</td></tr>
	
	<cfoutput>
	
		<tr>
		<td style="padding-left:17px;padding-top:4px" align="center">
			
		<cf_tl id="Filter" var="1">
					
		<input type   = "button" 
		       name   = "Submit" 
			   id     = "Submit"
			   value  = "#lt_text#" 
			   class  = "button10g" 
			   style  = "width:160px;height:23px" 
			   onclick= "pricefiltermain('#URL.Mission#','#URL.Warehouse#','#url.systemfunctionid#')">
	
		</td>
		</tr>
		
	</cfoutput>
	
</table>

</cfform>

</td></tr>

<tr><td colspan="2" style="padding-top:4px" class="line"></td></tr>

</table>

<cfset ajaxonload("doCalendar")>
