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
<cfparam name="url.receiptno" default="">

<cfif url.receiptNo eq "">
	
	<cf_screentop height="100%"    
	   label="Shipment, Receipt and Inspection" 	  
	   scroll="no" 
	   html="Yes" 
	   line="no"
	   jquery="Yes" 
	   layout="webapp" 
	   banner="blue">
   
</cfif>
	
<!--- passtry to create a iframe for a saving destination --->	

<table width="100%" height="100%">
	
	<cfoutput>
		<tr>
		   <td>
		   		<iframe src="ReceiptEntryContent.cfm?#cgi.query_string#"
		   		        width="100%"
		   		        height="100%"
		   		        scrolling="no"
		   		        frameborder="0"></iframe>
		   </td>
		</tr>
	</cfoutput>

</table>

<cfif url.receiptNo eq "">

	<cf_screenbottom layout="webapp"> 

</cfif>