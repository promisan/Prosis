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

 <cfdirectory action="LIST"
             directory="#SESSION.rootDocumentPath#\Documentation\#theClass#"
             name="AttachFiles"            
             sort="DateLastModified DESC"
             type="all"
             listinfo="name">
			 
	<cfset go = 0>		 
			 
	<cfloop query="Attachfiles">
	 <cfif UCase(Right(name,4)) eq ".PDF" or
				 UCase(Right(name,4)) eq ".GIF" or 
			     UCase(Right(name,4)) eq ".JPG" or 
				 UCase(Right(name,4)) eq ".PNG">
	     <cfset go = 1>
	 </cfif>
	</cfloop>		 
			 
	<cfif go eq "1">		 

	     <cfpdf action="MERGE"
			  name         = "att2"
	          overwrite    = "Yes"
	          keepbookmark = "No">			  
			 		
		<cfloop query="AttachFiles">
		    
			<cfif UCase(Right(name,4)) eq ".PDF">
			
			  	<cfpdfparam source="#SESSION.rootDocumentPath#\Documentation\#theClass#\#Name#">			
			
			<cfelseif UCase(Right(name,4)) eq ".GIF" or 
			     UCase(Right(name,4)) eq ".JPG" or 
				 UCase(Right(name,4)) eq ".PNG">
						
				<cfdocument name="att#currentrow#"
			          format="PDF"
			          pagetype="letter"
			          margintop="0.0"
			          marginbottom="0.5"
			          marginright="0.1"
			          marginleft="0.1"
			          orientation="landscape"
			          unit="in"
			          encryption="none"
			          fontembed="Yes"
			          backgroundvisible="No"
			          bookmark="True">
			  
			  	  <cfdocumentsection name="Image:#Name#">
					 
					 <table width="100%" height="100%" cellspacing="0" cellpadding="0">
					 <tr><td height="15" align="left">#Name#</td></tr>
					 <tr><td height="1" bgcolor="silver"></td></tr>
					 <tr><td valign="top">
					 
					 <img src="#SESSION.rootDocument#/Documentation/#theClass#/#Name#"
					     alt=""			   
					     border="0">
					 
					 </td></tr>
					 </table>
				 
				  <cfdocumentitem type="footer">
		
					<table width="100%" cellspacing="0" cellpadding="0">
					<tr><td height="1" bgcolor="808080"></td></tr>
					<tr><td align="center">Introduction</td></tr>
					</table>
		
				   </cfdocumentitem>
				   
				 </cfdocumentsection>  
			  
				</cfdocument>
				
				<cfpdfparam source="att#currentrow#">	
				
										
			</cfif>	
		</cfloop>			
	
	</cfpdf>	
</cfif>

<!--- final merge --->

<cfpdf action="MERGE"
          destination="#SESSION.rootPath#\cfrstage\mergepdf\intro_#theClass#.pdf"
          overwrite="Yes"
          keepbookmark="Yes">
		  
	<cfpdfparam source="pdfs/#fname#.pdf">
	
	<cfif attachfiles.recordcount gte "1">	
	   <cfpdfparam source="att2">
	</cfif>
			
</cfpdf>

	          
