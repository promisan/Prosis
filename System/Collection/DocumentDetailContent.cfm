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

<cfajaximport>

<cf_screentop height="100%" html="No" scroll="Yes">

<cfquery name="Collection" 
datasource="AppsSystem" 
username="#SESSION.login#" 
password="#SESSION.dbpw#">
SELECT   *
FROM     Collection
WHERE    CollectionId = '#url.collectionid#' 
</cfquery>

<cfparam name="url.id"           default="">
<cfparam name="url.attachmentid" default="">
<cfparam name="url.elementclass" default="">
<cfparam name="url.mission"      default="#collection.mission#">

<cf_filelibraryscript>

<!--- content --->

<table border="0" width="100%">

<cfif Collection.CollectionTemplate neq "">
		
	<tr>
		<td>
		<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left" bordercolor="#C0C0C0">
			<tr>
				<td width="1%"></td>
				<td width="99%">

					<cfif url.id neq "">				
						
						<cfparam name = "url.ElementId" default = "#url.id#">								
						<cfinclude template = "../../#Collection.CollectionTemplate#">					
						
					</cfif>	
														
				</td>
			</tr>
		</table>
		</td>
	</tr>

</cfif>

<!--- show preview document --->

<cfif url.presentation eq "quick">
	<cfset CTOTAL = 1>
<cfelse>	
	<cfset CTOTAL = 4>
</cfif>

<cfif url.attachmentid neq "">
	
	<cfquery name="getAttachment" 
       datasource="AppsSystem" 
	   username="#SESSION.login#" 
       password="#SESSION.dbpw#">
		SELECT * 
		FROM   Attachment
		WHERE  Attachmentid = '#url.attachmentid#'				
	</cfquery>

	<cfif getAttachment.recordcount eq 1>
		
		<cfif getattachment.server eq "document">
		   <cfset svr = SESSION.rootdocumentpath>
		<cfelse>
		   <cfset svr = getattachment.server>
		</cfif>		
	
	<cftry>	
			
		<cfif find("doc","#getattachment.filename#") neq 0 or find("rtf","#getattachment.filename#") neq 0>
		
			<cfset mydoc="#replace(getattachment.filename,'.docx','')#">
			<cfset mydoc="#replace(getattachment.filename,'.doc','')#">
			<cfset mydoc="#replace(getattachment.filename,'.rtf','')#">
		
			<cftry>
			   <cfdirectory action="CREATE" directory="#SESSION.rootpath#\CFRStage\User\#SESSION.acc#\">
			   <cfcatch></cfcatch>
			</cftry>	
			
			<!--- convert into PDF --->
			<cfdocument filename="#SESSION.rootpath#\CFRStage\User\#SESSION.acc#\#mydoc#.pdf" 
			 srcfile="#svr#\#getattachment.serverpath#\#getattachment.filename#" format="pdf" overwrite="true"/> 
			   
			<cfset mypdf = mydoc>
			<cfset dir = "#SESSION.rootpath#\CFRStage\User\#SESSION.acc#">
						
		<cfelse>
		
			<cfset mypdf="#replace(getattachment.filename,'.pdf','')#">
			<cfset dir = "#svr#\#getattachment.serverpath#">
			
		</cfif>
			
		<cfset thisPath=ExpandPath(".")>
		 
		<cfpdf action="getInfo" source="#dir#\#mypdf#.pdf" name="PDFInfo">
		
		<cfset pageCount="#PDFInfo.TotalPages#">
		
		<tr><td height="50">&nbsp;&nbsp;</td></tr>
		
		<tr>
		<td align="center"> 
		
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="left" bordercolor="C0C0C0">
		
			<cfif pageCount gte CTOTAL>
				<cfset vTotal = CTOTAL>
			<cfelse>	
				<cfset vTotal = 1>	
			</cfif> 
			
			<cfpdf action="thumbnail" source="#dir#\#mypdf#.pdf" 
			overwrite="yes" destination="../../CFRStage/User/#SESSION.acc#" scale=100 pages="1-#vTotal#"> 
			 
			<cfloop index="LoopCount" from ="1" to="#vTotal#" step="1">
			
			 <cfoutput>
				<tr>
					<td width="1%"></td>
					<td width="99%">	
					
						 <!--- <div class="virtualpage5 hidepiece"> --->
								<img src="#SESSION.root#/CFRStage/User/#SESSION.acc#/#mypdf#_page_#LoopCount#.jpg" alt="" border="0">
						 <!--- </div> --->
											
					</td>
				</tr>		 
			 </cfoutput>
			 
			</cfloop>
			</table>
		</td>	
		
		</tr>
				
		<cfcatch>
		    <table width="100%" align="center">
			<tr><td height="60" align="center"><font face="Verdana" size="2">No preview available</font></td></tr>
			</table>				
		</cfcatch>
	
	</cftry>
		
	</cfif>
	
</cfif>	

</table>


<cfif url.presentation eq "print">
  <script>
	  window.print()
  </script>
</cfif>