<!--- Jg added ClaimAudit table structure
Table fields are JG just for reference
SELECT     Claimid, ClaimRequestId, TCP_DocumentNo, f_tvrq_doc_id, PersonNO, Operational, Descr, Audit_status, Userid, Created, updated, ClaimidAuditid, 
                      Grade_IMIS, ClaimAsis, Status_IMIS, EO_Orgunit, EO_Name
FROM         ClaimAudit



SELECT     ClaimidAuditid, seq_num, Comments, Description, Supp_Tvcv_num, created, updated, userid, Supp_rec_num
FROM         ClaimAuditLine AS A

--->


<cfparam name="URL.Id" default="{00000000-0000-0000-0000-000000000000}">
<cfparam name="URL.SEQ" default="0">
<cfquery name="Get" 
	datasource="AppsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT CL.ClaimidAuditid, CL.seq_num, CL.Comments, CL.Description, CL.Supp_Tvcv_num, CL.created, CL.updated, CL.userid, 
	CL.Supp_rec_num ,HDR.claimid,HDR.TCP_Documentno,HDR.f_tvrq_doc_id,HDR.Audit_status,CL.addt_amount
	FROM ClaimAuditline CL,ClaimAudit HDR
	where HDR.ClaimidAuditid =CL.ClaimidAuditid
	and  HDR.claimidauditid ='#URL.Id#' 
	and CL.seq_num ='#URL.SEQ#' 
	ORDER BY seq_num desc
</cfquery>

<cfquery name="GetHeader" datasource="AppsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#" >
	
	SELECT HDR.*,PRSN.IndexNo as IndexNo,PRSN.fullname
	FROM ClaimAudit HDR,stperson PRSN
	where 
	  HDR.claimidauditid ='#URL.Id#' 
	  and HDR.personno =PRSN.personno
	
	
</cfquery>


<cfif #Get.Recordcount# eq "0">

	<cfset mode = "Insert">
	<cfset variable_mode ="">
	<cfquery name="Get" 
		datasource="AppsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT TOP 1 *
		FROM  ClaimAuditLine where 1=2
		ORDER BY Created DESC
	</cfquery>

<cfelse>

	<cfset mode = "Modify">
    <cfset variable_mode ="Readonly">
</cfif>

<cf_ajaxRequest>	

<cfoutput>
<!--- Jg added ClaimAudit table structure
Table fields are JG just for reference
SELECT     Claimid, ClaimRequestId, TCP_DocumentNo, f_tvrq_doc_id, PersonNO, Operational, Descr, Audit_status, Userid, Created, updated, ClaimidAuditid, 
                      Grade_IMIS, ClaimAsis, Status_IMIS, EO_Orgunit, EO_Name
FROM         ClaimAudit



SELECT     ClaimidAuditid, seq_num, Comments, Description, Supp_Tvcv_num, created, updated, userid, Supp_rec_num
FROM         ClaimAuditLine AS A

--->
<HTML><HEAD>
	<TITLE>Claim Audit #Mode#</TITLE>
</HEAD>
<body leftmargin="5" topmargin="5" rightmargin="5" bottommargin="5" onLoad="window.focus()">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
		
<script language="JavaScript">

function clearForm(oForm) {
    
  var elements = oForm.elements; 
    
  oForm.reset();

  for(i=0; i<elements.length; i++) {
      
  field_type = elements[i].type.toLowerCase();
  
  switch(field_type) {
  
    case "text": 
    case "password": 
    case "textarea":
    case "hidden":   
      
      elements[i].value = ""; 
      break;
        
    case "radio":
    case "checkbox":
        if (elements[i].checked) {
          elements[i].checked = false; 
      }
      break;

    case "select-one":
    case "select-multi":
                elements[i].selectedIndex = -1;
      break;

    default: 
      break;
  }
    }
}



    function doit(action) {
	
		Comments = document.getElementById("Comments").value
		Description   = document.getElementById("Description").value
		Supp_tvcv_num    = document.getElementById("Supp_tvcv_num").value
		Supp_rec_num   = document.getElementById("Supp_rec_num").value
        claimidauditid= document.getElementById("claimidauditid").value
		seq_num= document.getElementById("seq_num").value
		addt_amount= document.getElementById("addt_amount").value
		
		myaction = action
		url = "RecordSubmit.cfm?ts="+new Date().getTime()+
		             "&Comments="+Comments+
					 "&Description="+Description+
					 "&Supp_tvcv_num="+Supp_tvcv_num+
					 "&Supp_rec_num="+Supp_rec_num+
					 "&claimidauditid="+claimidauditid+
					 "&seq_num="+seq_num+
					 "&addt_amount="+addt_amount+
					 "&action="+action;
					 
		
		AjaxRequest.get({
	        'url':url,
	        'onSuccess':function(req){ 
		document.getElementById("result").innerHTML = req.responseText;
		if (document.getElementById("action").value == "1") {
				goback()
			}		
		},
						
	        'onError':function(req) { 
		document.getElementById("result").innerHTML = req.responseText;}	
	         }
		 );			
		 
		} 		
	
		function goback()
		{
		self.returnValue = "go"
		self.close();
		}
		

</script>

</cfoutput>

<cfform action="" method="POST" name="dialog">


<cfoutput>

<input type="hidden"   name="ClaimidAuditid" value="#URL.ID#" >
<input type="hidden" name="seq_num" value="#URL.seq#">
<input type="hidden" name="Description" >
<cfif GetHeader.recordcount GT "0" >
<table>
<cfloop query="Getheader"> 

<tr>
 
<td colspan="3"> <b>Travel-DocId: <em>#f_tvrq_doc_id#</em> </b></td>
  
<td colspan="5"></td>
<td></td>
<td> <b>IndexNo: <em>#Indexno#  #fullname#</em></b></td>
<td></td>
<td> <b>ClaimStatus: <em>#status_IMIS#</em></b></td> 
</tr>
</cfloop> 
</table>
<table><tr><td height="1" bgcolor="EAEAEA"></td></tr></table>
</cfif>

<cf_dialogTop text="#MODE#">


<!--- Entry form --->
<!---
SELECT CL.ClaimidAuditid, CL.seq_num, CL.Comments, CL.Description, CL.Supp_Tvcv_num, CL.created, CL.updated, CL.userid, 
	CL.Supp_rec_num ,HDR.claimid,HDR.TCP_Documentno,HDR.f_tvrq_doc_id,HDR.Audit_status
	FROM ClaimAuditline CL,ClaimAudit HDR
	where HDR.ClaimidAuditid =CL.ClaimidAuditid
	and  HDR.claimid ='#URL.Id#'
--->
<table><tr><td height="1" bgcolor="EAEAEA"></td></tr></table>
<tr>
<td></td>
</tr>
<table width="95%" cellspacing="2" cellpadding="1" align="center">

    <TR>
	
	
	<TR>
	<TD>Audit Comments:</TD>
    <TD>
	<textarea  name="Comments" cols="30" rows="3"><cfoutput>#Get.Comments#</cfoutput></textarea>
	<!---
  	   <cfinput style="text-align: center;" 
	     type="Text" value="#Get.comments#" 
		 name="Comments" 
		 range="2000,2020" message="Please enter the Comments" required="Yes" visible="Yes" enabled="Yes" size="4" maxlength="4" class="regular">
		 --->
    </TD>
	<td></td>
	</TR>
	<!---
	<TR>
	
    <TD>Audit Description:</TD>
    <TD>
	<textarea  name="Description" cols="30"  rows="3" ><cfoutput>#Get.Description#</cfoutput> </textarea>
	<!---
  	   <cfinput style="text-align: center;" 
	     type="Text" value="#Get.comments#" 
		 name="Comments" 
		 range="2000,2020" message="Please enter the Comments" required="Yes" visible="Yes" enabled="Yes" size="4" maxlength="4" class="regular">
		 --->
    </TD>
	</TR>
	--->
	<TR>
    <td>Supplimental TVCV number:</td>
    <TD>
  	   <cfinput style="text-align: center;"  type="text" name="Supp_tvcv_num" value="#Get.Supp_tvcv_num#" message="Please enter Supplimental TVCV number" required="NO" size="15" maxlength="20" class="regular">
    </TD>
	</TR>
	<TR>
    <td>Supplimental Receivable number:</td>
    <TD>
  	   <cfinput style="text-align: center;" type="text" name="Supp_rec_num" value="#Get.Supp_rec_num#" message="Please enter Supplimental Receivable number" required="NO" size="15" maxlength="20" class="regular">
    </TD>
	</TR>
	<TR>
    <td>Additional Amount Paid/Recovered:</td>
    <TD>
  	   <cfinput style="text-align: center;" type="text" name="addt_amount" value="#Get.addt_amount#" message="Please enter Additional Amount Reced/ Recovered" required="NO" size="15" maxlength="20" class="regular">
    </TD>
	</TR>
	
	<!---
	<TR style="display:none;">
	
    <TD>Date Updated :</TD>
    <TD>
	 <cfinput style="text-align: center;" type="text" passthrough = "#variable_mode#"  name="Updated" value="#Get.updated#" message="Please enter Description of Auditing" required="Yes" size="15" maxlength="22" class="regular">
	<!---
	 <cfif #get.updated# eq "">
	 
	  <cf_intelliCalendarDate
		FieldName="dateeffective" 
		Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
		Class="regular"
		AllowBlank="False">	
	 
	 <cfelse>
	 
	  <cf_intelliCalendarDate
		FieldName="dateeffective" 
		Default="#Dateformat(get.DateEffective, CLIENT.DateFormatShow)#"
		Class="regular"
		AllowBlank="False">	
	 
	 </cfif>
	--->
	</TD>
	</TR>
	--->
	<!---	
	<TR>
    <TD>Portal status</TD>
    <TD>
	   <input type="radio" name="stat" value="1" onClick="javascript:pap('1')" <cfif #get.Status# neq "0">checked</cfif>>Accept
	   <input type="radio" name="stat" value="0" onClick="javascript:pap('0')" <cfif #get.Status# eq "0">checked</cfif>>Deny
    </TD>
	</TR>
	
	<input type="hidden" name="status" value = "<cfif #get.Status# neq "0">1<cfelse>0</cfif>">
 	--->
	<script language="JavaScript">
	
	function pap(val) {
	
	if (val == "1") {
		document.getElementById("default").className = "regular"
		document.getElementById("status").value = "1"
		}
	else {
		document.getElementById("default").className = "hide"
		document.getElementById("defaultaccount").value = ""
		document.getElementById("status").value = "0"
	}
	
	}
		
	</script>
	<!---	
	<cfif get.Status eq "1">
	 <cfset cl = "regular">
	<cfelse>
	 <cfset cl = "hide"> 
	</cfif>
	
	<TR id="default" class="#cl#">
    <TD>Default PAP</TD>
    <TD height="25">
	  <table width="100%" cellspacing="0" cellpadding="0">
	  <tr><td>
	  <input type="text" style="text-align: center;" value="#get.DefaultAccount#" name="defaultaccount" size="8" maxlength="8" class="regular">	  
	  For current PAP, keep value blank</td>
	  </tr>
	  </table>
	</TD>
	</TR>

	<TR>
    <TD>Remarks</TD>
    <TD>
	   <input type="text" value="#get.Remarks#" name="remarks" size="40" maxlength="40" class="regular">
	</TD>
	</TR>
	---->
	<tr><td  colspan="2" id="result"></td></tr>
	
</table>

<table width="100%">
<tr><td height="7"></td></tr>
<tr><td height="1" bgcolor="silver"></td></tr>
<tr><td height="7"></td></tr>
</table>

<table>
<cfoutput> 
			 <cfinclude template="./claimInquiryAdditionalAttachment.cfm">
</cfoutput>
</table>
<table width="100%" align="center">	
		
	<td align="center">
	
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="goback()" >
	<cfif mode eq "insert">
    	<input class="button10g"  type="button" name="Insert" value=" Add " onclick="doit('insert')">
		
	<cfelse>
	 	<input class="button10g" type="hidden" name="Insert" value=" Delete " onclick="doit('delete')" >
		
		<input class="button10g" type="button" name="Insert" value=" Save " onclick="doit('modify')">
	</cfif>
	
 
	
	</td>	
	

	
</TABLE>

<!--- JG Audit hiddent the delete button since I did not want to show it up and also added clearform to clear
		everything in the form if the need be.
		<input class="button10g" type="button" name="Insert" value=" Delete " onclick="doit('delete')" >
		<input type="button" name="clear" class="button10g" value="Clear Form" onclick="clearForm(this.form);">
--->
</cfoutput>

</CFFORM>

</BODY></HTML>