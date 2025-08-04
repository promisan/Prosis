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

<cfparam name="URL.Period" default=""> 
<cfparam name="URL.ProgramCode" default="">	
<cfparam name="URL.ProgramName" default="">	
<cfset CLIENT.Sort = "OrgUnit">

<cfquery name="Program" 
	datasource="AppsProgram" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
	 SELECT  *
	 FROM    Program P
	 WHERE   ProgramCode = '#URL.ProgramCode#'		 
</cfquery>

<cfif Program.ProgramAllotment eq "0">
	<table align="center"><tr><td height="50"><font face="Calibri" size="2"> <cf_tl id="This program has not been enabled for allotment (settings)" class="message"></td></tr></table>
    <cfabort>
</cfif>

 <cf_LanguageInput
	TableCode       = "Ref_ModuleControl" 
	Mode            = "get"
	Name            = "FunctionName"
	Key1Value       = "#url.SystemFunctionId#"
	Key2Value       = "#url.mission#"					
	Label           = "Yes">

<cf_screenTop height="100%" 
    title="#lt_content# #URL.Mission#" 		
	border="0"
	html="No"
	scroll="no" 	
	jQuery="Yes"
	MenuAccess="Yes"
	TreeTemplate="Yes"
	validateSession="Yes">
	
<cfajaximport tags="cfform">
	
<cfoutput>
		
<script language="JavaScript">
	
	function updateFund(fund) {		
		document.getElementById("FundSelect").value = fund
		<cfoutput>		
		parent.right.document.location.href = "#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"
		</cfoutput>
	}
	
	function updateGroup() {			  
	    se = document.getElementById("treeselect")					
		if (treeselect.value != "") {
		
				parent.right.ptoken.location('AllotmentViewGeneral.cfm?Period=' + document.getElementById('PeriodSelect').value + 
	                     '&Edition=' + parent.document.getElementById('edition').value + 
	                     '&ProgramGroup=' + document.getElementById('ProgramGroup').value +					
						 '&' + treeselect.value						 
				parent.right.Prosis.busy('yes')		 														
		} else {					
			parent.right.document.location.href = "#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"
		}				
	}
	
	function view(val,id) {
		count = 1					
		while (count != 10) {					  
		     try {				  
			   se = document.getElementById('viewmode'+count)	
			   se.className = "labelit" 
			} catch(e) {}
	    	count++		  
		}			
		se = document.getElementById('viewmode'+val)
		se.className = "labelmediumbold" 
		updateGroup()			    
	}
	
	function updatePeriod(per,mandate,sid) {			
		document.getElementById("PeriodSelect").value = per	
		document.getElementById("MandateNo").value  = mandate
		ptoken.navigate('AllotmentViewTree.cfm?Mission=#URL.Mission#&period='+per+'&systemfunctionid='+sid,'treebox')
	}
	
</script>	
 
<cf_LayoutScript>
		
<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>	
<cf_layout attributeCollection="#attrib#">	
	
	<cf_layoutarea 
	          position="top"
	          name="controltop"
	          minsize="50"
	          maxsize="50"  
			  type="Border"
			  size="50"    
			  overflow="hidden"    
	          splitter="true">				  
			  
		<cf_ViewTopMenu background="gradient" label="#lt_content# #URL.Mission#">
					 
	</cf_layoutarea>		 
	
	<cf_layoutarea 
	   position="left" 
	   name="treebox" 		   
	   maxsize="400" 
	   size="260" 	   
	   collapsible="true" splitter="true">
	
	        <cf_divscroll>
			<cfinclude template="AllotmentViewTree.cfm">		
			</cf_divscroll>
				
	</cf_layoutarea>
	
	<cf_layoutarea  position="center" name="box" style="height:99%" overflow="hidden">
		
			<iframe name="right" id="right" width="100%" height="99%" scrolling="no" src="#SESSION.root#/Tools/Treeview/TreeViewInit.cfm"
		     frameborder="0"></iframe>	
							
	</cf_layoutarea>			
		
</cf_layout>

</cfoutput>

 
