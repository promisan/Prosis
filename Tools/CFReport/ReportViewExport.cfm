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

<cfparam name="Attributes.Banner" default="1">
<cfparam name="Attributes.Text" default="1">
<cfparam name="Attributes.Flash" default="1">
<cfparam name="Attributes.FlashScript" default="">
<cfparam name="Attributes.PDF" default="1">
<cfparam name="Attributes.PDFScript" default="">
<cfparam name="Attributes.Flashpaper" default="1">
<cfparam name="Attributes.Excel" default="1">
<cfparam name="Attributes.ExcelScript" default="">
<cfparam name="Attributes.Line" default="1">

<cfoutput>

<cfif #Attributes.Banner# eq "1">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
	   <td class="top4n" class="regular">&nbsp;&nbsp;<b>#SESSION.welcome# view</b></td>
	   <td align="right" background="#SESSION.root#/Images/title_table4.jpg" height="29">
	   </td>
	   <tr><td colspan="2" height="1" bgcolor="gray"></td>
	</tr>	
</table>  
</cfif>

<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center" class="formpadding">
  <tr>
  <td align="right"><table border="1" bordercolor="C0C0C0" rules="rows"><tr>
	
	   <cfif #Attributes.FlashPaper# eq "1">
	       
			<td bgcolor="FFFFFF">&nbsp;|&nbsp;</td>
	        <td bgcolor="FFFFFF">&nbsp;<a href="javascript:#Attributes.FlashScript#('flashpaper')">
			    Flash paper</a>&nbsp;</td>
			<td bgcolor="FFFFFF">
				<img src="#SESSION.root#/Images/flash_small.jpg" alt="" name="icon1" 
				id="icon1" border="0" align="middle" 
				width="16" height="17"
				style="cursor: pointer;" onClick="javascript:#Attributes.FlashScript#('flashpaper')" 
				onMouseOver="document.icon1.src='#SESSION.root#/Images/button.jpg'" 
				onMouseOut="document.icon1.src='#SESSION.root#/Images/flash_small.jpg'">
				  
			</td>
	   </cfif>
	   
	   <cfif #Attributes.PDF# eq "1">
	   
			<td bgcolor="FFFFFF">&nbsp;|&nbsp;</td>
			<td bgcolor="FFFFFF">&nbsp;<a href="javascript:#Attributes.PDFScript#('pdf')">
			     Adobe PDF</a>&nbsp;</td>
			<td bgcolor="FFFFFF">
				<img src="#SESSION.root#/Images/pdf_small.jpg" alt="" name="icon2" 
				  onMouseOver="document.icon2.src='#SESSION.root#/Images/button.jpg'" 
				  onMouseOut="document.icon2.src='#SESSION.root#/Images/pdf_small.jpg'"
				  width="18" height="17"
				  style="cursor: pointer;" alt="" border="0" align="middle" 
				  onClick="javascript:#Attributes.PDFScript#('pdf')">&nbsp;
			</td>
		</cfif>
		
		<cfif #Attributes.Excel# eq "1">
			<td bgcolor="FFFFFF">&nbsp;|&nbsp;</td>
			<td bgcolor="FFFFFF">&nbsp;<a href="javascript:#Attributes.ExcelScript#('excel')">
			     MS Excel</a>&nbsp;</td>
			<td bgcolor="FFFFFF">
				<img src="#SESSION.root#/Images/excel.jpg" alt="" name="icon3" 
				  onMouseOver="document.icon3.src='#SESSION.root#/Images/button.jpg'" 
				  onMouseOut="document.icon3.src='#SESSION.root#/Images/excel.jpg'"
				  style="cursor: pointer;" alt="" border="0" align="middle" 
				  onClick="javascript:#Attributes.ExcelScript#('excel')">
			</td>
			<td>&nbsp;|&nbsp;</td>
		</cfif>
		
	</tr>
	</table>	
</tr>	  
<cfif #Attributes.Line# eq "1">
<tr><td bgcolor="C0C0C0"></td></tr>
</cfif>
</table>

</cfoutput>
