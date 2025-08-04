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

<!--- ajax loaded --->

<!--- validate if the extension is accepted --->

<cf_param name="url.dir"         default="" type="String">
<cf_param name="url.source"      default="" type="String">
<cf_param name="url.destination" default="" type="String">
<cf_param name="url.box"         default="" type="String">

<cfquery name="getFilter" 
	 datasource="AppsSystem"
	 username="#SESSION.login#" 
	 password="#SESSION.dbpw#">
     SELECT    *
	 FROM      Ref_Attachment
	 WHERE     DocumentPathName = '#url.dir#' 	
</cfquery>

<cfoutput>
	<cfset cnt = 0>
	<cfloop index="suf" list="#url.source#" delimiters=".">
	     <cfset cnt = cnt+1>
		 <cfif cnt eq "2">
		    <script>
			 document.getElementById('ServerSuffix').value = '#suf#'
			</script> 
		 </cfif>
	</cfloop>
</cfoutput>

<cfif getFilter.AttachExtensionFilter neq "NONE" and getFilter.AttachExtensionFilter neq "">
	
	<cfset accept = "0">
		
	<cfloop index="itm" list="#getFilter.AttachExtensionFilter#">
			
		<cfif UCase(Right(itm,4)) eq UCase(Right(url.source,4))>			
			<cfset accept = "1">				
		<cfelseif UCase(Right(itm,5)) eq UCase(Right(url.source,5))>			
			<cfset accept = "1">			
		</cfif>
				
		<cfif accept eq "1" and url.destination neq "">
		
		    <cfif suf neq "">
				<cfset url.destination = "#url.destination#.#suf#">
			</cfif>
			
		
			<cfset accept = "0">
								
			<cfif UCase(Right(itm,4)) eq UCase(Right(url.destination,4))>			
				<cfset accept = "1">				
			<cfelseif UCase(Right(itm,5)) eq UCase(Right(url.destination,5))>			
				<cfset accept = "1">			
			</cfif>		
		
			<cfbreak>
		
		</cfif>
		
	</cfloop>
	
<cfelse>

	<cfset accept = "1">	

</cfif>

<cfif accept eq "0">

	<cfoutput>
	<script>
		ptoken.navigate('FileFormDialogSubmit.cfm?#url.box#&accept=0','submitbox')
	</script>
	</cfoutput>

<cfelse>
	
	<cfparam name="url.source" default="">
	
	<cfif   <!--- UCase(Right(url.source,4)) eq ".XLS" or  --->
	        UCase(Right(url.source,4)) eq ".DOC" or
			UCase(Right(url.source,5)) eq ".DOCX" or
			UCase(Right(url.source,5)) eq ".XLS" or
			UCase(Right(url.source,5)) eq ".XLSX" or
			UCase(Right(url.source,4)) eq ".HTM" or
			UCase(Right(url.source,5)) eq ".HTML" or
			UCase(Right(url.source,4)) eq ".TXT" or
			UCase(Right(url.source,4)) eq ".RTF">
			
			<table>
			
				<tr>
				<td><input type="checkbox" class="radiol" name="PDFConvert" id="PDFConvert" value="Yes"></td>
				<td>
				<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/pdf_small.gif" alt="" border="0" align="absmiddle">
				</td>
				<td>&nbsp;</td>
				<td class="labelit"><cf_tl id="Keep format after conversion">:</td>
				<td class="labelit">
					<table>
					<tr>
					<td><input type="radio" class="radiol" name="KeepOriginal" id="KeepOriginal" value="Yes" checked></td><td>Yes</td>
					<td><input type="radio" class="radiol" name="KeepOriginal" id="KeepOriginal" value="No"></td><td>No</td>
					</tr>
					</table>
				</td>	
				</tr>
				<tr class="labelit">				  
				   <td colspan="5"><font color="808080">PDF conversion might not be enabled for this site. Please check with your administrator.</td>
				</tr>
			
			</table>	
	
	<cfelse>
	
			<font color="gray">
			<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/finger.gif" alt="" border="0" align="absmiddle">
				Applies ONLY for MS-word and MS-excel documents
			</font>
			
	</cfif>		
	
	<cfoutput>
	<script>
		ptoken.navigate('FileFormDialogSubmit.cfm?box=#url.box#&accept=1','submitbox')
	</script>
	</cfoutput>
	
</cfif>	