
<!--- Main view of a contact
	
--->

<cfquery name="Action"
   datasource="AppsWorkOrder" 
   username="#SESSION.login#"
   password="#SESSION.dbpw#">   
   
    SELECT   WL.WorkOrderId,
			 WL.WorkOrderLine,
			 WLA.WorkActionId,
			 R.Description, 
	         WLA.DateTimePlanning, 
			 WL.ServiceDomain, S.Description AS DomainClassDescription		 
			
    FROM     WorkOrderLineAction AS WLA INNER JOIN
             WorkOrderLine AS WL ON WLA.WorkOrderId = WL.WorkOrderId AND WLA.WorkOrderLine = WL.WorkOrderLine INNER JOIN
             Ref_Action AS R ON WLA.ActionClass = R.Code INNER JOIN
             Ref_ServiceItemDomainClass AS S ON WL.ServiceDomain = S.ServiceDomain AND WL.ServiceDomainClass = S.Code
    WHERE    WLA.WorkActionId = '#URL.DrillId#'
	
</cfquery>

<cfquery name="Workorder" 
   datasource="AppsWorkOrder" 
   username="#SESSION.login#"
   password="#SESSION.dbpw#">
	SELECT  *
	FROM    WorkOrder
	WHERE   WorkOrderId = '#Action.WorkOrderId#'
</cfquery>

<cfquery name="Schedule" 
   datasource="AppsWorkOrder" 
   username="#SESSION.login#"
   password="#SESSION.dbpw#">
	SELECT  *
	FROM    WorkPlanDetail
	WHERE   WorkActionId = '#URL.DrillId#'
</cfquery>

<cfquery name="customer" 
   datasource="AppsWorkOrder" 
   username="#SESSION.login#"
   password="#SESSION.dbpw#">   
    SELECT     A.IndexNo, 
	           A.Salutation, 
			   A.LastName, 
			   A.LastName2, 
			   A.MaidenName, 
			   A.FirstName, 
			   A.MiddleName, 
			   A.DOB,			   
			   A.EmailAddress
			   
	FROM       Customer AS C INNER JOIN
               Applicant.dbo.Applicant AS A ON C.PersonNo = A.PersonNo
	WHERE      CustomerId = '#workorder.customerid#'	
</cfquery>

<cfajaximport tags="cfchart,cfform,cfinput-datefield">
<cf_textareascript>	

<cf_tl id="Medical Encounter" var="1">

<cf_screentop scroll="no" html="no" label="#workorder.Mission# #lt_text#" jQuery="Yes" line="no" layout="webapp">
		
	<cf_menuscript>
	<cf_filelibraryscript>
	<cf_listingscript>
	
	<cf_DialogOrganization>
	<cf_actionlistingscript>
	<cf_presentationscript>
	<cf_LayoutScript>
		
	<!--- template to be set somewhere in the db 
	<script>
		function printPledge(id,template) {
			<cfoutput>
				ptoken.open("#SESSION.root#/Tools/CFReport/OpenReport.cfm?ts=#GetTickCount()#&template="+template+"&ID1="+id, "_blank", "left=60, top=60, width=800, height=600, toolbar=no, menubar=no, status=yes, scrollbars=no, resizable=yes");
			</cfoutput>
		}
	</script>
	
	--->
	
</head>

 
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>

<cf_layout attributeCollection="#attrib#">
	
	<!---
		
	<cf_layoutarea 
	   	position  = "header"
	   	name      = "reqtop"
	   	minsize	  = "50px"
		maxsize	  = "50px"
		size 	  = "50px">	
		
			<cf_ViewTopMenu label="#workorder.Mission# #lt_text#" menuaccess="context" background="blue">
						 			  
	</cf_layoutarea>		
	
	--->
		
	<cf_layoutarea position="center" name="box">
	
			<cf_divscroll style="height:99%">
			
			<table width="95%" height="100%">
			
			<cfoutput>
			
			<tr>
			    <td style="height:35;font-size:40px;padding-top:20px;padding-left:20px" class="labellarge">
				<table><tr><td>				
				 <img src="#SESSION.root#/images/logos/staffing/blue/appointment.png" height="75" border="0" align="absmiddle">    					
				 </td>
				 <td style="padding-left:20px;height:35;font-size:40px">
				 #WorkOrder.Mission# <cf_tl id="Medical Appointment">
				</td></tr>
				</table>
				</td>	    
			</tr>
			
			</cfoutput>
													
			<tr><td align="center" width="95%" style="padding-left:30px">
			
			    	<cf_divscroll style="height:99%">
					
					<table width="100%" 
					      border="0"						 
						  cellspacing="0" 
						  cellpadding="0" 				
					      bordercolor="d4d4d4" class="formpadding">
						  
						  <tr><td align="center" style="padding:20px" class="labellarge">
						  
						  <cfoutput>
						  
						  <table width="100%" height="100%" align="center" class="formpadding">
						  	  <tr>
							        <td class="labelmedium" style="width:20%"><cf_tl id="Name"> <cf_space spaces="40"></td>
							        <td class="labellarge">#customer.firstname# #customer.middlename# #customer.lastname# #customer.lastname2#</td>
							  </tr>
							  <tr>
							       <td class="labelmedium"><cf_tl id="DOB"></td>
							       <td class="labellarge">#dateformat(customer.dob,client.dateformatshow)#</td>
							   </tr>
							  <tr class="line"><td colspan="2"></td></tr>	
							  <tr class="labelmedium"><td>Request</td><td>XXXXX</td></tr>
							  <tr class="labelmedium"><td>Topic 1</td><td>XXXXX</td></tr>		
							  <tr class="labelmedium"><td>Topic 2</td><td>XXXXX</td></tr>		
							  <tr class="labelmedium"><td>Topic 3</td><td>XXXXX</td></tr>	
							  <tr class="line"><td colspan="2"></td></tr>	
							  <tr class="labelmedium"><td>Specialism</td><td>XXXXX</td></tr>	
							  <tr class="labelmedium"><td>Specialist</td><td>XXXXX</td></tr>	
							  <cfif schedule.recordcount eq "0">
							  <tr class="labelmedium">
							  <td><cf_tl id="Request for Appointment">:</td>
							  <td>#dateformat(Action.dateTimePlanning,client.dateformatshow)# #timeformat(Action.dateTimePlanning,"HH:MM")#
							  </tr>
							  <cfelse>
							  <tr class="labelmedium">
							  <td><cf_tl id="Appointment">:</td>
							  <td>#dateformat(Schedule.dateTimePlanning,client.dateformatshow)# #timeformat(Schedule.dateTimePlanning,"HH:MM")#</td>
							  </tr>
							  </cfif>	  
							  <tr class="labelmedium"><td>Completed</td><td>XXXXX</td></tr>	
							  <tr class="labelmedium"><td>Diagnoses</td><td style="height:100">????</td></tr>	
							  <tr class="labelmedium"><td>Topic 1</td><td style="height:100">????</td></tr>	
							  <tr class="labelmedium"><td>Topic 2</td><td style="height:100">????</td></tr>	
							  <tr class="line"><td colspan="2"></td></tr>	
							  <tr class="labelmedium"><td>Charges</td><td>XXXXX</td></tr>	
							  <tr class="labelmedium"><td>Billing</td><td>XXXXX</td></tr>
						  </table>
						  
						  </cfoutput>
						 
						  </td></tr>	  
						  							
							<!---							
							<cf_menucontainer item="1" class="regular">
								 <cfset url.contributionId = url.drillid>
								 <cfset url.action = "view">
							     <cfinclude template="ContributionViewGeneral.cfm">		
							<cf_menucontainer>		
							--->
							
					</table>
					
					</cf_divscroll>	
					  
					</td>
			</tr>			
				
		</table>
		
		</cf_divscroll>	
								
	</cf_layoutarea>		
	
	<cf_wfactive objectKeyValue4="#url.drillid#">
	
	<cfif wfexist eq "1">
	  
		<cf_layoutarea 
		    position      = "right" 
			name          = "commentbox" 
			maxsize       = "500" 		
			size          = "35%" 		
			minsize       = "360"
			initcollapsed = "false"
			collapsible   = "true" 
			splitter      = "true"
			overflow      = "scroll">
			
			<table width="100%" height="100%">
			<tr><td style="padding-top:10px" class="labellarge"><b><cf_tl id="Send us your message"></td></tr>
			<tr><td style="padding-top:4px">
			<cf_divscroll style="height:98%">
				<cf_commentlisting objectid="#url.drillid#"  ajax="No">		
			</cf_divscroll>
			</td></tr>
			</table>
						
								
		</cf_layoutarea>	
	
	</cfif>
		
</cf_layout>	



