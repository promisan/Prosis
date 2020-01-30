
<!--- workflow asset assignment --->
  
<cfquery name="Workorder" 
   datasource="AppsWorkOrder" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">
	 SELECT  TOP 1 *
     FROM    RequestWorkorder
	 WHERE   Requestid = '#object.ObjectkeyValue4#'	 
</cfquery>

<cfloop query = "WorkOrder">

    <cfif workorderidto eq "">
	
		<cfset url.workorderid   = workorderid>
		<cfset url.workorderline = workorderline>
	
	<cfelse>
	
		<cfset url.workorderid   = workorderidTo>
		<cfset url.workorderline = workorderlineTo>
		
	</cfif>		
			
	<cfquery name="get" 
	   datasource="AppsWorkOrder" 
	   username="#SESSION.login#" 
	   password="#SESSION.dbpw#">
		 SELECT  TOP 1 L.Reference, L.ServiceDomain
	     FROM    WorkorderLine L
		 WHERE   L.WorkorderId   = '#url.workorderid#'	 
		 AND     L.WorkorderLine = '#url.workorderline#'
	</cfquery>
	
	<cfquery name="Format" 
		datasource="AppsWorkOrder"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_ServiceItemDomain
			WHERE  Code = '#get.ServiceDomain#'			
	</cfquery>
					   
      <cfif Format.displayformat eq "">
		<cfset val = get.reference>
	  <cfelse>
	    <cf_stringtoformat value="#get.reference#" format="#Format.DisplayFormat#">						
      </cfif>

	<cfoutput>
	<script>
	   try {
	   document.getElementById('workflowcustomlabel').innerHTML = "<b><font face='Verdana' size='3'>#val#</font></b>"
	   } catch(e) {}
	</script>
	</cfoutput>
	
	<table width="97%" align="center">
	
	<tr><td height="10"></td></tr>
			
	<tr><td height="35">
	
		<table width="100%" cellspacing="0" cellpadding="0">
		<tr>
		
			<cfset wd = "26">
			<cfset ht = "26">	
								
			<cfset itm = 0>					
									
			<cfset itm = itm+1>		
			<cf_menutab item       = "#itm#" 
			            base       = "dialog"
			            iconsrc    = "Logos/Workorder/General.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 
						class      = "highlight1"
						target     = "wfdialogbox"
						targetitem = "1"
						padding    = "2"
						name       = "General Information"
						source     = "#SESSION.root#/workorder/application/workorder/custom/Line.cfm?requestid=#object.ObjectkeyValue4#&tabno=contentwfdialogbox1&workorderid=#URL.workorderId#&workorderline=#url.workorderline#">			
											
			<cfset itm = itm+1>				
			<cf_menutab item       = "#itm#" 
			            base       = "dialog"
			            iconsrc    = "Logos/Workorder/Device.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 							
						padding    = "2"
						target     = "wfdialogbox"
						targetitem = "1"
						name       = "Provisioning and Equipment"
						source     = "#SESSION.root#/workorder/application/request/Request/Workflow/FullfillmentAssetDialog.cfm?workorderid=#URL.workorderId#&workorderline=#url.workorderline#&requestid=#object.ObjectkeyValue4#">		
							
			<cfset itm = itm+1>	
			<cf_menutab item       = "#itm#" 
			            base       = "dialog"
			            iconsrc    = "Logos/Workorder/Notes.png" 
						iconwidth  = "#wd#" 
						iconheight = "#ht#" 
						padding    = "2"
						target     = "wfdialogbox"
						targetitem = "2"
						name       = "Notes"
						source     = "#SESSION.root#/workorder/application/workorder/Memo/WorkorderLineMemo.cfm?containerId=contentwfdialogbox2&tabno=contentwfdialogbox2&workorderid=#URL.workorderId#&workorderline=#url.workorderline#">										
													
			<td width="20%"></td>	
				
		</tr>						
		</table>	
	</td>
	</tr>
	<tr><td height="2"></td></tr>
	<tr><td height="1" colspan="2" class="line"></td></tr>						
	<tr><td colspan="2" height="100%" valign="top">
			
		<table width="100%" height="100%">
						
			<cf_menucontainer item="1" class="regular" name="wfdialogbox">		
			     <cfset url.tabno = "contentwfdialogbox1">	
				 <cfset url.requestid = object.ObjectkeyValue4>	
				 <cfinclude template="../../../WorkOrder/Custom/Line.cfm">
			</cf_menucontainer>		
			
			<cf_menucontainer item="2" class="hide" name="wfdialogbox">					
			
		</table>
		
	</td></tr>	
		
	</table>
		
</cfloop>