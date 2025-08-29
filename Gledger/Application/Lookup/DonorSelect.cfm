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
<cf_screentop height="100%" label="Contribution select" html="No" scroll="Yes" close="parent.ColdFusion.Window.destroy('mydonor',true)" line="no" jquery="Yes" banner="gray" layout="webapp">

<cfparam name="URL.Crit"            default="">
<cfparam name="URL.Journal"         default="">
<cfparam name="URL.JournalSerialNo" default="">
<cfparam name="URL.ProgramCode"     default="">
<cfparam name="URL.Fund"            default="">
<cfparam name="URL.Selected"        default="">

<!--- get the information of the contet of the transaction itself to be mapped --->

 <cfquery name="getTransaction" 
	datasource="AppsLedger" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   *
	FROM     TransactionHeader
	WHERE    Journal         = '#url.journal#'
	AND      JournalSerialNo = '#url.journalserialno#'		 	
</cfquery>
	
<CFOUTPUT>	
	
	<script>
	
	function reloadForm() {
	    	
		crit = document.getElementById("find").value
		// per  = document.getElementById("period").value	
		// par  = document.getElementById("parent").value	
		url  = "DonorSelectDetail.cfm?ts="+new Date().getTime()+		      
				"&crit="+crit+
				"&journal=#url.journal#"+
				"&journalserialno=#url.journalserialno#"+
				"&selected=#url.selected#"+
				"&fund=#url.fund#"+
				"&programcode=#url.programcode#"
		 ptoken.navigate(url,'selection')				 
	}
	  
	function clearno() { document.getElementById("find").value = "" }
	
	function search() {
	
		 se = document.getElementById("find")	
		 if (window.event.keyCode == "13")
			{	document.getElementById("locate").click() }					
	    }
		
	
	function setvalue(acc) {	    
		
	    <cfif url.script neq "">
			
			try {
				parent.#url.script#(acc,'#url.scope#');	
			} catch(e) {}
		
	    </cfif>	
		
		parent.ProsisUI.closeWindow('mydonor')
				
	}			
		
	</script>
	
</CFOUTPUT>

<table width="100%" border="0" height="100%" 
   style="padding-left:3px;padding-bottom:3px;padding-right:3px" cellspacing="0" cellpadding="0" align="center">

  <tr><td height="3"></td></tr>

  <tr>

  <td height="24">
	  <table>	  
	  <tr><td height="4"></td></tr>	  
	  <tr>
	  <td style="padding-left:10px"></td>	  
	  <td bgcolor="white" style="border: 1px solid Silver;">
	 
	 	<table>
		<tr><td style="height:20px">
		
	 	 <cfoutput>
	  
		  <input type="text"
	       name="find" id="find" style="border:0px"
	       size="26"
		   value=""
		   onClick="javascript:clearno()" onKeyUp="javascript:search()"
	       maxlength="25"
	       class="regularxl">
		   
		   </td>
		   
		   <td style="width;20px;padding:2px;border-left: 1px solid Silver;">
		   
		    <img src="#SESSION.root#/Images/locate3.gif" 
					  alt         = "Search" 
					  name        = "locate" 
					  onMouseOver = "document.locate.src='#SESSION.root#/Images/button.jpg'" 
					  onMouseOut  = "document.locate.src='#SESSION.root#/Images/locate3.gif'"
					  style       = "cursor: pointer;" 				 
					  border      = "0" 
					  height      = "15" width="15"
					  align       = "absmiddle" 
					  onclick     = "reloadForm()">
			
		  </cfoutput>
		  
		  </td>
		  </tr>		 	  
		  </table>
		  
		 </tr>		 
		 <tr><td height="4"></td></tr>
		
	  </table>
  
  </td>
 
  
  <!---
  
  <td>
  
   <cfquery name="period" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   DISTINCT Period
	FROM     Program P INNER JOIN
             ProgramPeriod Pe ON P.ProgramCode = Pe.ProgramCode
	WHERE    P.Mission = '#URL.Mission#' 
	<cfif url.period neq "">	
	AND (Pe.Period IN
                     (SELECT    Period
                      FROM     Organization.dbo.Ref_MissionPeriod
                      WHERE    Mission = '#URL.Mission#' AND (AccountPeriod = '#URL.Period#' or MandateNo = '#URL.Period#'))
		OR Pe.Period = '#URL.Period#')			  
	</cfif>						
    </cfquery>
		
	  <select name="period" 
	style="background: font-style: normal; border: thin none; font-family: Verdana; font-stretch: normal; font-weight: bold; color: black;" accesskey="P" title="Parent Selection" onChange="javascript:reloadForm(this.value)">
	<option value = "">All</option>
     <cfoutput query="Period">
	<option value="#Period#">
	    #Period#
	</option>
	</cfoutput>
    </select>
      
  </td>  
  
  <td align="right">
  
  <cfquery name="parent" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	SELECT   DISTINCT ProgramClass
	FROM     Program P INNER JOIN
             ProgramPeriod Pe ON P.ProgramCode = Pe.ProgramCode
	WHERE    P.Mission = '#URL.Mission#' 
	<cfif url.period neq "">	
	AND (Pe.Period IN
                     (SELECT    Period
                      FROM     Organization.dbo.Ref_MissionPeriod
                      WHERE    Mission = '#URL.Mission#' AND (AccountPeriod = '#URL.Period#' or MandateNo = '#URL.Period#'))
		OR Pe.Period = '#URL.Period#')			  
	</cfif>						
    </cfquery>
	  
    <select name="parent" 
	style="background: font-style: normal; border: thin none; font-family: Verdana; font-stretch: normal; font-weight: bold; color: black;" accesskey="P" title="Parent Selection" onChange="javascript:reloadForm(this.value)">
	<option value = "">All</option>
     <cfoutput query="Parent">
	<option value="#ProgramClass#">
	    #ProgramClass#
	</option>
	</cfoutput>
    </select>	
  </td>
  
  --->
   
  <tr>
  <td height="100%" width="97%" align="center" valign="top" colspan="3" id="selection">
    
	 <script>
	     reloadForm('')
	 </script>
		
  </td>
  </tr>
  
</table>

<cf_screenbottom layout="webapp">
