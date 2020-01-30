<!---
	DocumentEdit_Lines.cfm
	
	Handle the workflow steps section of the Request Edit page
	
	Included in: DocumentEdit.cfm
	Includes: DocumentEditCandidate_Action.cfm
	          DocumentEditCandidate.cfm
			  DocumentRotatingPersonList.cfm
	 
	Modification History
	15Oct03 - added code to handle TriggerStatus = "3" conditions
				i.e., deployed personnel that are associated to this Request Document
    25Apr04 - added code for requirement to allways allow attachment for Mil Send Request to PM and Request Medical Clearance steps 
	01May04 - refined 25Apr04 code to create UDF IsAllowDocAttach(actId) which reads (dummy) entries in FlowActionRule having 
			  RuleTriggerClass = 'Attach'. UDF returns true if actId sent matches rec in FlowActionRule. Return value
			  is used in test block right before call to cf_filelibrary.
	09Jun04 - added code to hide/display Add Nominee button. This is controlled by entries in the FlowActionRule table.
	11Jun04 - added code to hide/display Create CPD List button. This is controlled by entries in the FlowActionRule table.
	11Jun04 - added code to detect module (TRAVEL/VACANCY) and include/exclude code blocks as necessary (e.g., control button label
		      Add Candidate or Add Nominee.
	21Jan05 - commented out code that displays button Created CPD List when the workflow step has been completed.
--->	

<cfparam name="URL.IDCandList" default="ZoomIn">
<cfparam name="URL.ActionId" default="0">

<cfset CLIENT.RecordNo = 0>

<SCRIPT LANGUAGE = "JavaScript">

function batch(vacno,actionid)
{
	window.open("Template/DocumentEditCandidateBatch.cfm?DocumentNo=" + vacno + "&ActionId=" + actionid, "batchcandidate", "width=550, height=550, toolbar=no, scrollbars=yes, resizable=no");
}

function history(vacno,actid)
{
	window.open("Template/DocumentActionHistory.cfm?ID=" + vacno + "&ID1=" + actid, "documenthistory", "width=650, height=330, toolbar=no, scrollbars=yes, resizable=no");
}

function doit1(chk,field)
{if (chk == "")
  {document.documentedit.actiondateactual_1.value = "";}
 else {   
  document.documentedit.actiondateactual_1.value = document.documentedit.actiontoday.value;
  } 
}

function doit2(chk,field)
{
if (chk == "")
  {document.documentedit.actiondateactual_2.value = "";}
 else 
 {document.documentedit.actiondateactual_2.value = document.documentedit.actiontoday.value;} 
}

function doit3(chk,field)
{
if (chk == "")
  {document.documentedit.actiondateactual_3.value = "";}
 else 
 {document.documentedit.actiondateactual_3.value = document.documentedit.actiontoday.value;} 
}

function closing()
{
   window.close()
   opener.location.reload()
}

function ask()

{
	if (confirm("Do you want to submit the updated information ?")) {
	
	return true 
	
	}
	
	return false
}	

</SCRIPT>

<!--- Added 1 May 04 to check whether the Attach Document link should show or not --->
<cffunction name="IsAllowDocAttach">
	<cfargument name="actId">
	<cfquery name="ChkIsAllowDocAttach" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
		SELECT TOP 1 * FROM FlowActionRule WHERE ActionId = #actId# AND RuleTriggerClass = 'Attach'
	</cfquery>
	<cfreturn "#ChkIsAllowDocAttach.RecordCount#">
</cffunction>

<!--- Added 11 June 04 to check whether Create CPD List button should show or not --->
<cffunction name="IsShowCpdList">
	<cfargument name="actId">
	<cfquery name="ChkIsShowCpdList" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
		SELECT TOP 1 * FROM FlowActionRule WHERE ActionId = #actId# AND RuleTriggerClass = 'CpdList'
	</cfquery>
	<cfreturn "#ChkIsShowCpdList.RecordCount#">
</cffunction>

<!--- Added 11 June 04 to check whether current module is TRAVEL or VACANCY --->
<cffunction name="IsTravelModule">
	<cfargument name="dummyArg">
	<cfquery name="ChkIsTravelModule" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
		SELECT TOP 1 DocumentLibrary AS Name FROM Parameter
	</cfquery>
	<cfif #ChkIsTravelModule.Name# EQ "travel">
		<cfreturn "1">
	<cfelse>
		<cfreturn "0">	
	</cfif>
</cffunction>

<!--- Added 6 Dec 04 to check whether current user is allowed to add nominees --->
<cffunction name="IsNomineeAdder">
	<cfargument name="dummyArg">
	<cfquery name="ChkIsNomineeAdder" datasource="AppsOrganization" username="#SESSION.login#" password="#SESSION.dbpw#">
		SELECT TOP 1 AccessId FROM OrganizationAuthorization 
		WHERE UserAccount = '#SESSION.acc#'
		AND   Role = 'NomineeAdder'
		AND   AccessLevel = '1'
	</cfquery>
	<cfreturn "#ChkIsNomineeAdder.RecordCount#">
</cffunction>

<!--- Added 9 Jun 04 to find steps at the completion of which the ADD NOMINEE button should be switched on --->
<cfquery name="GetStepNomineeOn" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT ActionId AS StepNomineeOn FROM FlowActionRule 
	WHERE 	RuleTriggerClass = 'NomineeOn' 
	AND     Substring(RuleTemplate,1,1) = '#Get.ActionClass#'
</cfquery>

<cfquery name="GetStepNomineeOff" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT ActionId AS StepNomineeOff FROM FlowActionRule 
	WHERE 	RuleTriggerClass = 'NomineeOff' 
	AND     Substring(RuleTemplate,1,1) = '#Get.ActionClass#'
</cfquery>
	
<!--- Get latest completed/bypassed/not applicable workflow step for all ACTIVE candidates (regardless of person) --->
<!--- DocumentCandidateAction values: 1-Completed, 7-ByPassed, and 8-N/A. --->
<!--- DocumentCandidate is not 6-Stalled or 9-Revoked --->
<cfquery name="GetCandStepLatestCompleted" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT MAX(ActionId) as LastCompletedActionIdCand
    FROM DocumentCandidateAction CA INNER JOIN DocumentCandidate DC ON CA.PersonNo = DC.PersonNo
    WHERE CA.DocumentNo = '#URL.ID#'
	AND   CA.ActionStatus IN ('1','7','8')			
    AND   DC.Status <> '9' 							
	AND   DC.Status <> '6'
</cfquery> 

<!--- Get latest completed/bypassed/not applicable workflow step for document --->
<!--- DocumentAction values: 1-Completed, 7-ByPassed, and 8-N/A. --->
<cfquery name="GetDocStepLatestCompleted" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT MAX(ActionId) as LastCompletedActionIdDoc
    FROM DocumentAction DA 
	WHERE DA.DocumentNo = '#URL.ID#'
	AND   DA.ActionStatus IN ('1','7','8')
</cfquery> 

<!--- If any candidate-level completed/bypassed/NA steps ( for active candidates ),
	  use latest candidate-level step.  Else use latest completed doc-level step.
--->
<cfoutput query="GetCandStepLatestCompleted">
<cfif #GetCandStepLatestCompleted.RecordCount# EQ 1 AND #LastCompletedActionIdCand# NEQ "">
	<cfset LastCompletedActionId = #GetCandStepLatestCompleted.LastCompletedActionIdCand#>	
<cfelse>		
	<cfset LastCompletedActionId = #GetDocStepLatestCompleted.LastCompletedActionIdDoc#>
</cfif>
</cfoutput>
	
<!--- See if the LastCompletedWorkflowStep for any active candidate is within the proper range for switching on the AddNominee button flag --->
<cfif #LastCompletedActionId# GTE #GetStepNomineeOn.StepNomineeOn# 
  AND #LastCompletedActionId# LT #GetStepNomineeOff.StepNomineeOff#>
	<cfset ShowAddNomineeButton = 1>	
<cfelse>
	<cfset ShowAddNomineeButton = 0>
</cfif>
<!------------------------------------------ End of code added 9 June 04 ----------------------------------->

<!--- listing of the actions for a document, will be part of cfoutput below --->

<cfset vDocumentNo = URL.ID>
<cfinclude template="DocumentPreparation.cfm">

<cfset PriorOrder = 99999>

<!--- identify the actions that lies just before the current active action --->

<cfif #ActionCurrent.RecordCount# gt 0>

   <cfstoredproc procedure="spActionLinesPrior" 
   datasource="#CLIENT.Datasource#" 
   username="#SESSION.login#" 
   password="#SESSION.dbpw#">

      <cfprocparam type="In" 
      cfsqltype="CF_SQL_INTEGER" 
      dbvarname="@DOCUMENTNO" 
      value="#URL.ID#" null="No">

      <cfprocparam type="In" 
      cfsqltype="CF_SQL_INTEGER" 
      dbvarname="@ORDERNO" 
      value="#ActionCurrentFirst.ActionOrderSub#" null="No">

      <cfprocresult name="ActionCurrentPrior" resultset="1">

   </cfstoredproc>

   <cfif #ActionCurrentPrior.recordCount# neq 0>
       <cfif #ActionCurrentPrior.ActionOrderSub# neq "">
           <cfset PriorOrder = #ActionCurrentPrior.ActionOrderSub#>
       </cfif>
   </cfif>
  
</cfif>

<!--- identify next action to be performed for a candidate in general to enable the button --->

<cfif #ActionCandidateLast.ActionOrderSub# eq "">
   <cfset #lastOrderCandidate# = "0">
<cfelse>
   <cfset #lastOrderCandidate# = #ActionCandidateLast.ActionOrderSub#>
</cfif>

<cfquery name="ActionCandidateActionNext" 
datasource="#CLIENT.Datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT MIN(ActionOrderSub) as ActionOrderSub
FROM DocumentFlow VA
WHERE VA.ActionOrderSub > #lastOrderCandidate#
 AND  DocumentNo = '#URL.ID#'
 AND  VA.ActionLevel = '1' 
</cfquery>

<cfoutput>
  <input type="hidden" name="actiontoday" value="#Dateformat(now(), CLIENT.DateFormatShow)#" size="30" maxlength="30" class="disabled" readonly>
  <input type="hidden" name="undoactionid" value="">
<!---  <input type="hidden" name="selectionid" value="#ActionCurrent.ActionOrder#"> --->
  <input type="hidden" name="selprioractionid" value="#PriorOrder#"> 
</cfoutput>

<cfoutput query="action">

<!--- 11 June 04 - to pick appropriate label for add candidate/nominee button --->
<cfif IsTravelModule(1)>	
	<cfset AddButtonLabel = "Add nominee">	
<cfelse>
	<cfset AddButtonLabel = "Add candidate">
</cfif>

<!--- check access rights on line --->

<cfif show neq "0">

	<cfinvoke component="Service.Access"  
		          method="vacancy"  
				  document="#URL.ID#" 
				  actionid="#ActionId#"
				  source="#CLIENT.Datasource#"
				  check="ActionId"
				  returnvariable="access">
				  
<cfelse>
  
      <cfset #Access# = "NONE">				  
			  
</cfif>			  
			  			  
<cfif #access# eq "NONE">
  
   <!--- don't show anything here --->
   <cfif #lastOrderCandidate# lt #ActionOrderSub#>
    	<cfset show = "0">
   </cfif> 
	  
<cfelseif (#access# eq "EDIT" OR #access# eq "ALL") AND #ActionLevel# eq "0" AND #show# eq "1"
  AND ((#ActionCurrent.ActionOrder# eq "#ActionOrder#" AND #ActionStatus# is "0") OR (#ActionStatus# is "7"))>
   
   <cfset CLIENT.recordNo = #Client.recordNo# + 1>
   
   <tr><td height="1" colspan="10" class="top"></td></TR> 
   <tr><td height="4" colspan="10"></td></tr>
      
   <tr>		
   <td rowspan="2">&nbsp;  
   <cfif #ActionStatus# eq 0>
   <img src="../../Images/arrow.gif" alt="" id="arrow" width="15" height="15" border="0">
   <cfelse>
   <img src="../../Images/attention.gif" alt="" width="20" height="20" border="0">
   </cfif>
   </td>		
   <td></td>	
   <td colspan="1"  class="regularlist">
   	&nbsp;<b><a href="javascript:history('#documentno#','#actionid#')"><u>#ActionDescription#</u>
	</a></b>
   </td>
	
	<td>
	
	<cfswitch expression="#ActionLevelTrigger#">
	
	<cfcase value="1">
		<cfif IsTravelModule(1)>
			<cfif IsNomineeAdder(1)>
				<input type="button" class="button7" name="Add" value="#AddButtonLabel#" onClick="javascript:addcandidate(#URL.ID#)">
			</cfif>
		<cfelse>		
	   	    <input type="button" class="button7" name="Add" value="#AddButtonLabel#" onClick="javascript:addcandidate(#URL.ID#)">
		</cfif>			
	</cfcase>
	<cfcase value="2">
   	    <input type="button" class="button7" name="Add" value="#AddButtonLabel#" onClick="javascript:addcandidate(#URL.ID#)">
	</cfcase>
	<cfcase value="3">
	   	<input type="button" class="button7" name="Add" value="Identify rotating personnel" onClick="javascript:adddeployedperson(#URL.ID#)">
	</cfcase>

	<cfcase value="P">
		<cfif #get.ActionClass# EQ "1" OR #get.ActionClass# EQ "2">
		   	<input type="button" class="button7" name="Add" value="Create Fax to PM" onClick="javascript:pm_createrequestfax(#URL.ID#)">
		</cfif>
	</cfcase>

	<cfcase value="L">
	   	<input type="button" class="button7" name="Add" value="&nbsp;Long list&nbsp;" onClick="javascript:longlist('#URL.ID#','#get.ReferenceNo#')">
	</cfcase>
	
	<cfcase value="R">
	   	<input type="button" class="button7" name="Add" value="&nbsp;Roster search&nbsp;" onClick="javascript:rostersearch('#URL.ID#','#get.FunctionNo#')">
	</cfcase>
	</cfswitch>
			
	</td>
	
	<TD class="regularlist"><cfif #Parameter.ShowPlanning# eq "1">
	#Dateformat(ActionDatePlanning, CLIENT.DateFormatShow)#&nbsp;</cfif></TD>
	
	<td class="regularlist">
			
	<cf_intelliCalendarDate
		FieldName="actiondatestart_#CLIENT.recordNo#" 
		Default="#Dateformat(actiondatestart, CLIENT.DateFormatShow)#">	
			
	</td>
	
	<td colspan="1" class="regularlist">
	
    <input type="hidden" name="actionid_#CLIENT.recordNo#" value="#ActionId#">
	
	<select name="actionstatus_#CLIENT.recordNo#" size="1" onChange="doit#CLIENT.recordNo#(this.value,'document.documentedit.actiondateactual_#CLIENT.recordNo#.value')" required="Yes">
	    <cfif #ActionStatus# eq "0">
	    <option value="">Pending</option>
		</cfif>
		<cfif #ActionByPassDisabled# eq "0">
    		<option value="7">In Process</option>
		</cfif>
		<option value="1">Completed</option>
		<cfif #ActionRejectDisabled# eq "0">
    		<option value="2">Reset</option>
		</cfif>		
		<cfif #ActionRequired# eq "0">
    		<option value="8">N/A</option>
		</cfif>
    	
	</select>	
	
	<td colspan="2" class="regularlist">	
	
	<cf_intelliCalendarDate
		FieldName="actiondateactual_#CLIENT.recordNo#" 
		Default="#Dateformat(actiondateactual, CLIENT.DateFormatShow)#">		
		
	</td>
	<td align="right">
	<input type="submit" class="button7" name="Submit" value="Submit">&nbsp;
	</td>
	
	</tr>
	 	
	<cfif #Action.ActionLevelTrigger# eq "1">
		 
	 <tr>
	 <td colspan="1"></td> 
	 <td colspan="7">
	 
	 <table width="100%">
     <tr>
	 	 
	 <td colspan="1" class="regularlist">Memo (100 chars max):&nbsp;</td>
	 <td colspan="7" class="regularlist">
    	<input type="text"   name="actionmemo_#CLIENT.recordNo#"   value="#ActionMemo#" size="100" maxlength="100" class="regular">
   	 </td>
	 </tr>
	 <tr>	
		  	
	 <td colspan="1" class="regularlist">
	 <cfif #ActionReferenceFieldName# eq "">Reference (20 chars max):&nbsp;
	 <cfelse>#ActionReferenceFieldName#:&nbsp;
	 </cfif></td>
 	 <td colspan="7" class="regularlist">
	 <input type="text"   name="actionreference_#CLIENT.recordNo#"   value="#ActionReference#" size="20" maxlength="20" class="regular">
 	 </td>
	 </tr>
	 </table>
		
	</TD>
    </TR>
	
	<tr>
	 <td colspan="2"></td>
	 <td colspan="7">
		 
	 <cf_filelibraryN
    	DocumentURL="#Parameter.DocumentURL#"
		DocumentPath="#Parameter.DocumentLibrary#"
		SubDirectory="#Get.DocumentNo#" 
		Filter="#actiondirectory#"
		Insert="yes"
		Remove="yes"
		box="b#actiondirectory#"
		ShowSize="#Parameter.ShowAttachmentSize#"
		reload="true">	
		 
	</td>
	</tr>
		
	<cfelse>
	 
    <tr>
	<td colspan="1"></td>
	<td width="100%" colspan="7">
	 
	 <table>
     <tr> 	 
	 
	 <td colspan="1" class="regularlist">Memo (100 chars max):&nbsp;</td>
	 <td colspan="7" class="regularlist">
    	<input type="text"   name="actionmemo_#CLIENT.recordNo#"   value="#ActionMemo#" size="100" maxlength="100" class="regular">
	
   	 </td>
	 </tr>
	 
	 <cfif #ActionReferenceShow# eq "1">
	 <tr>	
	 
	 <td colspan="1" class="regularlist">
	 <cfif #ActionReferenceFieldName# eq "">Reference (20 chars max):&nbsp;
		<cfelse>#ActionReferenceFieldName#:
		</cfif></td>
 	 <td colspan="7" class="regularlist">
	     <input type="text"   name="actionreference_#CLIENT.recordNo#"   value="#ActionReference#" size="20" maxlength="20" class="regular">
 	 </td>
	 </tr>
	 <cfelse>
    	 <input type="hidden"   name="actionreference_#CLIENT.recordNo#"   value="#ActionReference#" size="20" maxlength="20" class="regular">
	 </cfif>
	 </table>
		
	</TD>
    </TR>	 
	 		
	 <tr>
	 <td colspan="2"></td>
	 <td colspan="7">
	
	 <cf_filelibraryN
    	DocumentURL="#Parameter.DocumentURL#"
		DocumentPath="#Parameter.DocumentLibrary#"
		SubDirectory="#Get.DocumentNo#" 
		Filter="#actiondirectory#"
		Insert="yes"
		Remove="yes"
		box="b#actiondirectory#"
		ShowSize="#Parameter.ShowAttachmentSize#"
		reload="yes">	
		
	</td>
	</tr>
	
	<tr><td height="5"></td></tr>
	</cfif>
	
	<cfif #Action.ActionLevelTrigger# eq "1">
	
	<tr>
	<td colspan="2"></td>
	<td width="100%" colspan="7">
	     <cfinclude template="../DocumentEditCandidate.cfm">
    </td>
	</tr>
	<tr><td height="5"></td></tr>		
	</cfif>

	<cfif #Action.ActionLevelTrigger# eq "3">
	<tr>
	<td></td>
	<td width="100%" colspan="7">
	     <cfinclude template="../DocumentRotatingPersonList.cfm">
    </td></tr>		
	</cfif>

	
	<TR><td height="1" colspan="10" class="top"></td></TR>

<!--- FINISHED LINES --->
	
<cfelseif #ActionLevel# eq "0">

   <cfif #access# neq "NONE">

<!--- check if access for Undo --->

   <cfif show eq "1" or Parameter.ShowStepsAlways eq "1" or #ActionStatus# neq "0">
	 <cfif #ActionStatus# is '0'>
	  <TR bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">
               <TD class="regularlist">&nbsp;
	            <img src="../../Images/pending.gif" alt="" width="10" height="10" border="0">
        	   <cfset show = "0">
			   </TD>
	 <cfelseif #ActionStatus# is '1'>
	 <TR bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">
               <TD class="regularlist">&nbsp;
			   <img src="../../Images/check.gif" alt="" width="10" height="12" border="0">
	      	   </TD>
	 <cfelse> 
	 <tr bgcolor="EAD0C4">
               <TD class="regularlist">&nbsp;
	       	  <img src="../../Images/na.gif" alt="" width="12" height="12" border="0">
	      	  </TD>
	 </cfif>
	 
	<td>
	
    <!--- Following line replaced by one right after it on 15Oct03 --->
    <!---	<cfif #Action.ActionLevelTrigger# eq "1">  --->
	
	<cfif #Action.ActionLevelTrigger# eq "1" or #Action.ActionLevelTrigger# eq "3">
		<cfif #URL.IdCandList# eq "ZoomIn" and #URL.ActionId# eq #ActionId#>
   		  <a href="javascript:showdocument('#DocumentNo#','ZoomOut','#ActionId#')">
       	  <img src="../../Images/zoomOut.JPG" alt="" border="0">
		  </a>
	    <cfelse>	
		  <a href="javascript:showdocument('#DocumentNo#','ZoomIn','#ActionId#')">
          <img src="../../Images/zoomIn.JPG" alt="" border="0">
		  </a>
		</cfif>  
	</cfif>
	</td> 
	 
	<td colspan="1" class="regularlist">
	<a href="javascript:history('#documentno#','#actionid#')">
	<cfif #ActionCompleted# neq "" AND #ActionStatus# eq '1'>
		#ActionCompleted#
	<cfelse>
		#ActionDescription#
	</cfif>
	</a>
	</td>

	<!--- 6 April & 9 June 04: added code to test value of ShowAddNomineeButton var --->
	<td><cfif #ActionLevelTrigger# EQ "1" AND #ShowAddNomineeButton#>
			<cfif IsTravelModule(1)>
				<cfif IsNomineeAdder(1)>
					<input type="button" class="button7" name="Add" value="#AddButtonLabel#" onClick="javascript:addcandidate(#URL.ID#)">
				</cfif>
			<cfelse>
   				<input type="button" class="button3" name="Add" value="#AddButtonLabel#" onClick="javascript:addcandidate(#URL.ID#)">
			</cfif>
		</cfif>		
	</td>
	<td class="regularlist"><cfif #Parameter.ShowPlanning# eq "1">#Dateformat(ActionDatePlanning, CLIENT.DateFormatShow)#</cfif></td>
	<td class="regularlist">&nbsp;#Dateformat(ActionDateStart, CLIENT.DateFormatShow)#</TD>
	<td class="regularlist">#Dateformat(ActionDateActual, CLIENT.DateFormatShow)#</td>
	<td class="regularlist">#ActionFirstName# #ActionLastName#</TD>
	<td class="regularlist">#Dateformat(ActionDate, CLIENT.DateFormatShow)#
	<!--- #PriorOrder# - #ActionOrderSub# --->
	</TD>
	
	<cfif #PriorOrder# eq "#ActionOrderSub#">
	
		<cfinvoke component="Service.Access"  
			          method="vacancy"  
					  document="#URL.ID#" 
					  actionid="#PriorOrder#"
					  source="#CLIENT.Datasource#"
					  check="Order"
					  returnvariable="accessP">
					  
	<cfelse>
	
	  <cfset AccessP = "NONE">			
	 				  
	</cfif>			 
			
	<cfif ((#AccessP# eq "EDIT" or #AccessP# eq "ALL") AND #PriorOrder# eq "#ActionOrderSub#")
	      OR 
	      ((#Access# eq "EDIT" or #Access# eq "ALL") AND #ActionCurrent.ActionOrder# eq "#ActionOrder#" 
	      AND #ActionStatus# is "1")>	
	    <td class="regularlist">
    	    <input type="checkbox" name="undoactionid" value="#actionId#">Undo
        	<cfset elementundo = elementundo+1>
		</td>
	<cfelse>
	    <td></td>	
	</cfif>
    </TR>
   
	<!--- 11 June 04 - set colspan variable for Travel and Vacancy cases --->
    <cfif #IsTravelModule(1)#>
   		<cfset iColSpan = 8>
    <cfelse>
   		<cfset iColSpan = 7>   
    </cfif>
    <cfif #ActionMemo# neq "">
      <tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">
	  <td colspan="2"></td><td colspan="#iColSpan#" class="regularlist"><b>#ActionMemo#</b></td>
	  </tr>
    </cfif>
   
    <cfif #ActionReference# neq "">
      <tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">
	  <td colspan="2"></td><td colspan="#iColSpan#" class="regularlist"><b>#ActionReference#</b></td>
	  </tr>
    </cfif>   
   
	<!--- 1 May 04 - chk if action id allows display of AttachDoc link always --->
	<cfif #IsAllowDocAttach(#ActionId#)#>
		<cfset sInsert="yes">
	<cfelse>
		<cfset sInsert="no">
	</cfif>   
   
    <tr bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">
	<td colspan="2"></td>
	<td colspan="#iColSpan#">
	
	<cf_filelibraryN
    	DocumentURL="#Parameter.DocumentURL#"
		DocumentPath="#Parameter.DocumentLibrary#"
		SubDirectory="#Get.DocumentNo#" 
		Filter="#actiondirectory#"
		Insert="#sInsert#"
		Remove="no"
		box="b#actiondirectory#"
		ShowSize="#Parameter.ShowAttachmentSize#"
		reload="yes">	
					
	</td>
	</tr>
	
	<tr>
	     <td colspan="2"></td>
		 <td width="100%" colspan="7">
<!---	15Oct03  Replaced following 7 lines by 10 lines after it
		 <cfif #Action.ActionLevelTrigger# eq "1" 
		    AND URL.IdCandList eq "ZoomIn"
   		    AND URL.ActionId eq #ActionId#>
            <cfinclude template="../DocumentEditCandidate.cfm">
 			<TR><td colspan="2"></td>
			<td height="3" colspan="7" class="top2"></td></TR>
 		 </cfif>   --->		 
	 	<cfif URL.IdCandList eq "ZoomIn" AND URL.ActionId eq #ActionId#>
			<cfif #Action.ActionLevelTrigger# eq "1">
								    		    
	            <cfinclude template="../DocumentEditCandidate.cfm">
						
		 	<cfelseif #Action.ActionLevelTrigger# eq "3">
			    <cfinclude template="../DocumentRotatingPersonList.cfm">
				<tr><td colspan="2"></td><td height="3" colspan="7" class="top2"></td></tr>
			<cfelse>				
					<!-- do nothing -->
			</cfif>
		</cfif>
<!---    End of 15Oct03 fix --->
        </td>
	</tr>
   
   <!--- <TR><td height="1" colspan="9" bgcolor="gray"></td></TR>	--->
   
  <cfelse>
  
  <!--- stop the loop --->
		
  </cfif>
  
 </cfif> 
  
<!--- ROW FOR SUBLEVEL --->

<cfelse>

  <cfif show eq "1" or Parameter.ShowStepsAlways eq "1">
   
   <cfif #ActionCandidateActionNext.ActionOrderSub# gte #ActionOrderSub# 
   OR  #ActionCandidateActionNext.ActionOrderSub# eq "">
   
   	   <!--- for non-revoked/non-stalled candidates, count total pending candidate-level actions --->
	   <cfquery name="Completed" 
	    datasource="#CLIENT.Datasource#" 
	    username="#SESSION.login#" 
	    password="#SESSION.dbpw#">
	    SELECT Count(*) as Sum
	    FROM DocumentCandidateAction V, DocumentCandidate C
		WHERE V.DocumentNo = '#Get.DocumentNo#'
		AND   V.ActionId  = '#ActionId#'
		AND   V.ActionStatus = '0'
		AND   C.DocumentNo = V.DocumentNo
		AND   C.PersonNo  = V.PersonNo
		AND   (C.Status = '0' or C.Status = '3') 
	   </cfquery>
    
    <cfif #lastOrderCandidate# lt #ActionOrderSub#>
    	<cfset show = "0">
	</cfif>
              
    <cfif #Completed.Sum# gt '0'>
	
	     <TR bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">
		 		 
	     <TD class="regularlist">&nbsp;
             <img src="../../Images/pending.gif" alt="" width="10" height="10" border="0">
    	 </TD>
		 
	<cfelseif #lastOrderCandidate# neq "0">
	
	    <TR bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">
		 
		 <TD class="regularlist">&nbsp;
<!---			   <img src="../../Images/check.gif" alt="" width="10" height="12" border="0"> --->
	     </TD>
	<cfelse>
				
         <TR bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">
		 
	     <TD class="regularlist">&nbsp;</TD>
    </cfif>
  
   </cfif>

   <cfif (#Access# eq "EDIT" or #Access# eq "ALL") and #Completed.Sum# gt '0'>
     
       <td> 

	   <cfif #ActionCurrent.ActionOrder# gte #ActionOrder# and #ActionCandidateBatch# eq "1" >
	   <button class="button2" onClick="javascript:batch('#DocumentNo#','#ActionId#')">
	      <img src="../../Images/user.jpg" alt="" width="15" height="15" border="0">
	   </button>&nbsp;
	   </cfif>
	   </td>
	   <td colspan="2"  class="regularlist">   
      	<a href="javascript:history('#documentno#','#actionid#')">#ActionDescription#</a>
	    <cfif #IsShowCpdList(#ActionId#)#>
		   	&nbsp;&nbsp;
			<input type="button" class="button7" name="Add" value="Create CPD List"
			 onClick="javascript:pm_createcpdlist(#URL.ID#,'3')">
	    </cfif>
       </td>
	   	   
   <cfelse>	
       <td>*</td>  
	   <td colspan="2"  class="regularlist">   
      	<a href="javascript:history('#documentno#','#actionid#','')">
		<cfif #Completed.Sum# gt '0'>#ActionDescription#<cfelse>#ActionCompleted#</cfif></a>
<!-- 	    <cfif #IsShowCpdList(#ActionId#)#>
		   	&nbsp;&nbsp;
			<input type="button" class="button7" name="Add" value="Create CPD List"
			 onClick="javascript:pm_createcpdlist(#URL.ID#,'3')">
	    </cfif>
 -->       </td>
   
       <!--- <img src="../../Images/user.jpg" alt="" width="15" height="15" border="0"> --->
   </cfif>    
  
    <td width="100%" colspan="6" align="left">
         <cfinclude template="DocumentEditCandidate_Action.cfm">
    </td>
	     
   </tr>

   <!--- 11 June 04 --->
   <cfif #IsTravelModule(1)#>
   		<cfif #ActionMemo# neq "">
	  	  <TR bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">
	  		<td colspan="2"></td><td colspan="7" class="regularlist"><b>#ActionMemo#</b></td>
		  </TR>
	   	</cfif>
   
		<cfif #ActionReference# neq "">
	   	  <TR bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">
	  		<td colspan="2"></td><td colspan="7" class="regularlist"><b>#ActionReference#</b></td>
		  </TR>
	   	</cfif>   
   </cfif>   			

   <cfif Parameter.ShowAttachment eq "1">
     
    <TR>
	<td colspan="2"></td>
	<td colspan="7">
	
	<cfif (#Access# eq "EDIT" or #Access# eq "ALL") and #Completed.Sum# gt '0'>
	
	<cf_filelibraryN
    	DocumentURL="#Parameter.DocumentURL#"
		DocumentPath="#Parameter.DocumentLibrary#"
		SubDirectory="#Get.DocumentNo#" 
		Filter="#actiondirectory#"
		Insert="yes"
		box="b#actiondirectory#"
		Remove="yes"
		ShowSize="#Parameter.ShowAttachmentSize#">	
		
			
    <cfelse>

	 <!--- 1 May 04 - chk if action id allows display of AttachDoc link always --->
	 <cfif #IsAllowDocAttach(#ActionId#)#>
		<cfset sInsert="yes">
	 <cfelse>
		<cfset sInsert="no">
	 </cfif>   
	
	 <cf_filelibraryN
    	DocumentURL="#Parameter.DocumentURL#"
		DocumentPath="#Parameter.DocumentLibrary#"
		SubDirectory="#Get.DocumentNo#" 
		Filter="#actiondirectory#"
		box="b#actiondirectory#"
		Insert="#sInsert#"
		Remove="no"
		ShowSize="#Parameter.ShowAttachmentSize#">	
			
			
     </cfif>			
	</td>
	</tr>
	
	</cfif>
     
   </cfif>
		
	<!--- <TR><td height="1" colspan="9" bgcolor="gray"></td></TR> --->
    
</cfif>  

</CFOUTPUT>