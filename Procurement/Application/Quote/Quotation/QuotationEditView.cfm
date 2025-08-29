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
<cf_tl id="Edit Quotation" var="1">
	
	<cf_screenTop height="100%" label="#lt_text#" line="no"
	      bannerheight="50" 
		  band="no" 
		  scroll="no" 
		  layout="webapp"    	      
	      banner="blue">
		  
<cfoutput>
    
	<script language="JavaScript">

		function reloadForm(role,per) {
		  ptoken.location("QuotationTree.cfm?ID=#URL.ID#&Mode=#Mode#")
		}

	</script>
	   
	<table width="100%" height="100%" style="padding:10px" cellspacing="0" cellpadding="0" background="1">
		<tr>
			<td valign="top" width="260">
				<cfinclude template="QuotationTree.cfm">		
			</td>
			<td style="border-left: 1px solid Silver;">
				<iframe src="QuotationEdit.cfm?ID=#URL.ID#&Mode=#URL.Mode#"
		        name="right"
		        id="right"
		        width="100%"
		        height="100%"
				scrolling="auto"
		        frameborder="0"></iframe>
			</td>
		</tr>
	</table>
	<cf_screenbottom  layout="webapp">

</cfoutput>
