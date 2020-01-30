	
<cfparam name="url.warehouse" default="">
		
<table cellpadding="0" 
	   cellspacing="0" 
	   width="100%" 
	   height="100%" 
	   bgcolor="FFFFFF" 
	   style="background-image:url('<cfoutput>#SESSION.root#</cfoutput>/Images/Logos/BGV2.png'); background-position:top right; background-repeat:no-repeat">

	<tr>
	
	<td valign="top" height="100%">
	
			<table cellpadding="0" 
			   cellspacing="0" 
			   align="center"
			   width="98%" 
			   height="100%">
			   	<tr>
					<td valign="top" style="padding-top:10px">
					
		<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#_DayTotal"> 
		<CF_DropTable dbName="AppsQuery" tblName="#SESSION.acc#_COGS"> 			
		
		<cfquery name="get"
			datasource="AppsMaterials" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT  *
			FROM    Warehouse
			WHERE   Warehouse= '#url.warehouse#'			
		</cfquery>
		
		<!---	
		<cfoutput>#cfquery.executiontime#</cfoutput>	
		--->
		
			<table width="96%" height="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">
			<tr height="20px">
					<td>
						 
						  <table cellspacing="0" cellpadding="0">
						    <tr>
							<td>
							<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/Logos/Warehouse/Sale.png" style="width:60px;height:60px" border="0" alt="" align="absmiddle">
							</td>
							<td style="padding-left:9px;padding-top:15px">							
							<font size="5" face="calibri">						
								<span id="printTitle"><b><cfoutput>#get.Mission# #get.warehouseName# #url.warehouse#</cfoutput></b></span>
							</font>
							</td>
							</tr>							
												
						   </table>						   	
						
					</td>
					<td align="right">
						
						<cf_tl id="Print" var="vPrint">
						<cf_tl id="Day Totals" var="vDayTotal">
						   
						<cf_button2
							type		= "Print"
							text		= "&nbsp;&nbsp;&nbsp;&nbsp;#vPrint#" 
							subtext		= "&nbsp;&nbsp;&nbsp;&nbsp;#vDayTotal#"
							bgColor		= "eaeaea"
							height		= "48px"
							width		= "150px"
							textSize	= "19px"
							printTitle	= "##printTitle"
							printContent= "##salecontent_#url.warehouse#">
						
						</td>
			</tr>
			
			<tr><td height="10"></td></tr>
			
			<tr>
			<td valign="top" colspan="4" height="100%" style="padding:5px">					
			    <cf_divscroll id="printContent_#url.warehouse#" style="height:100%">					
					<cfdiv bind="url:../../SalesOrder/POS/Inquiry/DayTotalBase.cfm?systemfunctionid=#url.systemfunctionid#&warehouse=#url.warehouse#">				
				</cf_divscroll>
			</td>
			</tr>
			
			</table>
			
			</td></tr>
			
		</table>
	
	</td></tr>
	
</table>	
