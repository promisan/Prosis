<!--- 
	Application/Rules/FmPostBatch.cfm
	
	Candidate batch processing page that appears everytime the candidate processing icon is clicked in the 
	workflow section of the Personnel Request Edit page.

	Calls: ../Rules/FmPostBatchSubmit.cfm
		
--->

<cfquery name="ActionCandidateCurrent" 
datasource="#CLIENT.Datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT DISTINCT VC.DocumentNo, VC.PersonNo, VC.LastName, VC.FirstName, VC.PostNumber,
MIN(ActionOrderSub) as ActionOrderSub
FROM DocumentCandidate VC, DocumentCandidateAction VA
WHERE VC.DocumentNo = '#URL.DocumentNo#'
 AND  VC.DocumentNo = VA.DocumentNo
 AND  VC.PersonNo = VA.PersonNo
 AND  VA.ActionStatus = '0' 
 AND  VC.Status <> '9'
GROUP BY VC.DocumentNo, VC.PersonNo, VC.LastName, VC.FirstName, VC.PostNumber 
</cfquery>

<cfquery name="SearchResult" 
dbtype="query">
SELECT * 
FROM ActionCandidateCurrent
WHERE ActionOrderSub = #Action.ActionOrderSub#
</cfquery>

<cfquery name="GetGiven" 
datasource="#CLIENT.Datasource#" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">

    SELECT P.PostNumber, V.PostNumber as Given, V.Status, V.PersonNo
    FROM DocumentPost P LEFT JOIN  DocumentCandidate V ON 
	P.PostNumber = V.PostNumber	
	WHERE P.DocumentNo = '#URL.DocumentNo#'
	AND P.DocumentNo = '#URL.DocumentNo#'

--    SELECT P.PostNumber, V.PostNumber as Given, V.Status, V.PersonNo
--    FROM DocumentPost P, DocumentCandidate V
--	WHERE P.DocumentNo = '#URL.DocumentNo#'
--	AND P.PostNumber *= V.PostNumber
--	AND P.DocumentNo = '#URL.DocumentNo#'
</cfquery>


<cfform action="../Rules/FmPostBatchSubmit.cfm" method="POST" name="documentbatch">
  <cfoutput> 
    <input type="hidden" name="documentno" value="#URL.DocumentNo#">
    <input type="hidden" name="actionid" value="#URL.ActionId#">
    <input type="hidden" name="no" value="#SearchResult.recordCount#">
  </cfoutput> 
  <table width="100%" border="1" cellspacing="0" cellpadding="0" bordercolor="#002350" frame="all">
    <tr> 
      <td height="30" class="label"> <b>&nbsp;<cfoutput>&nbsp;#Action.ActionDescription#</b></cfoutput> </td>
    </tr><tr><td width="100%">
    <table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
      <TR bgcolor="6688aa"> 
        <td class="top" height="10"> <input class="regular" type="checkbox" name="ShowSelect" value="All" onClick="javascript:selectall('document.documentbatch.personno',this.checked);"> 
        </td>
        <TD class="top">Id</TD>
        <TD class="top">Name</TD>
		<TD class="top">Postnumber</TD>
      </TR>
      <cfset no = "0">
      <CFOUTPUT query="SearchResult"> 
        <cfset no = #no# + 1>
        <tr> 
          <td class="regular"><input type="checkbox" name="personno_#no#" value="#PersonNo#" onClick="hl(this,this.checked)"></TD>
          <TD class="regular">#PersonNo#</TD>
          <TD class="regular">#FirstName# #LastName#</TD>
		  <TD>
    	  <cfselect name="postnumber_#no#">
	    	<option value="" <cfif #PostNumber# is "">selected</cfif>></option>
    	    <cfloop query="GetGiven">
	    	<cfif #GetGiven.Given# eq ""  
			   or #GetGiven.Status# eq "9">
    	    	<option value="#PostNumber#">#GetGiven.PostNumber#</option>
	    	</cfif>
			</cfloop>
	      </cfselect>
		  </TD>					  
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
      </CFOUTPUT> 
	  
	  <cfoutput> 
        <tr>
          <td height="4" colspan="9"></td>
        </tr>
        <tr>
          <td height="4" colspan="9" bgcolor="6688aa"></td>
        </tr>
        <tr>
          <td height="4" colspan="9" class="header"></td>
        </tr>
        <tr> 
          <td class="header">&nbsp;Activity Started</td>
          <td class="regularlist">&nbsp; 
		  		<cf_intelliCalendarDate
				FormName="documentbatch"
				FieldName="actiondatestart" 
				DateFormat="#CLIENT.DateFormatShow#"
				Default="">
		  </td>
        </tr>
        <tr> 
          <td class="header">&nbsp;Activity:</td>
          <td colspan="3" class="regularlist">&nbsp; 
		  <select name="actionstatus" size="1" onChange="doit(this.value,'#actionid#')" required="Yes">
              <cfinclude template="../Template/DocumentEditDecision.cfm">
          </select> 
		  <input type="hidden" name="actiontoday" value="#Dateformat(now(), CLIENT.DateFormatShow)#"> 
          </td>
        </tr>
        <tr> 
          <td class="header">&nbsp;Date:</td>
          <td colspan="3" class="regularlist">&nbsp; 
		  		<cf_intelliCalendarDate
				FormName="documentbatch"
				FieldName="actiondateactual" 
				DateFormat="#CLIENT.DateFormatShow#"
				Default="#Dateformat(now(), CLIENT.DateFormatShow)#"> 
		  </td>
        </tr>
        <tr> 
          <td class="header">&nbsp;Memo:</td>
          <td colspan="5" class="regularlist">&nbsp; <input type="text"   name="actionmemo"   value="" size="50" maxlength="50" class="regular" onChange="javascript:setstatus(this.value,'0','#actionid#')"> 
          </td></td></TR>
        <tr>
          <td height="4" colspan="9" class="header"></td>
        </tr>
      </cfoutput> 
    </table></td>
  </table>
  <hr>&nbsp;
  <input type="button" name="Cancel" value=" Cancel " class="input.button1" onClick="window.close()">
  <input type="submit" name=" Submit " value="Submit" class="input.button1">
</cfform>

<!--- continues --->