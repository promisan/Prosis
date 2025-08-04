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

<cf_param name="url.host"    		default="#SESSION.rootDocumentPath#\" type="String">
<cf_param name="url.mode"    		default="attachment" type="String">
<cf_param name="url.box"			default="att1" type="String">
<cf_param name="url.dir"     		default="VacCandidate" type="String">
<cf_param name="url.id"      		default="cdaf0b9e-1018-0668-4387-e8c390bee314" type="String">
<cf_param name="url.id1"			default="" type="String">
<cf_param name="url.reload"  		default="undefined" type="String">
<cf_param name="url.documentserver" default="No" type="String">
<cf_param name="url.pdfscript"		default="" type="String">
<cf_param name="url.memo"	    	default="" type="String">
<cfparam name="DocumentServerIsOp"  default="0">

<cfajaxproxy cfc="Service.Process.System.UserController" jsclassname="systemcontroller">


<cfif url.pdfscript neq "">
	
	<cf_screentop height="100%" icon="pdfform.png" label="Attach Readable PDF" jquery="Yes" scroll="no" banner="gray" html="Yes" 
	     user="no" bannerheight="40" layout="webapp">

<cfelse>

<cf_screentop height="100%" label="Attach file" html="No" jquery="Yes" scroll="no" banner="red" user="no" bannerheight="40" layout="webapp">
   
</cfif>
		
    <cfif URL.DocumentServer neq "No">
			<cfquery name="Parameter" 
			datasource="AppsInit">
				SELECT * 
				FROM   Parameter
				WHERE  HostName = '#CGI.HTTP_HOST#'
			</cfquery>
		
			<!---- a Document server has been enabled for this IP (e.g. Xythos) 
			CHECK IF THE SERVER IS UP AND IF HE DOES NOT FIND IT, SKIP THE MODE AND MAKE THE DOCUMENTSERVER =1 
			---->	
	
			<cfif Parameter.DocumentServer neq "">
				<cfset DocumentServerIsOp="1">					
			<cfelse>
				<cfset DocumentServerIsOp="0">
			</cfif>
			
	<cfelse>
		<cfset DocumentServerIsOp="0">	
	</cfif>
	
	<script language="JavaScript">
	
		function checkfile() {
			
			var uController = new systemcontroller();			
			document.attach.action = document.attach.action + '&mid='+ uController.GetMid();
						
			<cfif DocumentServerIsOp eq "0">
				if (document.attach.uploadedfile.value == "") {
				   alert("You must select a file to upload.")
				   return false }
				
			</cfif>
		
			<cfoutput>
			
					<cfif DocumentServerIsOp eq "1">
			
						if (document.attach.DocumentServer.value == "") {
						   document.getElementById('busy').className='hide'			   
						   alert("You must select a Document server destination.")
						   return false }
						
					</cfif>
			</cfoutput>	
		   
		}
		
	</script>

<table width="100%" height="100%" cellspacing="0" cellpadding="0" align="center" class="formpadding">	

<tr><td valign="top" style="padding:10px">

<cfif DocumentServerIsOp eq "0">
	<cfset vServerSubmit = "FileFormSubmit">
<cfelse>
	<cfset vServerSubmit = "FileFormSubmitServer">
</cfif>

<CFFORM name  = "attach" 
	action    = "#vServerSubmit#.cfm?host=#url.host#&mode=#url.mode#&box=#URL.Box#&DIR=#URL.DIR#&ID=#URL.ID#&ID1=#URL.ID1#&reload=#URL.reload#" 
	method    = "post" 
	target    = "saveatt"
	enctype   = "multipart/form-data" 
	onSubmit  = "return checkfile()">
			
<table width="95%" align="center" class="formpadding">	

<cfif DocumentServerIsOp eq "0">	
		<TR class="labelmedium">

			<td width="100"><cf_tl id="File">:</td>
			<TD>
				<cfif DocumentServerIsOp eq "1">
					<input type = "file" 
					   name     = "uploadedfile" 
					   id       = "uploadedfile" 
					   size     = "32" 			   
					   class    = "regularxl" 
					   style    = "height:30px;font-size:16px;height:30px;border:0px">
				<cfelse>
					<cfoutput>
					<input type = "file"
		    		   name     = "uploadedfile"
					   id       = "uploadedfile"
				       size     = "32"
					   style    = "height:30px;font-size:16px;height:30px;border:0px"			  
			    	   class    = "regularxl"
				       onChange = "ptoken.navigate('FileFormPDF.cfm?box=#url.box#&dir=#url.dir#&source='+this.value+'&destination='+document.getElementById('ServerFile').value,'pdf')">		
					  </cfoutput> 
				</cfif>
			</TD>
		</TR>
		<tr class="labelmedium">
		   <td></td>
		   <td><font color="808080">Use the 'Choose file...' button to locate the file on your local file system or drag it.</td>
		</tr>
		<tr><td height="6"></td></tr>
		<TR class="labelmedium">
		   <td style="cursor: pointer;"><cf_tl id="Save as">:</td>
		   <td style="padding-left:3px">
		       
			   <table><tr>
			   <td>
		        <cfoutput>
				<INPUT type="text" name="ServerFile" id="ServerFile" size="30" class="regularxl" style="height:35px;width:98%"
				 onchange="_cf_loadingtexthtml='';ptoken.navigate('FileFormPDF.cfm?box=#url.box#&dir=#url.dir#&source='+document.getElementById('uploadedfile').value+'&destination='+this.value,'pdf')"> 
				</cfoutput>
			   </td>
			   
			   <td id="suffix">.<input type="text" id="ServerSuffix" name="ServerSuffix" style="border:1px solid silver;width:30px;text-align:center" readonly></td>								
			   
			   </tr>
			   </table>			   
			   
		   </td>
		</TR>
		<tr class="labelit">
		   <td></td>
		   <td><font color="808080">Use this field if you want to change the name of the file stored in the library. Otherwise leave blank.</td>
		</tr>

		<tr><td height="3"></td></tr>

		<TR class="labelit">
			<TD align="right"></TD>			
			<TD>
			<cfdiv id="pdf">
			<!---
			<font color="808080">
				<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/finger.gif" alt="" border="0" align="absmiddle">
					<cf_tl id="Applies ONLY for MS-word and MS-excel documents">
				</font>
			--->	
			</cfdiv>	
			</TD>
		</TR>

</cfif>

<tr><td height="6"></td></tr>
<TR>
   	<td style="cursor: pointer;" class="labelit"><cf_tl id="Description">:</td>
	
	<TD>
	
	<cfoutput>
	<!---
	  maxlength="200"
			   onkeyup="return ismaxlength(this)"	
			   --->
		
	 <INPUT type="text" id="AttachmentMemo"
			   name="AttachmentMemo"				    
			   class="regularxl" 
			   value="#url.memo#"				
			   style="height:35px;width:98%">
			   
			   </cfoutput>
							
	</TD>
</TR>
<tr class="labelit">
		   <td></td>
		   <td><font color="808080">Use this field if you want to add a description to your attachment for recognition. Otherwise leave blank.</td>
		</tr>

<!---- a Document server has been enabled for this IP (e.g. Xythos) ---->	
<cfoutput>

<input type="hidden" name="DocumentServer" id="DocumentServer" value="#url.DocumentServer#" size="50" readonly>		

</cfoutput>
		
<cfif DocumentServerIsOp eq "1">

<TR class="labelit">
   	<td style="cursor: pointer;"><B><cf_tl id="Document Server"></B>:</td>
	
	<TD>
		<cfoutput>
		<input type="text" name="DocumentServerPath" id="DocumentServerPath" value="#CLIENT.DocumentServerPath#" size="48" class="regularh">
		</cfoutput>		
		
		<button name="ServerBrowse" id="ServerBrowse" onclick="javascript:browse()" class="regularh"><cf_tl id="Save as">..</button>
							
	</TD>
</TR>

<cfelse>
		<input type="hidden" name="DocumentServerPath" id="DocumentServerPath" value="" size="50" readonly>

</cfif>

<tr><td height="4"></td></tr>

<tr><td colspan="2" align="center" height="30">
	
	<table height="30" cellspacing="0" cellpadding="0" class="formpadding">
	
	<tr><td align="center" id="submitbox"></td>
	
		<td height="30" id="busy" align="center" class="hide" style="padding-left:6px">
			<table align="center" width="200">
				<tr><td height="3"></td></tr>
				<tr><td height="1" class="line"></td></tr>
				<tr><td align="center" height="20" class="labelmedium">
			    <img align="absmiddle" src="<cfoutput>#SESSION.root#</cfoutput>/Images/busy4.gif" alt="" border="0">&nbsp;Uploading ...
				</td></tr>
				<tr><td height="1" class="line"></td></tr>
			</table>
		</td>
	</tr>
	
	</table>
	
</td>

</tr>

</TABLE>
</CFFORM>
</td>
</tr>
<cfdiv id="dFile">

<tr class="hide"><td height="100">

    <!--- target --->
	<iframe name="saveatt"
         id="saveatt"
         width="100%"
         height="300"
         scrolling="1"
         frameborder="0"></iframe>
</td>
</tr>
</table>

<cf_screenbottom html="No" layout="innerbox">

