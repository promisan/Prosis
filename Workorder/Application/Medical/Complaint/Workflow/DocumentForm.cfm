
<cfparam name="URL.drillid"       default="00000000-0000-0000-0000-000000000000">
<cfparam name="url.requestid"     default="#url.drillid#">

<cfparam name="url.requestline"   default="1">
<cfparam name="url.workorderid"   default="">
<cfparam name="url.workorderline" default="">
<cfparam name="url.domain"        default="Interaction">
<cfparam name="url.status"        default="">
<cfparam name="url.accessmode"    default="view">

<cfquery name="Request" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT * 
	FROM   Request	
	WHERE  Requestid = '#url.requestid#'		
</cfquery>

<cfquery name="Parameter" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM   Ref_ParameterMission
	WHERE  Mission = '#Request.mission#'	
</cfquery>

<cfquery name="RequestLine" 
	datasource="AppsWorkOrder" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT ValueFrom as Serviceitem
		FROM   RequestWorkorderDetail
		WHERE  Amendment = 'ServiceItem'
		<cfif url.requestid eq "">
		AND 1=0
		<cfelse>
		AND  Requestid   = '#url.requestid#'
		</cfif>		
</cfquery>

<!--- support this as at some point users can no longer edit it based on the actionstatus of the request 
    after it is applied into a workorder line --->
	

<!--- ------- --->


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
			   A.EmailAddress,
			   A.PersonNo
	FROM       Customer AS C INNER JOIN
               Applicant.dbo.Applicant AS A ON C.PersonNo = A.PersonNo
	WHERE      CustomerId = '#Request.customerid#'	
</cfquery>

<cf_actionlistingscript>
<cf_dialogstaffing>
		
<cfoutput>

<cf_tl id="Request for Appointment" var="1">

<cf_screentop jquery="Yes" html="Yes" layout="webapp" banner="gray" label="#lt_text#">

<cf_divscroll>

	<table width="94%" align="center" cellspacing="0" cellpadding="0" class="formpadding formspacing">
		  
	   <tr><td colspan="4" id="process"></td></tr>
	   
	   <tr><td colspan="4">
	   
	   <cfoutput>
		<table width="100%"><tr>
		<td style="padding-left:16px" class="labellarge"><a href="javascript:ShowCandidate('#Customer.PersonNo#')"><font color="0080C0">#Customer.FirstName# #Customer.MiddleName# #Customer.LastName# #Customer.LastName2#</font></a></td>
		<td align="right" class="labellarge" style="padding-right:10px">#Customer.IndexNo#</td>
		</tr>
		</tr></table>	
		</cfoutput>
	   
	   </td></tr>
	 	 	   
	   <cfif Request.RequestDate eq "">
	   		<cfset dte = "#DateFormat(now(),CLIENT.DateFormatShow)#">
	   <cfelse>
	        <cfset dte = "#DateFormat(Request.RequestDate,CLIENT.DateFormatShow)#">
	   </cfif>
	   
	    <tr>			
			<td style="padding-left:16px" class="labelmedium"><cf_space spaces="60">
				<cf_tl id="Request Date">
			</td>			
			<td class="labelmedium">
			   #dateformat(dte,client.dateformatshow)#			
			</td>					  
		</tr>	
		
		<cfset url.mode = accessmode>
				
		<!--- the core of the core --->
		<cfinclude template="../Create/DocumentFormRequestType.cfm">				
			
			
		<!--- support the view mode here as well --->				
		<cfset url.inputclass = "regularxl">
		<cfset url.style      = "padding-left:16px">
		<cfinclude template="../Create/DocumentFormTopic.cfm">			
		
		<tr>			
			<td valign="top" style="padding-top:4px;padding-left:16px;padding-right:20px" class="labelmedium" colspan="2">				
				#Request.Memo#
			</td>				 
		</tr>	
		
		<!---				
			<tr>			
				<td colspan="2">
					  <table align="center" cellspacing="0" cellpadding="0" class="formspacing formpadding"
					  	<tr>				  	  
							 <td>
							 
							 <cf_tl id="Back" var="1">
							 <input type="button" id="entryadd" style="width:160;font-size:13px" value="#lt_text#" 
							   class="button10g"  
							   onClick="closeComplaint('#URL.owner#','#URL.id#')">  
							   
							 </td>		
							 						  	  
						   	 <cfif URL.requestId eq "00000000-0000-0000-0000-000000000000">
							 
						   	 	<td>					   	 		
						   	 		<cf_tl id="Save" var="1">
							 		<input type="button" id="entryadd" style="width:160;font-size:13px" value="#lt_text#" 
						       		class="button10g" onClick="updateTextArea();addComplaint('#URL.owner#','#URL.id#','#URL.mission#')">
							 	</td>
								
							 <cfelseif Request.ActionStatus eq 1>
							 
							  		<td>
							  			
							 			<cf_tl id="Delete" var="1">
							 			<input type="button" id="entryadd" style="width:160;font-size:13px" value="#lt_text#" 
						       			class="button10g"  
							   			onClick="deleteComplaint('#URL.owner#','#URL.requestId#')">						  
							 		</td>									
									
									<td>			
								  		<cf_tl id="Save" var="1">
							 			<input type="button" id="entryadd" style="width:160;font-size:13px" value="#lt_text#" 
						       			class="button10g"  
								   		onClick="updateTextArea();updateComplaint('#URL.owner#','#URL.requestId#')">
							 		</td>							  
							 </cfif>  
						</tr>
					   </table>
				</td>			
			</tr>	
		--->
				
		<cfif URL.requestId neq "00000000-0000-0000-0000-000000000000">
				<tr>
					<td colspan="2">
																
						<cfset wflnk = "../Create/DocumentWorkflow.cfm">
						   
						<input type="hidden" 
						    id="workflowlink_#URL.RequestId#" 
						    value="#wflnk#"> 
						 
						<cfdiv id="#URL.RequestId#" 
						  bind="url:#wflnk#?ajaxid=#URL.RequestId#"/>
						
					</td>	
				</tr>
		</cfif>		
						
	</table>

</cf_divscroll>

</cfoutput>
