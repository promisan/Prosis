<!---
File:		ParameterEdit.cfm
Desc:		Report parameter collector page.
Calls:		pdfopen.cfm
Modification history:

PREPROCESS THE DATE FIELDS TO CAPTURE EMPTY VALUES!!

--->
<HTML><HEAD>
	<TITLE>Report parameters - Edit Form</TITLE>
</HEAD><BODY bgcolor="#FFFFFF">
 <link rel="stylesheet" type="text/css" href="../../../<cfoutput>#client.style#</cfoutput>">
 
<cf_PreventCache>
 
<cfoutput>
<script language="JavaScript">
function assign() {
	document.pdf.filename.value = pdf.pm_Mission.value+"_"+pdf.pm_PostType.value 
 	pdf.submit()
}
</script>
</cfoutput>
 
<cfquery name="CheckMissionAccess" 
 datasource="AppsTravel" 
 username="#SESSION.login#" 
 password="#SESSION.dbpw#">
       SELECT TOP 1 Mission
       FROM  ActionAuthorization
	   WHERE UserAccount = '#SESSION.acc#'
	   ORDER BY Mission
</cfquery>

<cfif #CheckMissionAccess.Mission# EQ "All Missions">
 
	<cfquery name="Mandate" 
    datasource="AppsTravel" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
       SELECT DISTINCT Mission, MandateNo
       FROM  Ref_Tvl_Mandate
	   ORDER BY Mission, MandateNo DESC
	</cfquery>
 
<cfelse>
 
	<cfquery name="Mandate" 
   	datasource="AppsTravel" 
    username="#SESSION.login#" 
    password="#SESSION.dbpw#">
       SELECT DISTINCT M.Mission, M.MandateNo
       FROM  ActionAuthorization A, Ref_Tvl_Mandate M
	   WHERE A.UserAccount = '#SESSION.acc#'
	   AND A.Mission = M.Mission
	   ORDER BY M.Mission, M.MandateNo DESC
 	</cfquery>
 
</cfif>
 
<cfquery name="Reports" 
   datasource="AppsSystem" 
      username="#SESSION.login#" 
       password="#SESSION.dbpw#">
       SELECT  *
       FROM  Ref_ModuleControl
	   WHERE SystemModule = 'PMSTARS'
	   AND FunctionClass = 'PDF'
	   AND FunctionName LIKE 'Deployment%'
	   AND MenuClass = 'Report'
</cfquery>
 
<!--- Get authorized PostType that current user is allowed to access --->
<cfquery name="AuthorizedPostType" datasource="AppsTravel" username="#SESSION.login#" password="#SESSION.dbpw#">
	SELECT DISTINCT RC.TravellerType AS PostType
	FROM ActionAuthorization AA, FlowAction FA, Ref_TravellerType RT, Ref_Category RC
	WHERE AA.ActionId = FA.ActionID
	AND   FA.ActionClass = RT.TravellerTypeCode
	AND   RT.TravellerType = RC.TravellerType
	AND   AA.AccessLevel <> '9'
	AND   AA.UserAccount = '#SESSION.acc#'
	ORDER BY RC.TravellerType
</cfquery>
 	
<cfform action="PDFopen.cfm" method="POST" name="pdf" id="pdf">

<cfoutput>
   
   <input type="hidden" name="filepath" value="<cfoutput>#CLIENT.RootPath#\rptFiles\PDFLibrary\Staffing\#SESSION.acc#\</cfoutput>">
   <input type="hidden" name="filename" value="<cfoutput>#SESSION.acc#</cfoutput>">
   <input type="hidden" name="caller" value="<cfoutput>#CLIENT.root#/Travel/Reporting/Deployment/ParameterEdit.cfm</cfoutput>">
      
</cfoutput>  	 	  

<table width="88%" border="1" cellspacing="0" cellpadding="0" align="center" bgcolor="FFFFFF">

<tr>
<td height="24" valign="middle" class="BannerN"><font face="Trebuchet MS" size="2"><b>&nbsp;&nbsp;Prepare new report:</b></font></td>
</tr>

<tr><td>

<!--- Entry form --->

<table width="97%" border="0" align="center" bordercolor="6688aa">
<tr><td>

<table width="97%" cellspacing="0" cellpadding="0" align="center">

    <tr>
    <td width="140" class="regular"><b>Format:</b></td>
    <td>
        <table border="0" cellspacing="0" cellpadding="0">
		<tr><td class="regular">
		    <input type="radio" name="filetype" value="Adobe PDF" checked>Adobe PDF
		    <input type="radio" name="filetype" value="Microsoft Word">Microsoft Word
		</td></tr>
		</table>
    </td>
	</tr>

    <tr><td height="5" class="regular"></td></tr>
  
    <tr>
    <td width="140" valign="top" class="regular"><b>Report format:</b></td>
    <td valign="top">
	    <table border="0" cellspacing="0" cellpadding="0">
        <cfoutput query="Reports">
		<tr><td class="regular">
          <input type="radio" name="report_file" value="#ControlNo#" checked><b>#FunctionMemo#</b>
        </td></tr>
		</cfoutput>
		</table>
    </td>
	</tr>
	
	<tr><td height="3"></td></tr>
	<tr><td class="regular"></td><td class="regular">&nbsp;&nbsp;&nbsp;&nbsp;The layout of the report you want to prepare.<td></tr>
	<tr><td height="5" class="regular"></td></tr>
	
    <tr>
    <td valign="top" class="regular"><b>Field Mission:</b></td>
    <td valign="top" class="regular">
	
    <!---cfselect name="pm_Mission" required="Yes">
	  <cfoutput query="Mandate">
	    <option value="#Mission#">#Mission#</option> 
	  </cfoutput>
	</cfselect--->

    <CF_TwoSelectsRelated
	QUERY="Mandate"
	NAME1="pm_Mission"
	NAME2="pm_MandateNo"
	DISPLAY1="Mission"
	DISPLAY2="MandateNo"
	VALUE1="Mission"
	VALUE2="MandateNo"
	SIZE1="1"
	SIZE2="1"
	AUTOSELECTFIRST="Yes"
	FORMNAME="pdf">	
		  	  
    </td>
	</tr>	
	<tr><td height="3"></td></tr>
	<tr><td class="regular"></td><td class="regular">&nbsp;&nbsp;&nbsp;&nbsp;The mission you want to select.</td></tr>
	<tr><td height="5"></td></tr>
	
	<tr>
	  <td class="regular"><b>Authorized post types:</b></td>
	  <td class="regular">	
	  <cfselect name="pm_PostType" required="Yes">
	  <cfoutput query="AuthorizedPostType">
	    <option value="#PostType#">#PostType#</option> 
	  </cfoutput>
	  </cfselect>	
	  </td>
	</tr>
	<tr><td height="3"></td></tr>
	<tr><td class="regular"></td><td class="regular">&nbsp;&nbsp;&nbsp;&nbsp;The posts types you are authorized to select.</td></tr>
	<tr><td height="5"></td></tr>

	<tr>
	    <td valign="top" class="regular"><b>Expected rotation start date:</b></td>
    	<td valign="top" class="regular">	
   	   		<cf_intelliCalendarDate
			FieldName="pm_StartDate" 
			Default="today"
			AllowBlank="False">
		</td>
	</tr>
	<tr><td height="3"></td></tr>
	<tr><td class="regular"></td><td class="regular">&nbsp;&nbsp;&nbsp;&nbsp;Earliest expected rotation date. Use dd/mm/yyyy format.</td></tr>
	<tr><td height="5"></td></tr>

	<tr>
	    <td valign="top" class="regular"><b>Expected rotation end date:</b></td>
    	<td valign="top" class="regular">	
   	   		<cf_intelliCalendarDate
			FieldName="pm_EndDate" 
			Default="today"
			AllowBlank="False">
		</td>
	</tr>
	<tr><td height="3"></td></tr>
	<tr><td class="regular"></td><td class="regular">&nbsp;&nbsp;&nbsp;&nbsp;Latest expected rotation date. Use dd/mm/yyyy format.</td></tr>
	<tr><td height="5"></td></tr>

</table>
</td></tr>
</table>
</td></tr>
<tr><td height="24" align="right" valign="middle" class="topN">
<input type="button" value="Prepare report" name="Submit" onclick="javascript:assign()">&nbsp;

</td></tr>

   <tr><td height="7"></td></tr>

<tr>
<td height="24" valign="middle" class="BannerN"><font face="Trebuchet MS" size="2"><b>&nbsp;My report(s):</b></font></td>
</tr>


<tr><td>

	
	<iframe src="../../../Tools/PDF/PDFLibrary.cfm?ID=Staffing" name="inline" id="inline" width="100%" height="180" frameborder="0" style="border: thin"></iframe>		

</td>
</tr>

</table>

</cfform> 

</BODY></HTML>