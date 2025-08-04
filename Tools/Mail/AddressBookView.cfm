<!--
    Copyright © 2025 Promisan

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

<cf_screentop html="no" jquery="Yes">

<script language="JavaScript">
	
	function search() {
		se = document.getElementById("search")
		ptoken.navigate('AddressBookDetail.cfm?name='+se.value,'detail')
	}
	
	function mailto() {	
		parent.document.getElementById("sendTO").value  = document.getElementById("mailto").value
		parent.document.getElementById("sendCC").value  = document.getElementById("mailcc").value
		parent.document.getElementById("sendBCC").value = document.getElementById("mailbcc").value
		parent.ProsisUI.closeWindow('addressdialog')	
	}
	
	function gotosearch() {
		se = document.getElementById("Search")
		se.focus()
	}
	
	function check() {
		if (window.event.keyCode == "13") { search() }	
	}	
	
	function address(fld,val) {
		se =  document.getElementById(fld)
		if (se.value == "") {
		    se.value = val
		} else { se.value = se.value+","+val }
		}
	
</script>

<body bgcolor="white" leftmargin="0" topmargin="0" rightmargin="0" bottommargin="0" onLoad="javascript:gotosearch()">

<table bgcolor="white" width="100%" height="100%" border="0" cellspacing="0" cellpadding="0">

<tr><td style="padding:10px">
<table width="99%" align="center" height="100%" border="0" cellspacing="0" cellpadding="0" >
<tr>
<td colspan="2" height="35" class="labelit">
<table><tr>
<td style="padding-left:3px">
<input type="text" name="search" id="search" size="20" maxlength="45" class="regularxl" style="width:202px;" onKeyUp="check()">
</td>
<td>
	<input type="button" name="Search" id="Search" value="Search" style="height:25;width:60" onClick="javascript:search()">
</td>
</tr>
</table>
</td>

<td align="right" style="padding-right:4px">
   <table class="formpadding">
   <tr><td>
   
	    <input type="button" 
		       name="Cancel" 
			   id="Cancel"
			   class="button10g"
			   style="height:25;"
			   value="Cancel"
			   onclick="parent.ProsisUI.closeWindow('addressdialog')">
		   
		   </td>
		   
		   <td>
					  
	   <input type="button" 
	          name="OK" 
			  id="OK"
			  value="OK" 
			  style="height:25;"
			  class="button10g" 
			  onclick="mailto()">
		  
		  </td>
	</tr>	  
    </table>
				  		   
				   
   </td>
</td>
</tr>
<tr>
   <td width="53%" height="100%">
    <table width="98%" height="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr class="line">
	    <td height="15" valign="top">
		<table width="100%" bgcolor="ffffff" class="formpadding">
		<tr class="labelmedium">
	    <td align="center">&nbsp;To&nbsp;&nbsp;</td>
	    <td align="center">&nbsp;&nbsp;Cc&nbsp;&nbsp;</td>
		<td align="center">&nbsp;&nbsp;Bcc&nbsp;&nbsp;</td>
		<td width="10"></td>
		<td width="70%"><cf_tl id="Name"></td>
		</tr>
		</table>
	    </td>
	</tr>
		
	<tr>
	    <td valign="top" style="border-left: 0px solid silver; border-right: 0px solid silver;">
		  	<cf_divscroll id="detail"/>
	    </td>
	</tr>
    </table>
   </td>
   <td width="8"></td>
   <td valign="top" style="padding-top:10px">
   <table width="100%" cellspacing="0" cellpadding="0">
   <tr class="labelmedium"><td width="50" style="padding-top:5px;font-size:19px;height:40px">To:</td></tr>
   <tr>
       <td><textarea class="regularxl" style="font-size:16px;padding:2px" cols="50" rows="7" id="mailto" name="mailto"><cfoutput>#URL.TO#</cfoutput></textarea></td>
   </tr>
   <tr class="labelmedium"><td style="padding-top:5px;font-size:19px;height:40px">Cc:</td></tr>
   <tr>
       <td><textarea class="regularxl" style="font-size:16px;padding:2px" cols="50" rows="7" id="mailcc" name="mailcc"><cfoutput>#URL.CC#</cfoutput></textarea></td>
   </tr>
   <tr class="labelmedium"><td style="padding-top:5px;font-size:19px;height:40px">Bcc:</td></tr>
   <tr>
       <td><textarea class="regularxl" style="font-size:16px;padding:2px" cols="50" rows="7" id="mailbcc" name="mailbcc"><cfoutput>#URL.BCC#</cfoutput></textarea></td></tr>
   <tr><td height="10"></td></tr>
 
   </table></td>
   
</tr>
    
</table>
</td></tr>

</table>

