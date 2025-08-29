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
<cfoutput>


<cfloop index="itm" list="#url.list#" delimiters="|">

	<script language="JavaScript">
	
	     if (document.getElementById("row#itm#").className == "cellcontent linedotted navigation_row") {
		     try {
			
				 if (document.getElementById("req#itm#").value == "0.00") {
				     document.getElementById("row#itm#").className  = "hide"
				     // document.getElementById("line#itm#").className = "hide" 
					 }			 
				
				 } catch(e) {
					     document.getElementById("row#itm#").className  = "hide"
					  //   document.getElementById("line#itm#").className = "hide"	
				 }
				 
		 } else {
		     document.getElementById("row#itm#").className  = "cellcontent linedotted navigation_row"
		     // document.getElementById("line#itm#").className = ""
		 }
	</script>

</cfloop>


<cf_tl id="Payable" var="1">

<cfif url.action eq "expand">

	<a href="javascript:togglecpl('collapse')">#lt_text#</a>
    <img src="#SESSION.root#/Images/expand3.gif" 
	    alt="hide completed lines" 
		border="0" 
		align="absmiddle" 
		onclick="togglecpl('collapse')">
		
			
<cfelse>

	<a href="javascript:togglecpl('expand')">#lt_text#</a>
    <img src="#SESSION.root#/Images/collapse3.gif" 
	    alt="hide completed lines" 
		border="0" 
		align="absmiddle" 
		onclick="togglecpl('expand')">

</cfif>		


</cfoutput>