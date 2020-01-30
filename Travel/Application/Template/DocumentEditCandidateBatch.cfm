<!---
	DocumentEditCandidateBatch.cfm
	
	Display the candidate batch submit page.  
	
	Called by: Batch() in ..Application\Template\DocumentEdit_Lines.cfm
	Calls: 	DocumentEditCandidateBatchSubmit.cfm
	
	Modification History:
	14June04 - added switch to print, for each candidate, PersonNo or IndexNo for Vacancy and Travel modules, respectively
--->
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">

<html>
<head>
	<title>Batch Processing</title>
</head>

<link rel="stylesheet" type="text/css" href="../../../<cfoutput>#client.style#</cfoutput>"> 

<body bgcolor="#f6f6f6" class="dialog" onLoad="window.focus()">
<cfset root = "#CLIENT.root#">
<cfinclude template="../Dialog.cfm">
<script language="JavaScript">

function doit(chk,id)

{

if (chk == "")
  {

  document.documentbatch.actionid.value = ""
  
  document.documentbatch.actiondateactual.value = "";
  document.documentbatch.actionmemo.value = "";
  document.documentbatch.actionmemo.readonly = true;
  }
 else 
  {
 
  document.documentbatch.actiondateactual.value = document.documentbatch.actiontoday.value;
  document.documentbatch.actionmemo.readonly = false;
  } 
}

ie = document.all?1:0
ns4 = document.layers?1:0

function hl(itm,fld){

     if (ie){
          while (itm.tagName!="TR")
          {itm=itm.parentElement;}
     }else{
          while (itm.tagName!="TR")
          {itm=itm.parentNode;}
     }
	 
	 	 		 	
	 if (fld != false){
		
	 itm.className = "highLight2";
	 }else{
		
     itm.className = "regular";		
	 }
  }

function ask()

{
	if (confirm("Do you want to submit the updated information ?")) {
	
	return true 
	
	}
	
	return false
	
}	


function selectall2(chk,val)
{

var count=1;

var itm = new Array();
while (count < 99)
      
   {    
   
  		 
	 itm2  = 'select_'+count
	 var fld = document.getElementsByName(itm2)
  	 var itm = document.getElementsByName(itm2)
	 
	 if (val == true) 
	 {
	 fld[0].checked = true;
	 }
	 else
	 {
	 fld[0].checked = false;
	 }
	
	 			
     if (ie){
	      itm1=itm[0].parentElement; 
		  itm1=itm1.parentElement; 
		  }
     else{
          itm1=itm[0].parentElement; 
		  itm1=itm1.parentElement; }		
	
	 if (val == true){
		
	 itm1.className = "highLight2";
	 }
	 		 
	 if (val == false){
		
	 itm1.className = "regular";
	 }
	 
	
	
    count++;
   }	

}







</script>

<cfquery name="Parameter" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
    SELECT * FROM Parameter	WHERE Identifier = 'A'
</cfquery>

<!--- define last status per candidate --->
<cfquery name="Action" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT * FROM DocumentFlow
	WHERE DocumentNo = '#URL.DocumentNo#'
	 AND  ActionId  = '#URL.ActionId#'
</cfquery>

<!--- check for alternative dialog screen --->
<cfquery name="Rule" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT * FROM FlowActionRule
	WHERE ActionId  = '#URL.ActionId#'
	AND  RuleTriggerClass = 'Batch'
</cfquery>

<cfif Rule.RecordCount eq 1>

     <!--- redirect to alternative processing template (if any) --->
     <cfinclude template="#Rule.RuleTemplate#">
	 
<cfelse>

<!-- for each DISTINCT PENDING candidate for this PENDING request... --->
<cfquery name="ActionCandidateCurrent" datasource="#CLIENT.Datasource#" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT DISTINCT VC.DocumentNo, VC.PersonNo, Upper(VC.LastName) as sLastName, VC.FirstName, P.IndexNo,
	MIN(ActionOrderSub) as ActionOrderSub
	FROM DocumentCandidate VC INNER JOIN DocumentCandidateAction VA ON VC.DocumentNo = VA.DocumentNo 
	                                                               AND VC.PersonNo = VA.PersonNo
			                   LEFT JOIN EMPLOYEE.DBO.Person P ON VC.PersonNo = P.PersonNo
	WHERE VC.DocumentNo = '#URL.DocumentNo#'
	 AND  VA.ActionStatus = '0' 
	 AND  VC.Status < '6'
	GROUP BY VC.DocumentNo, VC.PersonNo, VC.LastName, VC.FirstName, P.IndexNo 
</cfquery>

<!--- added 14June04 to control URL value depending on current module VACANCY or TRAVEL --->
<cfquery name="WhichModule"
 datasource="#CLIENT.Datasource#"
 username="#SESSION.login#"
 password="#SESSION.dbpw#">
    SELECT TOP 1 DocumentLibrary AS Name
    FROM Parameter
</cfquery>

<!--- returns one record for each candidate that has completed prior workflow step --->
<cfquery name="SearchResult" dbtype="query">
	SELECT * FROM ActionCandidateCurrent
	WHERE ActionOrderSub = #Action.ActionOrderSub#
	ORDER BY sLastName, FirstName
</cfquery>

<cfform action="DocumentEditCandidateBatchSubmit.cfm" method="POST" name="documentbatch">
  <cfoutput> 
    <input type="hidden" name="documentno" value="#URL.DocumentNo#">
    <input type="hidden" name="actionid" value="#URL.ActionId#">
    <input type="hidden" name="no" value="#SearchResult.recordCount#">
  </cfoutput> 
  <table width="100%" border="0" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
    <tr> 
      <td height="30" colspan="2" class="bannerN"> <b>&nbsp;<cfoutput>&nbsp;#Action.ActionDescription#</b></cfoutput>
	   </td>
    </tr>
	<cfoutput query="Action" maxrows=1> 
 	
	<tr>
       <td height="6" bgcolor="silver" colspan="2"></td>
    </tr>
   
    <tr>
      <td height="4" colspan="2" class="header"></td>
    </tr>
    <tr> 
	
	<tr><td height="3" colspan="2" class="header">
	  <table width="95%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="002350" style="border-collapse: collapse;">
	
      <td class="header">&nbsp;&nbsp;Activity Started</td>
      <td class="regularlist">&nbsp; 
	  		<cf_intelliCalendarDate
			formName="documentbatch"
			FieldName="actiondatestart" 
			DateFormat="#CLIENT.DateFormatShow#"
			Default=""> 
	  </td>
      </tr>
	  <tr><td height="3" class="header"></td></tr>
      
        <td class="header">&nbsp;&nbsp;Activity Status:</td>
        <td colspan="1" class="regularlist">&nbsp; 
		<select name="actionstatus" size="1" onChange="doit(this.value,'#actionid#')" required="Yes">
		
		<cfparam name="ActionStatus" default="9">
				
        <CFIF #ActionType# eq "Approval">	<!--- NOT USED IN PM STARS --->

		    <cfif #ActionStatus# eq "0">
	    		<option value="">Pending</option>
			</cfif>
			<option value="1">Approve</option>
			<cfif #ActionRequired# eq "0">
    			<option value="8">N/A</option>
			</cfif>
    		<cfif #ActionRejectDisabled# eq "0">
    			<option value="6">Not Approved</option> <!--- no firther action --->
			</cfif>		
			<cfif #ActionCandidateRevoke# eq "1">
	    		<option value="9">Withdraw</option>
			</cfif>	
		
        <CFELSEIF #ActionType# eq "Clearance">		<!--- NOT USED IN PM STARS --->
		
			<cfif #ActionStatus# eq "0">
			    <option value="">Pending</option>
			</cfif>
			<option value="1">Clear</option>
			<cfif #ActionRejectDisabled# eq "0">
    			<option value="6">Not cleared</option> <!--- no further action --->
			</cfif>	
			<cfif #ActionRequired# eq "0">
    			<option value="8">N/A</option>
			</cfif>
	    	<cfif #ActionCandidateRevoke# eq "1">
    			<option value="9">Withdraw</option>
			</cfif>	
		
  	    <CFELSE>			<!--- Else, ActionType is "Activity" or "Milestone".  Currently, these are the only types of actions in PM TRAVEL --->
		
		    <cfif #ActionStatus# eq "0">
		    	<option value="">Pending</option>
			</cfif>
			<option value="1">Completed</option>
    	 	<cfif #ActionRejectDisabled# eq "0">
    			<option value="2">Reset</option>
			</cfif>			
			<cfif #ActionByPassDisabled# eq "0">
    			<option value="7">In Process</option>
			</cfif>
			<cfif #ActionRequired# eq "0">
    			<option value="8">N/A</option>
			</cfif>    
			<cfif #ActionCandidateRevoke# eq "1">
    			<option value="9">Withdraw</option>
			</cfif>			
			<option value="6">No further action</option>
		
    	</CFIF>	
 		     	
        </select> <input type="hidden" name="actiontoday" value="#Dateformat(now(), CLIENT.DateFormatShow)#"> 
        </td>
     </tr>
	 
	 <tr><td height="3" class="header"></td></tr>
     <tr> 
        <td class="header">&nbsp;&nbsp;Effective Date:</td>
        <td colspan="1" class="regularlist">&nbsp; 
			<cf_intelliCalendarDate
			FormName="documentbatch"
			FieldName="actiondateactual" 
			DateFormat="#CLIENT.DateFormatShow#"
			Default="#Dateformat(now(), CLIENT.DateFormatShow)#">
		</td>
     </tr>
	 
	 <tr><td height="3" class="header"></td></tr>
	 
     <tr> 
	 
        <td class="header">&nbsp;
		<cfif #ActionReferenceFieldName# eq "">Ref (20 chars max):
		<cfelse>#ActionReferenceFieldName#:
		</cfif>
		</td>
        <td colspan="1" class="regularlist">&nbsp; 
		  <input type="text" name="actionreference"   value="" size="20" maxlength="20" class="regular"> 
        </td></td>
	 </tr>
	 
	 <tr><td height="3" class="header"></td></tr>
	 
	 <tr> 
        <td class="header">&nbsp;&nbsp;Memo (70 chars max):</td>
        <td colspan="1" class="regularlist">&nbsp; 
		  <input type="text" name="actionmemo"   value="" size="70" maxlength="70" class="regular"> 
        </td></td>
	 </tr>
	 
	 <tr>
       <td height="4"  colspan="4"></td>
       </tr>
	 
	 <tr>
       <td height="2" bgcolor="silver" colspan="2"></td>
       </tr>	
	    
	<tr>
       <td height="4"  colspan="4"></td>
       </tr>
	   
	 </td></tr></table>  

	  <table width="100%">
		<tr><td align="right">
				<input type="button" name="Cancel" value=" Cancel " class="input.button1" onClick="window.close()">
				<input type="submit" name="   Submit   " value="Submit" class="input.button1">&nbsp;&nbsp;&nbsp;
			</td>
		</tr>
		<tr><td height="6" colspan="4"></td></tr>
	  </table>
    	 
	 <tr>
       <td height="4" colspan="2"></td>
      </tr>
	       	 
     </cfoutput> 	
	
     <table width="95%" border="1" cellspacing="0" cellpadding="0" align="center" bordercolor="#002350" bgcolor="#FFFFFF" style="border-collapse: collapse;">
	 <tr><td>
	 <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" bordercolor="#002350" style="border-collapse: collapse;">
	
      <TR> 
	   
        <td class="topN" height="10">
		<input type="checkbox" name="ShowSelect" value="All" onClick="javascript:selectall2('document.documentbatch.personno_',this.checked);"> 
        </td>
		<TD class="topN">Cnt.</TD>
		<TD class="topN"><cfif #WhichModule.Name# EQ "vacancy">Id<cfelse>IMIS No</cfif></TD>	<!--- added 14June04 --->
        <TD class="topN">Name</TD>
      </TR>
	
      <cfset no = "0">
      <CFOUTPUT query="SearchResult"> 
        <cfset no = #no# + 1>
        <tr> 
          <td class="regular">
		   <input type="checkbox" name="select_#no#" value="1" onClick="hl(this,this.checked)">
		   <input name="personno_#no#" type="hidden" value="#PersonNo#">
		   </TD>
		  <TD class="regular">#CurrentRow#</TD> 
		  <TD class="regular"><cfif #WhichModule.Name# EQ "vacancy">#PersonNo#<cfelse>#IndexNo#</cfif></TD>  <!--- added 14June04 --->
          <TD class="regular">#FirstName# #sLastName#</TD>
        </TR>

	    <tr> 
          <td></td>
          <td colspan="3"> 
		  <cf_filelibraryN
    		DocumentURL="#Parameter.DocumentURL#/#URL.DocumentNo#"
			DocumentPath="#Parameter.DocumentLibrary#/#URL.DocumentNo#"
			SubDirectory="#PersonNo#" 
			Filter="#action.actiondirectory#"
			Insert="yes"
			Remove="yes"
			ShowSize="#Parameter.ShowAttachmentSize#">	
		  </td>
        </tr>
		<tr><td height="2" colspan="4"></td></tr>
		<tr><td height="1" colspan="4" class="topN"></td></tr>
		<tr><td height="2" colspan="4"></td></tr>
      </CFOUTPUT>
	  <cfloop index="row" from="#no#" to="10">
	  <tr><td>&nbsp;</td></tr> 
	  <tr><td height="2" colspan="4"></td></tr>
		<tr><td height="1" colspan="4" class="topN"></td></tr>
		<tr><td height="2" colspan="4"></td></tr>
	  
	  </cfloop>
	  
	   <tr>
       <td height="4" class="topN" colspan="4"></td>
       </tr>
	   </table>
	   </td></tr>
	
    </table></td>
  </table>
  <table width="100%">
  <tr><td height="6" colspan="5"></td></tr>
    <tr><td width="35%" align="right">
	<cfset DocumentNum= #URL.DocumentNo#>
	<cfoutput >
<button class="button2" onClick="javascript:showcertificate('#DocumentNum#')">
 <img src="../../../Images/user.JPG" alt="" width="14" height="14" border="0" align="bottom">
</button> </cfoutput> View Certificate
		  		<cfif #Action.ActionDescription# eq "Initiate Travel Authorization">
					<div align="left"></div>
					

<strong><font color="#003366">
			        </font>
		  		    </strong>
		  		</cfif>


    </td>
      <td width="65%" align="right">    
	  	<input type="button" name="Cancel" value=" Cancel " class="input.button1" onClick="window.close()">
      	<input type="submit" class="input.button1" name="   Submit   " value="Submit">&nbsp;&nbsp;&nbsp;
	  </td>
    </tr>
  </table>

</cfform>
</cfif>

</body>
</html>
