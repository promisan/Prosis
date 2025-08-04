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

<cf_screentop height="100%" scroll="no" jquery="Yes" html="No">

<cfajaximport>

<script language="JavaScript">

	function createXMLHttpRequest() {
				if (window.ActiveXObject) {
					xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
				} 
				else if (window.XMLHttpRequest) {
					xmlHttp = new XMLHttpRequest();
				}
			}
	
</script>			

<cfparam name="URL.Error" default="0">

<cfquery name="Section" 
datasource="AppsEPAS" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
    SELECT *
    FROM   Ref_ContractSection
	WHERE  Code = '#URL.Section#'
</cfquery>

<cfinclude template="setBehavior.cfm">

<cfform action="BehaviorSubmit.cfm?Contractid=#URL.Contractid#&Section=#URL.Section#&Code=#URL.Code#" method="POST" name="entry">

<table width="100%" height="100%" align="center" bgcolor="ffffff" border="0" cellspacing="0" cellpadding="0">

<tr><td valign="top" height="100%">

	<cf_divscroll>

	<table width="100%" border="0" align="center" cellspacing="0" cellpadding="0" class="formpadding">
	
	<cfoutput>
	<tr>
     <td class="labellarge"><img src="#SESSION.root#/Images/Logos/PAS/Criteria-on.png" height="64" alt="" border="0" align="absmiddle" style="margin-left: 20px;float: left;"><h1 style="padding-left:5px;font-size:30px;font-weight:200;float: left;margin:10px 0 0;">#Section.Description#</h1></td>	
    </tr> 	
	</cfoutput>	
	
	<cfif URL.Error eq "1">
		<tr class="labelit linedotted">
	    <td  height="25" align="center" valign="middle">
		&nbsp;<cfoutput><cf_interface cde="BehaviorError">
		<img src="#SESSION.root#/Images/Activity_stop.gif" alt="#Name#" border="0" align="absmiddle">
		&nbsp;&nbsp;
		<font color="FF0000"><b>#Name#</cfoutput></font>
		</td>
		</tr>
			
	</cfif>
			
	<tr><td>
	
		<cfquery name="Class" 
		 datasource="appsEPAS" 
		 username="#SESSION.login#" 
		 password="#SESSION.dbpw#">
			  SELECT   *
			  FROM     Ref_BehaviorClass
			  WHERE    Operational = '1'
			  ORDER BY ListingOrder
		</cfquery>
		
		  <table width="100%" border="0" cellspacing="0" cellpadding="0" class="formpadding">
				
				<cfoutput query="Class">
								
				<tr class="line">								
				<td width="95%" style="padding-left:30px;font-size:25px" class="labelmedium">
				<h1 style="font-size:20px;height:25px;padding:2px 3px 0;font-weight: 200;">#Code#. #Description#</h1></td>
				</tr>
									 
				<tr bgcolor="ffffff">
				    <td width="100%" colspan="2" id="#code#" align="center" style="padding-left:30px;padding-right:30px">
					
										
					<script language="JavaScript">
					
					function show#code#(code) {
						createXMLHttpRequest()
						xmlHttp.onreadystatechange = #code#show;
						url = "BehaviorShow.cfm?ID2="+code										
						xmlHttp.open("GET", url, true);
						xmlHttp.send(null);
					}
					
					function #code#show() {
						if(xmlHttp.readyState == 4) {
								if(xmlHttp.status == 200) {
								    document.getElementById("#code#_row").className = "regular";
									document.getElementById("#code#_desc").innerHTML = xmlHttp.responseText;
								  }
							 }
						}
					
					function delete#code#(code) {
						createXMLHttpRequest()
						xmlHttp.onreadystatechange = #code#handleStateChange;
						url = "BehaviorRecordDelete.cfm?ts="+new Date().getTime()+
						"&contractid=#URL.ContractID#&Class=#Code#&ID2="+code										
						xmlHttp.open("GET", url, true);
						xmlHttp.send(null);
					}
					
					function edit#code#(code) {
						createXMLHttpRequest()
						xmlHttp.onreadystatechange = #code#handleStateChange;
						url = "BehaviorRecord.cfm?ts="+new Date().getTime()+
						"&contractid=#URL.ContractID#&Class=#Code#&ID2="+code										
						xmlHttp.open("GET", url, true);
						xmlHttp.send(null);
					}
															
					function add#code#(act) {
					      
						createXMLHttpRequest();
						xmlHttp.onreadystatechange = #code#handleStateChange;
						old  = document.getElementById("#code#_BehaviorCodeOld");
						code = document.getElementById("#code#_BehaviorCode");
						desc = document.getElementById("#code#_BehaviorDescription");
						prio = document.getElementById("#code#_PriorityCode");
						trai = document.getElementById("#code#_Training");
						
						vOld = '';
						vCode = '';
						vDesc = ''
						vPrio = ''
						vTrai = '';
						
						if (old) { vOld = old.value; }
						if (code) { vCode = code.value; }
						if (desc) { vDesc = desc.value; }
						if (prio) { vPrio = prio.value; }
						if (trai) { vTrai = trai.checked; }
						
						url = "BehaviorRecordSubmit.cfm?ts="+new Date().getTime()+
						"&contractid=#URL.ContractID#&Class=#Code#&BehaviorCode="+vCode+
						"&BehaviorCodeOld="+vOld+
						"&BehaviorDescription="+vDesc+
						"&PriorityCode="+vPrio+
						// "&Training="+vTrai+
						"&id2="+act	
						xmlHttp.open("GET", url, true);
						xmlHttp.send(null);
							
						}	
																
					function #code#handleStateChange()
					    {
						if(xmlHttp.readyState == 4) {
								if(xmlHttp.status == 200) {
									document.getElementById("#code#").innerHTML = xmlHttp.responseText;
								  }
							 }
						}
																										
					</script>	
										
					<cfset URL.Class = "#Code#">
										
					<cfinclude template="BehaviorRecord.cfm">
							  
					</td>
				</tr>
							
				 <tr><td height="5"></td></tr>
				
				</cfoutput>	 
							
			</table>

	</td></tr>

	</table>
	
	</cf_divscroll>
	
	</td></tr>
	
	<tr><td height="30" align="center">
						
	<cfif getAdministrator("#Contract.Mission#") eq "1">
		<cfset reset = "1">
	<cfelse>
		<cfset reset = "0">	
	</cfif>
		
	 <cf_Navigation
		 Alias         = "AppsEPAS"
		 Object        = "Contract"
		 Group         = "Contract"
		 Section       = "#URL.Section#"
		 Id            = "#URL.ContractId#"
		 BackEnable    = "1"
		 HomeEnable    = "0"
		 ResetEnable   = "#reset#"
		 ResetDelete   = "0"	
		 ProcessEnable = "0"
		 NextEnable    = "1"
		 NextSubmit    = "1"
		 SetNext       = "0"
		 NextMode      = "0">		 
	  
	</td></tr>
	
</table>
	    

</cfform>	  