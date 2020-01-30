
<cfparam name="url.ID1" default="">
<cfparam name="url.requestId" default="">

<cfset url.requestId = url.ID1>

<cfif url.requestId neq "">

	
	<cfquery name="qRequest" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT PR.*,E.Description AS EventDescription,PEM.Instruction, TRI.Description TriggerDescription
		 FROM PersonRequest PR INNER JOIN Ref_PersonEvent E
		 ON E.Code = PR.EventCode INNER JOIN Ref_PersonEventMission PEM
		 ON PEM.PersonEvent = E.Code INNER JOIN Ref_PersonEventTrigger ET
		 ON ET.EventCode= E.Code INNER JOIN Ref_EventTrigger TRI
		 ON TRI.Code = ET.EventTrigger 
		 WHERE PEM.EnablePortal = '1'
		 AND PR.RequestId = '#URL.RequestId#'
		 ORDER BY PR.Created		
	</cfquery>
<cfelse>
	<cfquery name="qRequest" 
	datasource="AppsEmployee" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT PR.*,E.Description AS EventDescription,PEM.Instruction, TRI.Description TriggerDescription
		 FROM PersonRequest PR INNER JOIN Ref_PersonEvent E
		 ON E.Code = PR.EventCode INNER JOIN Ref_PersonEventMission PEM
		 ON PEM.PersonEvent = E.Code INNER JOIN Ref_PersonEventTrigger ET
		 ON ET.EventCode= E.Code INNER JOIN Ref_EventTrigger TRI
		 ON TRI.Code = ET.EventTrigger 
		 WHERE PEM.EnablePortal = '1'
		 AND 1 = 0
		 ORDER BY PR.Created		
	</cfquery>
</cfif>

<cfset mission = "">
<cf_verifyOnBoard PersonNo = "#URL.ID#">

<cfif mission neq "">
	
	
	<cfset url.mission = mission>

	<cfoutput>
	<cfform name="requestform" onsubmit="return false">
	
	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
	
	  <tr><td id="requestprocess"></td></tr>
	  <tr><td style="border:0px dotted silver;padding:2px">
	  	
		<input type="hidden" name="mission"  id="mission"  value="#URL.Mission#" class="regular">
		<input type="hidden" name="PersonNo" id="PersonNo" value="#URL.ID#" class="regular">
		
		<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		
	      <tr><td height="5" colspan="4"></td></tr>
		  <tr>
		    <td align="left" colspan="4" valign="bottom" class="labellarge" style="height:70px;font-size:28px;padding-bottom:3px">
			<cfoutput>
                <img src="#SESSION.root#/images/Contact-HR.png" height="50" width="50" align="absmiddle" alt="" border="0"  style="float: left; padding-right: 10px;">&nbsp;
                <h1 style="float:left;color:##333333;font-size:28px;font-weight:200;padding:0;position: relative;top: 5px;"><strong>New</strong> Request</h1>
			</cfoutput>
		    </td>
				    
		  </tr> 
		  
		  <tr class="line"><td height="4" colspan="4"></td></tr>	
		  <tr><td height="6"></td></tr>
		
		  <tr>
		  	<td>&nbsp;</td>
		    <td width="10%" class="labelmedium" style="padding-left:8px"><cf_tl id="Date">:</td>
		    <td width="80%">
		    	
		    	<cfif url.requestId neq "">
					<cf_intelliCalendarDate9
						FormName="requestform"
						class="regularxl enterastab"
						FieldName="DateEffective" 
						DateFormat="#APPLICATION.DateFormat#"
						message="Please enter an effective date"
						Default="#Dateformat(qRequest.RequestDate, CLIENT.DateFormatShow)#"	
				    	AllowBlank="False">
				<cfelse>
					<cf_intelliCalendarDate9
						FormName="requestform"
						class="regularxl enterastab"
						FieldName="DateEffective" 
						DateFormat="#APPLICATION.DateFormat#"
						message="Please enter an effective date"
						Default="#Dateformat(now(), CLIENT.DateFormatShow)#"	
				    	AllowBlank="False">				
				
				
				</cfif>
			</td>	
			<td>&nbsp;</td>	
		 </tr>	
		 
		  

	    <tr>
		  	<td></td>
		  	<td  class="labelmedium" style="padding-left:8px"><cf_tl id="Trigger">:</td>
			<td>
				<cfdiv bind="url:#session.root#/staffing/Portal/PersonRequest/getTrigger.cfm?RequestId=#URL.RequestId#&mission=#url.mission#"></cfdiv>	
			</td>		 
			<td></td>
		</tr>
		 
	    <tr>
		  	<td></td>
		  	<td  class="labelmedium" style="padding-left:8px"><cf_tl id="Condition">:</td>
		    <td style="padding-left:0px" id="dCondition">				
		    	<cfdiv bind="url:#session.root#/staffing/Portal/PersonRequest/getEvent.cfm?RequestId=#URL.RequestId#&mission=#url.mission#"></cfdiv>
			</td> 				

			<td></td>
		</tr>
		
		 <tr>
		  	<td>&nbsp;</td>
		    <td width="10%" class="labelmedium" style="padding-left:8px"><cf_tl id="Reference">:</td>
		    <td width="30%">
		
					  <input type="text" 
					       name="Reference" 
						   value="#qRequest.Reference#" 
						   class="regularxl"  
						   size="10"
						   maxlength="20">	
						   
					<input type="hidden" id="RequestId" name="RequestId" value="#qRequest.RequestId#">	
			</td>	
			<td>&nbsp;</td>	
		 </tr>	
	
		
		  <tr>
		  	<td></td>
		  	<td valign="top" class="labelmedium" style="padding-top:5px;padding-left:8px"><cf_tl id="Remarks">:</td>
		    <td class="labelmedium" style="padding-left:0px;height:20px">			  
			<textarea type="text" 
			      name  = "RequestMemo" 			   
			      id    = "RequestMemo"
				  class = "regular"  
				  style = "padding:3px;font-size:14px;width:100%;height:97" 
				  totlength = "500" 
				  onkeyup = "return ismaxlength(this)">#qRequest.RequestMemo#</textarea>				
				
		    </td>
			<td></td>
		</tr>
		
		
		
		</table>
		
		</td>
	  </tr>
	  
	  <cfif url.RequestId neq "">
	  	<tr>
	  		
	  		<td colspan="2">
				<cfset link = "Staffing/Application/Portal/PersonRequest/RequestEntry.cfm?id=#qRequest.PersonNo#&id1=#URL.RequestId#">

				<cfquery name="qPerson" 
				 datasource="AppsEmployee" 
				 username="#SESSION.login#" 
				 password="#SESSION.dbpw#">
				 	SELECT * 
				 	FROM Person
				 	WHERE PersonNo = '#qRequest.PersonNo#'
				</cfquery> 

			
			     <cf_ActionListing 
			         EntityCode       = "PersonRequest"
			           EntityClass      = "Standard"
			           EntityGroup      = ""
			           EntityStatus     = ""     
			           PersonNo         = "#qRequest.Personno#"
			           ObjectReference2 = "#qPerson.FirstName# #qPerson.LastName#" 
			           ObjectKey4       = "#URL.RequestId#"
			           AjaxId           = "#URL.Requestid#" 
			           ObjectURL        = "#link#"
			           Show             = "Yes">
	  		
	  		</td>
	  		
	  	</tr>
	  </cfif>
	  
	  <tr><td></td></tr>

		<tr><td class="line" colspan="2" align="center" style="padding-top:4px">
		
		   <cfoutput>
		   
		    <cf_tl id="Back" var="1">   
		
		   <input type    = "button" 
		          style   = "width:120" 
				  name    = "cancel" 
				  id      = "cancel" 
				  value   = "#lt_text#" 
		          class   = "button10g" 
			      onClick = "ColdFusion.navigate('#SESSION.root#/Staffing/Portal/PersonRequest/PersonRequestDetails.cfm?webapp=#url.webapp#&mode=edit&id=#url.id#','requests')">
			
		   <cf_tl id="Reset" var="1">  
		   		  
		   <input class   = "button10g" 
		          style   = "width:120" 
				  type    = "reset"  
				  name    = "Reset" 
				  id      = "Reset" 
				  value   = "#lt_text#">
		
		   <cf_tl id="Save" var="1"> 		  
		   
		   <input class   = "button10g" 
		          style   = "width:120" 
				  type    = "button" 
				  name    = "Submit" 
				  id      = "Submit" 
				  value   = "#lt_text#" 
				  onclick = "requestvalidate('#url.webapp#')">	 
		   
		   </cfoutput>
		   
	   </td>
	   </tr>  
	  
	  
	</table>  	
		
	
	</cfform>
	</cfoutput>
	
	<cfset ajaxonload("doCalendar")>

<cfelse>
	<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="formpadding">
	  <tr><td id="addressprocess"></td></tr>
	  <tr><td style="border:0px dotted silver;padding:2px">
		<table width="99%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
		
	      <tr><td height="5" colspan="4"></td></tr>
		  <tr>
		    <td align="left" colspan="4" bgcolor="eaeaea" valign="middle" class="labellarge" style="height:70px;font-size:18px;padding-bottom:3px">
			<cfoutput>
			    &nbsp;
			    <img src="#SESSION.root#/Images/flatwarning.png" height="48" border="0" align="absmiddle">
		    	&nbsp;<cf_tl id="Your profile is not entitled to request personnel actions"></b></font>
			</cfoutput>
		    </td>
		  </tr> 
		</table>
		</td>
	</tr>
  </table>		
</cfif>