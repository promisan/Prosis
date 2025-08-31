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
<cf_tl id="Select Ledger Account" var="gla">

<cf_screentop layout="webapp" html="No" height="100%" jQuery="Yes" user="no" line="no" label="#gla#" scroll="yes" banner="gray">

<cfparam name="URL.IDParent" default="">
<cfparam name="URL.Crit"     default="">
<cfparam name="URL.Journal"  default="">
<cfparam name="URL.Field"    default="">
<cfparam name="URL.Filter"   default="">
<cfparam name="URL.Mode"     default="">
<cfparam name="URL.Script"   default="">

<cfif url.filter eq "undefined">
     <cfset url.filter = "">
</cfif>

<cfif url.filter neq "">
		
		<cfset fil = "">
	    <cfloop index="itm" list="#url.filter#" delimiters="|">
	   
		   <cfif fil eq "">
		      <cfset fil = "'#itm#'">
		   <cfelse>
		      <cfset fil = "#fil#,'#itm#'">	  
		   </cfif>
	   	  
	    </cfloop>	
		
</cfif>

<cfquery name="Parent" 
datasource="AppsLedger" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT * 
    FROM Ref_AccountParent 
	<cfif url.filter neq "" and url.field eq "parent">
	WHERE AccountParent IN (SELECT AccountParent 
	                        FROM   Ref_AccountGroup 
							WHERE  AccountGroup IN (
						                         SELECT AccountGroup 
												 FROM Ref_Account 
												 WHERE AccountParent IN (#preservesingleQuotes(fil)#)
												 )
 						   )
	</cfif>
	
</cfquery>

<cf_dialogLedger>
	
<CFOUTPUT>	

<cf_systemscript>

<script>

_cf_loadingtexthtml='';	

function reloadForm() {
    
	_cf_loadingtexthtml='';	
	Prosis.busy("yes");
	crit = document.getElementById("find").value;
	par  = document.getElementById("parent").value;	
	url  = "AccountSelectDetail.cfm?idparent="+par+
			"&crit="+crit+
			"&mode=#url.mode#"+
			"&field=#url.field#"+
			"&journal=#url.journal#"+
			"&filter=#url.filter#"+
			"&mission=#URL.mission#";
			
	ptoken.navigate(url,'selection'); 		
	 
}
  
function clearno() { 
	document.getElementById("find").value = ""; 
}

function search() {
	
	se = document.getElementById("find");
	 
	if (window.event.keyCode == "13") {
	   reloadForm()
	}		
			
}

function selected(acc,tpe,des,frc) {		
	se  = acc+";"+des+";"+tpe+";"+frc;	
	if (se != "") {
		self.returnValue = se;
	}else {
		self.returnValue = "blank";
	}
	self.close();	
}

function setvalue(acc) {
    		
    <cfif url.script neq "">
		
		try {		
			parent.#url.script#(acc,'#url.scope#','#url.field#');				
		} catch(e) {}
	
    </cfif>	
	
	parent.ProsisUI.closeWindow('glaccountwindow')
		
}		

</script>
</CFOUTPUT>

<table width="99%" height="99%" align="center">

  <tr class="line">
  
  <td height="30">  
  	
  <table cellspacing="0" cellpadding="0" class="formpadding"><tr>
  <td style="padding-left:8px" class="labelit"><cf_tl id="Find">:</td>
  <td bgcolor="white" style="padding-left:6px;">
  
	  <cfoutput>
	  
		  <input type="text"
		       name      = "find"
			   id        = "find"
		       size      = "25"
			   value     = ""
			   onClick   = "javascript:clearno()" 
			   onKeyUp   = "javascript:search()"
		       maxlength = "24" 
			   style     = "border: 1px solid Silver;height:25px;font-size:14px;width:100;padding:3px"
		       class     = "regular3">
		   
				
	  </cfoutput>

  </td></tr></table>
  
  </td>
  <td align="right" style="padding-right:6px">
    <select name="parent" id="parent" class="regularxl"	accesskey="P" title="Parent Selection" onChange="reloadForm(this.value)">
	<option value = "">All</option>
     <cfoutput query="Parent">
	   <!---
	   <cfif find(AccountParent,url.filter) or url.filter eq "">
	   --->
	   		<option value="#AccountParent#" <cfif AccountParent is URL.IDParent>selected</cfif>>
			    #AccountParent# #Description#
			</option>
	   <!---   </cfif> --->
	</cfoutput>
    </select>
  </td>
   
  <tr>
  <td height="100%" valign="top" colspan="2" style="padding:10px"> 
	 <cf_divscroll>
	     <cf_securediv style="height:100%" bind="url:AccountSelectDetail.cfm?mode=#url.mode#&field=#url.field#&filter=#url.filter#&mission=#url.mission#&journal=#url.journal#" id="selection">   
	 </cf_divscroll>
  </td>
  </tr>
    
</table>

<cf_screenbottom layout="webdialog">
