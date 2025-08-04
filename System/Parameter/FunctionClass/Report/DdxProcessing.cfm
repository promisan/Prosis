<cfsavecontent variable="reportddx">
<?xml version="1.0" encoding="UTF-8"?>
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
<DDX xmlns="http://ns.adobe.com/DDX/1.0/" 
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://ns.adobe.com/DDX/1.0/ coldfusion_ddx.xsd">
   
    <StyleProfile name="TOC" > 
			<TableOfContents maxBookmarkLevel="infinite">
			<Header>
				<Center>
					<StyledText>
						<p font="Arial,18pt">Table of Contents</p>
					</StyledText>
				</Center>
			</Header>
			<TableOfContentsEntryPattern applicableLevel="1"> 
				<StyledText>
					<p font="Arial,10pt"><_BookmarkTitle/><leader leader-pattern="dotted"/><_BookmarkPageCitation/></p>
				</StyledText>
			</TableOfContentsEntryPattern> 

			<TableOfContentsEntryPattern applicableLevel="2"> 
				<StyledText><p font="Arial,10pt">&#160;&#160;&#160;&#160;&#160;<_BookmarkTitle/><leader leader-pattern="dotted"/><_BookmarkPageCitation/></p></StyledText>
			</TableOfContentsEntryPattern> 
			
			
			<TableOfContentsEntryPattern applicableLevel="3"> 
				<StyledText><p font="Arial,10pt">&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;<_BookmarkTitle/><leader leader-pattern="dotted"/><_BookmarkPageCitation/></p></StyledText>
			</TableOfContentsEntryPattern> 

			
			</TableOfContents>
	 </StyleProfile>	

	<StyleProfile name="CompsFooter">
		<Footer>
			<Left>
				<StyledText>
					<p font="Arial,8pt">Page <_PageNumber/> / <_LastPageNumber/></p>
				</StyledText>
			</Left>
			<Right>
				<StyledText>
					<p font="Arial,8pt">Last Modified: <_Modified/></p>
				</StyledText>
			</Right>
		</Footer>
	</StyleProfile>	

	
	<StyleProfile name="Draft">
		<Watermark opacity="5%" rotation="30" fitToPage="true">
			<StyledText>
				<p>Draft</p>
			</StyledText>
		</Watermark>
	</StyleProfile>


	<PDF result="GENERAL" >
			<PDF source="Introduction" bookmarkTitle="1. INTRODUCTION" includeInTOC="true" />		
			<PDF source="AFC" bookmarkTitle="2. APPLICATION FRAMEWORK CLASSES" includeInTOC="true" />		
			<PDF source="FCC" bookmarkTitle="3. FRAMEWORK CLASS COMPONENTS" includeInTOC="true" />								
	</PDF>	
	
	
	<cfinclude template="DdxFormat.cfm">
	
	<PDF result="Output1">
		<PageLabel format="Decimal"/> 
		<PDF source="TitlePage" bookmarkTitle="Cover Page" includeInTOC="false" />
	    <TableOfContents styleReference="TOC"/> 		
		<PDFGroup>

			<Header>
				<Right>
					<StyledText>
						<p font="Arial,8pt">PROSIS Use Case Writer Version 2.0</p>
					</StyledText>
				</Right>
			</Header>
			<Footer styleReference="CompsFooter" />
			<Watermark styleReference="Draft" />
		
				<PDF source="GENERAL" bookmarkTitle="SECTION: GENERAL" includeInTOC="true" />		
			
				<cfquery name="QClass2" 
				datasource="AppsControl" 
				username="#SESSION.login#" 
				password="#SESSION.dbpw#">
					SELECT     *
					FROM Class
					order by ClassId
				</cfquery>
				<cfoutput>
				<cfloop query="QClass2">
						<cfset fname=#QClass2.ClassName#>
						<cfset fname=replace(fname," ","_","ALL")>
						<PDF source="s#fname#" bookmarkTitle="SECTION: #UCASE(QClass2.ClassName)#" includeInTOC="true" />		
						
				</cfloop>
				</cfoutput>
			
			<PDF source="Appendix" bookmarkTitle="Appendix" includeInTOC="true" />				
		</PDFGroup>		
		
	</PDF>
	
	
</DDX>

</cfsavecontent>
<cfset reportddx = trim(reportddx)>


<cfset input=StructNew() />
<cfset input.TitlePage="pdfs/_TITLE.pdf"/>
<cfset input.Introduction="pdfs/_INTRODUCTION.pdf"/>
<cfset input.AFC="pdfs/_APPLICATIONFRAMEWORKCLASSES.pdf"/>
<cfset input.FCC="pdfs/_FRAMEWORKCLASSCOMPONENTS.pdf"/>

<cfinclude template="DdxInput.cfm">

<cfset input.Appendix="pdfs/_APPENDIX.pdf"/>







