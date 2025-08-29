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
<cfparam name="alias" default="AppsWorkOrder">	
<cfajaximport tags="cfdiv,cfform,cfinput-autosuggest">

<cfsavecontent variable="option">
	<input type="button" class="button10g" name="Search" id="Search" value="Search" onClick="history.back()">
</cfsavecontent>

<cfoutput>
<script>

function recordadd() {
   ColdFusion.navigate('RecordListingDetail.cfm?alias=#alias#&id2=new','listing')
}

function cancel() {
   ColdFusion.navigate('RecordListingDetail.cfm?alias=#alias#&id2=','listing')
}

function save(code) {

   document.mytopic.onsubmit() 
	if( _CF_error_messages.length == 0 ) {
       ColdFusion.navigate('RecordListingSubmit.cfm?alias=#alias#&id2='+code,'listing','','','POST','mytopic')
	 }   
 }
 
 

function option(sel) {
  
   if (sel != 'Text') {
     document.getElementById("ValueLength").className="hide"
   } else {
     document.getElementById("ValueLength").className="regularH"
   }
   if (sel != 'Lookup') {
      lookup.className='hide'
	} else {
	  lookup.className='regular'
	}
	if (sel != 'List') {
	 try {
	  document.getElementById("list1").className = "hide"
	  document.getElementById("list2").className = "hide"	
	 } catch(e) {}
	} else {
	 try {	 	     
		 document.getElementById("list1").className = "regular"
	     document.getElementById("list2").className = "regular"	
		} catch(e) {}
	}
}

function show(cde,code) {

	se1 = document.getElementById(cde+"_exp")
	se2 = document.getElementById(cde+"_col")
	se = document.getElementById(cde)
	if (se.className == "hide") {
		se2.className = "regular"
	    se1.className = "hide"
		se.className  = "regular" 
		ColdFusion.navigate('RecordListingObject.cfm?code='+code,cde+'_object')
	} else {
		se2.className = "hide"
	    se1.className = "regular"
		se.className  = "hide"		
		
	}
} 
 
 

</script>

</cfoutput>

<cf_divscroll>
	
<cfset Page         = "0">
<cfset add          = "1">
<cfinclude template = "../HeaderMaintain.cfm"> 		
	
<table width="99%" cellspacing="0" cellpadding="1" align="center">

	<tr><td height="1" class="line"></td></tr>
    <tr><td height="4"></td></tr>				
	<tr>
	
	    <td width="100%" id="listing">
		   <cfinclude template="RecordListingDetail.cfm">
		</td>
		
	</tr>		
	<tr><td height="5"></td></tr>				

</table>	

</cf_divscroll>
				

