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
<cfparam name="Form.searchtext"  default="">
<cfparam name="URL.Page"         default = "1">
<cfparam name="URL.engine"       default = "collection">
<cfparam name="URL.id"           default="">
<cfparam name="URL.category"     default="">
<cfparam name="URL.time"         default="">

<cfset fname = "#DateFormat(now(),"dd-mm-yyyy")#-#TimeFormat(Now(), 'hh-mm-ss')#.html">

<cfif url.engine eq "Collection">

	<cfquery name="Collection" 
	datasource="AppsSystem" 
	username="#SESSION.login#" 
	password="#SESSION.dbpw#">
		SELECT   *
		FROM     Collection
		WHERE    CollectionId = '#url.collectionid#' 
	</cfquery>
	
	<cfif collection.recordcount eq "0">

		<table align="center">
		<tr><td height="50">
			<font size="2" color="FF0000">Collection database no longer exists. Please contact your administrator</font></td>
		</tr>
		</table>
		<cfabort>
		
	</cfif>

<cfelseif url.engine eq "advanced">
	
	<!--- Update CaseFile information into CollectionLogCriteria --->
	<cfinclude template="CaseFile/AdvancedSearchCaseClassSubmit.cfm">

</cfif>

<cfoutput>
	<input type="hidden" name="previewstatus"  id="previewstatus"  value="preview_normal">
	<input type="hidden" name="categoryselect" id="categoryselect" value="#url.category#">	
	<input type="hidden" name="timeselect"  id="timeselect"    value="#url.time#">
</cfoutput>

<cfset CLIENT.PageRecords = 20>

<cfif form.searchtext neq "" or url.searchid neq "">

	<cfif url.engine eq "collection">

		<cfinclude template="Engine/CollectionEngine.cfm">
		
	<cfelseif url.engine eq "advanced">
	
		<cfinclude template="Engine/AdvancedEngine.cfm">
		
	</cfif>	
		 
	<table width="100%">
	 <tr><td align="right" height="1" colspan="2">
		 <div id="detail" style="z-index:10; position:absolute;padding:0px;top: 20px;right:770px;"></div>		 
	 </td></tr>
	 
	</table>	
		
	
	<cf_divscroll id="presentationbox">
	
		<table width="100%">
			
		<tr height="0">
			<td width="2%">
			</td>
			<td align="right">
			<cfinclude template = "Navigation.cfm">		
			</td>
		</tr>	
				
		<cfif url.engine eq "collection">
			<cfset recordsFound = info.FOUND>
		<cfelse>
			<cfset recordsFound = searchTotal.Total>
		</cfif>
						
		<cfif recordsFound LTE 2 AND isDefined("info.SuggestedQuery")>
			<cfoutput>
			<tr><td colspan="2" align="center">
	    		<font size="4">
	    		Did you mean:
			    <a href="javascript:redo_query('#info.SuggestedQuery#')"><font size="4" color="0080C0">#info.SuggestedQuery#</font></a>
				</font>
			</td></tr>
			</cfoutput>	
		</cfif> 
					
		<tr valign="top">
		
		<cfif recordsFound gte 1>
		
		<td><cf_space spaces="50">			
		
		  <cfif url.engine eq "collection">
		
			<cfquery name="Category" dbtype="query">			
				SELECT   DISTINCT Category
				FROM     CollectionResult
			</cfquery>
			
		<cfelse>
		
			<cfquery name="Category" dbtype="query">
				SELECT Category
				FROM   AdvancedResultCategories
			</cfquery>
			
		</cfif>
		
			<table width="220" align="center">
			
			    <!--- category selection --->
			
			    <cfoutput>
				<tr><td style="padding-left:35px;padding-top:5px;padding-bottom:5px"><a href="javascript:do_query('','','#url.engine#','#url.id#','#url.searchid#')">
				</cfoutput>
				
				<cfif url.category eq ""><b></cfif>
				<img src="<cfoutput>#SESSION.root#</cfoutput>/Images/Search/everything.jpg" width="17" height="17" align="absmiddle" border="0" alt=""><font size="3" style="verdana" color="0080C0"><cf_tl id="Everything"></font></a></td></tr>
				<cfoutput query="Category">
				
				<tr><td style="padding-left:35px;padding-top:5px;padding-bottom:5px">
				<cf_tl id="#Category#" var="1">	
				
				<cfif url.category eq category>
				   <img src="#SESSION.root#/Images/Search/#category#.jpg" width="17" height="17" align="absmiddle" border="0" alt="">&nbsp;&nbsp;<font size="3" style="verdana" color="0080C0"><b>#lt_text#</b></font>	
				<cfelse>
				   <img src="#SESSION.root#/Images/Search/#category#.jpg" width="17" height="17" align="absmiddle" border="0" alt="">&nbsp;&nbsp;<a href="javascript:do_query('#category#','','#url.engine#','#url.id#','#url.searchid#')"><font size="3" style="verdana" color="0080C0">#lt_text#</font></a>		
				</cfif>				
				</td>
				</tr>
				</cfoutput>
				<tr><td height="5"></td></tr>
				<tr><td style="border-top:dotted 1px silver;padding-left:35px;padding-right:20px"></td></tr>		
				
				<!--- time selection --->
				
				<tr><td height="6"></td></tr>
				
				<cfset st = "padding-top:2px;padding-bottom:2px;padding-left:35px">
				<cfset ft = "<font size='2' color='0080C0'>">
				
				<cfoutput>			
				<tr><td style="#st#"><font size="2" color="black"><cfif url.time eq ""><b><cfelse><a href="javascript:do_query('#url.category#','','#url.engine#','#url.id#','#url.searchid#')"></cfif><cf_tl id="All time"></font></a></td></tr>			
				<tr><td style="#st#"><cfif url.time eq "day"><b><cfelse><a href="javascript:do_query('#url.category#','day','#url.engine#','#url.id#','#url.searchid#')"></cfif>#ft#<cf_tl id="Past 24 Hours"></font></a></td></tr>
				<tr><td style="#st#"><cfif url.time eq "week"><b><cfelse><a href="javascript:do_query('#url.category#','week','#url.engine#','#url.id#','#url.searchid#')"></cfif>#ft#<cf_tl id="Past Week"></font></a></td></tr>
				<tr><td style="#st#"><cfif url.time eq "month"><b><cfelse><a href="javascript:do_query('#url.category#','month','#url.engine#','#url.id#','#url.searchid#')"></cfif>#ft#<cf_tl id="Past Month"></font></a></td></tr>			
				</cfoutput>
				
			</table>
		
		</td>   
		
		<cfelse>
		
		<td valign="top"><cf_space spaces="5"></td>
		
		</cfif>
		
		<cfsavecontent variable="vContent">
			<cfinclude template = "SearchContent.cfm">					
		</cfsavecontent>

		<cfset CLIENT.OutputFile = "#SESSION.rootPath#\CFRStage\user\#SESSION.acc#\#fname#">		
		
		<cffile action="Write" output = "#vcontent#" file = "#SESSION.rootPath#\CFRStage\user\#SESSION.acc#\#fname#">
		
		<td style="border-left: 0px solid d4d4d4;">
		
			<TABLE border="0" width="100%" cellspacing="0" cellpadding="0" class="formpadding"> 
				<tr>
				<td colspan="2" align="right">		
				
				    <table>
					
					<tr>
					<cfif url.category neq "" and url.category neq "document" and url.category neq "undefined">
							
						<td>								
						<cfinvoke component="Service.Analysis.CrossTab"  
							  method         = "ShowInquiry"
							  buttonName     = "Excel"
							  buttonText     = "Export List to Excel"
							  buttonClass    = "button10s"
							  buttonStyle    = "width:150px;"
							  scriptfunction = "facttabledetailxls"
							  buttonIcon     = "#SESSION.root#/Images/sqltable.gif"				  
							  reportPath     = "System\Collection\CaseFile\"
							  SQLtemplate    = "DocumentExcel.cfm"
							  queryString    = "SearchId=#url.searchid#&Category=#URL.category#"
							  dataSource     = "appsQuery" 
							  module         = "System"
							  reportName     = "Collection: Element Excel"
							  table1Name     = "Export file"
							  data           = "1"
							  filter         = ""
							  ajax           = "1"
							  olap           = "0" 
							  excel          = "1"> 
							  
						</td>	  
						  
					</cfif>	  
					
					<td>			
						&nbsp;&nbsp;
						<cfoutput>
							<button value="print" class="button10s" style="width:150px;"
			    		    onClick="do_friendly_print()"><img src="#SESSION.root#/Images/pdf_1.JPG" height="14" width="14" align="absmiddle" border="0">&nbsp;&nbsp;Export List to Pdf</button>			
						</cfoutput>
					</td>
					
					</tr>
					
					</table>	
					
				</td>	 			
			
				</tr>	 
				
				<tr><td colspan="2" height="1" style="border-bottom:1px dotted e4e4e4"></td></tr> 
			
			<TR>
			
			<td>&nbsp;</td>
			
			<TD>
				<cfoutput>
					#vContent#
				</cfoutput>				
			</TD>	
			</TR>	 
			</TABLE> 
			
		</td>			
		</tr>
		
		</table>
						
		</cf_divscroll>
		
			
</cfif>
