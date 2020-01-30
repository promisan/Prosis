<cf_tl id="Forecasting" var="vTitle">
<cf_screentop height="100%" 
	   scroll="Yes" 
	   label="#vTitle#" 
	   layout="webapp" 
	   banner="green" 
	   jQuery="Yes">  
	   
<cf_layoutScript>
<cf_PresentationScript>
	   
<table width="98%" height="99%" align="center">
	<tr><td height="10"></td></tr>
	<tr>
		<td class="labellarge" width="1%"><cf_tl id="Service">:</td>
		<td style="padding-left:10px;">
		
			<cfquery name="getServices" 
				datasource="appsWorkOrder" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT 	*
					FROM  	ServiceItem
					ORDER BY ListingOrder
			</cfquery>
			
			<cfform name="frmService">
				<cfselect 
					name="fltServiceItem" 
					id="fltServiceItem" 
					query="getServices" 
					display="Description" 
					value="Code" 
					class="regularxl">
				</cfselect>
			</cfform>
			
		</td>
	</tr>
	<tr><td height="5"></td></tr>
	<tr>
		<td colspan="2" height="100%" valign="top" style="border:1px solid #ededed;">
			<cfinclude template="ForcastViewDetail.cfm">
		</td>
	</tr>
</table>