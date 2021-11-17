
<cfquery name="Parameter" 
    datasource="AppsWorkOrder" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
        SELECT TOP 1 * 
        FROM  Ref_ParameterMission
</cfquery>

<cfparam name="URL.Mission" default="#Parameter.Mission#"> 

<cfif URL.Mission eq "">
	<cfset URL.Mission = Parameter.Mission>
</cfif>

<cfquery name="Get" 
	datasource="appsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   Wo.*, 	
	         SI.Description   AS ServiceItemDescription, 		
			 SI.ServiceMode,	
			 C.OrgUnit,
			 C.CustomerName   AS CustomerName, 
             C.Reference      AS CustomerReference, 
			 C.PhoneNumber    AS CustomerPhoneNo,
			 SI.EnableOrgUnitWorkOrder
    FROM     WorkOrder Wo 
	         INNER JOIN ServiceItem SI ON Wo.ServiceItem = SI.Code 
			 INNER JOIN Customer C ON Wo.CustomerId = C.CustomerId	
	WHERE    Wo.WorkOrderId = '#URL.workorderid#' 
</cfquery>	
		
<cfoutput>	

<cfset tmp = "WorkOrder/Application/WorkOrder/Invoice/WorkOrderInvoiceData.cfm"> 	

<cfform method="POST" name="workorderform" style="height:100%;width:100%">   	  

<cfif init eq "1">
<table width="95%" align="center">
<cfelse>
<table width="95%" align="center">

</cfif>

<!--- define access --->
	
<cfinvoke component = "Service.Access"  
   method           = "WorkorderProcessor" 
   mission          = "#get.mission#" 
   serviceitem      = "#get.serviceitem#"
   returnvariable   = "access">	
   	  
<cfif (get.recordcount eq "0") and (Access eq "EDIT" or Access eq "ALL")>
	
	<!--- entry mode is pending --->
			
<cfelse>	

	<tr><td colspan="2" style="padding-top:10px">
	<table width="100%" border="0" align="center">
	
	<!---				
	<tr>
		<td class="labellarge" style="padding-top:4px;height:40" colspan="2" align="left"><b>#get.CustomerName#</b></td>
	</tr>
	--->	
	
	<input type="hidden" name="workorderid" id="workorderid" value="#url.workorderid#">
	
	<tr class="labelmedium2">
		<td width="180"  style="padding-left:8px"><cf_tl id="Customer">:</td>
		<td>
		#get.CustomerName# #get.CustomerReference#
		</td>
	</tr>	

		
	<tr class="labelmedium2">
		<td width="180" height="22" style="padding-left:8px"><cf_tl id="Order">:</td>

		<td>
			
			  <table>
			   <tr>
			    <td style="padding-left:1px" class="labelmedium">#get.Mission# / #get.serviceitem# / #get.ServiceItemDescription#</b></td>
				<td class="labelmedium" style="padding-left:4px;padding-right:4px"><!--- <cf_tl id="under reference">:--->/</td>
				<td> <input type="text" name="Reference" value="#get.Reference#" size="13" maxlength="20" class="regularxxl"  onchange="ptoken.navigate('../Header/WorkorderHeaderSubmit.cfm?workorderid=#url.workorderid#','process','','','POST','workorderform')" >
				</td>
			   	<td align="right">
				
					<button 
						onclick="present('pdf','#tmp#');"
						class="button3" 
						type="button"
						alt"Print">
				    	<img src="#SESSION.root#/Images/Pdf.png" width="22" height="22" alt="Print" border="0" align="absmiddle">
				 	</button>	
														
				</td>
				<td id="bshow"></td>
			   </tr>
			  </table>
			  
		</td>
	</tr>
	
	<tr><td height="4"></td></tr>
	
	<!--- --------- ------>
	<!--- IMPLEMENTERS --->
	<!--- --------- ------>
		
	<cfif get.EnableOrgUnitWorkOrder eq 1>
	
		<tr>
			<td height="20" class="labelmedium" style="border:0px dotted c4c4c4;padding-left:8px"><cf_tl id="Implementer(s)">:<cf_space spaces="63"></td>
			<td width="80%" style="border:1px dotted c4c4c4;">
				<cf_securediv id="divImplementers" bind="url:../Implementer/Implementer.cfm?workOrderId=#get.workOrderId#">
			</td>
		</tr>
		
	</cfif>
	
	
	<cfif get.ServiceMode eq "WorkOrder">
	
		<tr><!---
		    <td class="labelmedium" valign="top" style="padding-top:3px;padding-left:8px"><cf_tl id="Progress">:</td>
			--->
		    <td style="padding:0px;" colspan="1"></td>
			<td style="padding-right:20px">					
			<cf_workorderlines workorderid="#get.workorderid#">			
			</td>
		</tr>
			
	<cfelse>
		
		<tr><td class="labelmedium" style="border:0px dotted c4c4c4;padding-left:8px"><cf_tl id="Details">:</td>
		
		<td style="border:0px dotted c4c4c4;">
		
		<table cellspacing="0" cellpadding="0">
		
		<tr>
		
		<cfquery name="Lines" 
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
		    FROM     WorkOrderLine Wo
			WHERE    Wo.WorkOrderId = '#URL.workorderid#' 
			AND      Wo.Operational = 1
			AND      Wo.DateEffective <= getDate() 
			AND     (Wo.DateExpiration >= getDate() or Wo.DateExpiration is NULL)
		</cfquery>	
		
			<td class="labelmedium" style="padding-left:3px"><cf_tl id="Active">:</td>
			<td class="labelmedium" style="padding-left:8px"><b>#Lines.Recordcount#</td>	
		
		<cfquery name="Expired" 
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
		    FROM     WorkOrderLine Wo
			WHERE    Wo.WorkOrderId = '#URL.workorderid#' 
			AND      Wo.Operational = 1
			AND      (Wo.DateExpiration < getDate()or Wo.DateEffective > getdate())
			
		</cfquery>	
			
			<td height="20" class="labelmedium" style="padding-left:8px"><cf_tl id="Expired">:</td>
			<td <td class="labelmedium" style="padding-left:8px"><b>		
			<cfif Expired.recordcount eq "0">None<cfelse><font color="FF0000">#Expired.Recordcount#</font></cfif></td>
			
			<cfquery name="Deactivated" 
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT   *
			    FROM     WorkOrderLine Wo
				WHERE    Wo.WorkOrderId = '#URL.workorderid#' 
				AND      Operational = 0		
		    </cfquery>	
		
			<td height="20" class="labelmedium" style="padding-left:8px"><cf_tl id="Deactivated">:</td>
			<td class="labelmedium" style="padding-left:8px"><b><cfif Deactivated.Recordcount eq "0"><cf_tl id="None"><cfelse><font color="FF0000">#Deactivated.Recordcount#</cfif></td>
			
			</tr>
			
		</table>
		
		</td>
		</tr>
		
	</cfif>					
		
	
	<cfquery name="Customer" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	    SELECT *
	    FROM  Customer
		WHERE CustomerId = '#get.customerid#'	
	</cfquery>
	
	<cfif customer.orgunit eq "">
	
		<cfset access = "ALL">
	
	<cfelse>
	
		<!--- define access --->
	
		<cfinvoke component = "Service.Access"  
		   method           = "WorkorderProcessor" 
		   mission          = "#get.mission#" 
		   serviceitem      = "#get.serviceitem#"
		   returnvariable   = "access">	
		   
	</cfif>	 
	
	<cfquery name="total" 
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
		    FROM     WorkOrderLine Wo
			WHERE    Wo.WorkOrderId = '#URL.workorderid#' 				
	</cfquery>	
	
	<cfquery name="check" 
			datasource="appsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
			SELECT   *
		    FROM     WorkOrderLine Wo
			WHERE    Wo.WorkOrderId = '#URL.workorderid#' 
			AND      Wo.Operational = 1			
		</cfquery>	
	
	<cfif (total.recordcount gte "1" and check.recordcount eq "0" and access eq "ALL") 
	    or (total.recordcount eq "0" and (access eq "EDIT" or access eq "ALL"))>
	
	
		<tr>
			<td height="20" style="font-family: Verdana; color: 002350;"></td>
			<td height="40" id="action">
			<cf_tl id="Delete" var="tDelete">
			<input type="button" name="Delete" id="Delete" class="button10g" value="#tDelete#" onclick="deleteorder('#url.workorderid#')">
			</td>
		</tr>
	
	</cfif>
		
				
	<cfquery name="Param" 
	  datasource="AppsWorkOrder" 
	  username="#SESSION.login#" 
	  password="#SESSION.dbpw#">
	      SELECT *
	      FROM Ref_ParameterMission
	   	  WHERE Mission = '#get.Mission#' 	 
	</cfquery>
	
	<!--- entry for fund control --->
	
	<cfinvoke component = "Service.Access"  
	   method           = "WorkorderFunder" 
	   mission          = "#param.TreeCustomer#" 
	   orgunit          = "#get.OrgUnit#"
	   serviceitem      = "#get.serviceitem#"
	   returnvariable   = "accessfunder">	
	  
	<cfif accessFunder eq "EDIT" or accessFunder eq "ALL">
				
		<tr>
			<td height="20" valign="top" style="padding-top:4px;padding-left:8px;border:0px dotted c4c4c4;" class="labelmedium"><cf_tl id="Accounting">:</td>
			<td style="border:0px dotted c4c4c4;">		
			<cfinclude template="../GLedger/GLedger.cfm">				
			</td>
		</tr>
			
						
		<!--- summarise billing info per year only for service order --->
		
		<cfif get.ServiceMode neq "WorkOrder">
		
		<tr>
			<td class="labelmedium" valign="top" style="border:0px dotted c4c4c4;padding-top:3px;height:30;padding-left:8px"><cf_tl id="Charges">:</td>
			<td width="80%" height="22" id="billingsummary" colspan="2">
			<cfinclude template="../ServiceDetails/Charges/ChargesWorkorder.cfm">
			</td>
		</tr>
		
		<!--- --------- --->
		<!--- THRESHOLD --->
		<!--- --------- --->
				
		<tr>
			<td class="labelit" align="right" style="height:40;padding-right:10px"><cf_tl id="Charge threshold">:</td>
			<td width="80%">
			<cfinclude template="../Threshold/ThresholdGet.cfm">		
			</td>
		</tr>	
		
		</cfif>
						
	</cfif>	
	
	<tr><td height="4"></td></tr>
	
	<tr>
			<td class="labelmedium" style="padding-left:8px;padding-top: 1px;"
			    valign="top"><cf_tl id="Memo">:</td>
			<td>
			
			<textarea name="Ordermemo"
			  onchange="ColdFusion.navigate('../Header/WorkorderHeaderSubmit.cfm?workorderid=#url.workorderid#','process','','','POST','workorderform')" 
			  class="regular" 
			  style="background-color:ffffff;border-radius:4px:border:1px solid c4c4c4;font-size:14px;padding:4px;width:100%;height:55">#get.Ordermemo#</textarea>
			</td>
	</tr>
		
		
					
	<tr>
	   <td height="25" valign="top" class="labelmedium" style="padding-top:3px;border:0px dotted c4c4c4;padding-left:8px"><cf_tl id="Attachments">:</td>
	   <td>
	   	   
		<cf_filelibraryN
			DocumentPath="Workorder"
			SubDirectory="#URL.workorderid#" 
			Filter=""
			width="100%"
			Insert="yes"
			Remove="yes"
			reload="true">	
	   
	   </td>
   </tr>

</cfif>
  
<tr><td id="process"></td></tr>
</table>

</td></tr>

</table>
 	
</cfform>   

</cfoutput>

