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
<cfquery name="Header" 
	datasource="appsSystem">
	SELECT   count(distinct Presentation) as counted
    FROM     UserPivotDetail
	WHERE    ControlId = '#ControlId#' 
	AND      Presentation LIKE 'Grouping%' 
</cfquery>
			
<cfoutput>

	<tr>	
	<td height="36" class="clsNoPrint">	
	<table class="formpadding">	
	
		<tr>
		<td>	
								
			<button name="refresh"
		        type="button"
		        class="button3"
		        style="height:24;width:26"
		        onClick="history.go()"
		        onMouseOver="this.className='button1'"
		        onMouseOut="this.className='button3'">
				<img title="Refresh" src="#SESSION.root#/Images/refresh.gif" border="0">
			</button>
		
		</td>
		<td>		
			<img src="#SESSION.root#/Images/separator.gif" border="0">		
		</td>
		<td style="padding-left:5px">		
			
			<span id="_printTitle" style="display:none;"><cf_tl id="Dataset"></span>
			
			<cf_tl id="Print" var="1">
			<cf_button2 
				mode		= "icon"
				type		= "Print"
				title       = "#lt_text#" 
				id          = "Print"					
				height		= "30px"
				width		= "25px" 
				style		= "width:18px; height:18px; margin-top:5px;"
				printTitle	= "##_printTitle"
				printContent = "##_divPivotContainer">
			
		</td>
		<td>		
			<img src="#SESSION.root#/Images/separator.gif" border="0">
		</td>
		<td>					
			<button class="button3" style="height:24;width:36" onclick="javascript:tableoutput('#controlid#','crosstabdata','view')" name="export" type="button"
			 onMouseOver="this.className='button1'" onMouseOut="this.className='button3'">
			<img title="Export pivot table fields to Table Format" src="#SESSION.root#/Images/table.gif" border="0"></button>
		</td>
		<!---
		<td>				
			<button class="button3" style="height:24;width:26" onclick="javascript:mail('#controlid#','crosstabdata','mail')" name="mail" type="button"
			 onMouseOver="this.className='button1'" onMouseOut="this.className='button3'">
			<img title="eMail pivot table fields to Excel" src="#SESSION.root#/Images/mail.gif" border="0"></button>
		</td>
		--->
		<td><img src="#SESSION.root#/Images/separator.gif" border="0"></td>
		<td>
			<button class="button3" style="height:24;width:36" onclick="javascript:excel('#controlid#','crosstabdata','view')" name="excel" type="button"
			 onMouseOver="this.className='button1'" onMouseOut="this.className='button3'">
			<img title="Export pivot table fields to Excel" src="#SESSION.root#/Images/excel.gif" height="19" width="19"  border="0"></button>
		</td>
						
		<cfif header.counted gte "1">
		
		<td><img src="#SESSION.root#/Images/separator.gif" border="0"></td>
		<td>		
				<button 
			     class       = "button3" 
				 style       = "height:24;width:36" 
				 onclick     = "javascript:collapseall()" 
				 id          = "collapseall" 
				 class       = "regular" 
				 type        = "button"
			     onMouseOver = "this.className='button1'" 
				 onMouseOut  = "this.className='button3'">
				<img title="Collapse" src="#SESSION.root#/Images/collapse3.gif" border="0"></button>
		</td>
		<td>		
				<button 
			     class       = "button3" 
				 style       = "height:24;width:36" 
				 onclick     = "javascript:expandall()" 
				 id          = "collapseall" 
				 type        = "button"
			     onMouseOver = "this.className='button1'" 
				 onMouseOut  = "this.className='button3'">		 
				<img title="Expand" src="#SESSION.root#/Images/expand3.gif" border="0"></button>
		</td>
		</cfif>
		
		<td>
		
		<img src="#SESSION.root#/Images/separator.gif" border="0">
		
		</td>
		<td>
					
			<button style    = "height:30;width:36" 
				 onclick     = "parent.olapexp('');this.className='hide';olapexp.className='button3'" 
				 id          = "olapcol" 			
				 class       = "button3" 
				 type        = "button">
				 
			  <img src="#SESSION.root#/Images/fullscreen.gif"  style= "height:22;width:22" title="Full screen">		 
				 
			 </button>
							 
			 <button style   = "height:30;width:36" 
				 onclick     = "parent.olapexp('reg');this.className='hide';olapcol.className='button3'" 
				 id          = "olapexp" 
				 class       = "hide" 
				 type        = "button">
				 
				  <img src="#SESSION.root#/Images/nofullscreen.png" style= "height:20;width:22" title="Show Selection screen">			 
				
			 </button>
			 
		</td>
						
		</tr>		
		
	</table>	
	
	</td></tr>		
	
</cfoutput>
