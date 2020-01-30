
<!--- Request for porting user select a different service item and then can select the service provisioning for the existing phone --->

<!--- select service --->

<cfquery name="From" 
   datasource="AppsWorkOrder" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	 SELECT  *
	 FROM    ServiceItem
	 WHERE   Code = '#url.serviceitem#'
</cfquery>

<cfquery name="ServiceItem" 
   datasource="AppsWorkOrder" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	 SELECT  *
	 FROM    ServiceItem
	 WHERE   ServiceDomain IN (SELECT ServiceDomain FROM ServiceItem WHERE Code = '#url.serviceitem#')
	 AND     Operational = 1
	 AND     Code IN (SELECT ServiceItem FROM ServiceItemMission WHERE Mission = '#url.mission#' and Operational = 1)
	 AND   Code != '#url.serviceitem#'
</cfquery>

<table width="100%" cellspacing="0" cellpadding="0">

<tr>
<td class="label"><cf_space spaces="40">Port&nbsp;service&nbsp;</td>

<td width="90%">

	<table cellspacing="0" cellpadding="0">
	<tr>
	<cfoutput>
	<td><font size="2" color="808080"> from: #From.Description#</td>
	<td>&nbsp;</td>
	</cfoutput>
	<td><font size="2" color="black">to:</td>
	<td>&nbsp;</td>
	<td style="padding-left:1px">
	
	    
		<cfquery name="Porting" 
		   datasource="AppsWorkOrder" 
		   username="#SESSION.login#" 
		   password="#SESSION.dbpw#">
			SELECT   RequestId, WorkOrderId, WorkOrderLine, Amendment, ValueFrom, ValueTo, Created
			FROM     RequestWorkOrderDetail
			<cfif url.requestid eq "">
			WHERE    1 = 0
			<cfelse>
			WHERE    RequestId = '#url.requestid#'
			</cfif>
			AND      Amendment = 'ServiceItem'
			</cfquery>
			
	   <cfif accessmode eq "Edit">
	
			<cfoutput>
			<select name="ServiceItemTo" id="ServiceItemTo"
		        style="font-size: 19px; color:black"
		        onChange="ColdFusion.navigate('../../../WorkOrder/ServiceDetails/Billing/DetailBillingFormEntry.cfm?mode=request&requesttype=#url.requesttype#&requestaction=#url.requestaction#&requestid=#url.requestid#&mission=#url.mission#&serviceitem='+this.value+'&date='+document.getElementById('dateeffective').value,'porting')">
				<cfloop query="ServiceItem"><option value="#Code#"<cfif Porting.Valueto eq code>Selected</cfif>>#Description#</option></cfloop>
			</select>
			</cfoutput>
		
		<cfelse>		
							
			<cfquery name="ServiceItem" 
			   datasource="AppsWorkOrder" 
			   username="#SESSION.login#" 
			   password="#SESSION.dbpw#">
				 SELECT  *
				 FROM    ServiceItem
				 WHERE   Code = '#Porting.Valueto#'	
			</cfquery>
	
			<cfoutput><font size="2" color="black">#serviceitem.description#</cfoutput>
			
		
		</cfif>
	
	</td>
	</tr>	
	</table>
</td>
</tr>

<tr><td height="3"></td></tr>

<tr><td colspan="2" id="porting">

   <cfset url.mode = "request">
   <cfif Porting.ValueTo neq "">
	   <cfset url.serviceitem = Porting.ValueTo>
   <cfelse>
       <cfset url.serviceitem = ServiceItem.Code>
   </cfif>	 
   
   <cfset url.date = dateformat(now(),CLIENT.DateFormatShow)>   
   <cfinclude template="../../../WorkOrder/ServiceDetails/Billing/DetailBillingFormEntry.cfm"></td>
</tr>

<tr><td colspan="2" class="line"></td></tr>
<tr><td height="4"></td></tr>
	<tr><td colspan="2" style="padding-left:1px"><cfinclude template="RequestDevice.cfm"></td></tr>    
</table>


<!--- show the entry screen for the service --->