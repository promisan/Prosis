<!--- Create Criteria string for query from data entered thru search form --->

<cf_screentop height="100%" html="no" layout="webapp" jquery="Yes" scroll="Yes" menuaccess="context" actionobject="Person"
		actionobjectkeyvalue1="#url.id#">
		
<cf_actionListingScript>
<cf_FileLibraryScript>	
<cf_dialogPosition>	

<cfinclude template="../Dependents/EmployeeDependentScript.cfm">

<cfajaximport tags="cfdiv,cfwindow">

<cfparam name="client.entitlementstatus" default="1">
<cfparam name="URL.Status" default="#client.entitlementstatus#">
<cfset client.entitlementstatus = url.status>

<cfoutput>

<cf_tl id="Do you want to remove this entitlement ?" var="deleteMsg">

<script language="JavaScript">

function entitlement(persno,indexno) {
    ptoken.location("EntitlementEntry.cfm?Status=1&systemfunctionid=#url.systemfunctionid#&ID=" + persno);
}

function entitlementtrigger(persno,indexno) {
    ptoken.location("EntitlementEntryTrigger.cfm?Status=1&systemfunctionid=#url.systemfunctionid#&ID=" + persno);
}

function dependentopen(personno,dep) {
    ptoken.location("../Dependents/DependentEdit.cfm?ID="+personno+"&ID1="+dep+"&action=entitlement");
}

function reloadForm(st) {
    Prosis.busy('yes')
    ptoken.location("EmployeeEntitlement.cfm?ID=#URL.ID#&Status=" + st);
}

function editamount(id,mde) {
    ptoken.open("EntitlementEdit.cfm?ID=#URL.ID#&ID1="+id+"&Status=#URL.Status#&systemfunctionid=#url.systemfunctionid#&accessmode="+mde+"&mode=backend", "_self", "left=80, top=80, width=560, height=500, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function edittrigger(id,mde) {
    ptoken.open("EntitlementEditTrigger.cfm?ID=#URL.ID#&ID1="+id+"&Status=#URL.Status#&accessmode="+mde+"&mode=backend&systemfunctionid=#url.systemfunctionid#", "_self", "left=80, top=80, width=560, height=500, toolbar=no, status=yes, scrollbars=no, resizable=no");
}

function deletetrigger(id) {
	if (confirm('#deleteMsg#')) {
		ptoken.navigate("EntitlementPurgeTrigger.cfm?ID=#URL.ID#&ID1="+id+"&Status=#URL.Status#&mode=&systemfunctionid=#url.systemfunctionid#",'process');
	}
}

function toggledays(id) {
     _cf_loadingtexthtml='';	
	 ptoken.navigate('setEntitlementSalaryDays.cfm?ID=#URL.ID#&ID1='+id, 'days_'+id);
}

function dependentedit(persno,depid,mode,ctr) {			
	 ptoken.location("#SESSION.root#/Staffing/Application/Employee/Dependents/DependentView.cfm?contractid="+ctr+"&action="+mode+"&ID="+persno+"&ID1="+depid)							
}	

function workflowdrill(key,box,mode) {
		
	    se = document.getElementById(box)
		ex = document.getElementById("exp"+key)
		co = document.getElementById("col"+key)
			
		if (se.className == "hide") {		
		   se.className = "regular" 		   
		   co.className = "regular"
		   ex.className = "hide"	
		   
		   ptoken.navigate('#SESSION.root#/Staffing/Application/Employee/Entitlement/EntitlementWorkflow.cfm?ajaxid='+key,key)		   		 
		} else {  se.className = "hide"
		          ex.className = "regular"
		   	      co.className = "hide" 
	    } 		
	}		

</script>

<cf_verifyOnBoard PersonNo="#url.id#">

<cfinvoke component="Service.Access"
	Method="PayrollOfficer"
	Role="PayrollOfficer"
	Mission="#mission#"
	ReturnVariable="PayrollAccess">		

</cfoutput>

<cf_tl id="Contract End" var="1">
<cfset vEoC="#lt_text#">

<cf_tl id="Contract defined" var="1">
<cfset vCD="#lt_text#">

<cf_divscroll>

<table cellpadding="0" cellspacing="0" width="99%" align="center">

	<tr><td height="10" style="padding-top:3px;padding-left:7px">	
		  <cfset ctr      = "0">		
	      <cfset openmode = "open"> 
		  <cfinclude template="../PersonViewHeaderToggle.cfm">		  
		 </td>
	</tr>	
	
	<tr><td>

<cfquery name="getActiveSchedule" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT   *
	FROM     Employee.dbo.PersonContract
	WHERE    PersonNo = '#URL.ID#' 
	AND      ActionStatus IN ('0','1')
	AND      DateEffective <= getDate() 
	ORDER BY DateExpiration DESC	
</cfquery>


<cfif URL.Status eq "0" or URL.Status eq "5">
      <cfset condition = " 1=1 ">
<cfelseif URL.Status eq "1">
      <cfset condition = "(dateAdd(s,-1,dateAdd(d,1,L.DateExpiration)) > #now()# or L.DateExpiration is NULL)">
<cfelse>	
	  <cfset condition = "(dateAdd(s,-1,dateAdd(d,1,L.DateExpiration)) < #now()#)">
</cfif>

<cfset conditiondep = condition>

<!-- AND L.SalarySchedule = '#getActiveSchedule.SalarySchedule#' --->

<cfif URL.Status eq "0">
     <cfset condition = "L.Status IN ('0','1','2')">
<cfelseif URL.Status eq "1">
      <cfset condition = "(#condition# AND L.Status IN ('0','1','2'))">
<cfelseif URL.Status eq "2">
      <cfset condition = "(#condition# AND L.Status IN ('0','1','2'))">
<cfelseif URL.Status eq "5">
      <cfset condition = "(#condition# AND L.Status IN ('0','1','2','9'))">	  
<cfelseif URL.Status eq "9">	
      <cfset condition = "L.Status = '9' and L.ContractId is NULL">  
</cfif>


<!--- Query returning search results --->
<cfquery name="UpdateActiveContract" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE PersonEntitlement
	SET    Status = '2'
	WHERE  ContractId IN (SELECT ContractId 
	                      FROM   Employee.dbo.PersonContract
						  WHERE  PersonNo = '#URL.ID#' 
						  AND    ActionStatus != '9')
	AND    Status != '9'
	AND    PersonNo = '#URL.ID#'
</cfquery>

<cfquery name="UpdateInactiveContract" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	UPDATE PersonEntitlement
	SET    Status = '9'
	WHERE  ContractId IN (SELECT ContractId 
	                      FROM   Employee.dbo.PersonContract
						  WHERE  PersonNo = '#URL.ID#' 
						  AND    ActionStatus = '9')
	AND    Status != '9'
	AND    PersonNo = '#URL.ID#'
</cfquery>

<cfquery name="Search" 
datasource="AppsPayroll" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
	SELECT L.*, 
	
		     (SELECT ActionStatus 
		      FROM   Employee.dbo.PersonContract	
			  WHERE  ContractId = L.ContractId) as ContractStatus,
			  
			(SELECT TOP 1 ObjectKeyValue4 
			  FROM     Organization.dbo.OrganizationObject 
			  WHERE    (Objectid   = L.EntitlementId OR ObjectKeyValue4 = L.EntitlementId)
			  AND      EntityCode = 'EntEntitlement' 
			  AND      Operational = 1) as Workflow,		
			
	         R.PayrollItemName, 
		     PT.EnableAmount, 
		     PT.description as TriggerDescription,
		     PT.TriggerCondition,
		     PT.TriggerDependent,
			 PT.TriggerGroup,
			 (SELECT EntitlementName
			  FROM   Ref_PayrollTriggerGroup
			  WHERE  SalaryTrigger    = L.SalaryTrigger
			  AND    EntitlementGroup = L.EntitlementGroup) as TriggerGroupName
	
	FROM     PersonEntitlement L LEFT OUTER JOIN
             Ref_PayrollItem R ON L.PayrollItem = R.PayrollItem LEFT OUTER JOIN
             Ref_PayrollTrigger PT ON L.SalaryTrigger = PT.SalaryTrigger
	    
	WHERE    L.PersonNo = '#URL.ID#' 
	AND      #preservesingleQuotes(condition)# 	
	ORDER BY L.EntitlementClass DESC, 
	         L.SalaryTrigger, 
			 R.PayrollItemName, 
			 L.DependentId,
			 L.DateEffective,
			 L.DateExpiration
	
	
	
</cfquery>

<table width="97%" align="center" border="0" cellspacing="0" cellpadding="0">

<tr><td>	
	
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="navigation_table">
  <tr class="labelit">
    <cfoutput>
    <td style="padding:10px 10px 10px;width:20">
		    <img src="<cfoutput>#SESSION.root#</cfoutput>/Images/Logos/Payroll/Entitlement.png" height="64" alt=""  border="0" align="absmiddle">
	</td>
	
	<td width="90%" colspan="3" valign="middle" style="font-weight:200;font-size:31px;padding-bottom:0px"><cf_tl id="Financial Entitlements"></td>
	</tr>
	
	<tr>
	
	<td style="padding-left:20px" colspan="3">	
	    <table style="border:0px solid silver; background-color:f1f1f1">
		<tr class="labelmedium">		
		<td style="padding-left:4px"><INPUT type="radio" name="Status" class="radiol" value="1" onClick="reloadForm('1')" <cfif URL.Status eq "1">checked</cfif>></td>
		<td style="padding-left:3px" onClick="reloadForm('1')"><cfif URL.Status eq "1"></cfif><cf_tl id="Valid">: #dateformat(now(),client.dateformatshow)#</td>
		<td style="padding-left:10px"><INPUT type="radio" name="Status" class="radiol" value="2" onClick="reloadForm('2')" <cfif URL.Status eq "2">checked</cfif>></td>
		<td style="padding-left:3px" onClick="reloadForm('2')"><cfif URL.Status eq "2"></cfif><cf_tl id="Valid expired"></td>
		<td style="padding-left:10px"><input type="radio" name="Status" class="radiol" value="0" onClick="reloadForm('0')" <cfif URL.Status eq "0">checked</cfif>></td>
		<td style="padding-left:3px" onClick="reloadForm('0')"><cfif URL.Status eq "0"></cfif><cf_tl id="Valid all"></td>		
		<td style="padding-left:10px">|</td>
		<td style="padding-left:10px"><INPUT type="radio" name="Status" class="radiol" value="9" onClick="reloadForm('9')" <cfif URL.Status eq "9">checked</cfif>></td>
		<td style="padding-left:3px" onClick="reloadForm('9')"><font color="FF0000"><cfif URL.Status eq "2"></cfif><cf_tl id="Cancelled"></td>
		<td style="padding-left:10px">|</td>
		<td style="padding-left:10px"><INPUT type="radio" name="Status" class="radiol" value="5" onClick="reloadForm('5')" <cfif URL.Status eq "5">checked</cfif>></td>
		<td style="padding-left:3px;padding-right:5px" onClick="reloadForm('5')"><cfif URL.Status eq "2"></cfif><cf_tl id="All"></td>
		</tr>
		</table>
	</td>
	
    <td align="right" valign="bottom" style="padding-bottom:5px"> 
	
		<cf_tl id="Add Rate based" var="1">
		<cfset vGeneric    = "#lt_text#">
	
		<cf_tl id="Add Individual" var="1">
		<cfset vIndividual = "#lt_text#">
		
		<table>
		<tr>
			<td><input type="button" value="#vGeneric#"  style="width:220px;height:26px;font-size:15px" class="button10g" onClick="entitlementtrigger('#URL.ID#','#URL.ID1#')"></td>
			<td style="padding-left:4px;padding-right:9px"><input type="button" style="width:230px;height:26px;font-size:15px" value="#vIndividual#" class="button10g" onClick="entitlement('#URL.ID#','#URL.ID1#')"></td>
		</tr>
		</table>
	
    </td>
	</cfoutput>
	
  </tr>
   
  <tr>
   
  <td width="100%" colspan="4" style="padding:10px">
  
  <table width="100%">
    	
	<TR height="18" class="line labelmedium2 fixrow">
    	<td width="1%" align="center"></td>
		<td width="1%" align="center"></td>
		<TD width="30%"><cf_tl id="Entitlement"></TD>
		<TD width="20%"><cf_tl id="Applies to"></TD>
		<td width="6%"><cf_tl id="Status"></td>
		<TD width="10%"><cf_tl id="Action"></TD>
    	<td style="min-width:90"><cf_tl id="Effective"></td>
		<TD style="min-width:90"><cf_tl id="Expiration"></TD>		
		<TD width="10%"><cf_tl id="Group"></TD>
		<TD width="5%"><cf_tl id="Days"></TD>
		<TD width="15%"><cf_tl id="Schedule"></TD>		
		<TD width="10%" align="right"><cf_tl id="Period"></TD>
		<TD width="20%" align="right" style="padding-right:4px"><cf_tl id="Amount"></TD>
	</TR>
	
<cfset last = '1'>

<cfif search.recordcount eq "0">

<tr class="labelmedium line">
<td colspan="12" align="center" style="padding:15px"><cf_tl id="There are no records to show in this view"></td>
</tr>

</cfif>

<cfset prior = "">

<cfoutput query="Search" group="EntitlementClass">

<tr class="line fixrow">
<td colspan="13" class="labelmedium" style="background-color:white;height:47px;padding-left:0px;font-size:21px">
	<cfif EntitlementClass eq "Rate"><cf_tl id="Rate based">
	<cfelseif EntitlementClass eq "Percentage"><cf_tl id="Percentage based">
	<cfelseif EntitlementClass eq "Amount"><cf_tl id="Individually calculated">
	</cfif>
</td>
</tr>

<cfoutput>

<cfif contractId neq "">
	<cfset cl = "f1f1f1">
<cfelseif status eq "0">	
    <cfset cl = "ffffcf">
<cfelseif status eq "9">
	<cfset cl = "FFB9B9">		
<cfelse>
    <cfset cl = "transparent">	
</cfif>


<TR style="height:22px" class="labelmedium2 line navigation_row" bgcolor="#cl#">

	<cfif workflow neq "">
 
	 <td  align="center" 
			style="cursor:pointer;padding-left:4px" 
			onclick="workflowdrill('#workflow#','box_#workflow#')" >
			
		<cf_wfActive entitycode="EntEntitlement" objectkeyvalue4="#entitlementid#">	
		 
			<cfif wfStatus eq "Open">
			
				  <img id="exp#Workflow#" 
			     class="hide" 
				 src="#SESSION.root#/Images/arrowright.gif" 
				 align="absmiddle" 
				 alt="Expand" 
				 height="9"
				 width="7"			
				 border="0"> 	
								 
			   <img id="col#Workflow#" 
			     class="regular" 
				 src="#SESSION.root#/Images/arrowdown.gif" 
				 align="absmiddle" 
				 height="10"
				 width="9"
				 alt="Hide" 			
				 border="0"> 
			
			<cfelse>
			
				   <img id="exp#Workflow#" 
			     class="regular" 
				 src="#SESSION.root#/Images/arrowright.gif" 
				 align="absmiddle" 
				 alt="Expand" 
				 height="9"
				 width="7"			
				 border="0"> 	
								 
			   <img id="col#Workflow#" 
			     class="hide" 
				 src="#SESSION.root#/Images/arrowdown.gif" 
				 align="absmiddle" 
				 height="10"
				 width="9"
				 alt="Hide" 			
				 border="0"> 
			
			</cfif>
			
			</td>
			
	<cfelse>
		
		<td height="28" align="center"></td>	
		  
	</cfif>	 
	
	<cfquery name="Action" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT    EAS.ActionDocumentNo, EAS.ActionStatus, EAS.ActionSourceId, EA.ActionSourceId as ParentSourceId
		FROM      Employee.dbo.EmployeeActionSource AS EAS INNER JOIN
                  Employee.dbo.EmployeeAction AS EA ON EAS.ActionDocumentNo = EA.ActionDocumentNo
		WHERE     EAS.ActionSource = 'Entitlement' AND EAS.ActionSourceId = '#Entitlementid#' AND EA.ActionStatus = '1'
		ORDER BY  EAS.ActionDocumentNo
	</cfquery>
				
	<td height="26">
	
			<cfif action.recordcount eq "0" or Action.ActionSourceid eq Action.ParentSourceId>
	
				<cfif status eq "2">
					<cfset mde = "edit">
				<cfelse>
					<cfset mde = "view">
				</cfif>
		
				<table>
					<tr>
						<td STYLE="padding-left:5px;WIDTH:15PX;padding-top:2px">
							<cfif ContractId eq "">	
								<cfif EntitlementClass eq "Amount">				
								   <cf_img icon="open" onClick="editamount('#EntitlementId#','#mde#')">				
								<cfelse>				
								   <cf_img icon="open" onClick="edittrigger('#EntitlementId#','#mde#')">						 
								</cfif>			
							</cfif>
						</td>
						<td style="width:15px padding-left:2px;padding-top:2px;padding-right:5px">
							<cfif Status eq "0">
								<cf_img icon="delete" onClick="deletetrigger('#EntitlementId#')">
							</cfif>
						</td>
					</tr>
				</table>
				
			</cfif>
	
	</td>	

	<TD style="padding-right:4px">

	<cfif EntitlementClass eq "Amount">#PayrollItemName#<cfelse>
    <cfif prior neq triggerdescription>#TriggerDescription#<cfelse>#TriggerDescription#<!---<img src="#client.root#/images/join.gif" alt="" border="0">---></cfif></cfif>
	 
	</TD>
	
	<TD width="20%">
	
	<cfif dependentid eq ""><cf_tl id="Staffmember"><cfelse>
	
	<!--- Query returning search results --->
		<cfquery name="Dependent" 
		datasource="AppsEmployee" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
			SELECT * FROM PersonDependent
			WHERE DependentId = '#dependentId#'	
		</cfquery>
		
		<cfif Dependent.ActionStatus eq "9">
		
			<!--- we do an effort obtain the active record of the dependent and if it not exist we correct it --->
			
			<cfset srcid = dependentId>
			
			<cfloop condition="#srcid# neq ''">
						
				<cfquery name="Dependent" 
				datasource="AppsEmployee" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT * 
					FROM   PersonDependent
					WHERE  SourceId  = '#srcid#'	
				</cfquery>
				
				<cfif dependent.actionStatus eq "">
				
					<cfset srcid = "">
				
					<font color="FF0000">
					
					<cfquery name="Dependent" 
					datasource="AppsEmployee" 
					username="#SESSION.login#" 
					password="#SESSION.dbpw#">
						SELECT * FROM PersonDependent
						WHERE DependentId = '#dependentId#'	
					</cfquery>
					
					#Dependent.FirstName# #Dependent.LastName#
					
					</font>
				
				<cfelseif dependent.actionStatus eq "9">
				 
				 	<cfset srcid = dependent.dependentId>
				
				<cfelse>
				
					<cfset srcid = "">
				
					<!--- current version --->
					<a href="javascript:dependentedit('#url.id#','#dependent.dependentid#','entitlement')"><font color="FF0000">#Dependent.FirstName# #Dependent.LastName#</font></a>!
											
				</cfif>
			
			</cfloop>
				
		<cfelse>
		
			<a href="javascript:dependentedit('#url.id#','#dependent.dependentid#','entitlement')">#Dependent.FirstName# #Dependent.LastName#</a>
						
		</cfif>
				
	</cfif>
	
	</TD>
	 
	<td style="padding-right:15px">
		
		<cfif ContractId eq "">	
			
			<cfif Status eq "9">
			   <font color="red"><cf_tl id="Cancelled">
			<cfelseif Status eq "2">
			   <cf_tl id="Approved">
		    <cfelse>
			   <font color="000080"><cf_tl id="Pending"></font>
		    </cfif>
		<cfelse>
		<cfif Status eq "9">
			  <font color="red"> <cf_tl id="Cancelled">
	    <cfelseif ContractStatus eq "1">
		       <cf_tl id="Approved"><cfelse><font color="red"><cf_tl id="Pending"></font>
	    </cfif>
		</cfif>	
		</a>
	</td>
	<td>
			
	<cfloop query="Action">
		<cfif ActionStatus eq "9"><font color="FF0000">#ActionDocumentNo#</font><cfelse><font color="black">#ActionDocumentNo#</font></cfif><cfif currentrow neq recordcount>&nbsp;|</cfif>		
	</cfloop>		
	
	</td>
	
	<cfif DateEffective gt DateExpiration and dateExpiration neq "">
		
		<td align="center" style="background-color:FEC5B8;padding-left:4px;padding-right:4px">#Dateformat(DateEffective, CLIENT.DateFormatShow)#</td>
		<td align="center" style="background-color:FEC5B8;padding-left:4px;padding-right:4px">
		  <cfif Dateformat(DateExpiration, CLIENT.DateFormatShow) eq ""><font color="808080">#vEoC#</font>
		  <cfelse>#Dateformat(DateExpiration, CLIENT.DateFormatShow)#
		  </cfif>
	    </td>
	
	<cfelse>
	
		<td align="center" style="padding-right:4px;padding-left:4px;">#Dateformat(DateEffective, CLIENT.DateFormatShow)#</td>
		<td align="center" style="padding-right:4px;padding-left:4px;">
		  <cfif Dateformat(DateExpiration, CLIENT.DateFormatShow) eq ""><font color="808080">#vEoC#</font>
		  <cfelse>#Dateformat(DateExpiration, CLIENT.DateFormatShow)#
		  </cfif>
		</td>
	
	</cfif>
	
	<TD style="padding-left:4px;padding-right:4px"><cfif TriggerGroupName eq "">#EntitlementGroup#<cfelse>#TriggerGroupName#</cfif></TD>
	<TD style="padding-right:4px;min-width:70px">
	<cfif PayrollAccess eq "EDIT" or PayrollAccess eq "ALL">
	<a href="javascript:toggledays('#EntitlementId#')" id="days_#EntitlementId#">
	   <cfif EntitlementSalaryDays eq "1"><cf_tl id="net days"><cfelse><cf_tl id="Default"></cfif>
	</a>
	<cfelse>
	<cfif EntitlementSalaryDays eq "1"><cf_tl id="net days"></cfif>
	</cfif>
	</TD>
	<TD style="padding-right:4px"><cfif SalarySchedule neq getActiveSchedule.SalarySchedule><font color="FF0000">#SalarySchedule#</font><cfelse>#SalarySchedule#</cfif></TD>
	<cfif EntitlementClass eq "Amount">
	<TD align="left"><cf_tl id="#Period#"></TD>
	<TD align="right" style="padding-right:4px;min-width:160px">
	<table style="width:100%"><tr><td style="padding-left:5px">#Currency#</td><td align="right">#NumberFormat(Amount, ",.__")#</td></tr></table>
	</TD>
	<cfelseif EnableAmount eq "1">
	<TD align="right"></TD>
	<TD align="right" style="padding-right:4px;min-width:160px">
	<table style="width:100%"><tr><td style="padding-left:5px">#Currency#</td><td align="right">#NumberFormat(Amount, ",.__")#</td></tr></table>
	</TD>
	<cfelseif ContractId neq "">
	<TD colspan="2" style="min-width:150px"><font color="800080">#vCD#</TD>
	<cfelse>
	<td colspan="2"></td>
	</cfif>
				
	<cfif TriggerCondition eq "Dependent" and (URL.Status eq "1" or URL.Status eq "0")>
			
		<cfquery name="Dependents" 
		datasource="AppsPayroll" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		    SELECT  P.DependentId, P.FirstName, P.LastName, P.DependentId, L.DateEffective, L.DateExpiration, L.Status
		    FROM    Employee.dbo.PersonDependent P INNER JOIN 
			        PersonDependentEntitlement L ON P.PersonNo = L.PersonNo and P.DependentId = L.DependentId
			WHERE   P.PersonNo = '#URL.ID#' 
			AND     P.ActionStatus IN ('0','1','2')
			AND     L.Status IN ('0','1','2')
			<cfif TriggerDependent eq "Insurance" or TriggerGroup eq "Insurance">			
			AND     L.SalaryTrigger IN (SELECT SalaryTrigger 
			                            FROM   Ref_PayrollTrigger 
										WHERE  TriggerGroup = 'Insurance')
			 											
			<cfelse>
			AND     ParentEntitlementId = '#entitlementid#' 
			</cfif>			
			AND    #preservesingleQuotes(conditiondep)#		
			ORDER BY L.DateEffective DESC
		</cfquery>		
		
		<cfif Dependents.recordcount gte "1">
		<tr style="border-bottom:1px solid silver;height:15px">
		<td></td>
		<td></td>
		<td colspan="12" style="padding-left:10px">
		<table><tr class="labelit"  style="height:15px">
		<cfloop query="Dependents">
				
			<cfif Status eq "2">
				<cfset cl = "DAEFF8">				
			<cfelse>
			    <cfset cl = "FDFEE0">
			</cfif>			
					
			<td bgcolor="#cl#" style="border-left:1px solid gray;padding-top:4px;padding-left:7px">
			<cf_img icon="select" onclick="dependentopen('#url.id#','#DependentId#')">				
			</td>	
			<TD style="min-width:100;padding-right:8px" bgcolor="#cl#"><a href="javascript:dependentopen('#url.id#','#DependentId#')">#FirstName# #LastName#</a></TD>				
			<TD bgcolor="#cl#" style="border-right:1px solid gray"><cfif status neq "2"><cf_tl id="Pending"></cfif></TD>														
					
		</cfloop>	
		</tr>
		</table>
		</td>
		</tr>
		</cfif>
	
	</cfif>

	<cfset prior = triggerdescription>
	
	<cfif workflow neq "">
		
			<input type="hidden" 
		       name="workflowlink_#workflow#" id="workflowlink_#workflow#" 		   
		       value="EntitlementWorkflow.cfm">			   		  
					   
			<tr id="box_#workflow#">
			
				    <td colspan="2"></td>
				 
				    <td colspan="11" id="#workflow#">
					
					<cfif wfstatus eq "open">
					
						<cfset url.ajaxid = workflow>					
						<cfinclude template="EntitlementWorkflow.cfm">
														
					</cfif>
				
				</td>
			
			</tr>
		
		</cfif>
	
</cfoutput>
</cfoutput>

</TABLE>

</td>
</tr>

</table>

<div id="process"></div>

</cf_divscroll>
