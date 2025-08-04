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

<style> 

  .bcell {
	border-left:0px solid silver;
	height:30px;
	border-bottom:1px solid silver }	
	
  .ccell {
    padding-left:5px;
	height:30px;
	border-left:0px solid silver;
	border-bottom:1px solid silver;
	border-right:0px solid silver;
	 }		
	
   TD {
	padding-left : 1px; }	  
	
 </style>
 
<cfparam name="url.mycl"   default="0">

<cfif url.mycl eq "1">
	<cf_screentop jquery="Yes" banner="gray" height="100%" scroll="no" html="No" layout="webapp" menuaccess="context">
<cfelse>
	<cf_screentop title="Contract" height="100%" jquery="Yes" scroll="yes" html="No" menuaccess="context">
</cfif> 

<cfparam name="url.action" default="0">

<cf_dialogPosition>

<cfoutput>

<script>
	
	function verifyrecord() { 
						    
		setweekschedule() 
					
		try {
		
			if (document.getElementById('salaryschedule').value == "") { 
		
				alert("You did not define a salary scale")
				document.getElementById('salaryselect').click()				
				return false
				}		
				
		} catch(e) {}
		
	}
	
	function setweekschedule() {	    
		 count = 0
		 ds = ""
		 se = document.getElementsByName("selecthour")		 
		 while (se[count]) {
		 	if (se[count].checked == true)	{
				ds = ds+'-'+se[count].value
		 }
		 count++
		} 			
		try {		
		document.getElementById("dayhour").value = ds		
		} catch(e) {}
	}
	
	function weekschedule(id,mis,eff) {

			if (ProsisUI.existsWindow('myschedule')) {
				ProsisUI.restoreWindow('myschedule');
			} else {
				try {
					ProsisUI.closeWindow('myschedule')
				} catch(e) {
					ProsisUI.createWindow('myschedule', 'Week schedule', '',{x:60,y:60,height:530,width:890,closable:false,minimize:true,maximize:false,modal:false,resizable:false,center:false});
					ptoken.navigate('#SESSION.root#/attendance/application/workschedule/ScheduleView.cfm?id=#url.id#&contractid='+id+'&mission='+mis,'myschedule')
				}
			}
	}
	
	
	
	function clearWSSelection() {
		$('.clsWSHrSlot input[type=checkbox]').prop('checked', false);
		$('.clsWSHrSlot').css('background-color', '');
	}
	
	function selectWS9To5() {
		clearWSSelection();
		$('.clsWSHrSlot95 input[type=checkbox]').prop('checked', true);
		$('.clsWSHrSlot95').css('background-color', '##ffffcf');
	}
			
</script>

</cfoutput>

<cfif url.action eq "0">
	<cfset onsub = "return verifyrecord()">
<cfelse>
	<cfset onsub = "">
</cfif>

<cfif url.mycl eq "1">
	
	<cf_layoutscript>
	<cf_textareascript>
	<cf_PresentationScript>
	
	<cfset attrib = {type="Border",name="mybox",fitToWindow="Yes"}>
	
	<cf_layout attributeCollection="#attrib#">
	
		<cf_layoutarea 
	          position="header"			  
	          name="controltop">	
			  
			<cf_ViewTopMenu label="Process Contract Amendment Request" menuaccess="context" background="blue" systemModule="Accounting">
					
		</cf_layoutarea>	
		
		<cf_layoutarea 
		    position="right" name="commentbox" minsize="20%" maxsize="30%" size="350" overflow="yes" initcollapsed="false" collapsible="true" splitter="true">
		
			<cf_divscroll style="height:99%">			
				<cf_commentlisting objectid="#url.id1#"  ajax="No">		
			</cf_divscroll>
			
		</cf_layoutarea>		 
	
		<cf_layoutarea  position="center" name="box">
			
		     <cf_divscroll style="height:99%">
						
			 <table style="width:100%;height:99%">
			   <tr>
			   <td style="padding-left:5px" valign="top"><cfinclude template="ContractEditContent.cfm">				   
			  </td></tr>
			  </table> 		
			 					
			</cf_divscroll>	
			
		</cf_layoutarea>			
			
	</cf_layout>

<cfelse>

	    <!--- normal mode --->		
		<cf_divscroll style="height:99%">			
		<cfinclude template="ContractEditContent.cfm">
		</cf_divscroll>	
			
</cfif>	

<cfif mode eq "edit" or last eq "1"> 
	
	<script>    
		 getreason()	
		 <cfif mdte eq "edit">	 
		 expiration_selectdate()
		 </cfif>
	</script>

</cfif>

