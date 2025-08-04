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

<cfoutput>

<cf_screenTop height="100%" label="#URL.CriteriaName#" html="No" banner="green" close="parent.ProsisUI.closeWindow('myextension',true)"
    jquery="Yes" scroll="no" html="yes" layout="webapp">
	
<script language="JavaScript">
			
			ie = document.all?1:0
			ns4 = document.layers?1:0
			
			function hl(itm,fld){
			 
			     if (ie){
			          while (itm.tagName!="TR")
			          {itm=itm.parentElement;}
			     }else{
			          while (itm.tagName!="TR")
			          {itm=itm.parentNode;}
			     }
				 	 	
								 	
				 if (fld != false){		
				 itm.className = "highLight2";		 
				 }else{		
			     itm.className = "regular";			
				 }
			  }
			  			  
			function selall(itm,fld) {
			    
			     sel = document.getElementsByName('select')	 
				 count = 0
				 
				 while (sel[count]) {
				 	 	 	 		 	
				 if (fld != false){
					
				 sel[count].checked = true;
				 itm = sel[count];
				 
				 if (ie){
			          while (itm.tagName!="TR")
			          {itm=itm.parentElement;}
			     }else{
			          while (itm.tagName!="TR")
			          {itm=itm.parentNode;}
			     }				 
				 itm.className = "highLight2";				 
				 
				 }else{		
				 		 
				 sel[count].checked = false				 
				 itm = sel[count]				 
				 if (ie){
			          while (itm.tagName!="TR")
			          {itm=itm.parentElement;}
			     }else{
			          while (itm.tagName!="TR")
			          {itm=itm.parentNode;}
			     }				 
				 itm.className = "regular";				 
				 }
				 count++
				 }
				
			  }
			  
</script>

<table width="95%" height="100%" align="center">
	 	  
	<tr><td colspan="2" height="100%" bgcolor="white" valign="top" style="padding:10px">
		
		<table width="100%" height="100%" align="center">
			<tr>
				<td valign="top" height="10">
				<cfajaximport tags="cfform">
				<cfdiv bind="url:FormHTMLExtViewFilter.cfm?row=#URL.row#&ControlID=#URL.ControlId#&ReportID=#URL.ReportId#&CriteriaName=#URL.CriteriaName#" id="left"/>		
				</td>
			</tr>
			<tr>	
				<td height="100%" style="padding-bottom:6px;border:0px solid silver">								
				<cf_divscroll><cfdiv id="result"></cf_divscroll>
				</td>
			</tr>
		</table>
	
		</td>
	</tr>

</table>

</cfoutput>

