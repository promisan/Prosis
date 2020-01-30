<!---
	Modification History
	15Oct03 - added code to handle TriggerStatus = "3" conditions
	i.e., deployed personnel that are associated to this Request Document
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
	window.open("Template/DocumentActionHistory.cfm?ID=" + vacno + "&ID1=" + actid, "documenthistory", "width=500, height=330, toolbar=no, scrollbars=no, resizable=no");
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

<!--- listing of the actions for a document, will be part of cfoutput below --->

<cfstoredproc procedure="spActionLines" 
datasource="#CLIENT.Datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

   <cfprocparam type="In" 
   cfsqltype="CF_SQL_INTEGER" 
   dbvarname="@DOCUMENTNO" 
   value="#URL.ID#" null="No">

   <!--- identify all actions --->
   <cfprocresult name="Action" resultset="1"> 
   <!--- identify the actions that are active --->
   <cfprocresult name="ActionCurrent" resultset="2">
   <!--- identify the first action that is active --->
   <cfprocresult name="ActionCurrentFirst" resultset="3">
   <!--- identify the action that were last performed for each candidate --->
   <cfprocresult name="ActionCandidateCurrent" resultset="4">
   <!--- identify the action that were last performed for a candidate --->
   <cfprocresult name="ActionCandidateLast" resultset="5">

</cfstoredproc>

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

<!--- check if access --->

<cfstoredproc procedure="spActionAccess" 
datasource="#CLIENT.Datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

   <cfprocparam type="In" 
   cfsqltype="CF_SQL_INTEGER" 
   dbvarname="@DOCUMENTNO" 
   value="#URL.ID#" null="No">
   
   <cfprocparam type="In" 
   cfsqltype="CF_SQL_INTEGER" 
   dbvarname="@ACTIONORDER" 
   value="#ActionOrderSub#" null="No">
   
   <cfprocparam type="In" 
   cfsqltype="CF_SQL_CHAR" 
   dbvarname="@USERID" 
   value="#SESSION.acc#" null="No">

   <!--- identify all actions --->
   <cfprocresult name="Check" resultset="1"> 
  
</cfstoredproc>

<!--- row with action enabled --->

<cfif Check.accessLevel eq "9">

  <!--- don't show anything here --->

   <cfif #lastOrderCandidate# lt #ActionOrderSub#>
    	<cfset show = "0">
   </cfif> 
	  
<cfelseif (Check.recordcount gte 1 
  AND #ActionLevel# eq "0"
  AND #show# eq "1"
  AND (#ActionCurrent.ActionOrder# eq "#ActionOrder#" AND #ActionStatus# is "0") 
   OR (#ActionStatus# is "7"))>
   
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
	   <input type="button" class="button7" name="Add" value="Add candidate" onClick="javascript:addcandidate(#URL.ID#)">
	</cfcase>
	<cfcase value="2">
	   <input type="button" class="button7" name="Add" value="Add candidate" onClick="javascript:addcandidate(#URL.ID#)">
	</cfcase>
	<cfcase value="3">
	   	<input type="button" class="button7" name="Add" value="Deployed personnel" onClick="javascript:adddeployedperson(#URL.ID#)">
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
	 	 
	 <td colspan="1" class="regularlist">Memo:&nbsp;</td>
	 <td colspan="7" class="regularlist">
    	<input type="text"   name="actionmemo_#CLIENT.recordNo#"   value="#ActionMemo#" size="100" maxlength="100" class="regular">
   	 </td>
	 </tr>
	 <tr>	
		  	
	 <td colspan="1" class="regularlist">
	 <cfif #ActionReferenceFieldName# eq "">Reference:&nbsp;
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
	 
	 <td colspan="1" class="regularlist">Memo:&nbsp;</td>
	 <td colspan="7" class="regularlist">
    	<input type="text"   name="actionmemo_#CLIENT.recordNo#"   value="#ActionMemo#" size="100" maxlength="100" class="regular">
	
   	 </td>
	 </tr>
	 
	 <cfif #ActionReferenceShow# eq "1">
	 <tr>	
	 
	 <td colspan="1" class="regularlist">
	 <cfif #ActionReferenceFieldName# eq "">Reference:&nbsp;
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

<!--- check if access for Undo --->

<cfstoredproc procedure="spActionAccess" 
datasource="#CLIENT.Datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

   <cfprocparam type="In" 
   cfsqltype="CF_SQL_INTEGER" 
   dbvarname="@DOCUMENTNO" 
   value="#URL.ID#" null="No">
   
   <cfprocparam type="In" 
   cfsqltype="CF_SQL_INTEGER" 
   dbvarname="@ACTIONORDER" 
   value="#PriorOrder#" null="No">
   
   <cfprocparam type="In" 
   cfsqltype="CF_SQL_CHAR" 
   dbvarname="@USERID" 
   value="#SESSION.acc#" null="No">

   <!--- identify all actions --->
   <cfprocresult name="Prior" resultset="1"> 
  
</cfstoredproc>

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
	 
	<td colspan="2" class="regularlist">
	<a href="javascript:history('#documentno#','#actionid#')">
	<cfif #ActionCompleted# neq "" AND #ActionStatus# eq '1'>
	        #ActionCompleted#
	<cfelse>#ActionDescription#
	</cfif>
	</a>
	</td>
	<td class="regularlist"><cfif #Parameter.ShowPlanning# eq "1">
	#Dateformat(ActionDatePlanning, CLIENT.DateFormatShow)#</cfif></td>
	<TD class="regularlist">&nbsp;#Dateformat(ActionDateStart, CLIENT.DateFormatShow)#</TD>
	<td class="regularlist">#Dateformat(ActionDateActual, CLIENT.DateFormatShow)#</td>
	<td class="regularlist">#ActionFirstName# #ActionLastName#</TD>
	<td class="regularlist">#Dateformat(ActionDate, CLIENT.DateFormatShow)#
	<!--- #PriorOrder# - #ActionOrderSub# --->
	</TD>
			
	<cfif (Prior.recordcount gte 1 AND #PriorOrder# eq "#ActionOrderSub#") or 
	(Check.recordcount gte 1 AND #ActionCurrent.ActionOrder# eq "#ActionOrder#" 
	 AND #ActionStatus# is "1")>	
	    <td class="regularlist">
    	    <input type="checkbox" name="undoactionid" value="#actionId#">Undo
        	<cfset elementundo = elementundo+1>
		</td>
	<cfelse>
	    <td></td>	
	</cfif>
    </TR>
   
   <cfif #ActionMemo# neq "">
      <TR bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">
	  <td colspan="2"></td><td colspan="7" class="regularlist"><b>#ActionMemo#</b></td>
	  </tr>
   </cfif>
   
   <cfif #ActionReference# neq "">
      <TR bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">
	  <td colspan="2"></td><td colspan="7" class="regularlist"><b>#ActionReference#</b></td>
	  </tr>
   </cfif>   
   
   <TR bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">
	<td colspan="2"></td>
	<td colspan="7">
	
	<cf_filelibraryN
    	DocumentURL="#Parameter.DocumentURL#"
		DocumentPath="#Parameter.DocumentLibrary#"
		SubDirectory="#Get.DocumentNo#" 
		Filter="#actiondirectory#"
		Insert="no"
		box="b#actiondirectory#"
		Remove="no"
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
  
<!--- ROW FOR SUBLEVEL --->

<cfelse>

  <cfif show eq "1" or Parameter.ShowStepsAlways eq "1">
   
   <cfif #ActionCandidateActionNext.ActionOrderSub# gte #ActionOrderSub# 
   OR  #ActionCandidateActionNext.ActionOrderSub# eq "">
   
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
    
   <cfif Check.sum gte 1 and #Completed.Sum# gt '0'>
     
       <td> 
	
	   <cfif #ActionCurrent.ActionOrder# gte #ActionOrder# and #ActionCandidateBatch# eq "1" >
	   <button class="button7" onClick="javascript:batch('#DocumentNo#','#ActionId#')">
	      <img src="../../Images/user.jpg" alt="" width="15" height="15" border="0">
	   </button>
	   </cfif>
	   </td>
	   <td colspan="2"  class="regularlist">   
      	<a href="javascript:history('#documentno#','#actionid#')">#ActionDescription#</a>
       </td>
	   	   
   <cfelse>	
       <td>*</td>  
	   <td colspan="2"  class="regularlist">   
      	<a href="javascript:history('#documentno#','#actionid#','')">
		<cfif #Completed.Sum# gt '0'>#ActionDescription#<cfelse>#ActionCompleted#</cfif></a>
       </td>
   
       <!--- <img src="../../Images/user.jpg" alt="" width="15" height="15" border="0"> --->
   </cfif>    
  
    <td width="100%" colspan="6" align="left">
         <cfinclude template="DocumentEditCandidate_Action.cfm">
    </td>
	     
   </tr>
   
   <cfif Parameter.ShowAttachment eq "1">
     
    <TR>
	<td colspan="2"></td>
	<td colspan="7">
	
	<cfif Check.sum gte 1 and #Completed.Sum# gt '0'>
	
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
	 
	 <cf_filelibraryN
    	DocumentURL="#Parameter.DocumentURL#"
		DocumentPath="#Parameter.DocumentLibrary#"
		SubDirectory="#Get.DocumentNo#" 
		Filter="#actiondirectory#"
		box="b#actiondirectory#"
		Insert="no"
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