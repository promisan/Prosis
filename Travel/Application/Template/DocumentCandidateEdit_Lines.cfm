<!---
	DocumentCandidateEdit_Lines.cfm
	
	Display workflow steps for a candidate.
	
	Modification History:
	04Oct04 - MM added code to handle new ActionStatus 5 (Failed medical)
--->
<cfset CLIENT.RecordNo = 0>

<SCRIPT LANGUAGE = "JavaScript">

function doit1(chk,field)
{
if (chk == "")
  {document.documentcandidateedit.actiondateactual_1.value = "";}
 else 
 {document.documentcandidateedit.actiondateactual_1.value = document.documentcandidateedit.actiontoday.value;} 
}

function doit2(chk,field)
{
if (chk == "")
  {document.documentcandidateedit.actiondateactual_2.value = "";}
 else 
 {document.documentcandidateedit.actiondateactual_2.value = document.documentcandidateedit.actiontoday.value;} 
}

function doit3(chk,field)
{
if (chk == "")
  {document.documentcandidateedit.actiondateactual_3.value = "";}
 else 
 {document.documentcandidateedit.actiondateactual_3.value = document.documentcandidateedit.actiontoday.value;} 
}

function doit4(chk,field)
{
if (chk == "")
  {document.documentcandidateedit.actiondateactual_4.value = "";}
 else 
 {document.documentcandidateedit.actiondateactual_4.value = document.documentcandidateedit.actiontoday.value;} 
}

function doit5(chk,field)
{
if (chk == "")
  {document.documentcandidateedit.actiondateactual_5.value = "";}
 else 
 {document.documentcandidateedit.actiondateactual_5.value = document.documentcandidateedit.actiontoday.value;} 
}

function doit6(chk,field)
{
if (chk == "")
  {document.documentcandidateedit.actiondateactual_6.value = "";}
 else 
 {document.documentcandidateedit.actiondateactual_6.value = document.documentcandidateedit.actiontoday.value;} 
}

function doit7(chk,field)
{
if (chk == "")
  {document.documentcandidateedit.actiondateactual_7.value = "";}
 else 
 {document.documentcandidateedit.actiondateactual_7.value = document.documentcandidateedit.actiontoday.value;} 
}

function doit8(chk,field)
{
if (chk == "")
  {document.documentcandidateedit.actiondateactual_8.value = "";}
 else 
 {document.documentcandidateedit.actiondateactual_8.value = document.documentcandidateedit.actiontoday.value;} 
}

</script>

<cfstoredproc procedure="spActionLinesCandidate" 
datasource="#CLIENT.Datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

   <cfprocparam type="In" 
   cfsqltype="CF_SQL_INTEGER" 
   dbvarname="@DOCUMENTNO" 
   value="#URL.ID#" null="No">
   
      <cfprocparam type="In" 
   cfsqltype="CF_SQL_VARCHAR" 
   dbvarname="@PERSONNO" 
   value="#URL.ID1#" null="No">

   <!--- identify all actions --->
   <cfprocresult name="Action" resultset="1"> 
   <!--- identify the actions that are active --->
   <cfprocresult name="ActionCurrent" resultset="2">
   
</cfstoredproc>

<cfset PriorOrder = 99999>

<cfif #ActionCurrent.RecordCount# gt 0>

<cfquery name="ActionCurrentPrior" 
datasource="#CLIENT.Datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT DISTINCT V.DocumentNo, MAX(A.ActionOrder) as ActionOrder
FROM DocumentCandidateAction V, DocumentFlow A
WHERE V.DocumentNo = '#Get.DocumentNo#'
AND   V.PersonNo = '#URL.ID1#'
AND   A.ActionLevel = '1'
AND   V.DocumentNo = A.DocumentNo
AND   A.ActionOrder < #ActionCurrent.ActionOrder#
GROUP BY V.DocumentNo
</cfquery>

  <cfif #ActionCurrentPrior.recordCount# neq 0>
     <cfif #ActionCurrentPrior.ActionOrder# neq "">
         <cfset PriorOrder = #ActionCurrentPrior.ActionOrder#>
     </cfif>
  </cfif>

</cfif>

<cfoutput>
		<input type="hidden" name="actiontoday" value="#Dateformat(now(), CLIENT.DateFormatShow)#" size="30" maxlength="30" class="disabled" readonly>
		<input type="hidden" name="undoactionid" value="">
		<input type="hidden" name="selprioractionid" value="#PriorOrder#"> 
</cfoutput>

<cfoutput query="action">

<cfif (#URL.IDArea# eq #ActionArea#) OR (#URL.IDArea# eq "All")>

<!--- check if access --->

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

<cfelseif 
    (#access# eq "EDIT" OR #access# eq "ALL") 
	AND #show# eq "1" <!--- user authorised ---> 
    AND 
	 ((#ActionCurrent.ActionOrder# eq "#ActionOrder#"  <!--- only current action --->
	   AND #Get.Status# neq "1"                            <!--- only open documents --->    
	   AND #ActionStatus# is "0"                           <!--- only if candidate action is not completed --->
	   AND #GetCandidateStatus.Status# lt "6")             <!--- candidate not revoke --->
	OR (#ActionStatus# is "7" and #GetCandidateStatus.Status# lt "6"))> <!--- in process --->
	
	<cfset CLIENT.recordNo = #Client.recordNo# + 1>
	
	<!---	AND #Condition.ActionStatus# is "1") master action is completed --->
	
   <tr><tr><td height="2" colspan="9">
      
   </td></tr>
   <tr><tr><td height="1" colspan="9" class="top"></td></tr>
   <tr><tr><td height="2" colspan="9"></td></tr>
   
   <tr>
   <td colspan="1" bgcolor="white">&nbsp;  
   <cfif #ActionStatus# eq 0>
   <img src="../../Images/arrow.gif" alt="" width="15" height="15" border="0">
   <cfelse>
   <img src="../../Images/attention.gif" alt="" width="20" height="20" border="0">
   </cfif>
   </td>		
   
   <td colspan="1"  class="regularlist">
     &nbsp;<b><a href="javascript:history('#documentno#','#actionid#','#personno#')">#ActionDescription#</a></b>
   </td>
   
   <TD class="regularlist"><cfif #Parameter.ShowPlanning# eq "1">
	#Dateformat(ActionDatePlanning, CLIENT.DateFormatShow)# </cfif></TD>
    <cfif #ActionType# neq "Milestone">
      <td colspan="2" class="regularlist" style="visibility: visible;">Activity started:
			
	  <cf_intelliCalendarDate
		FieldName="actiondatestart_#CLIENT.recordNo#" 
		Default="#Dateformat(actiondatestart, CLIENT.DateFormatShow)#">	
	  </td>
	<cfelse>
    	<td>
	      <input type="hidden" name="actiondatestart_#CLIENT.recordNo#" value="#Dateformat(actiondatestart, CLIENT.DateFormatShow)#">
    	</td>
	</cfif>
	<td colspan="3" align="right"><input type="submit" class="button7" name="Submit" value="Save changes">&nbsp;</td>
	
   </tr>
  
   <tr>
    <td colspan="1"></td> 
	<td width="100%" colspan="8">
	 
	 <table>
  	 
	<cfif #ActionForm# neq "">
	
	<cfquery name="Document" 
    datasource="#CLIENT.Datasource#" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
    SELECT *
    FROM FlowActionForm R
    WHERE R.ActionForm = '#ActionForm#'
    </cfquery>
	
	<tr>
  	 <td></td>
	 <td width="100" colspan="1" class="regularlist">Action:</td>
	 <td class="regular">
	 
	 <input type="radio" name="ActionStatus_#CLIENT.recordNo#" value="0" checked>Pending
	 <cfif #ActionRequired# eq "0">
    		<input type="radio" name="ActionStatus_#CLIENT.recordNo#" value="8">N/A
	 </cfif>
	 &nbsp;&nbsp;
	 <button name="createdoc" class="button4" onClick="javascript:documentcandidate('#Document.FormPath#','#URL.ID#','#URL.ID1#','#ActionDirectory#','#ActionId#')">#Action.ActionDescription#</button>
	 </td>
	</tr>
	
	<input type="hidden" name="actionreference_#CLIENT.recordNo#" value="#ActionReference#">
	<input type="hidden" name="actionmemo_#CLIENT.recordNo#" value="#ActionMemo#">
	<input type="hidden" name="actionid_#CLIENT.recordNo#" value="#ActionId#">
	<input type="hidden" name="actiondateactual_#CLIENT.recordNo#" value="">
		
	<cfelse>
	
	<tr> 	 
	 <td class="regular"><!---#ActionOrderSub#---></td>
	 <td colspan="1" class="regularlist">Memo:&nbsp;</td>
	 <td colspan="2" class="regularlist">
    	<input type="text"   name="actionmemo_#CLIENT.recordNo#"   value="#ActionMemo#" size="80" maxlength="100" class="regular">
   	 </td>
	 </tr>
	 
	 <cfif #ActionReferenceShow# eq "1">
	 <tr>	
	 <td></td>
	 <td colspan="1" class="regularlist">
	 <cfif #ActionReferenceFieldName# eq "">Reference:&nbsp;
		<cfelse>#ActionReferenceFieldName#:
		</cfif></td>
 	 <td colspan="2" class="regularlist">
	 <input type="text"   name="actionreference_#CLIENT.recordNo#"   value="#ActionReference#" size="20" maxlength="20" class="regular">
 	 </td>
	 </tr>
	 <cfelse>
    	 <input type="hidden"   name="actionreference_#CLIENT.recordNo#"   value="#ActionReference#" size="20" maxlength="20" class="regular">
	</cfif>
	
	<tr>
 	 <td></td>
	 <td width="100" colspan="1" class="regularlist">
	 <cfif #ActionParent# neq "" and #ActionType# eq "Milestone">#ActionParent# date:<cfelse>Action:</cfif></td>
	 <td colspan="1" class="regularlist">
	
    <input type="hidden" name="actionid_#CLIENT.recordNo#" value="#ActionId#">
	<select name="actionstatus_#CLIENT.recordNo#" size="1" onChange="doit#CLIENT.recordNo#(this.value,'document.documentcandidateedit.actiondateactual_#CLIENT.recordNo#.value')" required="Yes">
		
     	<cfinclude template="DocumentEditDecision.cfm">
			
	</select>	
		   	
	<cf_intelliCalendarDate
		FieldName="actiondateactual_#CLIENT.recordNo#" 
		Default="#Dateformat(actiondateactual, CLIENT.DateFormatShow)#">		
		
	</td>
	</tr>
	
	</cfif>
	
	</table>
	
	</TD>
    </TR>
		 
  	
	<TR>	
	<td colspan="1"></td>
	<td colspan="7">
	
	<cf_filelibraryN
    	DocumentURL="#Parameter.DocumentURL#/#Get.DocumentNo#"
		DocumentPath="#Parameter.DocumentLibrary#/#Get.DocumentNo#"
		SubDirectory="#URL.ID1#" 
		Filter="#actiondirectory#"
		Insert="yes"
		Remove="yes"		
		ShowSize="#Parameter.ShowAttachmentSize#"
		reload="yes">	
		
	
	</td>
	</tr>
	<tr><td height="2" colspan="9"></td></tr>
	<tr><td height="1" colspan="9" class="top"></td></tr>
	<tr><td height="2" colspan="9"></td></tr>
			
<cfelse>

  <cfif #access# neq "NONE">

   <cfif show eq "1">
	 <cfif #ActionStatus# is '0'>
	
	 <TR bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">
               <TD class="regularlist" bgcolor="white">
	            <img src="../../Images/pending.gif" alt="" width="10" height="10" border="0">
    	   <cfset show = "0">
		  	   
		   
			   </TD>
	 <cfelseif #ActionStatus# is '1'>
	 <TR bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">
               <TD bgcolor="white">
			   <img src="../../Images/check.gif" alt="" width="10" height="12" border="0">
	      	   </TD>
	 <cfelseif #ActionStatus# is '5'>	<!--- added 04Oct04 --->
		 <TR bgcolor="ffffcf">
               <td align="left" bgcolor="FFFFFF">&nbsp;
	       	  <img src="../../Images/failed_medical.jpg" alt="" width="14" height="14" border="0">
	      	  </td>
	 <cfelse> 
		 <TR bgcolor="ffffcf">
               <td align="left" bgcolor="FFFFFF">&nbsp;
	       	  <img src="../../Images/na.gif" alt="" width="12" height="12" border="0">
	      	  </td>
	 </cfif>
	 
	<TD class="regularlist">&nbsp;
	<a href="javascript:history('#documentno#','#actionid#','#personno#')">
	<cfif #ActionCompleted# neq "" and #ActionStatus# neq "0">#ActionCompleted#<cfelse>#ActionDescription#</cfif>
	</a></TD>
	<td class="regularlist"><cfif #Parameter.ShowPlanning# eq "1">
	#Dateformat(ActionDatePlanning, CLIENT.DateFormatShow)#</cfif></td>
	<TD class="regularlist">&nbsp;#Dateformat(ActionDateStart, CLIENT.DateFormatShow)#</TD>
	<td class="regularlist">#Dateformat(ActionDateActual, CLIENT.DateFormatShow)#</td>
	<td class="regularlist">#ActionFirstName# #ActionLastName#</TD>
	<td class="regularlist">#Dateformat(ActionDate, CLIENT.DateFormatShow)#</TD>
	
	<cfif #PriorOrder# eq "#ActionOrder#">
	
	<cfinvoke component="Service.Access"  
			          method="vacancy"  
					  document="#URL.ID#" 
					  actionid="#PriorOrder#"
					  source="#CLIENT.Datasource#"
					  check="OrderParent"
					  returnvariable="accessP">
					  
	<cfelse>
	
	  <cfset AccessP = "NONE">			
	 				  
	</cfif>			 
	
	<cfif (((#AccessP# eq "EDIT" or #AccessP# eq "ALL") AND #PriorOrder# eq "#ActionOrder#") 

	  OR ((#access# eq "EDIT" OR #access# eq "ALL")  
	      AND #ActionCurrent.ActionOrder# eq "#ActionOrder#" 
	      AND #ActionStatus# gte "1"))
		  
		  AND #GetCandidateStatus.Status# neq "9">	
		  
	    <td class="regularlist">
				
	    <input type="checkbox" name="undoactionid" value="#actionid#">Undo
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
	  <td colspan="2"></td><td colspan="7" class="regularlist">#ActionReferenceFieldName#:<b>#ActionReference#</b></td>
	  </tr>
   </cfif>
   
   <TR bgcolor="#IIf(CurrentRow Mod 2, DE('ffffff'), DE('EBEBEB'))#">
	<td colspan="2" bgcolor="white"></td>
	<td colspan="8" bgcolor="white">
	
	<cf_filelibraryN
    	DocumentURL="#Parameter.DocumentURL#/#Get.DocumentNo#"
		DocumentPath="#Parameter.DocumentLibrary#/#Get.DocumentNo#"
		SubDirectory="#URL.ID1#" 
		Filter="#actiondirectory#"
		Insert="yes"
		Remove="yes"
		ShowSize="#Parameter.ShowAttachmentSize#"
		reload="yes">	
		
	</td>
	
	</tr>
	
  </cfif>
  
  </cfif>
  
</cfif>
  
</cfif>

</CFOUTPUT>