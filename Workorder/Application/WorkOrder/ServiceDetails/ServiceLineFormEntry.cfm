
<!--- entry form --->

<cfparam name="url.workorderid"   default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.tabno"         default="0">
<cfparam name="url.workorderline" default="0">

<cfquery name="Line" 
datasource="AppsWorkOrder" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	 SELECT  *	
     FROM    WorkOrderLine WL INNER JOIN WorkOrderService WS ON WL.ServiceDomain = WS.ServiceDomain AND WL.Reference = WS.Reference 
	 WHERE   WL.WorkOrderId     = '#url.workorderid#'	
	 AND     WL.WorkOrderLine   = '#url.workorderline#'
</cfquery>

<!--- new line, no open requests --->
<cfquery name="checkopen" 
     datasource="AppsWorkOrder" 
     username="#SESSION.login#" 
     password="#SESSION.dbpw#">
		SELECT  'X'
		WHERE	1 = 0
</cfquery>


<table width="100%" height="100%">

<tr><td height="5"></td></tr>

<tr><td id="contentbox" style="height:100%" valign="top">  <!--- contenbox is target for submit to load the servicelineformedit --->
	
	<cfform name="customform" method="POST" style="height:100%">	
	
		<table width="95%" border="0" class="formpadding" cellspacing="0" align="center">
			
		<tr><td colspan="2">
		
			<cfinclude template="ServiceLineFormData.cfm">
		
		</td></tr>
			
		<cfoutput>
		
			<tr><td colspan="2" class="line"></td></tr>
					
			<tr><td align="center" colspan="2" height="30">
					
				<input type    = "button" 
				       name    = "Save" 
			           id      = "Save"
					   Value   = "Save"
					   class   = "button10g" 
					   style   = "width:150;height:26"
					   onclick = "ColdFusion.navigate('ServiceLineForm.cfm?openmode=dialog&tabno=#url.tabno#&systemfunctionid=#url.systemfunctionid#&workorderid=#url.workorderid#&workorderline=#url.workorderline#&mode=save','submitbox','','','POST','customform')")>
					
				</td>
			</tr>
			
			<tr><td id="submitbox"></td></tr>
					
		</cfoutput>
		
		</td></tr>
		
		</table>
		
	</cfform>
		
</td>
</tr>
</table>	

