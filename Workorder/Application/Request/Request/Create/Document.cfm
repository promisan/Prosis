
<cfparam name="url.drillid"       default="">
<cfparam name="url.requestid"     default="#url.drillid#">
<cfparam name="url.requestline"   default="1">
<cfparam name="url.domain"        default="">
<cfparam name="url.workorderid"   default="">
<cfparam name="url.workorderline" default="">
<cfparam name="url.mode"          default="edit">
<cfparam name="url.billingid"     default="">
<cfparam name="url.scope"         default="backoffice">  <!--- portal or backoffice scope --->

<!--- validate if indeed a request can be made --->

<cfif url.workorderid neq "" and url.workorderline neq "">

	<cfquery name="get" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		SELECT   *
	     FROM    WorkOrderLine 		 
		 WHERE   WorkOrderId   = '#url.workorderid#'
		 AND     WorkorderLine = '#url.workorderline#'					 
	</cfquery>

	<cfquery name="Expiration" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">	
		SELECT   *
	     FROM    WorkOrderLine 		 
		 WHERE   WorkOrderId   = '#url.workorderid#'
		 AND     WorkorderLine = '#url.workorderline#'			
		 AND     DateExpiration <= getDate()		 
	</cfquery>
					
	<cfquery name="Children" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
	
		SELECT   WO.*, 
		         P.IndexNo AS IndexNo, 
				 P.LastName AS LastName, 
				 P.FirstName AS FirstName,
				 P.Nationality,
				 P.Gender				
				 
	     FROM    WorkOrderLine WO LEFT OUTER JOIN
		         Employee.dbo.Person P ON WO.PersonNo = P.PersonNo				 
		 WHERE   WO.ParentWorkOrderId   = '#url.workorderid#'
		 AND     WO.ParentWorkorderLine = '#url.workorderline#'			
	</cfquery>
	
	<cfif children.recordcount eq "0" and Expiration.recordcount eq "0" and get.Operational eq "1">
	
	<cfelse>
	
		<cf_screentop html="No">
	
		<table width="100%"><tr><td style="height:200" class="labellarge" 
		    align="center"><font color="FF0000">Problem, the line underlying this request is not active anymore. Please refresh you screen</font></td></tr>
		</table>
		
		<cfabort>
	
	</cfif>

</cfif>


<cfquery name="Domain" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ServiceItemDomain
	WHERE  Code = '#url.domain#'	
</cfquery>

<cfif url.requestid eq "">

	<cf_screentop height="100%" 
			  layout="webapp" 
			  label="New Request #domain.description#" 
			  banner="red"	  			  
			  scroll="Yes" 
			  jquery="Yes"
			  line="no"
			  html="Yes">

<cfelse>
	
	<cfquery name="Request" 
		datasource="AppsWorkOrder" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Request		
			WHERE  RequestId = '#url.requestid#'						
	</cfquery>
	
	<cfset url.mission = request.mission>
	
	<cfif Request.DomainReference neq "">
	
		<cfquery name="Format" 
		datasource="appsWorkOrder"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_ServiceItemDomain
			WHERE  Code = '#Request.serviceDomain#'			
	   </cfquery>
   
	   <cfif format.displayformat eq "">
			<cfset val = Request.DomainReference>
		<cfelse>
		    <cf_stringtoformat value="#Request.DomainReference#" format="#format.DisplayFormat#">						
		</cfif>
	
	    <cfset lbl = "rfs: #Request.Reference# for #val#">
		
	<cfelse>
	
		<cfquery name="Reference" 
			datasource="AppsWorkOrder" 
			username="#SESSION.login#" 
			password="#SESSION.dbpw#">
				SELECT  W.Reference
				FROM    RequestWorkOrder R, WorkOrderLine W
				WHERE   R.RequestId    = '#url.requestid#'	
				AND     R.Workorderid   = W.WorkOrderid
				AND     R.WorkorderLine = W.WorkOrderLine 					
		</cfquery>
		
		<cfquery name="Format" 
		datasource="appsWorkOrder"
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT *
			FROM   Ref_ServiceItemDomain
			WHERE  Code = '#Request.serviceDomain#'			
	   </cfquery>
   
	   <cfif format.displayformat eq "">
			<cfset val = Reference.Reference>
		<cfelse>
		    <cf_stringtoformat value="#Reference.Reference#" format="#format.DisplayFormat#">						
		</cfif>
		
	    <cfset lbl = "rfs: #Request.Reference# #val#">
		
	</cfif>
		
		<cf_screentop height="100%" layout="webapp" 
			banner="gray"
			label="#lbl#" 	
			option="#Format.description#" 		
			jquery="Yes"
			scroll="Yes" 
			html="Yes">	

</cfif>

<cf_calendarscript>
<cf_dialogstaffing>
<cf_dialogWorkorder>
<cf_FileLibraryScript>
<cf_menuscript>
<cf_actionListingScript>

<cfoutput><script type="text/javascript" src="#SESSION.root#/Scripts/jQuery/jquery.js"></script></cfoutput>				

<cfinclude template="../../../WorkOrder/ServiceDetails/Billing/DetailBillingFormScript.cfm">

<!--- ---------------------------------------------------------- --->
<!--- hide/show dependent on the type of the request isAmendment --->
<!--- ---------------------------------------------------------- --->

<cfoutput>

	<script language="JavaScript">
	
	    // added to filter on the fly for the selected devices 
	
	    function captureprovision() {
	
			var vdata = $(".provision:visible");		
			var l_units   = '';
			
			$(vdata).each(function() {	
				
				 if ($(this).attr("type") == 'checkbox' ) {
				 	if ($(this).is(':checked'))
					 l_units = l_units + '|' + $(this).val();
				 } else
					 l_units = l_units + '|' +  $(this).val();
			});		
			
			if (l_units != "") {
			   document.getElementById("Provisioning").value = l_units							
			}   
	    }		
	
	    function ask(id) {
			
			if (confirm("Remove this request. This action can not be reversed?")) {
			    ColdFusion.navigate('DocumentSubmit.cfm?action=delete&requestid='+id,'formcontent')
				return true 			
			}		
			return false	
			
	    }	
		
		function loadrequesttype(mode) {  	 	   
		   itm = document.getElementById("serviceitem").value   		  
		   ColdFusion.navigate('#SESSION.root#/WorkOrder/Application/Request/Request/Create/DocumentRequestType.cfm?scope=#url.scope#&requestid=#url.requestid#&serviceitem='+itm+'&accessmode='+mode+'&workorderid=#url.workorderid#','boxrequesttype')     	  
		}
		
		function loadcustomform(reqid,tpe,itm,mode,wid,act) { 			 
		   ColdFusion.navigate('#SESSION.root#/WorkOrder/Application/Request/Request/Templates/SelectFormCustom.cfm?scope=#url.scope#&mission=#url.mission#&accessmode='+mode+'&requestid='+reqid+'&requesttype='+tpe+'&serviceitem='+itm+'&workorderlineid='+wid+'&RequestAction='+act,'processdetails')    
		}
			
	</script>

</cfoutput>

<cfajaximport tags="cfwindow,cfdiv,cfform,cfinput-datefield">

<table width="100%" height="100%" bgcolor="fffffe">

	<tr class="hide"><td id="processdetails"></td></tr>
	<tr class="hide"><td id="ajaxbox"></td></tr>
	<tr><td height="4"></td></tr>
	<tr>
		<td valign="top" id="formcontent" style="padding:8px">
		    <cfif url.requestid eq "">
				<cfinclude template="DocumentForm.cfm">
			<cfelse>	
				<cfinclude template="DocumentEdit.cfm">
			</cfif>
		</td>
	</tr>
	
</table>

