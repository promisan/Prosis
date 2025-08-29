<!--
    Copyright © 2025 Promisan B.V.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
-->
<cfparam name="URL.Id" default="{00000000-0000-0000-0000-000000000000}">

<cfquery name="Get" 
	datasource="AppsTravelClaim" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT *
	FROM  stFundStatus
	WHERE ValidationId = '#URL.Id#'
</cfquery>

<cfif #Get.Recordcount# eq "0">

	<cfset mode = "Insert">

	<cfquery name="Get" 
		datasource="AppsTravelClaim" 
		username="#SESSION.login#" 
		password="#SESSION.dbpw#">
		SELECT TOP 1 *
		FROM  stFundStatus
		ORDER BY Created DESC
	</cfquery>

<cfelse>

	<cfset mode = "Modify">

</cfif>

<cf_ajaxRequest>	
<cf_calendarScript>

<cfoutput>

<HTML><HEAD>
	<TITLE>Funding Validation #Mode#</TITLE>
</HEAD><body leftmargin="5" topmargin="5" rightmargin="5" bottommargin="5" onLoad="window.focus()">
<link rel="stylesheet" type="text/css" href="<cfoutput>#SESSION.root#/#client.style#</cfoutput>">
		
<script language="JavaScript">

    function doit(action) {
	
		fundtype = document.getElementById("fundtype").value
		period   = document.getElementById("period").value
		date     = document.getElementById("dateeffective").value
		status   = document.getElementById("status").value
		pap      = document.getElementById("defaultaccount").value
		remarks  = document.getElementById("remarks").value
		id       = document.getElementById("id").value
		
		myaction = action
		url = "RecordSubmit.cfm?ts="+new Date().getTime()+
		             "&fundtype="+fundtype+
					 "&period="+period+
					 "&date="+date+
					 "&status="+status+
					 "&pap="+pap+
					 "&remarks="+remarks+
					 "&id="+id+
					 "&action="+action;
		
		AjaxRequest.get({
	        'url':url,
	        'onSuccess':function(req){ 
		document.getElementById("result").innerHTML = req.responseText;
		goback()
		},
						
	        'onError':function(req) { 
		document.getElementById("result").innerHTML = req.responseText;
			}	
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

<input type="hidden" name="id" id="id" value="#URL.ID#">

<cf_dialogTop text="#MODE#">

<!--- Entry form --->

<table><tr><td height="1" bgcolor="EAEAEA"></td></tr></table>

<table width="95%" cellspacing="2" cellpadding="1" align="center">

    <TR>
    <td>Fund-type:</td>
    <TD>
  	   <cfinput style="text-align: center;" type="text" name="fundtype" value="#Get.FundType#" message="Please enter a code" required="Yes" size="1" maxlength="1" class="regular">
    </TD>
	</TR>
	
	<TR>
    <TD>Period:</TD>
    <TD>
  	   <cfinput style="text-align: center;" 
	     type="Text" value="#Get.Period#" 
		 name="period" 
		 range="2000,2020" message="Please enter a  valid period = 2000-2020" required="Yes" visible="Yes" enabled="Yes" size="4" maxlength="4" class="regular">
    </TD>
	</TR>
			
	<TR>
    <TD>Date Effective:</TD>
    <TD>
	
	 <cfif #get.DateEffective# eq "">
	 
	  <cf_intelliCalendarDate9
		FieldName="dateeffective" 
		Default="#Dateformat(now(), CLIENT.DateFormatShow)#"
		Class="regular"
		AllowBlank="False">	
	 
	 <cfelse>
	 
	  <cf_intelliCalendarDate9
		FieldName="dateeffective" 
		Default="#Dateformat(get.DateEffective, CLIENT.DateFormatShow)#"
		Class="regular"
		AllowBlank="False">	
	 
	 </cfif>
	
	</TD>
	</TR>
		
	<TR>
    <TD>Portal status</TD>
    <TD>
	   <input type="radio" name="stat" id="stat" value="1" onClick="javascript:pap('1')" <cfif #get.Status# neq "0">checked</cfif>>Accept
	   <input type="radio" name="stat" id="stat" value="0" onClick="javascript:pap('0')" <cfif #get.Status# eq "0">checked</cfif>>Deny
    </TD>
	</TR>
	
	<input type="hidden" name="status" id="status" value = "<cfif #get.Status# neq "0">1<cfelse>0</cfif>">
 	
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
	  <input type="text" style="text-align: center;" value="#get.DefaultAccount#" name="defaultaccount" id="defaultaccount" size="8" maxlength="8" class="regular">	  
	  For current PAP, keep value blank</td>
	  </tr>
	  </table>
	</TD>
	</TR>

	<TR>
    <TD>Remarks</TD>
    <TD>
	   <input type="text" value="#get.Remarks#" name="remarks" id="remarks" size="40" maxlength="40" class="regular">
	</TD>
	</TR>
	
	<tr><td  colspan="2" id="result"></td></tr>
	
</table>

<table width="100%">
<tr><td height="7"></td></tr>
<tr><td height="1" bgcolor="silver"></td></tr>
<tr><td height="7"></td></tr>
</table>

<table width="100%" align="center">	
		
	<td align="center">
	
		<input class="button10g" type="button" name="Cancel" value=" Cancel " onClick="goback()">
	<cfif mode eq "insert">
    	<input class="button10g"  type="button" name="Insert" value=" Add " onclick="doit('insert')">
	<cfelse>
	 	<input class="button10g" type="button" name="Insert" value=" Delete " onclick="doit('delete')">
		<input class="button10g" type="button" name="Insert" value=" Save " onclick="doit('modify')">
	</cfif>
	
	</td>	
	
</TABLE>

</cfoutput>

</CFFORM>

</BODY></HTML>